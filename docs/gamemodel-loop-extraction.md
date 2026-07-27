# GameModel Loop Extraction — Spec & Record

**Status:** ✅ implemented (this doc doubles as the design record).
**Goal:** make the no-shame gameplay loop unit-testable by moving pure session rules out of
the SwiftUI layer, without changing any visible behavior.

## The problem

`GameModel` (a `@MainActor ObservableObject`) mixed three concerns: SwiftUI `@Published`
state, the pure gameplay rules (selection, re-serve, correctness, completion, mastery,
momentum), and side effects (persistence, timing). Because the rules lived in a UI object,
they could only be exercised through a running app — `swift test` couldn't reach them, so
the product's most important invariants (no-shame loop) were untested at the unit level.

## The boundary

| Concern | Lives in | Testable via |
|---|---|---|
| Gameplay/session **rules** | **`RaceSession`** (DecoderCore) | `swift test` ✅ |
| UI state, timing, persistence, copy | `GameModel` (ChunkRacerApp) | app/UI tests |

### `RaceSession` (DecoderCore) — the extracted engine
Owns: `pack`, `engine`, `learner` (mastery + momentum + prefs), `cleared`, `lastAnswered`,
`events`, `current`, `choices`. No I/O, no UI, no timing.

```
init(pack:engine:learner:)     // presents the first item
advance()                      // next uncleared item (defers just-answered) or complete
answer(_:promptShownAt:now:)   // correctness → mastery/momentum/cleared/events; no advance
updateAccessibility(_:)        // fold prefs edited in settings back into the learner
solved · total · progress · isComplete · summary   // derived
```

Rules it encodes (the non-negotiables): progress advances **only** on a correct answer; a
miss keeps the item uncleared so it returns later (no lose-state, D3); the just-answered
item is deferred from the very next pick; the race completes only when all items are cleared.

### `GameModel` (ChunkRacerApp) — orchestration only
Holds a `RaceSession`, mirrors its state into the same `@Published` surface the view already
used (so `GamePlayView` is **unchanged**), owns the 1.1s feedback pause before `advance()`,
persists the event + profile, and maps outcomes to user-facing copy (`arloLine`) and
celebrate/re-serve feedback.

## Bug fixed in passing

The old `savePreferences()` did `fontManager.profile = learner`, which **overwrote** the
accessibility edits the settings sheet had just made — so changing reading font/tint and
tapping Done silently discarded them. Now prefs flow the correct direction:
`session.updateAccessibility(fontManager.profile.accessibility)` → mirror → save.

## Tests added (DecoderCoreTests)

`RaceSession` is now covered directly: starts with an item + choices; progress advances only
on correct; session completes when all cleared and the summary reflects 100%; repeated misses
never complete or produce a lose-state; the just-answered item is deferred from the next pick.
(32 tests total, all green.)

## Payoff for the suite

`RaceSession` is platform-neutral and app-agnostic in shape — the next Decoder app (Sound
Forge, etc.) can reuse the same session/mastery/momentum pattern instead of re-implementing
loop rules inside a new view model.

## Not done (deliberately deferred)

- **GamePlayView decomposition** — held until the art PR lands (collision risk).
- **Localization string extraction** — premature pre-playtest.
- Further splitting `GameModel` persistence into a service — current size is fine.
