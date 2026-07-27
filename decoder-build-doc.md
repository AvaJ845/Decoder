# Decoder — Architectural Build Document

**A platform-first series of reading-strategy games for kids with dyslexia and ADHD.**

Version 0.1 · Draft for engineering + design review
Author: Product concept compiled 2026-07-26

---

## 0. TL;DR

Decoder is **one platform expressed as many small games**, not a franchise of separate apps. Five launch titles share a common core (learner profile, skill graph, reward economy, adaptive engine) and load their content as data, not code. That single decision is what makes the series *compounding*: every future addition — new games, seasonal packs, curriculum alignment, new languages — inherits the platform and gets cheaper and more valuable over time.

Build the shared core thin, launch **one flagship exceptionally well**, prove kids return and skills move, then expand.

---

## 1. Vision & Core Insight

Dyslexia and ADHD get lumped together but are different problems:

- **Dyslexia** is a *decoding* problem — mapping symbols to sounds and doing it fast enough that meaning survives.
- **ADHD** is a *regulation* problem — starting, sustaining, and not being punished by the interface for looking away.

Decoder treats **reading strategy as the shared spine** and lets each app lean into one need, while never making a kid feel remediated. Everything is a real game with genuine strategy, with evidence-based literacy structure (structured literacy / Orton-Gillingham principles) underneath.

**Design north star:** A kid should feel like they're playing, a parent should see measurable skill growth, and a specialist should recognize the pedagogy.

---

## 2. Product Principles (apply to every app)

| Principle | What it means in the build |
|---|---|
| **Failure is invisible** | No red X's, no "wrong." A miss quietly re-serves the item later via spaced repetition. Shame is the #1 reason these kids quit. |
| **Short by default** | Sessions default to 3–7 min. Core challenges are 60–90 sec. Respect the attention budget instead of fighting it. |
| **Multisensory always** | Every core interaction fires audio + visual + haptic together. |
| **Typography is the product, not a menu** | OpenDyslexic option, adjustable spacing/line-height, one-line "reading ruler," off-white backgrounds (pure white glares for many dyslexic readers). |
| **Streaks that forgive** | Momentum-based, not punishment-based. One bad day never resets 30 days of progress. |
| **Accessibility is default, not opt-in** | Full VoiceOver/TalkBack, dyslexia-friendly defaults on day one. |
| **Evidence is a feature** | Real skill metrics (decoding accuracy, fluency WPM, strategy use) captured from v1. Impossible to retrofit later. |

---

## 3. The Apps (launch series)

One universe, one friendly world, shared profile and reward economy. Apps unlock progressively.

| # | App | Target need | Core loop |
|---|---|---|---|
| 1 | **Sound Forge** | Decoding / phonics | Snap sound-chunks (phonemes/onsets/rimes) together to "forge" words. Tap → hear → haptic click → see mouth shape. Strategy: build the longest valid word from limited chunks. Orton-Gillingham structure as a crafting game. |
| 2 | **Chunk Racer** | Fluency / automaticity | Rhythm/racing game — keep pace by recognizing word-chunks on sight. Pace adapts, never shames a miss. Tight feedback loop, no dead air (ADHD win). |
| 3 | **Clue Hunt** | Comprehension strategy | Detective game. Research-backed strategies (predict, question, visualize, infer, summarize) are "detective tools" the kid *chooses* to deploy on a passage. Teaches metacognition — how to attack text. |
| 4 | **Focus Dojo** | ADHD executive function | Reading *stamina*, not content. 60–90 sec "belt" challenges, body-doubling timers, a "brain-dump" parking lot for intrusive thoughts, forgiving momentum streaks. |
| 5 | **Story Studio** | Motivation / output | Remix and finish stories using unlocked words. Reading becomes a means to *making*. Text-to-speech reads their own writing back. |

**The series moat — the Decoder Kit:** every strategy a kid learns becomes a reusable tool that appears across all apps. Learn "chunking" in Sound Forge → it's a power in Chunk Racer → a tactic in Clue Hunt. Strategies become *transferable skills*, the exact thing these kids are told they lack.

