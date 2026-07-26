# Decoder — Sprint Plan: Chunk Racer (Flagship) to Launch

**Scope:** the thin shared core + **Chunk Racer** through App Store submission and launch.
**Team assumption:** solo / very small (1–3). Mostly sequential; **art is the parallel track** (Lead Graphic Principal).
**Cadence:** 2-week sprints. Sprint 0 + 12 sprints ≈ **26 weeks (~6 months)**.
Companion to: `decoder-build-doc.md` (architecture), `decoder-art-bible.md` (art).

> **Reality check for a tiny team:** 26 weeks is *aggressive but achievable* if scope holds. The single biggest risk is one person building both the platform *and* the game. Guard scope hard (see §4 MoSCoW) and treat the two kid-playtest gates as non-negotiable — they save you from polishing the wrong thing.

---

## 1. How this plan is sequenced (the dependency spine)

```
Sprint 0        Foundations  ─┐
Sprints 1–2     Thin core    ─┤ (profile · skill graph · adaptive engine · economy)
Sprint 3        Gray-box loop ┘ ── validate FEEL before investing in art
Sprint 4        PLAYTEST #1 + feedback systems  ◄── first gate
Sprints 5–7     Real art · game feel · a11y · onboarding
Sprint 8        Content + adaptive tuning
Sprint 9        Privacy · offline · performance
Sprint 10       PLAYTEST #2 (beta)  ◄── second gate
Sprints 11–12   Submit · launch · stabilize
```

**Why gray-box before art (Sprint 3 → 4 → 5):** the invisible-failure tone and the rhythm/pace *feel* are the make-or-break, and they can only be judged by real dyslexic/ADHD kids. Validate the loop with placeholder art in Sprint 4, *then* pour art in from Sprint 5. Doing it the other way risks re-skinning a loop that doesn't work.

**Two tracks per sprint:** 🛠️ **Eng** (the dev) runs sequentially down the spine. 🎨 **Art** (you) runs ahead in parallel, following the art-bible §9 critical path so assets are ready when integration needs them.

---

## 2. Sprint-by-sprint

### Sprint 0 · Weeks 1–2 · Foundations & risk spike
🛠️ **Eng**
- Repo, Xcode **Universal target (iPhone UI only)**, SwiftUI + SpriteKit app shell, TestFlight/CI pipeline.
- Design-token layer from the art bible (palette, two type roles) as a Swift theme.
- **Content-pack schema v0** (JSON) + validator + one hand-authored sample pack.
- Event store scaffold (append-only local + sync stub).
- **Risk spike:** SpriteKit rhythm-timing + Core Haptics feasibility on device.

🎨 **Art**
- **Master style frame** — one hero Chunk Racer screen fully rendered; locks the visual language.
- Deliver locked palette + type roles as tokens.

✅ **Exit:** app builds to a device, renders a themed screen, loads the sample pack, logs one event. Timing spike answers "is the rhythm loop feasible?"

---

### Sprint 1 · Weeks 3–4 · Thin core I — profile + skill graph
🛠️ **Eng**
- Learner profile (local, parent-gated creation).
- Skill-graph data model + the **fluency slice** of nodes.
- SkillState mastery tracking + persistence.

🎨 **Art**
- Primary **guide character** concept + turnaround (pre-rig approval).

✅ **Exit:** create a learner, see fluency skill nodes, mastery persists across launches.

---

### Sprint 2 · Weeks 5–6 · Thin core II — adaptive engine v1 + economy
🛠️ **Eng**
- **Adaptive engine v1:** selection + within-node difficulty + spaced repetition (SM-2-style), pace-regulation interface. Rules-based, clean seam for a smarter model later.
- Reward economy minimal (currency earn/spend, unlock).

🎨 **Art**
- Decoder Kit **currency icon** + core tool icons.
- **UI kit**: primary/secondary buttons, toggles (9-slice).

✅ **Exit:** engine serves the next item from a pack and schedules re-serves; currency earns and spends.

---

