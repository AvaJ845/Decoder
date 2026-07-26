# Decoder Art Bible — v1 Production Assets

This folder contains the first production asset set for the Decoder series, following the decisions in `decoder-art-bible.md`.

## Decisions made (lead principal)

- **Flagship:** Chunk Racer
- **Line system:** Thick confident linework
- **Shape motif:** Rounded rectangles with soft chamfer
- **Primary palette (contrast-audited, see D15):**
  - Background: `#F7F4EC` (light) / `#1A1F23` (dark)
  - Reading surface: `#FFFDF7` (light) / `#2A3036` (dark)
  - Primary brand: `#2A9D8F` (teal) / `#4ECDC4` (dark) — borders, fills, vehicle
  - Primary brand text: `#1B7A6E` (dark teal) / `#4ECDC4` (dark) — text on light surfaces
  - Secondary brand: `#E76F51` (coral) / `#F4A261` (dark)
  - Success: `#A67C2E` (gold) / `#FFD670` (dark)
  - Gentle re-serve: `#5A8A8A` (soft blue) / `#7AB0B0` (dark)
  - Neutral UI: `#264653` (slate) / `#CED4DA` (dark)
- **Display type:** Fredoka One
- **Reading type:** OpenDyslexic (default), Lexend Deca fallback

## Folder contents

```
assets/art-bible/
├── README.md                      # This file
├── ASSET_KEY_MAP.md              # Maps every assetKey to a file and use
├── style-frames/
│   └── master-style-frame.png    # Hero screen locking the visual language
├── characters/
│   ├── kit_guide_arlo_idle.png   # Arlo: default guide pose
│   ├── kit_guide_arlo_celebrate.png
│   ├── kit_guide_arlo_encourage.png
│   └── kit_guide_arlo_think.png
├── ui-kit/
│   ├── ui_button_kit.png         # Buttons, toggles, sliders, icon buttons
│   ├── ui_feedback_gentle_reserve.png  # Invisible failure system
│   └── ui_momentum_protected.png       # Forgiving streak meter
└── game-art-chunk-racer/
    ├── racer_track_lane.png
    ├── racer_vehicle_idle.png
    ├── racer_vehicle_hit.png
    ├── racer_target_chunk.png
    ├── racer_word_card.png
    ├── racer_chunk_tile.png
    ├── racer_chunk_tile_hit.png
    └── racer_chunk_tile_reserve.png
```

**Mockup-aligned game assets (produced):** `app/ChunkRacerApp/Resources/`
- `racer_car.png` / `@2x` / `@3x` — the teal vehicle on the progress track
- `finish_flag.png` / `@2x` / `@3x` — the finish-line flag
- `arlo_smiley.png` / `@2x` / `@3x` — the footer guide icon
- `chunk_racer_logo.png` / `@2x` / `@3x` — the title/logo wordmark

These are produced as 2x/3x raster PNGs. They are bundled by Xcode and resolved via `AssetKeyResolver` and `BundleImage` so they can be swapped for vector/PDF versions without code changes.

## What these are

Every PNG here is a **concept / style frame** for the art team. The final shipping assets must be:

1. **Vector-traced** (SVG/PDF) or authored as vector from the start.
2. **Rig-ready** for characters and vehicles (separated layers, no flattening).
3. **Named to the assetKey** in `ASSET_KEY_MAP.md`.
4. Given **light + dark + tint-safe** variants.
5. Given **Reduce-Motion** variants where animated.

The content packs (`assets/code/chunk-racer-basics-pack.json`) now reference these assets by **key**, not by file. The iOS app resolves the key to the correct `@2x`/`@3x`/PDF variant. This is what makes iPad a cheap UI/QA phase rather than a rewrite.

## How to use

1. **Review the master style frame** — this locks the visual language.
2. **Trace characters into vector rigs** and export Arlo's four core poses as loops.
3. **Build the shared UI kit** as 9-slice SVG/PDF components.
4. **Produce per-word / per-chunk tile variants** from the templates in `game-art-chunk-racer/`.
5. **Run a contrast check** on every color pair against the light/dark/tint backgrounds.
6. **Tick the Definition of Done** in `decoder-art-bible.md` §10 before shipping any asset.

## Open production items

- Arlo viseme / mouth-shape set (for Sound Forge later, but designed now)
- Reduce-Motion variants of all animated feedback
- Dark-mode variants of every asset
- Per-word and per-chunk tile variants from the templates
- 9-slice specs for buttons and panels

For iOS import and App Store assets, see `assets/ios/README.md`.
