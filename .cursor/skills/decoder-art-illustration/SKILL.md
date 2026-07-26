---
name: decoder-art-illustration
description: Generates placeholder art assets and produces a DE-Art production brief for any Decoder iOS app. Use when an app needs characters, vehicles, environments, UI components, or a logo that matches the art-bible style and accessibility requirements.
---

# Decoder Art Illustration Skill

## Purpose

Produce first-pass, art-bible-aligned illustration assets for any app in the Decoder series, and generate a clear brief of what DE-Art must create for final production. This skill keeps the visual language consistent across Chunk Racer, Sound Forge, Clue Hunt, Focus Dojo, and Story Studio.

## When to use this skill

- A new Decoder app needs a hero character, logo, environment, or vehicle.
- The Fellow wants to explore a high-fidelity mockup direction without waiting for DE-Art.
- You need to generate placeholder assets that can be dropped into the iOS bundle immediately and replaced later by final art.
- You need to write a DE-Art brief with exact asset keys, palette, and Definition of Done.

## Workflow

### 1. Read the art bible first

Always read these documents before generating art:

- `decoder-art-bible.md` — palette, typography, line system, shape motif, DoF.
- `app/assets/art-bible/ASSET_KEY_MAP.md` — how asset keys map to files.
- `assets/code/contrast_audit.py` — to verify every color pair passes WCAG.

### 2. Decide what is placeholder vs. final

| Generate now | Leave to DE-Art |
|---|---|
| Simple UI icons, buttons, rulers | Hero character rigs, vehicle rigs, environment paintings |
| Geometric vehicles and environment tiles | Detailed illustrated characters and full scenes |
| Logo concept / wordmark layout | Final vector logo with proper typography |
| Flat-color concept art | 9-slice UI components, animated particles |

### 3. Generate placeholders in two ways

**Option A — Python/PIL (for geometric, repeatable assets):**

Use or extend the scripts in `Required DE-Art illustration/`:

- `generate_game_assets.py` — car, flag, smiley icon, logo wordmark.
- `generate_mockup2_placeholders.py` — orange car, buttons, track tiles, vertical ruler.

Output goes to `app/ChunkRacerApp/Resources/` so Xcode bundles it automatically.

**Option B — AI image generation (for hero characters / logos):**

Use the `GenerateImage` tool with a prompt that locks:

- The art-bible palette (teal `#2A9D8F`, text teal `#1B7A6E`, coral `#E76F51`, gold `#A67C2E`, ink `#264653`, cream `#F7F4EC`).
- Thick, confident outlines.
- Rounded, friendly shapes.
- Transparent or plain cream background.
- One character/vehicle per image, centered.

Save the output to `Required DE-Art illustration/` and note it is a concept for DE-Art to replace.

### 4. Verify accessibility before finishing

Run the contrast audit and check every new foreground/background pair:

```bash
cd "/Users/dj/Documents/Decoder"
python3 assets/code/contrast_audit.py
```

If a color fails, darken the light-mode variant or add a darker text-only variant (`*_text` swatch). Never ship art that fails AA on the reading surface.

### 5. Write the DE-Art brief

For every app, produce a brief document in `Required DE-Art illustration/` named `<app>-de-art-brief.md` with:

- Hero assets that need final illustration (with asset keys).
- Animation states required (idle, celebrate, encourage, etc.).
- Reduce-Motion variants needed.
- Light/dark variants needed.
- Transparent-background requirements.
- Parallax or tileable specs for environments.
- Reference to the generated placeholder files.

## Hard constraints (never violate)

1. **Reading text is never baked into an image.** Word cards, chunks, and instructions are always rendered live in SwiftUI so they honor the reading font, spacing, and Dynamic Type.
2. **Color never carries meaning alone.** Pair color with shape, position, icon, or motion.
3. **Every animated asset needs a Reduce-Motion equivalent.**
4. **AA contrast on all four background tints and dark mode.**
5. **Characters/vehicles must be isolated and transparent** (no baked backgrounds).
6. **Tone must be warm, encouraging, and never corrective.** No red, no frowns, no shame visuals.
7. **No time-pressure countdown visuals** (D3). A stopwatch or timer icon in a mockup must be flagged to the Fellow.

## Default asset palette

Use these exact hex values. Light and dark variants are locked in `Sources/DecoderCore/DesignTokens.swift`.

| Role | Light | Dark | Usage |
|---|---|---|---|
| Background | `#F7F4EC` | `#1A1F23` | Grounds |
| Reading surface | `#FFFDF7` | `#2A3036` | Cards |
| Primary brand | `#2A9D8F` | `#4ECDC4` | Fills, borders, vehicles |
| Primary brand text | `#1B7A6E` | `#4ECDC4` | Text on light surfaces |
| Secondary brand | `#E76F51` | `#F4A261` | Accents, highlights |
| Success | `#A67C2E` | `#FFD670` | Celebrate, stars |
| Gentle re-serve | `#5A8A8A` | `#7AB0B0` | Re-serve borders |
| Neutral UI | `#264653` | `#CED4DA` | Ink, outlines |

## Naming convention for assets

Assets are referenced by `assetKey` in content packs and resolved by `AssetKeyResolver` to `@1x`/`@2x`/`@3x`/PDF variants. Use the format:

```
<app>_<object>_<state>
```

Examples:
- `racer_vehicle_idle`
- `racer_vehicle_celebrate`
- `racer_track_road`
- `kit_guide_arlo_idle`
- `ui_button_pause`
- `brand_chunk_racer_logo`

## Output checklist

After using this skill, ensure:

- [ ] Placeholder assets are saved to `Required DE-Art illustration/` and `app/ChunkRacerApp/Resources/` (for iOS use).
- [ ] A DE-Art brief exists for any asset that needs final production.
- [ ] `app/assets/art-bible/ASSET_KEY_MAP.md` is updated with new keys.
- [ ] `decoder-art-bible.md` is updated if the palette or style evolved.
- [ ] Contrast audit passes.
- [ ] The app builds and the new assets are visible in the Simulator.
- [ ] `HANDOFF.md` and `decoder-fellow-direction.md` reflect the new art direction and remaining DE-Art work.

## Reference

For full rationale, example prompts, and the Chunk Racer case study, see [reference.md](reference.md).
