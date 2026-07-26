# Decoder

**Reading-strategy games for kids with dyslexia and ADHD.** Practice that feels *safe, fast, and worth coming back to* — never a test, never a red X.

Decoder is a **platform** ("one platform, many small games") and this repo builds its **flagship app, Chunk Racer** — a fluency game where a kid sees a chunk (like `at`) and picks the streaming word that contains it (`c`**`at`**). iPhone first; iPad is a committed later phase.

> **Naming, so it's unambiguous:** **Decoder** = the platform/repo and the shared engine. **Chunk Racer** = the first app built on it. Future apps (Sound Forge, Clue Hunt, Focus Dojo, Story Studio) will be separate app targets that reuse the same `DecoderCore` engine. They are one product family, not separate products.

## Status

- ✅ Chunk Racer is **playable and code-complete for the first kid playtest**.
- ✅ Accessible: VoiceOver, Dynamic Type, Reduce Motion, dyslexia-friendly typography controls, four background tints, full dark mode, **WCAG AA verified**.
- ✅ `DecoderCore` engine is covered by tests (`swift test`).
- ⏳ Before the playtest ships to more kids: licensed fonts + production art (see `docs/de-art-asset-request.md`). Placeholder art + system fonts are fine for the playtest itself.

## Quick start

Requires **Xcode 26+**, **Swift 6+**, and **xcodegen** (`brew install xcodegen`).

```bash
git clone https://github.com/AvaJ845/Decoder.git
cd Decoder/app

swift test                       # 1. run the DecoderCore engine tests (headless, no Xcode UI)
xcodegen generate                # 2. generate the Xcode project from project.yml

# 3. build + run on the simulator
xcodebuild -project ChunkRacer.xcodeproj -scheme ChunkRacer \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -configuration Debug -derivedDataPath .build/dd CODE_SIGNING_ALLOWED=NO build
xcrun simctl install booted .build/dd/Build/Products/Debug-iphonesimulator/ChunkRacer.app
xcrun simctl launch booted AvaResearchLLC.ChunkRacer
```

For a **physical device**: open `ChunkRacer.xcodeproj`, set your Team in Signing & Capabilities, enable Developer Mode on the phone, and Run.

> **The Xcode project is generated and gitignored.** `app/project.yml` is the source of truth. After adding or removing any Swift file, run `xcodegen generate` — otherwise the build won't see it.

## Repo structure

```
app/
├── project.yml                     # source of truth for the Xcode project (xcodegen)
├── Sources/DecoderCore/            # PRODUCT LOGIC — platform-neutral, testable, no UIKit
│   ├── ContentPack.swift           #   content schema v2.1 + models
│   ├── ContentPackValidator.swift  #   the shipping gate (mechanic invariant)
│   ├── SkillGraph.swift            #   the reading-strategy skill DAG
│   ├── AdaptiveEngine.swift        #   "what to serve next" (session-bounded)
│   ├── SkillState / LearnerProfile / ProfileStore   #   mastery + persistence
│   ├── ForgivingMomentum.swift     #   streak that forgives a bad day
│   ├── EventStore / SessionSummary #   the evidence pipeline
│   ├── AssetKeyResolver.swift      #   key → @2x/@3x/PDF + dark/reduce-motion
│   └── DesignTokens.swift          #   the frozen palette + type roles
├── Tests/DecoderCoreTests/         # engine tests (run via `swift test`)
├── ChunkRacerApp/                  # APP SHELL — SwiftUI UI layer, imports DecoderCore
│   ├── GamePlayView.swift          #   the race loop screen
│   ├── GameModel.swift             #   session orchestration
│   ├── Theme.swift / FontManager   #   tokens → SwiftUI Color/Font
│   └── Resources/                  #   the ONLY bundled assets (+ Resources/Fonts/)
└── assets/                         # source art, content packs, scripts (not bundled)

docs/                               # design direction, playtest plan, monetization, art request
decoder-fellow-direction.md         # THE OPERATING HUB — the bar + numbered decision log
decoder-build-doc.md · decoder-art-bible.md · decoder-sprint-plan.md
```

**Three layers to keep straight:** `DecoderCore` = product logic (testable, reusable across future apps) · `ChunkRacerApp` = the app shell (UI) · `docs/` + `*.md` at root = design direction and decisions.

## The product bar (non-negotiable)

Decoder serves kids who already find reading hard, so these are **enforced, not aspirational**:

1. **No shame** — no red X, buzzer, "wrong", or lose-state. A miss re-serves warmly.
2. **Reading text is live-rendered** — never baked into an image, always switchable to OpenDyslexic and spacing-adjustable.
3. **Color never carries meaning alone** — paired with shape/icon/position/motion.
4. **Every animation has a Reduce-Motion equivalent** that loses no information.
5. **Off-white grounds, WCAG AA, full dark mode.**
6. **Access-first** — the child's core reading practice is never paywalled.

The full bar, rationale, and the numbered decision log live in **[`decoder-fellow-direction.md`](decoder-fellow-direction.md)** — read it before changing product behavior.

## Contributing

Multiple people work here; see **[`CONTRIBUTING.md`](CONTRIBUTING.md)** for the branch/PR flow, lane ownership, and review bar. In short: branch off `main`, one PR per change, a Fellow reviews against the bar and merges — no direct commits to `main`.

## Documentation map

| Doc | What it is |
|---|---|
| [`decoder-fellow-direction.md`](decoder-fellow-direction.md) | The bar + decision log (start here) |
| [`decoder-build-doc.md`](decoder-build-doc.md) | Platform architecture |
| [`decoder-art-bible.md`](decoder-art-bible.md) | Palette, typography, asset rules |
| [`docs/playtest-1-plan.md`](docs/playtest-1-plan.md) | Kid playtest #1 protocol |
| [`docs/playtest-1-recruiting-kit.md`](docs/playtest-1-recruiting-kit.md) | How to recruit + run the playtest |
| [`docs/de-art-asset-request.md`](docs/de-art-asset-request.md) | Production art request for DE-Art |
| [`docs/monetization-approach.md`](docs/monetization-approach.md) | Access-first subscription model |