---

## 4. System Architecture

The whole series stands on **four shared services** plus a **content pipeline**. A "new app" is mostly new content + skin, not new plumbing.

```
┌──────────────────────────────────────────────────────────────┐
│                        DECODER PLATFORM                        │
│                                                                │
│   ┌────────────────┐  ┌────────────────┐  ┌────────────────┐  │
│   │ Learner Profile│  │  Skill Graph   │  │ Reward Economy │  │
│   │  (who they are)│  │ (what to learn)│  │ (Decoder Kit)  │  │
│   └───────┬────────┘  └───────┬────────┘  └───────┬────────┘  │
│           │                   │                   │           │
│           └─────────┬─────────┴─────────┬─────────┘           │
│                     │                   │                     │
│              ┌──────▼───────────────────▼──────┐              │
│              │        Adaptive Engine           │              │
│              │  (what to serve next, & how hard)│              │
│              └──────────────┬───────────────────┘             │
│                             │                                 │
│              ┌──────────────▼───────────────────┐             │
│              │        Content Pipeline           │             │
│              │  (packs loaded as DATA, not code) │             │
│              └──────────────┬───────────────────┘             │
└─────────────────────────────┼─────────────────────────────────┘
                              │
      ┌──────────┬────────────┼────────────┬──────────┐
      ▼          ▼            ▼            ▼          ▼
 Sound Forge  Chunk Racer  Clue Hunt  Focus Dojo  Story Studio
      │          │            │            │          │
      └──────────┴─────┬──────┴────────────┴──────────┘
                       ▼
             Parent / Teacher Companion
               (dashboard & reporting)
```

### 4.1 Shared Core Services

**A. Learner Profile** — lives *above* the apps.
- Skill mastery state, current pace, accessibility preferences, session history.
- One profile per child; a parent/guardian account can hold several.
- Portable across every current and future app — no re-onboarding.

**B. Skill Graph** — the map of every micro-skill and its prerequisites.
- Decode short vowels → blend chunks → read fluently → infer meaning, etc.
- Every game is a *different way to practice a node* on this graph.
- **New content = new nodes/packs, no re-architecting.** (See §5.)

**C. Reward Economy (Decoder Kit)** — one currency and one inventory of "tools."
- **Local-active, global-passive (D23):** each app owns an immediate, self-contained, high-velocity reward loop; the shared inventory is a **passive, automated collection** that accrues in the background — never something a child exits an app to "spend." ADHD optimizes for immediate local novelty, so cross-app navigate-to-spend friction destroys a token's value.
- Add a game later and it slots into the existing economy instead of inventing its own.
- Tools are the cross-app strategies that form the moat.

**D. Adaptive Engine** — the crown jewel. (See §6.)
- Decides what to serve next and at what difficulty, from the profile.
- Built once; every current and future app gets smarter for free.

### 4.2 Content as Data, Not Code (highest-leverage decision)

Levels, passages, word-chunk sets, and story templates are authored as **content packs** the app loads at runtime — never hardcoded. Once true, "feature additions" become "author and publish," doable by a small team, curriculum partner, or specialist without an engineering release:

- Seasonal packs (Halloween word hunt, space unit)
- Curriculum-aligned packs (district asks for grade-3 alignment → author a pack)
- Difficulty expansions
- New languages later (the phonics *engine* is the hard part; Spanish/French become packs on top)

**Requirement:** define a versioned content-pack schema (JSON/CBOR) with validation, before authoring the first level.

---

## 5. The Skill Graph (reading-strategy spine)

A directed acyclic graph of micro-skills. Nodes carry: id, name, prerequisites, target mastery threshold, and which game surfaces practice it. Illustrative spine:

```
[Phonemic awareness]
      → [Letter–sound correspondence]
            → [Blend onset+rime]
                  → [Decode CVC words]
                        → [Decode digraphs/blends]
                              → [Multisyllable chunking]
                                    → [Sight-word automaticity]
                                          → [Fluency @ target WPM]
                                                → [Literal comprehension]
                                                      → [Inference]
                                                      → [Summarizing]
                                                      → [Prediction/questioning]
```

