# DE-Art Brief — Chunk Racer

**App:** Chunk Racer (Decoder series flagship)  
**Date:** 2026-07-26  
**Fellow:** Apple Fellow  
**DE-Art owner:** TBD — this brief replaces placeholder art with final production assets.

## Reference materials

- Art bible: `decoder-art-bible.md`
- Asset key map: `app/assets/art-bible/ASSET_KEY_MAP.md`
- Placeholder art: `Required DE-Art illustration/`
- Mockup scope doc: `docs/chunk-racer-mockup-2-scope.md`
- Contrast audit: `assets/code/contrast_audit.py`

## Design direction (locked)

- **Flagship:** Chunk Racer
- **Line system:** Thick, confident outlines
- **Shape motif:** Rounded rectangles with soft chamfer
- **Character:** Arlo, a teal bear, as a transparent rigged sprite
- **Vehicle:** Teal go-kart with white circle + number 7 on the front
- **Palette:** locked in `Sources/DecoderCore/DesignTokens.swift`
  - Primary brand: `#2A9D8F` / `#4ECDC4`
  - Primary brand text: `#1B7A6E` / `#4ECDC4`
  - Secondary: `#E76F51` / `#F4A261`
  - Success: `#A67C2E` / `#FFD670`
  - Gentle re-serve: `#5A8A8A` / `#7AB0B0`
  - Ink: `#264653` / `#CED4DA`
  - Background: `#F7F4EC` / `#1A1F23`
  - Surface: `#FFFDF7` / `#2A3036`

## Hero assets — final illustration required

| assetKey | Description | States / Variants | Notes |
|---|---|---|---|
| `brand_chunk_racer_logo` | Full logo with "CHUNK RACER" wordmark + orange race car | Light, dark | Replace `chunk_racer_logo_concept.png`; use Fredoka One for typography, keep the orange car as accent |
| `arlo_kart_idle` | Arlo driving the go-kart | Light, dark, transparent | Reference `arlo_kart_hero.png` |
| `arlo_kart_celebrate` | Arlo in kart, happy/success pose | Light, dark, transparent | Use for correct answers |
| `arlo_kart_encourage` | Arlo in kart, gentle re-serve expression | Light, dark, transparent | Use for misses (warm, not sad) |
| `arlo_kart_dust` | Dust / motion cloud behind the kart | Light, dark, transparent | Short loop or particle frames |

## Environment assets — final illustration required

| assetKey | Description | Tileable | Variants |
|---|---|---|---|
| `racer_track_road` | Road surface with teal stripe at bottom edge | Yes (horizontal) | Light, dark |
| `environment_hill_layer1` | Rolling green hills, foreground | Yes (horizontal) | Light, dark |
| `environment_tree_layer2` | Trees / bushes, midground | Yes (horizontal) | Light, dark |
| `environment_cloud_layer3` | Clouds, slow parallax background | Yes (horizontal) | Light, dark |
| `racer_track_sky` | Sky gradient | Yes (horizontal) | Light, dark |

## UI assets — final production required

| assetKey | Description | Variants |
|---|---|---|
| `ui_button_pause` | Teal circle with white pause bars | Light, dark |
| `ui_button_sound` | Teal pill with white speaker icon | Light, dark |
| `ui_button_skip` | Yellow/gold pill with white forward arrows | Light, dark |
| `ui_pill_find_chunk` | Small pill label "Find the chunk!" | Light, dark |
| `ui_ruler_vertical` | Vertical semi-transparent teal band with dashed white borders | Light, dark |
| `ui_momentum_protected` | Shield icon for protected streak | Light, dark |
| `ui_feedback_gentle_reserve` | Re-serve visual cue (never a red X) | Light, dark |
| `celebrate_sparkle` | Success burst / sparkle particle | Light, dark, Reduce-Motion (static ring) |

## Motion requirements

| Asset | Motion | Reduce-Motion equivalent |
|---|---|---|
| Arlo kart | Idle bounce + dust puff loop | Static pose, no dust |
| Track | Parallax scroll (layers at different speeds) | Static layered scene or single static background |
| Celebrate | Sparkle burst ~0.6s | Static gold ring or checkmark |
| Re-serve | Card gently slides down and dims | Static offset and dim, no motion |
| Racer progress | Car advances along track | Step to new position with no tween |

## Accessibility requirements

- All text remains live-rendered in SwiftUI; **no text baked into images** except the logo wordmark.
- AA contrast on every foreground/background pair; run `assets/code/contrast_audit.py`.
- Color never carries meaning alone; pair with shape, position, icon, or motion.
- Transparent backgrounds for characters, vehicles, and props.
- Light + dark variants for every asset.
- Reduce-Motion variants for every animated asset.

## Placeholder references

These files are already in the iOS bundle and can be used as size/style reference:

- `Required DE-Art illustration/arlo_kart_hero.png` — Arlo hero concept
- `Required DE-Art illustration/chunk_racer_logo_concept.png` — logo concept
- `Required DE-Art illustration/racer_car_orange*` — orange car placeholder
- `Required DE-Art illustration/racer_track_road*` / `hill*` / `tree*` / `cloud*` — environment placeholders
- `Required DE-Art illustration/ui_button_pause*` / `sound*` / `skip*` — button placeholders
- `Required DE-Art illustration/ui_ruler_vertical*` — reading ruler placeholder

## Definition of Done

Before any asset moves from "in progress" to "done":

- [ ] Vector-first (SVG/PDF) or authored at largest iPad target size with `@1x`/`@2x`/`@3x` rasters.
- [ ] Named exactly to its `assetKey`.
- [ ] Transparent background for characters, vehicles, and props.
- [ ] Layered / rig-ready if animated.
- [ ] Light and dark variants.
- [ ] Reduce-Motion variant if animated.
- [ ] Contrast AA across all four background tints and dark mode.
- [ ] Legible at smallest intended size.
- [ ] Tone check: warm, never babyish, never corrective.
- [ ] Added to `app/assets/art-bible/ASSET_KEY_MAP.md`.
- [ ] Replaces the corresponding placeholder in `app/ChunkRacerApp/Resources/`.

## Open questions for DE-Art kickoff

1. **Animation tool:** Spine, After Effects, or SpriteKit atlas? (Affects rigging and export.)
2. **Logo typography:** Do we have a licensed Fredoka One file, or should the logo be hand-traced as vector shapes?
3. **Number on the kart:** Always "7", or should it be configurable per learner?
4. **Parallax performance:** How many layers can we afford on iPhone SE / older iPads?