### Sprint 3 · Weeks 7–8 · Chunk Racer gray-box core loop
🛠️ **Eng**
- Playable loop with **placeholder art**: chunks approach → recognize-on-sight → rhythm/pace → hit/miss.
- Wire loop to the adaptive engine + event logging.
- Recruit 3–5 kids for the playtest (schedule now).

🎨 **Art**
- Chunk-tile **visual grammar** + racer/vehicle rough.

✅ **Exit:** end-to-end **playable gray-box**; internal demo. Loop is fun *before* any polish.

---

### Sprint 4 · Weeks 9–10 · 🚩 Playtest #1 + feedback systems
🛠️ **Eng**
- **Kid gray-box playtest** (3–5 dyslexic/ADHD kids) — observe tone, pace, frustration.
- Build the **invisible-failure feedback system** (no red X / buzzer / frown) + **forgiving momentum meter** (with protected rest-day state).
- Iterate the loop from playtest findings.

🎨 **Art**
- Invisible-failure feedback visuals, momentum-meter states, success/celebrate (+ Reduce-Motion variant).

✅ **Exit / GATE:** kids re-engage after a miss without shame; momentum meter forgives; playtest learnings logged and actioned. *If the loop isn't fun here, stop and fix it before Sprint 5.*

---

### Sprint 5 · Weeks 11–12 · Art integration + game feel/juice
🛠️ **Eng**
- Asset pipeline: **asset-key resolution**, vector import, texture atlases.
- Replace placeholders with real art; particle juice; **Core Haptics** on iPhone; **abstract-cue → visual** layer (so iPad later needs no rework).
- Reduce-Motion variants wired.

🎨 **Art**
- Full **Chunk Racer** set: track environment, **rigged** vehicle, chunk hit/near-miss states. Start viseme set.

✅ **Exit:** the game looks and feels real; visual + audio + haptic land on every core beat; Reduce-Motion works.

---

### Sprint 6 · Weeks 13–14 · Accessibility foundation
🛠️ **Eng**
- Full **VoiceOver**, **Dynamic Type**, adjustable spacing/line-height, bg-tint options, reading ruler, TTS read-back.
- Contrast audit vs WCAG AA across all delivered art.

🎨 **Art**
- Accessibility-control icons; **dark-mode variants** across delivered assets.

✅ **Exit:** fully operable via VoiceOver; typography controls work; AA pass on every screen.

---

### Sprint 7 · Weeks 15–16 · Onboarding, parent gate, session shaping
🛠️ **Eng**
- Short first-run onboarding; **parent gate** (COPPA-aligned); session shaping (3–7 min, **end on a win**).
- Integrate guide-character emotes (encourage / celebrate / mouth-shapes).

🎨 **Art**
- Guide character **fully rigged** + emote/mouth-shape library; onboarding illustrations; **app icon** + launch screen.

✅ **Exit:** cold start → first game in under a minute; parent gate in place; sessions end on a win.

---

### Sprint 8 · Weeks 17–18 · Content build-out + adaptive tuning
🛠️ **Eng**
- Author real **fluency content packs** — enough for weeks of play; difficulty banding.
- Tune the adaptive engine against real content; validate spaced-repetition scheduling.

🎨 **Art**
- Remaining prop/scene variants; **App Store screenshot frames**.

✅ **Exit:** enough content for sustained play; difficulty curve feels right in internal testing.

---

### Sprint 9 · Weeks 19–20 · Privacy, offline, performance
🛠️ **Eng**
- **COPPA / GDPR-K:** minimal PII, data export/delete controls, **no ad SDKs**, App Store privacy nutrition label.
- **Offline-first:** sessions work with no connectivity; sync on reconnect.
- Performance: frame rate, memory, battery; test on an older min-spec iPhone.

✅ **Exit:** privacy checklist green; smooth on min-spec device; offline sessions verified.

---

### Sprint 10 · Weeks 21–22 · 🚩 Playtest #2 (beta) + polish
🛠️ **Eng**
- **TestFlight beta** with real families (dyslexic/ADHD kids); gather **retention + early skill-growth signal**.
- Bug bash + polish pass.