Executive-function skills (initiation, sustained attention, self-monitoring) run as a **parallel track** surfaced by Focus Dojo and woven into every session's pacing.

**Design rule:** a skill node is mastered only via spaced, distributed success — not a single correct answer. Mastery decays without practice, and the adaptive engine schedules review.

---

## 6. Adaptive Engine (make-or-break)

A pretty game with dumb difficulty progression is just a toy. Budget for this like it's the product — because it is.

**Responsibilities**
1. **Selection** — pick the next skill node to practice (target the edge of ability, not too easy/hard).
2. **Difficulty** — tune item difficulty within a node to keep the kid in flow.
3. **Spaced repetition** — schedule review of shaky items (SM-2-style or a modern variant), and quietly re-serve misses.
4. **Pace regulation** — adapt speed to the child, never punish a miss with a shame state.
5. **Session shaping** — respect the 3–7 min budget; end on a win.

**Inputs:** per-item response correctness + latency, streak/momentum state, time-of-day/session-length signals, accessibility settings.

**Start simple, design to grow:** v1 can be a well-tuned rules + spaced-repetition system. Leave a clean interface so it can evolve into a model-driven mastery estimator (e.g., Bayesian knowledge tracing) later without touching the games.

---

## 7. Data Model (sketch)

```
Account
 ├─ id, role (parent/teacher), auth, subscription
 └─ Learners[]

Learner
 ├─ id, displayName, ageBand
 ├─ accessibilityPrefs { font, spacing, lineHeight, bgTint, ruler, tts }
 ├─ SkillState[]  → { skillId, mastery 0–1, lastPracticed, dueAt }
 ├─ Inventory     → { toolIds[], currencyBalance }
 └─ SessionLog[]  → { appId, start, end, itemsAttempted, outcomes }

ContentPack   (data, not code — versioned & validated; PLATFORM-AGNOSTIC)
 ├─ id, version, appId, locale, skillIds[]
 └─ Items[]   → { itemId, skillId, payload, difficultyBand,
                  assetKeys[],          // keys, NOT pixel files — app resolves @2x/@3x + form factor
                  cues[],               // abstract: { emphasis:"strong", type:"snap" } — app maps to haptics/audio/visual
                  minCanvas,            // complexity hint; layout stays in the app, keyed to size class
                  enhancedInput[] }     // optional enrichments e.g. ["pencil"] — never required

Event  (analytics + evidence, append-only)
 └─ { learnerId, appId, itemId, correct, latencyMs, ts }
```

The three fields in bold above (`assetKeys`, `cues`, `enhancedInput`, `minCanvas`) are the **device-capability/presentation layer**. They keep the pedagogical content platform-neutral while letting each device render it natively — and they are what make "iPad later" a drop-in rather than a rewrite. See §8.1.

**Privacy note:** children's data. Design for COPPA/GDPR-K from day one — minimal PII, parent-gated accounts, no third-party ad SDKs, data-retention and export/delete controls baked in. This is both a legal and a trust requirement for this audience.

---

## 8. Tech Stack — Native iOS (iPhone first, iPad later)

**Platform decision:** iOS-native. iPhone-first launch; iPad as a later phase (see §8.2). Optimize for excellent typography/accessibility control, Core Haptics, offline-capable sessions, and one codebase feeding many small games.

- **Client:** **Swift / SwiftUI + SpriteKit**, one shared app shell hosting the games. Best-in-class VoiceOver, Dynamic Type, typography fidelity, and Core Haptics. Build the target as **Universal (iPhone + iPad) from day one**, but only ship/QA the iPhone UI first — this reserves the iPad identity without building its layout yet.
- **Shared core:** a Swift package (profile, skill graph, economy, adaptive engine) consumed by every game. The literal expression of "one platform, many games."
- **Content pipeline:** versioned JSON/CBOR packs + schema validator. Deliver via **On-Demand Resources (ODR)** or CloudKit so new packs ship without an App Store release — the iOS-native "author and publish."
- **Backend:** thin sync service for profile/progress + event ingestion. **Offline-first** client (sessions must work with no connectivity); sync on reconnect.
- **Analytics/evidence:** append-only event store feeding both the adaptive engine and the parent/teacher dashboard.
- **Companion:** parent/teacher dashboard (web first; native later) reads the same event store.

