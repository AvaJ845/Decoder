# Decoder — App (Chunk Racer flagship)

Sprint 0 foundation. Native iOS (Swift/SwiftUI + SpriteKit), iPhone-first, Universal
target reserved for iPad later (build doc §8.2).

## Layout

```
app/
├── Package.swift                 # DecoderCore Swift package (headless, testable)
├── Sources/DecoderCore/          # platform-neutral shared core
│   ├── ContentPack.swift         # schema-v2.1 models
│   ├── Cue.swift                 # abstract cue vocabulary (snap/pulse/bloom/drift)
│   ├── SkillGraph.swift          # the reading-strategy DAG
│   ├── ContentPackValidator.swift# the shipping gate (mechanic invariant)
│   ├── PackLoader.swift          # load + validate
│   ├── AdaptiveEngine.swift      # "what to serve next" seam (v1 rules)
│   ├── EventStore.swift          # append-only evidence log (in-memory + JSONL)
│   ├── AssetKeyResolver.swift    # key → @2x/@3x/PDF + dark/reduce-motion (§8.1)
│   └── DesignTokens.swift        # frozen palette + type roles
├── Tests/DecoderCoreTests/       # 13 tests, incl. the cr-011/012 regression
├── ChunkRacerApp/                # iOS UI layer (needs the Xcode project)
│   ├── ChunkRacerApp.swift       # @main App shell
│   ├── ContentView.swift         # Sprint 0 exit screen
│   ├── Theme.swift               # DesignTokens → SwiftUI Color
│   ├── Haptics.swift             # cue → Core Haptics (iPad-safe no-op)
│   └── RhythmSpikeScene.swift    # SpriteKit rhythm/timing feasibility spike
└── tools/keygen.py               # asset-key production queue for DE-Art
```

## Build & test the core (headless — runs here)

```bash
cd app
swift build
swift test
```

The core is Foundation-only so it builds and tests without Xcode. `swift test` proves
the Sprint 0 exit at the core level: pack loads, validates clean, skillIds resolve, the
v2.1 mechanic invariant holds, events log.

## Wire the iOS app (DE-App, next)

`ChunkRacerApp/` is real source but needs an Xcode app target to build (it imports
UIKit/SwiftUI/SpriteKit/CoreHaptics):

1. New Xcode project → iOS App "ChunkRacer" (SwiftUI), Universal, min iOS 16, **build/run iPhone only for now**.
2. Add this folder as a local Swift Package dependency (`DecoderCore`).
3. Add the `ChunkRacerApp/` files to the target.
4. Bundle `assets/code/chunk-racer-basics-pack.json` and `assets/code/skill-graph.json`.
5. Run on device to exercise `Haptics` and `RhythmSpikeScene` (the timing spike).

## Asset production queue

```bash
python3 tools/keygen.py ../assets/code/chunk-racer-basics-pack.json
```

Lists every `assetKey` the content needs and marks `PRODUCE` vs `delivered`.
