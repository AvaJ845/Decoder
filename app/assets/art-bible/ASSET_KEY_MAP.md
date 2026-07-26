# Decoder Asset Key Map — Chunk Racer v1

This document maps every `assetKey` referenced in the content packs to a concrete art asset, following the naming convention `app_object_state` from `decoder-art-bible.md` §6.

**Key rule:** content packs reference **keys**, not pixel files. The iOS app resolves each key to `@2x` / `@3x` / PDF variants in the asset catalog. This keeps content platform-neutral and makes iPad a drop-in.

---

## Naming Convention Recap

`app_object_state`

- `app` — `racer` (Chunk Racer), `forge`, `hunt`, `dojo`, `studio`, `kit` (shared), `ui` (shared UI), `brand` (identity)
- `object` — `word`, `chunk`, `vehicle`, `track`, `button`, `guide`, etc.
- `state` — `idle`, `hit`, `reserve`, `celebrate`, `encourage`, `think`, `dark`, `reducemotion`

Multi-resolution raster: append `_@2x` / `_@3x` last. Vector PDFs use the key directly.

---

## Shared Guide Character — Arlo (Decoder Kit)

| assetKey | Source file | Use | Status |
|---|---|---|---|
| `kit_guide_arlo_idle` | `characters/kit_guide_arlo_idle.png` | Default hub/guide pose | concept |
| `kit_guide_arlo_celebrate` | `characters/kit_guide_arlo_celebrate.png` | Success stinger | concept |
| `kit_guide_arlo_encourage` | `characters/kit_guide_arlo_encourage.png` | Gentle re-serve / near-miss | concept |
| `kit_guide_arlo_think` | `characters/kit_guide_arlo_think.png` | Hint / thinking cue | concept |

**Canonical Arlo (locked):** rig the **clean book-body Arlo** (gold bookmark, no cape) as seen in `ui_feedback_gentle_reserve.png`. The caped style-frame variant is superseded — do not rig both.

**Next production step:** trace the canonical pose into a rigged vector character (Adobe Animate / Spine / After Effects) and export idle/celebrate/encourage/think loops plus a phoneme viseme set.

---

## Shared UI Kit

| assetKey | Source file | Use | Status |
|---|---|---|---|
| `ui_button_primary` | `ui-kit/ui_button_kit.png` (primary teal button) | Main CTAs: "RACE", "Start" | concept |
| `ui_button_secondary` | `ui-kit/ui_button_kit.png` (coral button) | Secondary actions: "Later", "Back" | concept |
| `ui_button_icon_speaker` | `ui-kit/ui_button_kit.png` | TTS repeat | concept |
| `ui_button_icon_settings` | `ui-kit/ui_button_kit.png` | Settings | concept |
| `ui_toggle_on` / `ui_toggle_off` | `ui-kit/ui_button_kit.png` | Accessibility toggles | concept |
| `ui_slider_star` | `ui-kit/ui_button_kit.png` | Chunk Racer pace / momentum slider | concept |
| `ui_momentum_protected` | `ui-kit/ui_momentum_protected.png` | Forgiving streak meter with rest-day shield | concept |
| `ui_feedback_gentle_reserve` | `ui-kit/ui_feedback_gentle_reserve.png` | Invisible failure / re-serve language | concept |
| `ui_button_pause` | `ChunkRacerApp/Resources/ui_button_pause.png` / `@2x` / `@3x` | Pause button (mockup 2) | **placeholder** |
| `ui_button_sound` | `ChunkRacerApp/Resources/ui_button_sound.png` / `@2x` / `@3x` | Sound button (mockup 2) | **placeholder** |
| `ui_button_skip` | `ChunkRacerApp/Resources/ui_button_skip.png` / `@2x` / `@3x` | Skip/forward button (mockup 2) | **placeholder** |
| `ui_ruler_vertical` | `ChunkRacerApp/Resources/ui_ruler_vertical.png` / `@2x` / `@3x` | Vertical reading ruler (mockup 2) | **placeholder** |
| `ui_pill_find_chunk` | `ui-kit/ui_pill_find_chunk.png` | "Find the chunk!" pill label | concept |
| `kit_guide_arlo_idle` | `ChunkRacerApp/Resources/arlo_smiley.png` / `@2x` / `@3x` | Footer guide icon (smiley in teal square) | **produced** |
| `brand_racer_logo` | `ChunkRacerApp/Resources/chunk_racer_logo.png` / `@2x` / `@3x` | Logo wordmark for splash / title | **produced** |
| `brand_chunk_racer_logo` | `Required DE-Art illustration/chunk_racer_logo_concept.png` | Final logo concept with orange car | **concept** |

**Next production step:** produce 9-slice PDF/SVG buttons and Lottie/Spine variants for the momentum meter and feedback states.

---

## Chunk Racer Game Art