### 8.1 iOS/iPadOS Presentation Layer

The pedagogical content stays platform-neutral (§7). Device specifics live in a thin layer so the same pack renders natively on any Apple device:

- **Assets by key, not by file.** Content references `assetKey`; the asset catalog resolves @2x/@3x and, later, iPad variants. Prefer **vector/PDF assets** so one asset scales across all form factors.
- **Abstract cues, not device calls.** Content declares intent (`{emphasis:"strong", type:"snap"}`); the app maps it to Core Haptics on iPhone and audio/visual emphasis elsewhere. **Never** encode a specific haptic pattern in content — critically, **iPad has no haptic engine**, so haptics can never be a hard requirement.
- **Layout by size class, not device.** Layout lives in the app and keys to size class + available space — not "iPhone vs iPad." This is what survives iPad Split View / Slide Over later.
- **Optional input modalities.** `enhancedInput` (e.g. `["pencil"]`) is enrichment only. iPhone (no Pencil) always has a first-class path; iPad can light up Apple Pencil later for Story Studio (writing) and Sound Forge (letter-sound tracing).
- **Dynamic Type + semantic sizing.** Text references semantic sizes, never fixed points — which the dyslexia-friendly typography controls need anyway.

### 8.2 Why iPhone-first is nearly free to extend to iPad

Building the §8.1 abstractions now — not the iPad UI now — means iPad becomes additive, not a rewrite:

| iPhone-first (now) | What it buys for iPad (later) |
|---|---|
| Core Haptics fully in play — "multisensory always" works completely on iPhone | Cue abstraction already routes to audio/visual, so the iPad's *no-haptics* case is already handled |
| Layout keyed to size class, not device | iPad's larger canvas + multitasking widths just fall out of the same layout code |
| Assets referenced by key, vector-first | iPad @-resolution / larger variants added to the catalog, no content edits |
| `enhancedInput` present but unused on iPhone | Apple Pencil support becomes a feature flip, not a redesign |
| Universal target reserved, iPhone UI only | iPad is a UI/QA phase, not a new app |

**iPhone-first discipline:** don't build iPad layouts yet, but never write anything that *assumes* iPhone — no hardcoded haptics-required items, no device-keyed layout, no pixel-baked assets. Those three habits are the entire cost of keeping iPad cheap.

### 8.3 Platform Strategy — iPhone first, iPad on the roadmap (not iPhone-only)

**Decision: iPhone launches the series; iPad is a committed later phase — not abandoned.** These are two separate calls and the doc treats them separately.

*Why iPhone-first is right:* the core design (3–7 min sessions, phone-in-a-waiting-room moments, forgiving momentum streaks) is native to the phone, Core Haptics is fully in play, and one form factor is faster to nail.

*Why iPad stays on the roadmap:* kids' literacy is an **iPad-heavy category.** Many kids in the 5–10 band don't have their own iPhone but do have an iPad (home or shared); schools, reading specialists, and SLPs run on iPads; and reading itself wants screen — the reading ruler, longer passages, and less scrolling all read better on the larger canvas. Going iPhone-*only* forever would quietly cap the brand exactly where it's meant to grow (the education channel and the comprehension/writing titles), and would be the *more expensive* choice long-term — a retrofit the day a district asks for iPad.

*Not all five apps weigh the same:* the decoding/fluency games (**Sound Forge, Chunk Racer**) are excellent on a phone; the comprehension/writing games (**Clue Hunt, Story Studio**) genuinely want the iPad canvas.

**Milestone tie:** target iPad to arrive around the push of **Clue Hunt / Story Studio and the first school conversations** — i.e., iPad shows up exactly when the apps and the channel that need it do. Until then, hold the §8.2 discipline so it stays a cheap UI/QA phase.

---

## 9. Roadmap — Three Horizons

