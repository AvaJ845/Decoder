# Decoder — Fellow Handoff

**Purpose:** hand this to another assisting Fellow / LLM so they can continue without prior chat context. Self-contained. Read the linked docs for depth.

**Canonical repo:** https://github.com/AvaJ845/Decoder — this is the moving-forward reference for all future work.

---

## 0. TL;DR

- **Project:** Decoder — an iOS *suite* of reading-strategy games for kids with **dyslexia + ADHD**. "One platform, many small games." Flagship = **Chunk Racer** (fluency). Others planned: Sound Forge, Clue Hunt, Focus Dojo, Story Studio.
- **You are the Apple Fellow:** you own roadmap + design/UX decisions; two engineers (DE-App, DE-Art) implement; you review against the bar. Engineering owns *how*; Fellow owns *what* and *whether it's good enough*.
- **State:** Chunk Racer has a **working, playable "race" loop on the iOS Simulator** — real mechanic, motion, celebrate, gentle-failure, VoiceOver labels, learner profile persistence, and Dynamic Type infrastructure. Core logic is a tested Swift package.
- **The one blocker:** the reading/display **font files aren't in the repo** — the code is ready to load them, but until the `.otf/.ttf` files are dropped, the app still falls back to the system rounded font. See §3.

---

## 1. Ground rules (the bar — never violate)

**The one goal that breaks ties:** *a kid with dyslexia/ADHD reads more, more fluently, because practice feels safe, fast, and worth returning to.*

**Non-negotiables (a violation blocks merge):**
1. **No shame** — no red X / buzzer / frown / "wrong" / lose-state. A miss re-serves warmly. Time/speed is a difficulty dial, never a threat.
2. **Reading text is rendered live** — never baked into an image, never styled/animated. Must switch to OpenDyslexic/Lexend and honor spacing + Dynamic Type.
3. **Color never carries meaning alone** — pair with shape/icon/position/motion.
4. **Every animation has a Reduce-Motion equivalent** that loses no info.
5. **Off-white low-glare grounds; WCAG AA; full dark mode + tint-safe.**
6. **Accessibility gates the kid playtest, not just launch** (VoiceOver, Dynamic Type, Reduce Motion).

Full design constitution + numbered decision log (D1–D12): **`decoder-fellow-direction.md`** (read this first).

---

## 2. What's completed

