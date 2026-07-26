# DE-Assist Next Items — Decoder / Chunk Racer

**After the Apple Fellow pass on 2026-07-26.**

This doc lists what the Apple Fellow completed in code and what needs DE-App / DE-Art hands next.

## What the Fellow completed (in code)

### 1. Learner profile + mastery persistence (Step 5)

**Files added / changed:**
- `app/Sources/DecoderCore/LearnerProfile.swift` — `LearnerProfile`, `AccessibilityPrefs`, `BackgroundTint`.
- `app/Sources/DecoderCore/SkillState.swift` — per-skill mastery with `apply(correct:)` and spaced review scheduling.
- `app/Sources/DecoderCore/ProfileStore.swift` — `ProfileStore` protocol, `InMemoryProfileStore`, `FileProfileStore`.
- `app/Sources/DecoderCore/ForgivingMomentum.swift` — streak + protected/rest-day state.
- `app/Sources/DecoderCore/AdaptiveEngine.swift` — updated `AdaptiveEngine` to take `LearnerProfile`; `SimpleAdaptiveEngine` uses persisted mastery.
- `app/ChunkRacerApp/GameModel.swift` — new file; `GameModel` now owns `LearnerProfile`, `ProfileStore`, `AdaptiveEngine`, and persists after every answer.
- `app/ChunkRacerApp/GamePlayView.swift` — wired to the new `GameModel`; replaced the old inline momentum meter with `MomentumMeter` that shows protected state.
- `app/Tests/DecoderCoreTests/DecoderCoreTests.swift` — added tests for `SkillState`, `LearnerProfile`, `ProfileStore`, `ForgivingMomentum`, and updated the adaptive-engine test.

**Result:**
- 22 core tests pass.
- iOS app builds successfully on the iPhone 17 Pro Simulator target.
- Mastery and momentum now survive app relaunch (when using `FileProfileStore`).
- The adaptive engine serves the weakest skill first using real mastery data.

### 2. Forgiving momentum meter (Step 2 polish)

- `ForgivingMomentum` supports `hit()`, `miss()`, `shieldForRestDay()`, and a `protectedCount`.
- A miss when protected consumes protection instead of resetting the streak.
- A miss without protection drops the streak by 2 but floors at 0.
- Reaching a 5-streak grants 2 protected misses.
- The UI shows a shield icon when protection is active.

## What DE-App takes next

### 1. Dynamic Type + bundled fonts (blocked on DE-Art font drop)

**The infrastructure is already in place:** `FontManager` tries to load the bundled faces and falls back to the system rounded font when they are missing. `UIAppFonts` is already declared in `ChunkRacerApp/Info.plist`. `AccessibilitySettingsView` already lets users switch reading fonts and adjust spacing/line height. All text in `GamePlayView` uses `FontManager` and scales with Dynamic Type.

Once DE-Art drops the font files into `app/ChunkRacerApp/Resources/Fonts/`:

- Verify the filenames match `UIAppFonts`.
- Confirm the fonts load (the `FontManager` will pick them up automatically).
- Remove any remaining `.system(...)` font calls that bypass `FontManager`.
- Run a contrast audit against the four background tints and dark mode.

### 2. Real latency measurement

- The `GameModel` currently passes `latencyMs: 0` to events.
- Measure the time from `present()` to `choose(_:)`, capped at a reasonable max, and record real latency.
- This feeds into the adaptive engine later.

### 3. File-based persistence in the app target

- `GameModel` currently uses `InMemoryProfileStore` by default for previews/tests.
- In the production app, wire it to a `FileProfileStore` in a sandboxed app directory (`FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)`).
- Use a stable learner ID (e.g., from the future parent-gated account flow) instead of the hardcoded `"demo"`.

### 4. StoreKit 2 monetization (after playtest #1)

- See D12 / D13 in `decoder-fellow-direction.md` and `docs/monetization-approach.md`.
- Build subscription groups in App Store Connect: annual default, monthly option, lifetime unlock.
- Implement the parent-gated paywall with clear trial terms.
- Support restore purchases, Family Sharing, and Ask to Buy.
- Ensure the paywall never interrupts the child's core race loop.

