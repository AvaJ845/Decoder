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
| `kit_guide_arlo_idle` | `ChunkRacerApp/Resources/kit_guide_arlo_idle.png` (+ `@2x`/`@3x`) | Default hub/guide pose | **production drop** (book-Arlo, D20) |
| `kit_guide_arlo_celebrate` | `ChunkRacerApp/Resources/kit_guide_arlo_celebrate.png` (+ `@2x`/`@3x`) | Success stinger | **production drop** |
| `kit_guide_arlo_encourage` | `ChunkRacerApp/Resources/kit_guide_arlo_encourage.png` (+ `@2x`/`@3x`) | Gentle re-serve / near-miss | **production drop** |
| `kit_guide_arlo_think` | `ChunkRacerApp/Resources/kit_guide_arlo_think.png` (+ `@2x`/`@3x`) | Hint / thinking cue | **production drop** |

Masters also live under `Required DE-Art illustration/kit_guide_arlo_*.png`.

**Canonical Arlo (locked, D20):** **book-body Arlo** (gold bookmark, no cape). Bear-kart art is expression reference only. Warmth guardrail: celebrate/encourage must read at small size; escalate before redesign if expression fails.

**Next production step:** rig book-Arlo (Adobe Animate / Spine / After Effects) for loops + phoneme viseme set. Fellow wires these keys into gameplay UI.

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
| `ui_momentum_protected` | `ChunkRacerApp/Resources/ui_momentum_protected.png` (+ `@2x`/`@3x`) | Forgiving streak meter with rest-day shield | **production drop** |
| `ui_feedback_gentle_reserve` | `ChunkRacerApp/Resources/ui_feedback_gentle_reserve.png` (+ `@2x`/`@3x`) | Invisible failure / re-serve language | **production drop** |
| `celebrate_sparkle` | `ChunkRacerApp/Resources/celebrate_sparkle.png` (+ `@2x`/`@3x`) | Success sparkle stinger | **production drop** |
| `celebrate_sparkle_reducemotion` | `ChunkRacerApp/Resources/celebrate_sparkle_reducemotion.png` (+ `@2x`/`@3x`) | Reduce-Motion success cue | **production drop** |
| `ui_button_pause` | `ChunkRacerApp/Resources/ui_button_pause.png` / `@2x` / `@3x` | Pause button (mockup 2) | **placeholder** |
| `ui_button_sound` | `ChunkRacerApp/Resources/ui_button_sound.png` / `@2x` / `@3x` | Sound button (mockup 2) | **placeholder** |
| `ui_button_skip` | `ChunkRacerApp/Resources/ui_button_skip.png` / `@2x` / `@3x` | Skip/forward button (mockup 2) | **placeholder** |
| `ui_ruler_vertical` | `ChunkRacerApp/Resources/ui_ruler_vertical.png` / `@2x` / `@3x` | Vertical reading ruler | **production drop** |
| `ui_pill_find_chunk` | `ui-kit/ui_pill_find_chunk.png` | "Find the chunk!" pill label | concept |
| `brand_racer_logo` | `ChunkRacerApp/Resources/chunk_racer_logo.png` / `@2x` / `@3x` | Logo wordmark for splash / title (Fredoka + orange #7 car) | **production drop** |
| `brand_chunk_racer_logo` | `Required DE-Art illustration/chunk_racer_logo_concept.png` (+ Resources scales) | Full wordmark master | **production drop** |

**Next production step:** produce 9-slice PDF/SVG buttons and Lottie/Spine variants for the momentum meter and feedback states.

---

## Chunk Racer Game Art

| assetKey | Source file | Use | Status |
|---|---|---|---|
| `racer_track_lane` | `game-art-chunk-racer/racer_track_lane.png` | Scrolling track segment (tileable) | concept |
| `racer_track_road` | `ChunkRacerApp/Resources/racer_track_road.png` / `@2x` / `@3x` | Road tile with teal stripe (mockup 2) | **placeholder** |
| `environment_hill_layer1` | — | ~~Foreground hills~~ | **CUT** (no parallax; calm / ADHD) |
| `environment_tree_layer2` | — | ~~Midground trees~~ | **CUT** |
| `environment_cloud_layer3` | — | ~~Background clouds~~ | **CUT** |
| `racer_vehicle_idle` | `ChunkRacerApp/Resources/racer_car.png` / `@2x` / `@3x` | Default teal vehicle on the progress track | **produced** |
| `racer_kart_idle` | `ChunkRacerApp/Resources/racer_kart_idle.png` (+ `@2x`/`@3x`) | Book-Arlo in kart (track vehicle) | **production drop** |
| `racer_vehicle_idle_orange` | `ChunkRacerApp/Resources/racer_car_orange.png` / `@2x` / `@3x` | Orange race car for logo and track (mockup 2) | **placeholder** |
| `racer_vehicle_hit` | `game-art-chunk-racer/racer_vehicle_hit.png` | Success bounce state | concept |
| `racer_finish_flag` | `ChunkRacerApp/Resources/finish_flag.png` / `@2x` / `@3x` | Finish-line flag on the track | **produced** |
| `racer_target_chunk` | `game-art-chunk-racer/racer_target_chunk.png` | Big top-of-screen target chunk | concept (text rendered live) |
| `racer_word_card` | `game-art-chunk-racer/racer_word_card.png` | Reusable word-card backing template | concept (text rendered live) |
| `racer_chunk_tile` | `game-art-chunk-racer/racer_chunk_tile.png` | Reusable target-chunk tile backing | concept (text rendered live) |
| `racer_chunk_tile_hit` | `game-art-chunk-racer/racer_chunk_tile_hit.png` | Success state for any chunk tile | reusable |
| `racer_chunk_tile_reserve` | `game-art-chunk-racer/racer_chunk_tile_reserve.png` | Gentle re-serve state | reusable |

**Parallax environments are cut** — do not produce or wire scrolling hills/trees/clouds.

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
| `brand_racer_icon` | `../ios/ChunkRacer/Assets.xcassets/AppIcon.appiconset/` (+ master `Required DE-Art illustration/brand_racer_icon_master.png`; Resources `brand_racer_icon` @1x/@2x/@3x preview) | Chunk Racer iOS icon — book-Arlo in kart on cream | **production drop** |
| `brand_racer_launch` | `../ios/ChunkRacer/Assets.xcassets/LaunchScreen.imageset/launch-screen.png` | Chunk Racer launch screen | concept |
| `brand_racer_hero` | `../ios/Marketing/app-store-hero.png` | App Store marketing banner | concept |
| `brand_racer_master_style` | `style-frames/master-style-frame.png` | Master style frame for the whole series | concept |

**Fellow note:** drag/update `AppIcon.appiconset` into the Xcode asset catalog (see `app/assets/ios/README.md`). Wordmark is already in the bundled `Resources/` folder.

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
