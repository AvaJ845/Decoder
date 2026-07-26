# Contributing to Decoder

We have multiple people (Fellows + DEs) working at once. This guide keeps us from
editing the same files in parallel and silently losing work. **Read it before your
first change.**

## Golden rules

1. **No direct commits to `main`.** Branch → PR → review → merge. Always.
2. **Don't edit a file someone else is actively in.** Coordinate by lane (below). The
   flashpoint is `app/ChunkRacerApp/GamePlayView.swift` — one person at a time.
3. **Pull `main` before you branch**, and rebase before you open a PR, so merges are clean.
4. **Every PR must build and pass `swift test`** and clear the review bar (see below).

## Lane ownership

Stay in your lane; cross-lane changes go through the owner's review.

| Lane | Owner | Files |
|---|---|---|
| Platform / logic | **DE-App** | `app/Sources/DecoderCore/**`, `app/ChunkRacerApp/GameModel.swift`, tests |
| Art / assets | **DE-Art** | `app/ChunkRacerApp/Resources/**`, `app/assets/**`, art docs, DE-Art brief |
| View integration + review | **Fellow** | `app/ChunkRacerApp/GamePlayView.swift`, `Theme.swift`, design/decision docs |

If a change needs two lanes, split it into two PRs or pair on one branch.

## Branch + PR flow

```bash
git checkout main && git pull
git checkout -b <type>/<short-topic>      # feat/ fix/ chore/ docs/
# ...work...
swift test                                 # from app/ — must pass
git push -u origin <branch>
```
Open a PR against `main`. A **Fellow reviews and merges** — authors don't self-merge.

## Build & test

```bash
cd app
swift test                                 # headless core — must pass
xcodegen generate                          # regenerate the Xcode project (see below)
xcodebuild -project ChunkRacer.xcodeproj -scheme ChunkRacer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug -derivedDataPath .build/dd CODE_SIGNING_ALLOWED=NO build
```

**The Xcode project is generated and gitignored.** Never commit `app/ChunkRacer*.xcodeproj/`.
The source of truth is `app/project.yml`. After adding/removing any Swift file, run
`xcodegen generate` or the build won't see it ("cannot find X in scope").

## The review bar (PRs are checked against this, in order)

From `decoder-fellow-direction.md` — read it. A violation of a non-negotiable is an
automatic request-changes:

1. **The one goal** — does it make reading feel safer / faster / more repeatable?
2. **Non-negotiables:** no shame (no red X / buzzer / lose-state); reading text is live,
   never baked/animated; color never carries meaning alone; every animation has a
   Reduce-Motion equivalent; off-white grounds + WCAG AA + dark mode; accessibility
   (VoiceOver, Dynamic Type) works.
3. **Access-first** (D13): never paywall the child's core reading practice.
4. **Invariants green:** `swift test` passes; content validator passes.
5. **Asset Definition of Done** (art-bible §10) for anything visual.

## Commit messages

Imperative subject; explain the *why* in the body. End co-authored work with:

```
Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
```

## Gotchas

- macOS 26 stamps `com.apple.provenance` xattrs that break codesign — handled by the
  `postBuildScripts` step + `CODE_SIGNING_ALLOWED=NO` for simulator. Keep both.
- Files written to `~/` land in `~/Documents/Decoder/` on this machine — use explicit paths.
- Namespace is `AvaResearchLLC` (not `com.toppupgames.*` — that's a different project).
