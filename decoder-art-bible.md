# Decoder — Art Bible

**The single source of truth for visual production across the Decoder series.**

Version 0.1 · Owner: Lead Graphic Principal
Companion to: `decoder-build-doc.md` (architecture). Where the build doc says *what*, this says *how it looks and how it ships*.

> **North star:** A 6-year-old finds it warm. A 10-year-old finds it *cool*. A parent finds it trustworthy. A dyslexic/ADHD kid never feels remediated. If an asset fails any one of these, it's not done.

---

## 1. Audience Truths (why every rule below exists)

1. **Appealing, never babyish.** Kids reading below their age level must not be handed a toddler aesthetic — it reads as "for babies" and they quit. Target *beloved animated series*, not *preschool flashcard*.
2. **Calm energy for ADHD.** Rich and characterful, never overstimulating. Negative space, controlled palette, purposeful motion (juice on success, quiet otherwise). The screen never competes with the task.
3. **Dignity for dyslexia.** The art carries the warmth so the *reading surface* stays clean. Never decorate the text itself.
4. **Character-led.** Kids bond with characters, not UI. The guide cast is the emotional hook *and* the brand's connective tissue across all five apps.
5. **Inclusive by default.** Diverse skin tones, abilities, and presentations. This audience and its parents notice.

---

## 2. Style Guardrails

**Hold one system — don't mix.**

- [ ] **Shape language:** bold, rounded, friendly geometry. Confident shapes with a hint of edge (cool, not cutesy).
- [ ] **Line system:** choose ONE and hold it series-wide — *thick confident linework* **or** *clean flat shapes*. (Decision owner: Lead Principal. Record choice here: `__________`)
- [ ] **Energy:** expressive characters, calm compositions. Generous negative space. No ambient motion — motion is a reward, not wallpaper.
- [ ] **Reading surface is sacred:** never style, texture, animate, or crowd the text kids decode.
- [ ] **Warmth lives in characters + rewards**, not in the reading area.
- [ ] **Backgrounds:** off-white / low-glare only. Never pure white (glares for dyslexic readers).
- [ ] **Tone of feedback:** encouraging, never corrective. There is no "wrong" in this world (see §7 Feedback States).

**Style decisions log** (fill in and freeze before mass production):
| Decision | Choice |
|---|---|
| Line system (linework vs flat) | **Thick confident linework** — bold black outlines, consistent 4–6 pt weight at artboard scale, rounded caps/joins. Reads clearly at 60 px and gives the cast a "beloved animated series" feel. |
| Primary shape motif | **Rounded rectangles with a soft chamfer** — friendly but with a slight edge (cool, not babyish). Used for buttons, cards, panels, vehicle body, and chunk tiles. |
| Character proportion (head:body ratio) | **~1:2 for the primary guide** (slightly older-kid proportions; avoids toddler "big-head" look). Secondary guides and creatures can vary. |
| Texture policy (flat / subtle grain / painterly) | **Flat with soft gradients** — solid colors plus subtle 1–2 step shadows for depth. No heavy texture, no painterly effects. Keeps vector cleanup cheap. |
| Flagship title (drives first art set) | **Chunk Racer** — tightest visual loop, clearest speed/rhythm metaphor, and best vehicle for proving the invisible-failure feedback system. |
| Case convention (reading) | **All-lowercase** for words and chunks in every reading context — target chunk, word cards, TTS captions. Uppercase is reserved for the display/brand logo only. Early-literacy standard; prevents the "AT" vs "cat" mismatch seen in the first style frame. |
| Canonical Arlo | **The clean book-body Arlo** (gold bookmark, no cape) from `ui_feedback_gentle_reserve` is canonical. Rig this one; the caped style-frame variant is superseded. |

---

## 3. Color & Palette Rules

**Color means delight — never meaning.**