| assetKey | Source file | Use | Status |
|---|---|---|---|
| `racer_track_lane` | `game-art-chunk-racer/racer_track_lane.png` | Scrolling track segment (tileable) | concept |
| `racer_track_road` | `ChunkRacerApp/Resources/racer_track_road.png` / `@2x` / `@3x` | Road tile with teal stripe (mockup 2) | **placeholder** |
| `environment_hill_layer1` | `ChunkRacerApp/Resources/racer_track_hill.png` / `@2x` / `@3x` | Foreground hills (mockup 2) | **placeholder** |
| `environment_tree_layer2` | `ChunkRacerApp/Resources/racer_track_tree.png` / `@2x` / `@3x` | Midground trees (mockup 2) | **placeholder** |
| `environment_cloud_layer3` | `ChunkRacerApp/Resources/racer_track_cloud.png` / `@2x` / `@3x` | Background clouds (mockup 2) | **placeholder** |
| `racer_vehicle_idle` | `ChunkRacerApp/Resources/racer_car.png` / `@2x` / `@3x` | Default teal vehicle on the progress track | **produced** |
| `racer_vehicle_idle_orange` | `ChunkRacerApp/Resources/racer_car_orange.png` / `@2x` / `@3x` | Orange race car for logo and track (mockup 2) | **placeholder** |
| `racer_vehicle_hit` | `game-art-chunk-racer/racer_vehicle_hit.png` | Success bounce state | concept |
| `racer_finish_flag` | `ChunkRacerApp/Resources/finish_flag.png` / `@2x` / `@3x` | Finish-line flag on the track | **produced** |
| `racer_target_chunk` | `game-art-chunk-racer/racer_target_chunk.png` | Big top-of-screen target chunk | concept (text rendered live) |
| `racer_word_card` | `game-art-chunk-racer/racer_word_card.png` | Reusable word-card backing template | concept (text rendered live) |
| `racer_chunk_tile` | `game-art-chunk-racer/racer_chunk_tile.png` | Reusable target-chunk tile backing | concept (text rendered live) |
| `racer_chunk_tile_hit` | `game-art-chunk-racer/racer_chunk_tile_hit.png` | Success state for any chunk tile | reusable |
| `racer_chunk_tile_reserve` | `game-art-chunk-racer/racer_chunk_tile_reserve.png` | Gentle re-serve state | reusable |
| `arlo_kart_idle` | `Required DE-Art illustration/arlo_kart_hero.png` | Arlo in go-kart, hero concept | **concept** |
| `arlo_kart_celebrate` | TBD | Arlo in kart, success pose | **needs final art** |
| `arlo_kart_encourage` | TBD | Arlo in kart, gentle re-serve | **needs final art** |
| `arlo_kart_dust` | TBD | Dust/motion puffs behind kart | **needs final art** |

**Note:** per-word / per-chunk image cards are **not produced** because reading text is rendered live (decision D2). The word cards in the mockup are white buttons with dark borders and live text, with the target chunk tinted teal. This matches the accessibility requirement to honor reading font, spacing, and Dynamic Type.

**Audio keys** (not visual art, but still in the content pipeline):

| assetKey | Use |
|---|---|
| `racer_audio_cat` | Whole-word TTS audio for "cat" |
| `racer_audio_dog` | Whole-word TTS audio for "dog" |
| ... | ... |
| `racer_audio_chunk_at` | Chunk audio for "at" |

---

## Brand / Identity

| assetKey | Source file | Use | Status |
|---|---|---|---|
| `brand_decoder_icon` | `../design/decoder-series-icon.png` | Decoder series app icon | concept |
| `brand_racer_icon` | `../ios/ChunkRacer/Assets.xcassets/AppIcon.appiconset/` | Chunk Racer iOS icon set | produced |
| `brand_racer_launch` | `../ios/ChunkRacer/Assets.xcassets/LaunchScreen.imageset/launch-screen.png` | Chunk Racer launch screen | concept |
| `brand_racer_hero` | `../ios/Marketing/app-store-hero.png` | App Store marketing banner | concept |
| `brand_racer_master_style` | `style-frames/master-style-frame.png` | Master style frame for the whole series | concept |

---

## Content-Pack Sample References

**Mechanic (locked, schema v2.1):** the `targetChunk` is the prompt; the player picks the streaming word that contains it. So each item needs one chunk-prompt tile, one correct word card, and the distractor word cards. Distractor words never contain the chunk.

The sample pack `assets/code/chunk-racer-basics-pack.json` uses the following keys per item:

```
racer_chunk_<targetChunk>      # the prompt tile shown at top
racer_word_<correctWord>       # the answer card
racer_word_<distractorWord>    # lane-mate cards (words WITHOUT the chunk)
racer_audio_<word>             # whole-word TTS (correct + distractors)
racer_audio_chunk_<chunk>      # chunk-prompt TTS
```

These are generated from the word bank `assets/content/chunk-racer-word-bank.json`. A content-authoring script should auto-generate the key list for each item before an artist starts production (see the Sprint 0 `keygen` tool).

---

## Definition of Done Reminder

Before any asset moves from "concept" to "produced":

- [ ] Vector-first (or authored at largest iPad target + `@1x`/`@2x`/`@3x`)
- [ ] Named to its `assetKey`
- [ ] Transparent background (characters/props)
- [ ] Layered / rig-ready if animated
- [ ] Light and dark variants
- [ ] Reduce-Motion variant if animated
- [ ] Contrast AA; no meaning carried by color alone
- [ ] Legible on all four background tints
- [ ] Reads at smallest intended size (icons at 60 px)
- [ ] Tone check: warm, never babyish, never corrective
- [ ] Exists in the content schema / key map