**Horizon 1 — Depth (launch + first year).**
Ship *one* flagship (recommend **Chunk Racer** or **Sound Forge** — tightest, most measurable outcome) as a complete, delightful thing. Prove kids return and skills move. Then the first "additions" are **more content + smarter adaptation inside existing apps**, not new apps. This is where retention and outcomes are earned.

**Horizon 2 — New skill surfaces.**
New games reusing the whole platform:
- Spelling/encoding (the inverse of decoding)
- Vocabulary depth
- Handwriting/dysgraphia support
- **Math word-problems** (reading strategy applied to math — large underserved space)

**Horizon 3 — Ecosystem.**
- Parent/teacher companion grows into a real dashboard
- Classroom / small-group mode
- Content-authoring tool so SLPs, reading tutors, and teachers create and share packs

That last step turns a series into a **platform with a community** — the durable business.

---

## 10. Measurement & Evidence

For this audience, evidence is what gets you past skeptical parents, into schools, and recommended by specialists.

- Capture from v1: **decoding accuracy, fluency (WPM), strategy usage, session stamina, retention.**
- Align content to accepted frameworks (structured literacy / Orton-Gillingham) and make that alignment legible in the pack metadata.
- Parent/teacher dashboard shows **real skill growth over time**, not vanity engagement.
- Design an eventual efficacy study path (pre/post skill measures) — the event store already holds the data if built per §7.

---

## 11. Risks & Mitigations

| Risk | Mitigation |
|---|---|
| Launching all five at once dilutes focus and quality | Ship one flagship first; prove it works before expanding |
| Under-investing in the adaptive engine → toy, not tool | Budget it as the core product; clean interface to upgrade later |
| Over-engineering the platform before shipping | Build the *thin* version of the four services app #1 truly needs, designed to grow |
| No evidence → can't win parents/schools | Bake measurement in from v1; it can't be retrofitted |
| Children's-data compliance retrofitted late | COPPA/GDPR-K, minimal PII, no ad SDKs from day one |
| Content bottleneck as series grows | Content-as-data + eventual authoring tool decouple content from engineering |

---

## 12. Immediate Next Steps

1. **Pick the flagship** (recommend Chunk Racer or Sound Forge) and scope it as a complete iPhone v1.
2. **Define the content-pack schema** (versioned, validated, platform-agnostic with the §8.1 presentation fields) before authoring any levels.
3. **Spec the thin shared core** — the minimum viable Profile / Skill Graph / Economy / Adaptive Engine the flagship needs, designed for growth. Build as a Swift package, Universal target, iPhone UI only.
4. **Draft the skill graph** for the flagship's slice of the spine (§5).
5. **Stand up the event store** so evidence collection exists from the first playtest.
6. **Prototype the core loop** with real dyslexic/ADHD kids early — the failure-is-invisible and pacing feel can only be validated with the actual audience.
7. **Hold the iPhone-first discipline** (§8.2): no hardcoded-haptic-required items, no device-keyed layout, no pixel-baked assets — the three habits that keep the later iPad phase cheap.

> **Execution plan:** these next steps are sequenced into 2-week sprints — thin core + Chunk Racer through App Store launch — in **`decoder-sprint-plan.md`**.

---

## 13. Art Direction & Graphics Asset Specification

*For the lead graphic principal. This section defines the visual language, the technical delivery rules that fit the platform architecture (§8.1), and the full asset inventory. Assets are produced at the highest quality and delivered so a single source scales cleanly from iPhone today to iPad later.*

> **Companion doc:** the full production version of this section — with fill-in palette tables, the naming convention, per-asset checklists, and a Definition of Done — lives in **`decoder-art-bible.md`**. This section is the summary; the art bible is the working document.

### 13.1 Art Direction — the feel that converts *these* kids

Three audience truths drive every visual decision:

1. **Appealing, never babyish.** A 9-year-old dyslexic reader working at a lower reading level must not be handed a toddler aesthetic — that reads as "this is for babies" and they quit. Aim for a style that a 6-year-old finds warm and a 10-year-old finds *cool*: expressive characters, confident shapes, a hint of edge. Think "beloved animated series," not "preschool flashcard."
2. **Calm energy for ADHD.** Rich and characterful, but **not overstimulating.** Clean compositions, generous negative space, a controlled palette, and motion that's purposeful (juice on success) rather than ambient chaos. The screen should never compete with the task.
3. **Dignity for dyslexia.** The visuals carry the warmth so the *reading surface* can stay clean. Never decorate the text itself.

**Character-led.** Kids bond with characters, not UI. The series needs a small cast of **guide characters** (the friendly faces of the Decoder Kit) that recur across all five apps — this is both the emotional hook and the brand's connective tissue. Design them rig-ready (see §13.3) because they must emote: celebrate, encourage, model mouth shapes, react to a near-miss with warmth, never disappointment.

**Inclusive by default.** Diverse skin tones, abilities, and presentations across characters and any human figures — this audience and its parents notice, and it's the right call.

**Style guardrails**
- Bold, rounded, friendly geometry; thick confident linework or clean flat shapes (pick one system and hold it).
- **Color means delight, never meaning.** Because ~1 in 12 boys is colorblind and the audience is neurodivergent, no game state may be communicated by color alone — always pair with shape, icon, position, or motion.
- **Off-white, low-glare backgrounds** (pure white glares for many dyslexic readers). Support a user `bgTint` preference (cream / soft blue / grey) — design art to sit on *any* of those tints, so keep large flat character backfields transparent.
- **Full dark-mode variants** for every asset. Not an inversion — a designed dark palette.
- **Reduce-Motion variants**: every animated celebration needs a calm static/low-motion alternative (accessibility setting + ADHD overwhelm).

### 13.2 Color, Contrast & Type (art constraints, not suggestions)

- **Contrast:** interactive elements and any text-bearing art meet WCAG AA (4.5:1 text, 3:1 large/graphical). Build a contrast-checked master palette.
- **Display P3 color profile** for iPhone (wide gamut) with sRGB fallbacks exported.
- **Two type roles, kept separate:**
  - *Display/brand type* — characterful, used in logos, titles, buttons, celebrations.
  - *Reading type* — the surface kids actually decode. Dyslexia-friendly (OpenDyslexic offered; also a clean humanist sans as default), with user-adjustable spacing/line-height and a reading-ruler treatment. **Never** style, texture, or animate reading type. These two roles must never bleed into each other.

### 13.3 Technical Delivery Spec (fits §8.1: asset-by-key, vector-first)

- **Vector-first.** Deliver UI, icons, characters, and props as **vector (SVG / PDF)** wherever possible so one source scales iPhone → iPad → @3x with zero re-export. This is the single most important rule for keeping iPad cheap.
- **Raster where vector can't (painterly scenes, textures):** author at the largest target (iPad Pro 12.9″ @2x = ~2732 px long edge) and export @1x/@2x/@3x. Never author to phone size and scale up.
- **Naming = asset keys.** File/slice names map 1:1 to the content schema's `assetKey` values (§7). Agree the naming convention *before* production: `app_object_state`, e.g. `forge_anvil_idle`, `racer_chunk_hit`, `kit_tool_chunking`.
- **Layered & rig-ready.** Characters and any object that must animate are delivered in **separated layers / skeletal rigs**, not flattened — so engineering can animate in SpriteKit or export **Lottie** (vector UI animation) and **texture atlases / sprite sheets** (game animation). Provide a short animation intent note per character (idle, celebrate, encourage, mouth-shapes).
- **Safe areas & scalability:** design to size-class layout, not fixed device frames (§8.1). Provide 9-slice / stretchable specs for any framed UI (buttons, panels) so they resize without distortion.
- **Transparency:** characters/props on transparent backgrounds (they sit on user-tinted backfields).
- **Abstract-cue visuals:** where content fires an abstract `cue` (§7), supply the *visual* half (flash, bounce, particle burst) so iPad — which has no haptics — still lands the multisensory beat via visuals + audio.
- **Icon/marketing set:** App Store icon at 1024×1024 (no alpha, no rounding — Apple rounds), plus the full iOS icon size ladder, per app.