- [ ] **No game state communicated by color alone.** Always pair color with shape, icon, position, or motion. (~1 in 12 boys is colorblind; audience is neurodivergent.)
- [ ] **Contrast meets WCAG AA:** 4.5:1 for text, 3:1 for large/graphical/interactive elements. Every interactive or text-bearing asset is contrast-checked.
- [ ] **Backgrounds are tint-safe.** Support user `bgTint` preference: cream / soft-blue / grey / off-white. Characters & props ship on **transparent** backfields so they sit on any tint.
- [ ] **Full dark-mode palette** — a *designed* dark palette, not an inversion.
- [ ] **Color profile:** author in **Display P3** (wide gamut, iPhone) with **sRGB fallbacks** exported.

**Master palette (define once, use everywhere):**
| Role | Light | Dark | Notes |
|---|---|---|---|
| Background (off-white base) | `#F7F4EC` | `#1A1F23` | Cream light, charcoal dark. Never pure white. |
| Reading surface | `#FFFDF7` | `#2A3036` | High-legibility card surface; AA+ contrast against text. |
| Primary brand | `#2A9D8F` (teal) | `#4ECDC4` | Main action, brand moments, vehicle, borders. |
| **Primary brand text** | `#1B7A6E` (dark teal) | `#4ECDC4` | Text on light surfaces; AA+ against cream/surface. The accent color (#2A9D8F) is too light for text on light grounds. |
| Secondary brand | `#E76F51` (coral) | `#F4A261` | Energy, highlights, secondary actions. |
| Success / celebrate | `#A67C2E` (gold) | `#FFD670` | Always paired with star burst / bounce / checkmark shape. Darkened in light mode for AA on the reading surface. |
| Gentle re-serve (NOT error) | `#5A8A8A` (soft blue) | `#7AB0B0` | Warm "try again later" cue; never red, never alarm. Darkened in light mode so the re-serve card border meets the 3:1 UI-component ratio. |
| Neutral UI / lines | `#264653` (slate) | `#CED4DA` | Outlines, body text, separators. |
| Progress / momentum green | `#8FBF5A` | `#A9D66B` | Momentum-meter fill only. Always paired with the protected/shield shape — never color alone. |

- [ ] Palette validated for the three most common color-vision deficiencies (protanopia, deuteranopia, tritanopia).
- [ ] Palette legible on all four background tints.

---

## 4. Typography Rules

**Two type roles. They never bleed into each other.**

- [ ] **Display / brand type** — characterful. Logos, titles, buttons, celebration stingers. May be styled and animated.
- [ ] **Reading type** — the surface kids decode. **Never styled, textured, or animated.**
  - [ ] OpenDyslexic offered as a user option.
  - [ ] Default = clean humanist sans (high legibility).
  - [ ] User-adjustable letter-spacing and line-height honored in all art layouts.
  - [ ] Reading-ruler treatment supported (one-line focus).
  - [ ] Uses semantic / Dynamic Type sizing — never fixed point sizes baked into art.
- [ ] Display type and reading type are visually distinct so kids never confuse "chrome" with "the thing to read."

Record chosen fonts here: Display **`Fredoka One`** · Reading (default) **`OpenDyslexic`** (with `Lexend Deca` as a system humanist fallback)

---

## 5. Technical Delivery Spec

**Vector-first is the rule that keeps iPad cheap. Follow it unless the art literally can't be vector.**

- [ ] **Vector (SVG / PDF)** for UI, icons, characters, props — one source scales iPhone → iPad → @3x with zero re-export.
- [ ] **Raster only where vector can't** (painterly scenes, textures): author at the **largest** target (iPad Pro 12.9″ @2x ≈ 2732 px long edge), export **@1x / @2x / @3x**. Never author to phone size and scale up.
- [ ] **Transparent backgrounds** on characters/props (they sit on tinted backfields).
- [ ] **Layered & rig-ready:** anything that animates is delivered in **separated layers / skeletal rig**, never flattened. Enables SpriteKit animation, **Lottie** (UI), and **texture atlases / sprite sheets** (game).
- [ ] **9-slice / stretchable specs** for any framed UI (buttons, panels) so they resize without distortion.
- [ ] **Size-class layout**, not fixed device frames (see build doc §8.1). No pixel-baked assumptions about screen size.
- [ ] **Abstract-cue visuals:** where content fires an abstract `cue`, supply the *visual* half (flash, bounce, particle burst) so iPad (no haptics) still lands the multisensory beat.
- [ ] **Reduce-Motion variant** for every animated asset — a designed calm/static alternative (accessibility + ADHD overwhelm).
- [ ] **App icons:** 1024×1024 marketing icon (no alpha, no pre-rounding — Apple rounds) + full iOS size ladder, **per app**.
- [ ] **Color profile** exported both Display P3 and sRGB.

---

## 6. Naming Convention (files = asset keys)

**File/slice names map 1:1 to the content schema's `assetKey` values. Agree this BEFORE producing anything.**

**Pattern:** `app_object_state` (all lowercase, underscore-separated)

- `app` — short code: `forge` (Sound Forge), `racer` (Chunk Racer), `hunt` (Clue Hunt), `dojo` (Focus Dojo), `studio` (Story Studio), `kit` (shared Decoder Kit), `ui` (shared UI), `brand` (identity).
- `object` — what it is: `anvil`, `chunk`, `tool_chunking`, `button_primary`, `guide_arlo`.
- `state` — variant: `idle`, `hit`, `celebrate`, `reserve`, `dark`, `disabled`, `reducemotion`.

**Examples**
| Asset | Key / filename |
|---|---|
| Sound Forge anvil, resting | `forge_anvil_idle` |
| Chunk Racer chunk tile, on hit | `racer_chunk_hit` |
| Decoder Kit chunking tool icon | `kit_tool_chunking` |
| Primary button, dark mode | `ui_button_primary_dark` |
| Guide character celebrating | `kit_guide_arlo_celebrate` |
| Momentum meter, protected rest-day state | `ui_momentum_protected` |

Rules:
- [ ] No spaces, no capitals, no version numbers in filenames (version via source control / export folder).
- [ ] Dark-mode variants use `_dark` suffix; Reduce-Motion use `_reducemotion`.
- [ ] Multi-resolution raster: `_@2x` / `_@3x` suffix appended last.
- [ ] Every delivered key exists in the content schema (no orphan art, no missing art).

---

## 7. Feedback States — the most important system in the whole product

**There is no "wrong" in Decoder. Failure is invisible.** Shame is the #1 reason these kids quit.

- [ ] **Success / celebrate:** juicy, character-led, earned-feeling. Ships with a Reduce-Motion static variant.
- [ ] **Gentle re-serve ("invisible failure"):** **NO red X. NO buzzer. NO frown.** A warm "let's see that one again later" language — the character stays encouraging, the item simply drifts back for later. This is the tone-defining asset set; if it feels like a correction, it's wrong.
- [ ] **Near-miss (games):** positive momentum, never a shame state.
- [ ] **Forgiving momentum meter:** must include a **"protected / rest-day" state** — one bad day never resets progress. Full/empty is not enough; the meter visibly *forgives*.
- [ ] Every feedback beat pairs visual + (audio hook) + abstract-cue visual, so it lands with or without haptics.

---

## 8. Asset Inventory & Checklist

**Legend:** ☐ = to do · **[V1]** = required for iPhone flagship v1 · rest phase in.
Per asset, don't tick "done" until: *vector-first ✓ · named to key ✓ · transparent bg ✓ · layered/rig-ready ✓ · light+dark ✓ · Reduce-Motion (if animated) ✓ · contrast AA ✓.*

### A. Brand & Identity
- ☐ **[V1]** App icon — flagship (1024 marketing + full iOS ladder; reads at 60 px)
- ☐ App icon — remaining four apps (as a coherent set)
- ☐ Series wordmark
- ☐ Per-app wordmarks/logos (×5)
- ☐ **[V1]** Launch screen — flagship
- ☐ Launch screens — remaining apps
- ☐ App Store screenshot frames + feature-graphic templates

### B. Guide Characters (Decoder Kit cast — shared)
- ☐ **[V1]** Primary guide — fully rigged: `idle`, `celebrate`, `encourage`, `think`
- ☐ **[V1]** Primary guide — **mouth-shape / viseme set** (phonics-critical, accurate)
- ☐ **[V1]** Primary guide — expression sheet + emote library (reused as reward stingers)
- ☐ Secondary guides ×2–4 (one per strategy/tool)
- ☐ Character animation-intent notes (per character)

### C. Shared UI Kit
- ☐ **[V1]** Primary / secondary buttons (9-slice)
- ☐ **[V1]** Toggles, sliders
- ☐ **[V1]** Accessibility controls: font, spacing, line-height, bg-tint, ruler, TTS
- ☐ **[V1]** Forgiving momentum meter (incl. protected/rest-day state)
- ☐ **[V1]** Skill-mastery indicators
- ☐ **[V1]** Decoder Kit currency icon
- ☐ Tool / inventory icons — one per strategy (chunking, predicting, inferring, visualizing, summarizing…)
- ☐ Unlock / chest reward moment
- ☐ **[V1]** Feedback: success/celebrate (+ Reduce-Motion variant)
- ☐ **[V1]** Feedback: gentle re-serve / invisible-failure system
- ☐ **[V1]** System illustrations: onboarding, empty state, loading, offline, parent-gate

### D. Per-App Game Art
**Sound Forge (decoding)** *(flagship candidate)*
- ☐ Forge / anvil environment
- ☐ Snap-together sound-chunk tiles (onset / rime / phoneme grammar)
- ☐ Forged-word reveal moment
- ☐ Mouth-shape / articulation visuals paired to phonemes *(pedagogically accurate)*

**Chunk Racer (fluency)** *(flagship candidate)*
- ☐ Track / lane environment
- ☐ Racer / vehicle (rig-ready)
- ☐ On-sight word-chunk targets
- ☐ Speed / rhythm visuals
- ☐ Hit / near-miss states (no shame states)

**Clue Hunt (comprehension)** *(iPad-forward — screen-hungry)*
- ☐ Detective kit — each strategy as a tool (magnifier = questioning, etc.)
- ☐ Passage / scene backdrops
- ☐ Clue / evidence props
- ☐ "Case solved" moment

**Focus Dojo (executive function)**
- ☐ Dojo environment
- ☐ Belt-progression visuals
- ☐ Session / body-doubling timers
- ☐ Brain-dump "parking lot" UI

**Story Studio (output)** *(iPad-forward)*
- ☐ Story-building blocks / props
- ☐ Scene / background library
- ☐ Character stickers
- ☐ Writing surface (respects reading-type rules)
- ☐ Apple Pencil hooks (iPad enrichment)

### E. Audio-linked & Motion
- ☐ **[V1]** Viseme / mouth-shape set (shared; Sound Forge-critical)
- ☐ **[V1]** Particle / juice kits for success beats
- ☐ Lottie animations for UI transitions & celebrations

---

## 9. Flagship v1 Critical Path

Produce in this order so the language is locked before mass production, and so apps #2–5 + iPad inherit the pipeline instead of restarting it:

1. ☐ **Master style frame** — one hero screen fully rendered; locks the visual language.
2. ☐ **Master palette** — light + dark + tint-safe, contrast-checked, colorblind-validated.
3. ☐ **Two type roles** chosen and specced.
4. ☐ **Primary guide character** — fully rigged, core emotes + mouth-shapes.
5. ☐ **Shared UI kit** — incl. forgiving momentum meter + invisible-failure feedback system.
6. ☐ **Flagship game art** (Sound Forge *or* Chunk Racer) — complete set.
7. ☐ **App icon + launch screen** — flagship.
8. ☐ Everything vector-first, named to keys, layered/rig-ready.

---

## 10. Definition of Done (per asset — pin this above the desk)

An asset ships only when ALL are true:

- [ ] Vector-first (or authored at largest target + @1x/@2x/@3x if raster)
- [ ] Named to its `assetKey` (`app_object_state`)
- [ ] Transparent background (characters/props)
- [ ] Layered / rig-ready if it animates
- [ ] Light **and** dark variants
- [ ] Reduce-Motion variant if animated
- [ ] Contrast AA; no meaning carried by color alone
- [ ] Legible/clean on all four background tints
- [ ] Reads correctly at smallest intended size (icons at 60 px)
- [ ] Tone check: warm, never babyish, never corrective
- [ ] Exists in the content schema (no orphans)

---

*Warmth in the characters. Calm in the composition. Dignity on the reading surface. Vector everywhere so one source grows from iPhone to iPad and from one game to five.*