### Docs (project root `~/Documents/Decoder/`)
- `decoder-build-doc.md` — platform architecture (skill graph §5, content schema §7, iOS presentation layer §8.1, iPhone-first/iPad-later §8.2).
- `decoder-art-bible.md` — palette, typography, asset rules, Definition of Done (§10). Frozen decisions filled in.
- `decoder-sprint-plan.md` — flagship-to-launch sprint sequence (solo/tiny team).
- `decoder-art-handoff-review.md` — review of the art delivery; all blocking findings resolved.
- `decoder-fellow-direction.md` — **the operating hub**: principles, decision log, roadmap, build status.
- `SPRINT-0.md` — Sprint 0 status.
- Reusable **skill** `decoder-suite-app` (for building apps #2–5). Source of truth: `~/Documents/Skills/decoder-suite-app/`; repo copy `Decoder/.claude/skills/decoder-suite-app` is a symlink to it.

### Code (`~/Documents/Decoder/app/`)
- **`DecoderCore`** Swift package (platform-neutral, headless, **22 tests passing** via `swift test`):
  - `ContentPack` + schema-v2.1 models, `ContentPackValidator` (the shipping gate — enforces the mechanic invariant; has a regression test for the answer-in-distractors bug), `SkillGraph`, `AdaptiveEngine` (v1 rules seam, now driven by persisted `LearnerProfile`), `EventStore` (append-only, in-memory + JSONL), `AssetKeyResolver` (vector-first, dark/reduce-motion), `Cue` vocabulary, `DesignTokens` (frozen palette + type roles), `PackLoader`.
  - `LearnerProfile`, `SkillState`, `ProfileStore`, `ForgivingMomentum` — learner profile, mastery persistence, and forgiving streak.
- **`ChunkRacerApp`** (SwiftUI + SpriteKit; Xcode target via **xcodegen** `project.yml`):
  - Loads + validates the bundled pack, then runs the **playable race loop**: chunk prompt → tap the streaming word that contains it. The UI is now aligned with the provided mockup: large teal target card, three big white answer buttons with dark borders, teal car on a dashed progress track, finish flag, five-dot progress indicator in the header, and an Arlo smiley footer with a streak counter.
  - `GameModel` — now owns the persisted `LearnerProfile`, uses the adaptive engine, and records real answer latency.
  - `AccessibilitySettingsView` — parent/settings sheet for reading font, letter spacing, line height, background tint, reading ruler, and TTS. **Dynamic Type scaling is wired throughout**; real bundled fonts are the only missing piece.
  - `BundleImage` + `AssetKeyResolver` — content references assets by key; the app resolves `@2x`/`@3x`/PDF variants. The new mockup-aligned game assets are bundled in `ChunkRacerApp/Resources/`.
  - `Haptics.swift` — cue→Core Haptics mapper, iPad-safe no-op. `RhythmSpikeScene.swift` — SpriteKit timing spike.
- **Content:** `app/assets/code/chunk-racer-basics-pack.json` (12 items, v2.1 mechanic: `targetChunk`/`correctWord`/`distractorWords`), `skill-graph.json`, `content-pack-schema.json`.
- **Verified running on iOS Simulator (iPhone 17 Pro).** Bundle ID `AvaResearchLLC.ChunkRacer`, org identifier `AvaResearchLLC`.

### Decisions locked (see decision log for rationale)
Mechanic = chunk-prompt→pick-word (D1); dynamic reading text, not baked (D2); no time-pressure fail state (D3); reduce-motion parity (D4); one focal celebrate (D5); near-zero onboarding (D6); fonts Fredoka/OpenDyslexic/Lexend (D7); dark+tint required (D8); abstract cue→haptic (D9); accessibility gates playtest (D10); Arlo as isolated transparent sprites (D11).

---

## 3. THE BLOCKER (needs a human/asset drop)

**Reading + display fonts are not in the repo.** Decision D7 sets: display = **Fredoka One**; reading = **OpenDyslexic** (default) + **Lexend Deca** (fallback), user-switchable, Dynamic-Type-aware. The app currently falls back to the system rounded font.

**Why it blocks:** these are licensed font files that cannot be fetched programmatically. Until the `.otf/.ttf` files are placed in the repo, the app cannot display the art-bible typefaces and still falls back to the system rounded font. However, **the Dynamic Type and font-switching infrastructure is already in place** — once the files arrive, the swap is minimal.

**Exactly what's needed:**
1. Drop font files into `app/ChunkRacerApp/Resources/Fonts/`:
   - `Fredoka One` (or Fredoka variable), `OpenDyslexic-Regular/Bold`, `LexendDeca-Regular` (+ weights as available).
2. Confirm each font's license permits embedding in a shipping iOS app.
3. The code is already wired: `UIAppFonts` is prepared, the `FontManager` falls back to system fonts when bundled faces are missing, and the accessibility settings sheet lets users switch reading fonts. Once the files are present, the app will load them automatically.

**Learner profile + mastery persistence, real latency measurement, and accessibility settings are now implemented** (see §4). No other blocker exists for continuing — everything else is ownable in code or in assets.

---

## 4. What's needed next (prioritized)

**What's next (prioritized):**

**Blocked on the font drop (§3):**
- **Step 3 — Final typography + contrast audit.** The Dynamic Type/font-switching code is ready; once the `.otf/.ttf` files are dropped, run the contrast audit across all four background tints and dark mode to complete the accessibility gate.

**Owned by DE-Art (asset production):**
- **Isolated, transparent, rig-ready Arlo sprites** (idle/celebrate/encourage) — current character PNGs are spec sheets, unusable in-game (D11). Native placeholder token stands in.
- **Real vehicle/track art + celebrate particle** (with static Reduce-Motion variant). Native placeholders in place.
- Per-word/chunk assets are **not** needed as images — text is dynamic (D2). Fonts are the real typography dependency.

**Completed in this pass:**
- ✅ **Step 5 — Learner profile + mastery persistence.** Implemented in `DecoderCore` with `LearnerProfile`, `SkillState`, `ProfileStore`, and `ForgivingMomentum`. The adaptive engine now uses persisted mastery; the race loop persists after every answer.
- ✅ **Real latency measurement** — `GameModel` records milliseconds from prompt to answer and stores it in the event stream.
- ✅ **Accessibility settings sheet** — `AccessibilitySettingsView` lets users change reading font, letter spacing, line height, background tint, reading ruler, and TTS. Preferences are saved to `LearnerProfile.accessibility`.
- ✅ **Dynamic Type infrastructure** — all text scales with the system Dynamic Type setting; the font system falls back to the system rounded font when bundled faces are missing.
- ✅ **Mockup-aligned gameplay UI** — `GamePlayView` now matches the supplied mockup layout: large teal target card, three big white answer buttons with dark borders, teal car on a dashed track, finish flag, five-dot progress indicator in the header, Arlo smiley footer, and a streak counter moved to the footer.
- ✅ **Mockup-aligned game assets** — produced and bundled `racer_car`, `finish_flag`, `arlo_smiley`, and `chunk_racer_logo` as `@2x`/`@3x` PNGs in `ChunkRacerApp/Resources/`.
- ✅ **22 tests pass** and the iOS app builds on the iPhone 17 Pro Simulator target.

**Then:** kid playtest #1 on the real-feeling, accessible loop → that gate decides the rest (content scale, privacy/offline, beta, launch — see sprint plan).

---

## 5. How to build & run

**Toolchain:** Swift 6.3, Xcode 26.6, `xcodegen` at `~/bin/xcodegen`.

Headless core tests:
```bash
cd ~/Documents/Decoder/app && swift test
```

Generate the Xcode project (required after adding/removing any source file — xcodegen enumerates sources at generation time):
```bash
cd ~/Documents/Decoder/app && xcodegen generate
```

Build + run on the Simulator (signing off — simulator doesn't need it):
```bash
cd ~/Documents/Decoder/app
xcodebuild -project ChunkRacer.xcodeproj -scheme ChunkRacer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug -derivedDataPath .build/dd CODE_SIGNING_ALLOWED=NO build
xcrun simctl install booted .build/dd/Build/Products/Debug-iphonesimulator/ChunkRacer.app
xcrun simctl launch booted AvaResearchLLC.ChunkRacer
```

**Physical device:** open `ChunkRacer.xcodeproj` in Xcode, add the Apple ID under Settings → Accounts (CLI can't authenticate to Apple), set Team in Signing & Capabilities, enable Developer Mode on the device (iOS 16+), then Run.

---

## 6. Gotchas (will bite otherwise)

- **New source files → run `xcodegen generate`** or the build won't see them ("cannot find X in scope").
- **`com.apple.provenance` xattr** (macOS 26) fails codesign. Handled by a `postBuildScripts` step (`xattr -cr`) and `CODE_SIGNING_ALLOWED=NO` for simulator. Keep both.
- **Simulator can't inject taps** from CLI; verify interaction by tapping in the Simulator UI, or via a UI test.
- **`~/` writes land in `~/Documents/Decoder/`** on this machine (a redirect in the user's setup) — use explicit paths.
- **Namespace:** Decoder uses `AvaResearchLLC` — **not** the `com.toppupgames.*` namespace (that's a different project, Top Pup).
- **Skill edits:** edit the source at `~/Documents/Skills/decoder-suite-app/`, never recreate a copy in the repo (repo has a symlink).

---

## 7. Operating model to continue

Lead with the §1 bar and the decision log in `decoder-fellow-direction.md`. Make design calls decisively; tie every review verdict (Ship / Ship-with-notes / Rework) to a specific principle or decision, never taste-as-authority. When a new need arises, prefer extending the shared `DecoderCore` over app-local one-offs — the suite's value is that everything is shared. Record new cross-app calls in the decision log so the next app inherits them.

---

## 8. Monetization (Apple-aligned decision)

The business model has been decided and documented. The Fellow owns this direction; DE-App implements the StoreKit plumbing once the race loop and accessibility gate are solid.

**Consumer model:**
- Free download with the first 3 levels / one daily race unlocked.
- 7-day free trial, then annual subscription as the default: **$39.99–$49.99/year**.
- Monthly option: **$5.99/month**.
- Lifetime unlock: **$79.99–$99.99** for the anti-subscription segment.
- Family Sharing included; parent-gated purchase flow; no ads, no consumables, no dark patterns.

**Institutional model:**
- School / SLP / district licensing through Apple School Manager / volume purchase.
- Per-student: **$4–$8/student/year**; per-classroom: **$200–$400/classroom/year**.
- This channel becomes critical when Clue Hunt / Story Studio launch on iPad.

**Why this fits:** it aligns with Apple's design principles (Clarity, Deference, Privacy, User control, Family Sharing, Trust), avoids ads/data monetization required by COPPA/GDPR-K, and lets the trial prove skill growth before the parent pays.

**Full docs:**
- `docs/monetization-approach.md` — concise handoff doc for the fellow.
- `.cursor/skills/decoder-monetization/SKILL.md` — reusable skill.
- `.cursor/skills/decoder-monetization/reference.md` — full rationale and Apple-principle mapping.
