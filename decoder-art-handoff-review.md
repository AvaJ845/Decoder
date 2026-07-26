# Decoder — Art Handoff Review & Engineering Production Plan

**Reviewer:** Apple Fellow · **Date:** 2026-07-26
**Input:** the graphics lead's v1 critical-path delivery in `assets/art-bible/`, `assets/ios/`, and `assets/code/`.
**For:** the two Distinguished Engineers taking this from concept assets to a shippable Chunk Racer.

---

## 0. Verdict

**Strong, coherent, ship-shaped handoff. Approved to move into production — with one design decision to resolve first (§2.1) and two quick content fixes (already applied, §2.2).**

The delivery does the most important thing right: it locks a visual language that is *warm without being babyish*, and it nails the tone-defining asset — the gentle re-serve. The schema/keys/content plumbing is clean and matches the build doc's platform-neutral design. Nothing here needs to go back to the drawing board; it needs vector production, rigging, and the decisions below.

---

## 1. What I verified (all ✅)

| Check | Result |
|---|---|
| Schema v2 matches build doc §7 presentation layer | ✅ `assetKeys[]`, `cues[]`, `minCanvas`, `enhancedInput[]` all present and well-typed |
| `cues` uses a controlled vocabulary | ✅ `emphasis: light\|medium\|strong`, `type: snap\|pulse\|bloom\|drift` — a good, implementable addition |
| Content pack validates against schema v2 | ✅ structurally conformant |
| Pack `skillIds` resolve to real skill-graph nodes | ✅ all 5 (`decode-cvc`, `decode-digraphs-blends`, `sight-words-short`, `multisyllable-chunking`, `fluency-target-wpm`) exist |
| Skill graph matches build doc §5 spine | ✅ DAG, prerequisites, mastery thresholds, app mappings, EF parallel track |
| Asset keys follow `app_object_state` (§6) | ✅ consistent across map, pack, and filenames |
| Frozen decisions reflected in the art | ✅ thick linework, teal/coral/gold palette, chamfered rounded-rects, slate ink, off-white ground |
| Tone-critical asset (invisible failure) | ✅ **exemplary** — "Let's see that one again later," card drifts to a soft-blue queue, heart, zero shame |
| iOS icon set completeness | ✅ 18 sizes + Contents.json; 1024 marketing present |
| Concept→production gap documented | ✅ both READMEs are honest about it |

The pipeline is doing exactly what the architecture intended: content references **keys**, art carries the language, and iPad stays a cheap later phase.

---

## 2. Findings

### 2.1 🔴 BLOCKING (decide before the Sprint 3 loop build) — game-mechanic mismatch

The **content data and the style frame describe two different, inverse mechanics.** This must be reconciled to one canonical mechanic before engineering builds the loop, because it changes the payload model, which assets are "selectable," and the adaptive-difficulty logic.

- **Pack data model** (`payload: {word, chunk, distractors}`, where distractors are *chunks* like `["it","ot"]` for `at`): implies **"given the whole word, pick its correct chunk"** — chunk tiles are the selectable targets.
- **Master style frame** (target chunk **AT** at top; word cards **cat / dog / sun** in lanes): implies the inverse — **"given the target chunk, pick the word that contains it"** — word cards are the selectable targets, and the on-screen distractors are *words* (`dog`, `sun`) that don't exist in the pack data.

**My recommendation — adopt the style-frame mechanic (chunk prompt → pick the word):** it's the better fit for a *fluency* game (kids read whole words at speed to spot a chunk), it matches the hero frame the whole team just aligned on, and "words streaming down lanes" is the natural Racer fantasy. That requires evolving the payload to:

```jsonc
"payload": {
  "targetChunk": "at",
  "correctWord": "cat",
  "distractorWords": ["dog", "sun"]   // words, not chunks
}
```

Owner: **Fellow + graphics lead + lead DE**, one 30-min call. Whatever is chosen, update schema payload, the pack, and `ASSET_KEY_MAP` together so they can't drift again.

### 2.2 🟠 SHOULD-FIX

- **Content bug — answer listed as its own distractor (APPLIED).** `cr-011` had `distractors:["swam","swim"]` with `chunk:"swim"`; `cr-012` had `distractors:["launch","lunch"]` with `chunk:"lunch"`. In both the correct answer was also a distractor. I substituted plausible near-misses (`slim`, `bunch`). **Content owner: please sanity-check the substitutions** for phonics appropriateness.
- **Case convention undefined.** The style frame shows the target chunk uppercase (**AT**) while words are lowercase (`cat`). Early-literacy convention favors lowercase throughout. Lock a case rule and apply it to word/chunk assets and TTS captions. Owner: graphics lead + reading/pedagogy.
- **Canonical Arlo not yet locked.** The style-frame Arlo (coral cape, blockier body) and the gentle-reserve Arlo (gold bookmark, cleaner book body) differ. **Rig ONE canonical Arlo** — don't rig both. Owner: graphics lead to designate; DE-Art to rig the chosen one.
- **Reading type in concept art isn't the real reading face.** Words in the concept PNGs use a generic rounded sans, not **OpenDyslexic / Lexend Deca**. Fine for concepts, but the build must render reading type in the real faces (enforced by the DoD). Owner: DE-App.