### 13.4 Asset Inventory

Organized by shared vs. per-app. **Bold = needed for the iPhone flagship v1; the rest phase in.**

**A. Brand & Identity (series-level)**
- Series wordmark + the five app wordmarks/logos.
- **App icon per app** (full iOS size ladder + 1024 marketing) — must read at 60 px and feel like a set.
- **Launch screens** per app (calm, fast, on-brand).
- App Store screenshot frames & feature-graphic templates (marketing).

**B. Guide Characters (the Decoder Kit cast) — shared across all apps**
- **1 primary mascot/guide, fully rigged** (idle, celebrate, encourage, think, mouth-shape set for phonics), for v1.
- 2–4 secondary guides (phase in), each mapped to a strategy/tool.
- Expression sheets + a small emote library (reused as reward stingers).

**C. Shared UI Kit**
- **Primary/secondary buttons, toggles, sliders** (incl. the accessibility controls: font, spacing, line-height, bg-tint, ruler, TTS) — 9-slice.
- **Progress & momentum visuals:** the *forgiving* streak/momentum meter (must have a "protected/rest day" state, not just full/empty), skill-mastery indicators.
- **Reward economy (Decoder Kit):** currency icon, the tool/inventory icons (one per strategy — chunking, predicting, inferring, visualizing, summarizing…), unlock/chest moment.
- **Feedback states — the hardest and most important set:**
  - *Success/celebrate* (juicy, with Reduce-Motion static variant).
  - **"Invisible failure"** — the gentle re-serve. **No red X, no buzzer, no frown.** A warm "let's see it again later" visual language. Get this system right and the whole product's tone works.
- System illustrations: onboarding, empty states, loading, offline, parent-gate.

**D. Per-App Game Art**
- **Sound Forge (decoding)** — *flagship candidate.* The forge/anvil environment; **snap-together sound-chunk tiles** (onset/rime/phoneme) in a coherent visual grammar; forged-word reveal; **mouth-shape / articulation visuals** paired to phonemes (real pedagogical value — get these accurate).
- **Chunk Racer (fluency)** — *flagship candidate.* Track/lane environment, the racer/vehicle (rig-ready), on-sight word-chunk targets, speed/rhythm visuals, near-miss and hit states (no shame states).
- **Clue Hunt (comprehension)** — detective kit where each **strategy is a tool** (magnifier=questioning, etc.), passage/scene backdrops, clue/evidence props, the "case solved" moment. *(iPad-forward — screen-hungry.)*
- **Focus Dojo (executive function)** — dojo environment, **belt-progression** visuals, session/body-doubling timers, the **"brain-dump parking lot"** UI for intrusive thoughts.
- **Story Studio (output)** — story-building blocks/props, scene/background library, character stickers, a writing surface that respects reading-type rules, Pencil-ready hooks (iPad enrichment). *(iPad-forward.)*

**E. Audio-linked & Motion Assets**
- Mouth-shape/viseme set (shared, but Sound Forge-critical).
- Particle/juice kits for success beats.
- Lottie animations for UI transitions and celebrations.

### 13.5 Production Priority for the Flagship (v1)

To not boil the ocean, the graphic principal's v1 critical path:
1. **Master style frame** (one hero screen fully rendered) to lock the language before mass production.
2. **Contrast-checked master palette** (light + dark + tint-safe) and the two type roles.
3. **Primary guide character, fully rigged** with the core emote + mouth-shape set.
4. **Shared UI kit** incl. the **forgiving momentum meter** and the **invisible-failure feedback system**.
5. **Flagship game art** (Sound Forge *or* Chunk Racer) as a complete set.
6. **App icon + launch screen** for the flagship.
7. Everything vector-first, named to asset keys, layered/rig-ready — so iPad and apps #2–5 inherit the pipeline instead of restarting it.

---

*One growing platform, expressed as many small games. Get the four shared services and content-as-data right, launch one flagship exceptionally well, and every future addition gets cheaper and more valuable because it inherits everything before it. That's a compounding series, not a treadmill.*