🎨 **Art**
- Polish punch-list; any missing states surfaced by beta.

✅ **Exit / GATE:** beta stable; retention and skill signals reviewed; punch-list triaged. *This is where you confirm kids come back and skills move — the whole thesis.*

---

### Sprint 11 · Weeks 23–24 · Submission + parent evidence
🛠️ **Eng**
- Final App Store assets (**icon ladder**, screenshots, description, metadata), age rating; **submit to review**.
- Basic **parent evidence view**: skill growth over time (decoding/fluency), from the event store.

🎨 **Art**
- Final store creative; icon ladder QA at all sizes (legible at 60 px).

✅ **Exit:** submitted to App Review; parent-facing evidence view live.

---

### Sprint 12 · Weeks 25–26 · Launch + stabilization (buffer)
🛠️ **Eng**
- Address review feedback, launch, monitor, hotfix buffer.
- Retro; stand up the Horizon-1 **content cadence** (regular new packs).

✅ **Exit:** live on the App Store; monitoring + a content-release rhythm in place.

---

## 3. Milestones & Gates

| Milestone | Sprint | The question it answers |
|---|---|---|
| Foundations proven | 0 | Is the rhythm loop technically feasible? |
| Thin core done | 2 | Can the platform serve/adapt/reward? |
| Playable gray-box | 3 | Is the loop fun without polish? |
| 🚩 **Playtest #1** | 4 | Is the *tone* right — no shame, kids re-engage? |
| Feature-complete | 8 | Is there enough game and content? |
| Ship-ready | 9 | Private, offline, performant? |
| 🚩 **Beta / Playtest #2** | 10 | Do kids come back and do skills move? |
| Launch | 12 | Live and stable. |

---

## 4. Scope guard (MoSCoW for the v1 launch)

If the plan slips, cut from the bottom — never cut the two playtests or the accessibility/privacy work.

- **Must:** thin core (profile, skill graph, adaptive v1, economy), Chunk Racer loop, invisible-failure system, forgiving momentum, VoiceOver + Dynamic Type + dyslexia typography controls, COPPA/offline, one solid content bank, app icon/launch/store assets.
- **Should:** parent evidence view, full viseme set, rich juice/particle polish, multiple bg tints.
- **Could:** secondary guide characters, extended tool/inventory art, seasonal pack.
- **Won't (this release):** iPad UI, apps #2–5, Apple Pencil, authoring tools, classroom mode. *(All kept cheap by the §8.2 discipline — not built now.)*

---

## 5. Solo/tiny-team risks

| Risk | Mitigation |
|---|---|
| One person building platform **and** game → overload | Keep the core *thin* (only what Chunk Racer needs); resist gold-plating in Sprints 1–2. |
| Bus factor / knowledge silo | Keep the docs current; commit small; note decisions in the build doc. |
| Polishing before validating | Hard gate at Sprint 4 — no real-art investment until the gray-box loop earns it. |
| Art track outrunning or lagging eng | Art follows art-bible §9 order; the per-sprint 🎨 line keeps it synced to integration needs. |
| Burnout over 6 months | Sprint 12 is a real buffer, not filler; protect it. Reforecast at the Sprint 4 and Sprint 8 gates. |
| Adaptive engine underbuilt → "toy" | v1 is rules + spaced repetition, but tuned with real content in Sprint 8, not hand-waved. |

---

## 6. After launch (hand-off to the roadmap)

Launch is **Horizon 1** in the build doc. The immediate post-launch loop is *not* app #2 — it's **more content + smarter adaptation inside Chunk Racer** to prove retention and outcomes. App #2 (Sound Forge) reuses this entire plan's core and pipeline, so its sprint plan will be shorter — it inherits the platform. Draft that only once Chunk Racer's retention/skill signal is real.

---

*Validate the feel before the finish. Two kid playtests are the spine of this plan — everything else is in service of getting the loop in front of them, then making what works beautiful.*
