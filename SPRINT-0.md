# Sprint 0 — Foundations & Risk Spike · Status

**Goal (sprint plan §Sprint 0):** app scaffolding, design tokens, content-pack schema +
validator, event store, and the SpriteKit rhythm/haptics feasibility spike.
**Exit criteria:** app builds, renders a themed screen, loads a pack, logs an event;
the timing spike answers "is the rhythm loop feasible?"

## Done ✅

| Deliverable | Status | Evidence |
|---|---|---|
| DecoderCore Swift package | ✅ builds | `swift build` clean (Swift 6.3) |
| Content-pack schema **v2.1** (mechanic locked) | ✅ | `assets/code/content-pack-schema.json` |
| Codable models + loader | ✅ | `Sources/DecoderCore/ContentPack.swift`, `PackLoader.swift` |
| **Content-pack validator** (shipping gate) | ✅ tested | `ContentPackValidator.swift` + regression test for the cr-011/012 bug |
| Skill-graph model + resolve | ✅ tested | pack's 5 skillIds resolve to graph nodes |
| Cue vocabulary (snap/pulse/bloom/drift) | ✅ | `Cue.swift` |
| Adaptive-engine seam (v1 rules) | ✅ tested | serves weakest-skill item first |
| Event store (in-memory + JSONL) | ✅ tested | append-only, round-trips |
| Asset-key resolver (§8.1) | ✅ tested | vector-first, dark/reduce-motion suffixes |
| Design tokens (frozen palette + type roles) | ✅ | `DesignTokens.swift` |
| SwiftUI app shell + Sprint 0 exit screen | ✅ source | `ChunkRacerApp/` (needs Xcode target) |
| Core Haptics cue mapper (iPad-safe) | ✅ source | `Haptics.swift` |
| SpriteKit rhythm/timing spike | ✅ source | `RhythmSpikeScene.swift` |
| keygen asset-production tool | ✅ runs | 46 keys queued for DE-Art |
| Repo + .gitignore | ✅ | this repo |

**Tests:** 13/13 passing (`swift test`), ~0.006s.

## Handed off / next (needs a Mac + Xcode, DE-App)

- [ ] Create the Xcode app target, add DecoderCore as a local package, bundle the JSON (README).
- [ ] Run `RhythmSpikeScene` + `Haptics` on a physical iPhone → record tap→beat offsets → **close the feasibility question** (the one Sprint 0 item that needs real hardware).
- [ ] TestFlight/CI pipeline.

## Findings resolved this sprint (from the art handoff review)

- Mechanic mismatch → schema **v2.1**, pack **v1.1.0**, key map updated.
- cr-011/cr-012 answer-in-distractors bug → fixed + **regression test**.
- Case convention (all-lowercase), canonical Arlo, progress-green token → recorded in the art bible.

## Sprint 0 exit — met at the core level

`swift test` proves: **loads pack → validates clean → resolves skills → serves first item → logs event.**
The only exit item still open is the on-device rhythm/haptics spike, which by definition
needs Xcode + a physical iPhone (handed to DE-App above).
