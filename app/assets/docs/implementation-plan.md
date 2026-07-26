# Chunk Racer — Implementation Plan

**Goal:** Build the flagship iPhone app for the Decoder series in a thin, compounding way.  
**Estimated timeline:** 8–10 weeks for a playable v1 (one experienced iOS engineer + one content author).

---

## Phase 1: Shared Core (Weeks 1–2)

Build the platform layer as a Swift package consumed by Chunk Racer and future apps.

| Task | Deliverable |
|---|---|
| Define content-pack schema v1 | `ContentPackSchema.json` (done) |
| Schema validator | Swift struct + JSON decoding with validation errors |
| Learner profile model | `LearnerProfile`: preferences, skill state, inventory |
| Skill graph model | `SkillGraph`: nodes, prerequisites, mastery thresholds |
| Reward economy model | `DecoderKit`: currency balance, unlocked tools |
| Adaptive engine v1 (rules-based) | `AdaptiveEngine`: item selection, difficulty tuning, spaced review |
| Event store | `EventStore`: append-only local events with sync queue |

**Success criteria:** All unit tests pass; the engine can select a sensible next item from a sample pack.

## Phase 2: Content Pipeline (Weeks 2–3)

Create the actual content and tooling to author more without engineering.

| Task | Deliverable |
|---|---|
| Author word bank | `chunk-racer-word-bank.json` (done) |
| Define 5 launch levels | `chunk-racer-levels.json` (done) |
| Build sample content pack | `chunk-racer-basics-pack.json` (done) |
| Create content authoring script | Python script that validates JSON and generates audio asset list |
| Produce TTS audio placeholders | `audio/` folder with generated `.mp3` files for every word |
| Validate packs against schema | CI step that fails on schema violations |

## Phase 3: Chunk Racer Game (Weeks 3–6)

Build the actual app on top of the shared core.

| Task | Deliverable |
|---|---|
| Xcode project setup | SwiftUI + SpriteKit hybrid app target |
| Hub screen | Mascot, streak, today's recommendation, settings |
| Race scene | Scrolling cards, target chunk, timer, tap handling |
| TTS integration | AVSpeechSynthesizer with rate/pitch tuning |
| Haptics | UIImpactFeedbackGenerator on correct hits |
| Accessibility | VoiceOver labels, Dynamic Type, off-white option, OpenDyslexic font |
| End-of-race screen | Hits, streak, score, currency, replay button |
| Settings | Font, background, voice, haptics, session length |
| Offline sync | Local storage + background sync when online |

## Phase 4: Prototype-to-App Bridge (Week 6)

The web prototype (`assets/code/prototype/index.html`) is used for two things:
- Validate the core loop with kids and parents before iOS polish.
- Extract the pacing constants and UX copy for the Swift app.

| Task | Deliverable |
|---|---|
| Run playtests with 5–8 kids | Recorded observations, latency notes |
| Adjust card speed, spawn rate, target ratio | Updated constants in Swift |
| Refine hint text and TTS voice | Content pack updates |
| Confirm failure-is-invisible feel | No visible "wrong" states anywhere |

## Phase 5: Parent Companion (Weeks 7–8, thin v1)

A lightweight view inside the same app (not a separate app yet).

| Task | Deliverable |
|---|---|
| Parent gate | Math or swipe challenge to enter |
| Progress dashboard | Weekly minutes, skill growth, streak |
| Settings override | Accessibility, session length, data export |
| COPPA/GDPR-K compliance | Minimal PII, no ad SDKs, export/delete controls |

## Phase 6: Polish & Launch Prep (Weeks 8–10)

| Task | Deliverable |
|---|---|
| App icon & launch assets | All sizes for iOS, App Store screenshots |
| App Store metadata | Description, keywords, privacy policy URL |
| Beta via TestFlight | Internal + external testers |
| Efficacy pre-study design | Pre/post measures using the event store |
| Bug bash + performance pass | 60fps on iPhone 12+, cold start <2s |

## Recommended Tech Stack

- **Language:** Swift 5.9+
- **UI:** SwiftUI for hub/settings, SpriteKit for the race scene
- **Persistence:** SwiftData or Core Data for profile; SQLite for events
- **Networking:** URLSession for content pack + sync
- **Audio:** AVSpeechSynthesizer + AVAudioPlayer for SFX
- **Haptics:** Core Haptics on supported devices, fallback UIImpactFeedback
- **Content format:** JSON with Swift `Codable` models, validated on decode
- **CI:** GitHub Actions running schema validation + unit tests

## Risk Mitigation

| Risk | Mitigation |
|---|---|
| Over-engineering the platform | Phase 1 is deliberately thin; only what Chunk Racer truly needs |
| Content bottleneck | Content-as-data + Python validator lets non-engineers author packs |
| Adaptive engine feels like a toy | Build simple rules first, leave clean interface for Bayesian upgrade later |
| Accessibility regressions | Accessibility audit checklist in every PR |
| Playtest recruitment | Partner with one local reading clinic or parent group early |

## Definition of Done for v1

- [ ] Kid can complete a 60s race without reading instructions.
- [ ] No visible "wrong" feedback anywhere.
- [ ] Accessibility defaults are on and tested with VoiceOver.
- [ ] Events capture accuracy, latency, and skill per item.
- [ ] Parent can view progress and change settings.
- [ ] App works offline; syncs on reconnect.
- [ ] Content packs can be updated without an App Store release.
- [ ] App Store-ready build passes TestFlight review.

---

*Assets are in `/assets`. Shared core, content, design, and documentation are all starter-ready.*
