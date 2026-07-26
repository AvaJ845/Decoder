# Decoder Art Illustration — Reference

## Why this skill exists

Decoder is a platform of reading-strategy games for kids with dyslexia and ADHD. Every app must share one visual language, one accessibility bar, and one art pipeline. This skill gives the Fellow a fast way to:

1. Generate placeholder art that is good enough to test the UI and mechanics.
2. Produce a clear, principle-driven brief for DE-Art so the final assets are right the first time.

## The art-bible philosophy (from `decoder-art-bible.md`)

- **Line system:** Thick, confident outlines.
- **Shape motif:** Rounded rectangles with soft chamfers.
- **Palette:** Warm, low-glare, high-contrast, color-vision-safe.
- **Typography:** Two roles — Fredoka One for display, OpenDyslexic/Lexend for reading. Never styled or baked into images.
- **Tone:** Warm, never babyish, never corrective.

## Placeholder vs. final art

**Placeholders** are acceptable in the app bundle for as long as the mechanic and accessibility are being validated. They must still pass the contrast audit and be named to their asset keys.

**Final art** must be produced by DE-Art before App Store submission. It must be vector-first or authored at iPad target size, transparent where needed, and include light/dark/Reduce-Motion variants.

## Example AI prompts

### Arlo in a kart (hero concept)

```
A cute, friendly children's book illustration of a teal-colored bear character named Arlo wearing a teal and white racing helmet. Arlo is smiling and driving a small teal go-kart. The go-kart has a white circular front plate with the number 7. Flat vector style with thick dark outlines, suitable for a mobile game for kids with dyslexia. Small dust clouds behind the kart suggest motion. Color palette: teal #2A9D8F, orange #E76F51, gold #A67C2E, dark ink #264653, cream background #F7F4EC. Isolated, centered, 3/4 angle.
```

### Logo concept

```
A clean, modern mobile game logo for a children's reading game called "CHUNK RACER". "CHUNK" in bold, bubbly teal sans-serif letters above "RACER" in matching slightly smaller teal letters. Below the text is a small stylized orange race car with motion lines. Flat vector illustration with thick dark teal outlines. Color palette: teal #2A9D8F, orange #E76F51, cream #F7F4EC, ink #264653. Centered on a plain cream background.
```

## How to use the Python scripts

The scripts live in `Required DE-Art illustration/` and output to `app/ChunkRacerApp/Resources/`.

### `generate_game_assets.py`

Generates the first mockup-aligned placeholders:

- `racer_car` (teal)
- `finish_flag`
- `arlo_smiley`
- `chunk_racer_logo`

### `generate_mockup2_placeholders.py`

Generates the mockup-2 environment/UI placeholders:

- `racer_car_orange`
- `ui_button_pause`, `ui_button_sound`, `ui_button_skip`
- `ui_ruler_vertical`
- `racer_track_road`, `racer_track_hill`, `racer_track_tree`, `racer_track_cloud`

### Adding a new asset

1. Add a `draw_<name>()` function to the relevant script.
2. Call `save_at_scales("<asset_key>", draw_<name>)` in `main()`.
3. Run the script.
4. Add the asset key to `app/assets/art-bible/ASSET_KEY_MAP.md`.
5. Run the contrast audit.
6. Build the app and verify.

## Contrast audit integration

Every new color pair must be checked in `assets/code/contrast_audit.py`. The script targets:

- **4.5:1** for normal text.
- **3.0:1** for large text and UI components.

If the brand teal (`#2A9D8F`) fails on light surfaces, use the darker text variant (`#1B7A6E`) without changing the accent color.

## DE-Art brief template

Use this template for any app:

```markdown
# DE-Art Brief — <App Name>

## Hero assets needed (final illustration)
- `asset_key` — description — states — variants

## Environment/UI assets needed (final)
- `asset_key` — description — tileable? — parallax layer?

## Motion requirements
- List every animation and its Reduce-Motion equivalent.

## Accessibility requirements
- AA contrast, color-independent meaning, transparent backgrounds, light/dark variants.

## Reference placeholders
- Links to the generated placeholder files in `Required DE-Art illustration/`.

## Definition of Done
- Vector-first or authored at largest iPad target.
- Named to asset key.
- Transparent backgrounds for characters/props.
- Light + dark + tint-safe + Reduce-Motion variants.
- Contrast audit pass.
- Tone check complete.
```

## Current case study: Chunk Racer

The first application of this skill produced the assets in `Required DE-Art illustration/` and the brief in `docs/chunk-racer-mockup-2-scope.md`. The full production gap is documented there; the placeholders are in the iOS bundle and pass the contrast audit.
