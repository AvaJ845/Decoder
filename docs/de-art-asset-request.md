# Chunk Racer — Asset Review & Exact Request for the Art Lead

**From:** Apple Fellow (review) · **For:** DE-Art lead · **Date:** 2026-07-26
**Supersedes/refines:** `Required DE-Art illustration/chunk-racer-de-art-brief.md`
(trims scope, adds the real blocker, resolves a character conflict).

> **Send-over summary:** For **Playtest #1 we do NOT need more art** — the current
> placeholders are fine; the playtest tests the loop, not the finish. **Decisions locked:**
> Arlo = book (`docs/arlo-identity-decision.md`); reading default = Lexend Deca with
> OpenDyslexic switchable (`docs/font-default-decision.md`). Then produce Tier 1 (§3).
> Do **not** build the parallax environment (§4). Work on branch `art/chunk-racer-production`.

---

## 0. Is the current folder "what we need"?

**What's in `Required DE-Art illustration/`:** placeholder programmatic PNGs (car, finish
flag, arlo_smiley, logo, pause/sound/skip buttons, track scenery) + two AI concepts
(`arlo_kart_hero.png`, `chunk_racer_logo_concept.png`) + generation scripts + the brief.

**Verdict:**
- **For the playtest:** ✅ sufficient. The app already uses the car/flag/smiley placeholders;
  the loop is accessible and playable. Ship nothing new to run Playtest #1.
- **For ship:** ❌ these are placeholders, not production art. Tier 1 below is the real need.
- The AI concepts are **good direction** (thick linework, on-palette, appealing, not babyish) —
  use them as reference, not as final assets (they have baked backgrounds and baked text).

---

## 1. TWO decisions — **LOCKED** (2026-07-26, graphics lead)

### 1a. ✅ Arlo's identity: **BOOK** (locked)
**Canonical Arlo is the book character** (clean book-body, gold bookmark, no cape).  
The teal bear in `arlo_kart_hero.png` is **expression / kart-energy reference only** — do not rig a bear.

Full rationale + expressive-rig requirements: **`docs/arlo-identity-decision.md`**.

Produce only: `kit_guide_arlo_*` + `racer_kart_*` (book-Arlo in the go-kart).

### 1b. ✅ Fonts — **Lexend Deca default**, OpenDyslexic switchable (locked)
| Role | Font |
|---|---|
| Reading default | **Lexend Deca** |
| Reading switchable | **OpenDyslexic** (Regular + Bold) |
| Display | **Fredoka One** |

Drop licensed `.otf`/`.ttf` into `app/ChunkRacerApp/Resources/Fonts/`.  
**DJ / project owner sources the files.** Code defaults updated to Lexend Deca.  
Playtest may still change the preferred default based on kid preference — do not treat OpenDyslexic as settled science.

Full rationale: **`docs/font-default-decision.md`**.

---

## 2. Design guardrails that override the old brief

- **Keep it CALM (deference + ADHD non-negotiable).** The old brief specced a multi-layer
  **parallax environment** (hills + trees + clouds + sky scrolling). **Cut it — stays cut.** A busy,
  animated, scrolling scene risks overstimulating exactly the kids we serve. The background
  stays quiet — a single near-static backdrop at most.
- **Arlo-in-a-kart as the on-track racer is welcome** — one character is calm; a scrolling
  scene is not. So: rich *character*, quiet *environment*. Book-Arlo sits in the kart.
- **Reading text stays live-rendered** (D2) — never baked into art except the logo wordmark.
- **Every asset meets the Definition of Done** (§5).
- **Sequencing:** fonts may land before Playtest #1 (legibility). Rigged Arlo / kart / icon /
  feedback are **ship-work parallel to recruitment** — playtest findings can still redirect them.
  Do not protect Tier-1 art against loop changes.

---

## 3. Tier 1 — produce for ship (in priority order)