### 5. Multi-learner account support (Horizon 2)

- `LearnerProfile` already supports multiple IDs; the UI currently hardcodes `"demo"`.
- Build a parent/teacher switcher for learners once accounts are implemented.

## What DE-Art takes next

### 1. Font drop (blocks Dynamic Type)

**Drop into `app/ChunkRacerApp/Resources/Fonts/`:**
- `Fredoka One` (or Fredoka variable font) — display/brand role.
- `OpenDyslexic-Regular` and `OpenDyslexic-Bold` — reading default.
- `LexendDeca-Regular` (+ `LexendDeca-Bold`, `LexendDeca-Medium` if available) — reading fallback.

**Confirm:**
- Each font's license permits embedding and redistribution in a commercial iOS app.
- Fonts are the actual `.otf` or `.ttf` files, not web-font CSS.

### 2. Isolated, transparent Arlo sprites (D11)

The current `characters/kit_guide_arlo_*.png` files are **concept sheets with baked backgrounds** — unusable in-game.

**Deliver:**
- `kit_guide_arlo_idle` — neutral, friendly pose.
- `kit_guide_arlo_celebrate` — success/celebration pose.
- `kit_guide_arlo_encourage` — gentle re-serve / near-miss pose.
- Each as a **transparent PNG or PDF**, with the canonical body from the art bible (book-shaped robot, teal body, coral scarf, gold star antenna, gold bookmark).
- Provide a simple rig or separated layers so engineering can animate subtle idle/breathe motion.

### 3. Vehicle + track + celebrate particle (D5, D11)

**Track:**
- A tileable, horizontally scrolling race-track segment.
- Thick confident linework, off-white/cream background, dark grey road, red-white curbs, small green bushes.
- Transparent background or matching the cream ground.

**Vehicle:**
- A teal race car with a friendly face (windshield = eyes, bumper = smile).
- White racing stripe, coral accent, black wheels with teal rims.
- Idle state and a success bounce/hit state.
- Transparent background, rig-ready (wheels separated, body layer).

**Celebrate particle:**
- One focal gold star burst (~0.6s duration).
- Static Reduce-Motion variant: a single gold ring or solid badge.

### 4. UI kit assets (for future polish)

The current UI uses SwiftUI shapes and SF Symbols. For final production, deliver:
- Primary and secondary button backgrounds (9-slice compatible).
- Toggle on/off states.
- The forgiving momentum meter as a standalone asset.
- The gentle re-serve visual (word drifting back along a dotted path).

## Definition of Done for any art asset

Before an asset is considered production-ready, verify:
- [ ] Vector-first (SVG/PDF) or authored at largest iPad target.
- [ ] Named to its `assetKey` (`app_object_state`).
- [ ] Transparent background (characters/props).
- [ ] Layered / rig-ready if it animates.
- [ ] Light and dark variants.
- [ ] Reduce-Motion variant if animated.
- [ ] Contrast AA; no meaning carried by color alone.
- [ ] Legible on all four background tints.
- [ ] Reads at smallest intended size (icons at 60 px).
- [ ] Tone check: warm, never babyish, never corrective.
- [ ] Exists in the content schema / key map.

## Ordering recommendation

1. **DE-Art:** font drop (unblocks Dynamic Type).
2. **DE-App:** Dynamic Type + font switching + contrast audit.
3. **DE-Art:** Arlo sprites + vehicle/track (in parallel with DE-App work).
4. **DE-App:** wire real art into the placeholder slots.
5. **Fellow review:** accessibility gate + kid playtest #1.
6. **DE-App:** StoreKit 2 monetization (post-playtest).

## Contact / questions

- Architecture: `decoder-build-doc.md`
- Art direction: `decoder-art-bible.md`
- Fellow decisions: `decoder-fellow-direction.md`
- Handoff: `HANDOFF.md`
- Monetization: `docs/monetization-approach.md`