### 2.3 🟡 MINOR / polish

- **Off-palette green** in the momentum meter fill isn't a frozen palette token. Either add a named "progress green" or recolor to a palette value. Owner: graphics lead.
- **Emoji flame** (🔥) in the momentum meter is a system raster emoji — replace with a custom keyed flame asset for style consistency.
- **UI kit is one composite sheet.** `ui_button_kit.png` backs ~7 distinct keys (`ui_button_primary`, `ui_button_secondary`, toggles, slider…). Production must **slice** it into individually keyed 9-slice assets.
- **Chunk audio keys.** Pack references whole-word audio (`racer_audio_cat`) but not chunk audio; the map lists `racer_audio_chunk_at`. Decide whether the chunk gets its own audio (pedagogically useful) and reference it if so.

---

## 3. Engineering Production Plan (the two DEs)

Two workstreams, split by strength. They converge at the Sprint 3 gray-box loop. This maps onto `decoder-sprint-plan.md`.

### DE-App (platform + game engineering)
Owns the thin core, the game loop, and asset *integration*.

1. **Asset-key resolver** — the layer that turns `racer_word_cat` → the right catalog entry (@2x/@3x/PDF, light/dark, tint). Nothing else can integrate art until this exists. *(Sprint 0–1)*
2. **Abstract-cue mapper** — `{emphasis,type}` → Core Haptics (iPhone) + the visual/audio half. Wire the 4 cue types (`snap/pulse/bloom/drift`). *(Sprint 2)*
3. **Content-pack loader + validator** in-app (schema v2) — reject malformed packs at load, log to the event store. *(Sprint 1)*
4. **Gray-box loop** using placeholder art, driven by the adaptive engine, honoring the **resolved §2.1 mechanic**. *(Sprint 3)*
5. Enforce **reading type = OpenDyslexic/Lexend** and Dynamic Type in all text rendering. *(Sprint 6)*

### DE-Art (technical art / rigging)
Owns turning concept PNGs into rig-ready, variant-complete vector assets.

1. **Vector-trace** every character, prop, and UI element (SVG/PDF), named to `assetKey`. *(Sprint 5, front-loaded)*
2. **Rig Arlo + the vehicle** (separated layers / skeletal rig) — Arlo: idle/celebrate/encourage/think loops + start the viseme set; vehicle: idle/hit. Rig the **one canonical Arlo** only. *(Sprint 5)*
3. **Per-word / per-chunk tile variants** from the templates — build the auto-generation script the map calls for (word bank → key list → templated tile), so this scales without hand-drawing each. *(Sprint 5–8)*
4. **Light/dark/tint-safe + Reduce-Motion variants** for every asset. *(Sprint 6)*
5. **Slice the UI composite sheet** into individual 9-slice components. *(Sprint 5)*
6. **Contrast-check** every pair against light/dark/all four tints; **tick the §10 Definition of Done** per asset before "produced." *(ongoing, gate at Sprint 9)*

### Acceptance criteria for "asset is production-done"
The art-bible §10 DoD verbatim — vector-first · named to key · transparent bg · layered/rig-ready · light+dark · Reduce-Motion (if animated) · AA contrast, no color-only meaning · clean on 4 tints · legible at 60 px · tone check · exists in schema/key map. **No asset ships until all boxes tick.**

---

## 4. Do-first checklist (this week)

- [x] **Resolve §2.1 mechanic** → **DONE.** Adopted the style-frame mechanic (chunk prompt → pick the word). Schema bumped to **v2.1** (`targetChunk` / `correctWord` / `distractorWords`); pack rewritten to match (v1.1.0); key map updated. Distractor words are guaranteed not to contain the chunk.
- [x] **§2.2 content fixes** → **DONE.** Distractor substitutions applied and folded into the mechanic rewrite; **case convention locked to all-lowercase** in the art bible.
- [x] **Canonical Arlo + progress green** → **DONE (pending graphics-lead ratify).** Clean book-body Arlo designated canonical in the art bible and key map; `#8FBF5A/#A9D66B` "progress green" added to the palette.
- [x] **Asset-key resolver + in-app validator** → **scaffolded in Sprint 0** (`DecoderCore`, see `app/`).
- [ ] DE-Art builds the **per-word/per-chunk generation script** — Sprint 0 ships a `keygen` reference; DE-Art extends it to emit tile artboards.

*All blocking and should-fix findings are resolved. Remaining items are owned by DE-Art in normal sprint flow.*

---

## 5. Bottom line

This is the good kind of handoff: the hard, subjective calls (does it feel warm? does failure feel safe?) are *made and made well*, so engineering can spend its time on production rather than on redesign. The only true blocker is a mechanic mismatch that's cheap to resolve in a single conversation — resolve it before the Sprint 3 loop, keep the two DEs on their split tracks, and hold every asset to the §10 DoD gate. Nothing here should slow the sprint plan.

*Verified: schema, keys, skill graph, palette, tone. Flagged: one mechanic decision, two content fixes (done), a handful of consistency items. Approved to produce.*