| # | assetKey | What | States / variants |
|---|---|---|---|
| 1 | `kit_guide_arlo_*` | **Canonical Arlo, rigged, isolated, transparent** | idle · celebrate · encourage · think · start a viseme/mouth-shape set. Rig-ready (layered). |
| 2 | `racer_kart_*` | **Arlo in the go-kart** = the on-track racer (replaces the flat placeholder car) | idle (subtle bounce) · hit/celebrate · transparent. Keep the #7 + coral accent. |
| 3 | `brand_racer_icon` | **Final app icon**, on-brand | full iOS size ladder + 1024; legible at 60 px. |
| 4 | `ui_feedback_gentle_reserve`, `ui_momentum_protected`, `celebrate_sparkle` | Feedback set: warm re-serve cue, protected-streak **shield**, success sparkle | light · dark · **Reduce-Motion static** for the sparkle |
| 5 | `ui_ruler_vertical` | Reading-ruler band (final) | light · dark |
| 6 | `brand_chunk_racer_logo` | Logo wordmark (Fredoka One + orange car accent) | light · dark · **optional** — header currently renders text fine; do last |

## 4. Do NOT produce (scope cuts)

- ❌ **The parallax environment** (`environment_hill/tree/cloud/sky`, scrolling layers) — cut for calm.
- ❌ **Per-word / per-chunk word cards** — text is rendered live (D2); these must never be images.
- ⚠️ **UI buttons** (pause/skip): only if we decide the app needs them. `sound` (TTS) yes.
  Don't build pause/skip speculatively — confirm with the Fellow first.

## 5. Definition of Done (per asset — from art-bible §10)

Vector-first (SVG/PDF) or authored at largest iPad target + @1x/@2x/@3x · named to its
`assetKey` · transparent background · layered/rig-ready if animated · light **and** dark ·
Reduce-Motion variant if animated · **AA contrast on all four tints + dark** (run
`assets/code/contrast_audit.py`) · legible at smallest size · tone: warm, never babyish,
never corrective · added to `app/assets/art-bible/ASSET_KEY_MAP.md` · replaces the placeholder
in `app/ChunkRacerApp/Resources/`.

## 6. Where the art work goes (critical)

Only one folder is actually compiled into the iOS app. Dropping art anywhere else will *not* make it render.

| What | Where it goes | Bundled into app? |
|---|---|---|
| **Shipping assets** (Arlo, kart, icon, feedback, ruler) — named to `assetKey`, with `@1x`/`@2x`/`@3x` | **`app/ChunkRacerApp/Resources/`** | ✅ **Yes — the only bundled folder** |
| **Fonts** (OpenDyslexic / Lexend / Fredoka `.otf`/`.ttf`) | **`app/ChunkRacerApp/Resources/Fonts/`** | ✅ Yes — auto-loaded by `FontManager` |
| **Vector masters / working files / concepts** | `app/assets/art-bible/` | ❌ No — source of truth, keeps the bundle lean |
| **Asset catalog** — add every new key | `app/assets/art-bible/ASSET_KEY_MAP.md` | (doc) |

**Trap to avoid:** `Required DE-Art illustration/` and `app/assets/` are reference folders, not bundled. For an asset to render in the app, the final file must live in `app/ChunkRacerApp/Resources/` and be named to its `assetKey`. The current placeholders work because they are already in that folder.

## 7. Workflow — how to deliver

1. Branch off `main`: **`art/chunk-racer-production`**.
2. Add final assets to `app/ChunkRacerApp/Resources/` (and fonts to `app/ChunkRacerApp/Resources/Fonts/`).
3. Add masters/concepts to `app/assets/art-bible/` and update `app/assets/art-bible/ASSET_KEY_MAP.md`.
4. **One PR per asset group** (e.g. "Arlo rigged set", "kart racer", "feedback set") — small PRs review faster than one giant drop.
5. Fill the PR template; the **Fellow reviews against the DoD + the review bar** and merges.
6. After adding/removing any Swift file, run `xcodegen generate` in `app/`. Never commit the generated `app/ChunkRacer*.xcodeproj/` (it's gitignored).
7. Answer the kickoff questions in the old brief §112 (animation tool, kart number, etc.) in your first PR description.

---

*Net: nothing blocks the playtest. Decisions locked (book Arlo; Lexend default). Source
fonts; produce Tier 1; keep the environment calm; hold the DoD. Small PRs on
`art/chunk-racer-production`; Fellow reviews each.*
