# Chunk Racer — Mockup 2 Scope Breakdown

**Project:** Decoder — `/Users/dj/Documents/Decoder`  
**Target:** Chunk Racer iOS app, gameplay screen  
**Date:** 2026-07-26  
**Fellow decision needed:** how much of this high-fidelity mockup to chase before the kid playtest.

---

## The delta: current vs. mockup 2

| Area | Current (builds, runs, accessible) | Mockup 2 (target visual) | Gap |
|---|---|---|---|
| **Header** | "Chunk Racer" text + 5 dots + gear | Logo wordmark "CHUNK RACER" + orange race car + pause button + stopwatch timer | Needs logo asset, pause button, timer decision |
| **Progress** | Dashed line + simple teal car + finish flag | Full landscape track with scrolling hills, trees, road, teal stripe | Needs environment tiles + parallax system |
| **Target chunk** | White card with teal border, live text "ip/at" | White card with large teal "AT" + "Find the chunk!" pill | Mostly matches; pill shape differs |
| **Word choices** | Three stacked white buttons, static | Three word boxes on the track, possibly scrolling | Static vs. scrolling is a gameplay change |
| **Reading ruler** | Horizontal teal band behind the chunk prompt | Vertical teal band centered on the middle word | Directional change; may need to move to selected word |
| **Footer** | Smiley icon + "Find the chunk!" bubble + streak counter | Streak counter card + Arlo in kart + sound + skip buttons | Needs Arlo kart sprite, sound/skip buttons |
| **Character** | SF Symbol / generated smiley placeholder | Teal bear (Arlo) in teal go-kart with helmet, dust clouds | Needs full Arlo vehicle rig |
| **Art style** | Flat shapes, thick outlines | Detailed illustration, natural environment | Needs professional DE-Art production |

---

## What must be created (asset list)

### Immediate placeholder art we can generate today
- `racer_car_orange` — a simple orange race car for the logo (keeps the current placeholder style)
- `racer_track_hill`, `racer_track_tree`, `racer_track_road_tile` — tileable landscape pieces
- `racer_track_sky` — gradient/sky backing
- `ui_button_pause` — teal circle with white pause bars
- `ui_button_sound` — teal pill with speaker
- `ui_button_skip` — yellow pill with forward arrows
- `ui_pill_find_chunk` — small pill label for "Find the chunk!"
- `ui_ruler_vertical` — vertical teal band with dashed borders

### Requires DE-Art / professional illustration
- `brand_logo_chunk_racer` — full logo with "CHUNK RACER" + orange car + motion lines
- `arlo_kart_idle` — Arlo in go-kart, driving
- `arlo_kart_celebrate` — Arlo in go-kart, celebrating
- `arlo_kart_encourage` — Arlo in go-kart, gentle re-serve expression
- `arlo_kart_dust` — motion/dust particles for the kart
- `environment_hill_layer1`, `environment_tree_layer2`, `environment_cloud_layer3` — parallax layers
- `racer_track_road` — final road texture with teal stripe
- `celebrate_sparkle` — refined success particle (replace current star burst)

### Engineering / systems
- **Parallax scrolling track** — SpriteKit scene or tile-based scrolling background.
- **Word boxes on the track** — layout system that places words on a road surface rather than stacked buttons.
- **Vertical reading ruler** — highlight that centers on the currently focused word (the one the child is about to tap).
- **Pause / sound / skip buttons** — button handlers and accessibility labels.
- **Timer** — requires Fellow decision (see D3 blocker below).

---

## Limitations & blockers

### 1. The timer conflicts with D3 (non-negotiable)
The mockup shows a **"60s" countdown timer**. This is a hard stop against **decision D3**: *the race has no time-pressure fail state*. We can implement a timer only if it is **non-punishing** — e.g., a personal-best pace indicator, not a countdown-to-lose. **As Fellow I would not ship a visible countdown that says "you lost when time runs out."**

Options:
- **A.** Remove the timer from the visual target entirely.
- **B.** Replace it with a non-punishing pace indicator (e.g., "Your best: 45s" or a calm progress arc).
- **C.** Keep the timer visual but make it purely decorative / non-functional until post-playtest.

### 2. Static vs. scrolling words changes the feel significantly
The mockup shows words on a scrolling track. Our current mechanic is **tap the word that contains the chunk** — the words don't need to move. Moving the words adds:
- **Motor demand** (kids must track motion, harder for ADHD/dyslexia).
- **Time pressure** (even without a timer, moving targets create urgency).
- **Engineering complexity** (scrolling + collision + tap targeting).

**Fellow call:** keep words static for the playtest (matches the current proven mechanic) or invest in moving words? I recommend static for the first playtest; motion can be added as a difficulty dial later.

### 3. The art lift is large
Mockup 2 is a full illustrated scene. The current build uses simple shapes and generated placeholders. Closing this gap requires:
- A dedicated DE-Art sprint (estimated 1–2 weeks for a single artist) to produce the environment, Arlo kart, and UI kit.
- Rigging Arlo for kart states (idle, celebrate, encourage) and dust particles.
- 9-slice or tileable environment assets so the track scrolls smoothly at all screen sizes.

### 4. Scope impact on the kid playtest
The accessibility gate (D10) is the current blocker before playtest #1. Chasing mockup 2's full art before that playtest would delay validation by weeks. The right sequence is:
1. **Finish accessibility gate** (font drop + final contrast check) — this is the real blocker.
2. **Run kid playtest #1** with the current clean, accessible, static-word build.
3. **Then** invest in the illustrated track + Arlo kart based on what the playtest teaches us.

---

## Recommended path forward

**Phase 1 (now — pre-playtest):**
- Keep the current accessible static-word gameplay.
- Generate simple placeholder versions of the logo car, pause button, sound/skip buttons, and vertical ruler so the UI language aligns with the mockup without the full art lift.
- Do NOT add the timer or scrolling words yet.

**Phase 2 (post-playtest #1):**
- If the mechanic is validated, commission DE-Art to produce the illustrated environment, Arlo kart, and full logo.
- Implement parallax scrolling track as an optional visual layer ( Reduce-Motion equivalent stays static ).
- Decide on the timer/pace element with real kid data.

---

## Decision needed from the Fellow

1. **Do we chase mockup 2 visuals before the kid playtest?** (My recommendation: no; it delays the gate without improving the reading-mechanic validation.)
2. **What do we do about the timer in the mockup?** (My recommendation: remove or replace with a non-punishing pace indicator.)
3. **Do we keep words static or move to scrolling track?** (My recommendation: keep static for playtest #1; motion as a later difficulty dial.)
4. **Should I generate the low-cost placeholder assets** (logo car, pause/sound/skip buttons, vertical ruler) now to align the UI language without the full art sprint?
