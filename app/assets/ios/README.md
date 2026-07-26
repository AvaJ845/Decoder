# iOS Asset Bundle — Chunk Racer (Decoder series)

This folder contains the image assets and Xcode Asset Catalog structure needed to build the iOS version of the flagship app **Chunk Racer**. All visuals follow the art-bible decisions in `decoder-art-bible.md` and `assets/art-bible/`.

**Art-bible decisions applied here:**
- Flagship: Chunk Racer
- Line system: thick confident linework
- Palette: teal `#2A9D8F`, coral `#E76F51`, gold `#E9C46A`, soft blue `#A8DADC`, off-white `#F7F4EC`
- Display type: Fredoka One · Reading type: OpenDyslexic
- Off-white backgrounds, no pure white
- Invisible failure: no red X, no frown, no shame states

## Folder Structure

```
assets/ios/
├── generate_ios_icons.py         # Script to regenerate app icon sizes
├── generate_screenshots.py       # Script to resize screenshots to App Store sizes
├── README.md                     # This file
└── ChunkRacer/
    ├── Assets.xcassets/
    │   ├── AppIcon.appiconset/   # 18 icon sizes + Contents.json
    │   └── LaunchScreen.imageset/# Launch screen + Contents.json
    ├── Screenshots/              # 4 source 9:16 mockups
    ├── AppStoreScreenshots/      # 16 resized screenshots (4 screens × 4 sizes)
    └── Marketing/
        └── app-store-hero.png    # 16:9 App Store marketing banner
```

## How to import into Xcode

### 1. App Icon

Option A: Drag the whole `AppIcon.appiconset` folder into Xcode under `Assets.xcassets`.

Option B: Create a new iOS App Icon set in Xcode, then drag each generated PNG into the correct slot. The `Contents.json` already maps every file to its size/idiom/scale.

Included sizes:

| Size | Scale | Dimensions | Usage |
|---|---|---|---|
| 20pt | 2x/3x | 40×40 / 60×60 | iPhone notifications |
| 29pt | 2x/3x | 58×58 / 87×87 | iPhone Settings |
| 40pt | 2x/3x | 80×80 / 120×120 | iPhone Spotlight |
| 60pt | 2x/3x | 120×120 / 180×180 | iPhone Home screen |
| 20pt | 1x/2x | 20×20 / 40×40 | iPad notifications |
| 29pt | 1x/2x | 29×29 / 58×58 | iPad Settings |
| 40pt | 1x/2x | 40×40 / 80×80 | iPad Spotlight |
| 76pt | 1x/2x | 76×76 / 152×152 | iPad Home screen |
| 83.5pt | 2x | 167×167 | iPad Pro Home screen |
| 1024pt | 1x | 1024×1024 | App Store |

### 2. Launch Screen

The `LaunchScreen.imageset` contains a full-bleed launch image. For production, Apple recommends using a `LaunchScreen.storyboard` rather than a static image, but you can use this image as the background of that storyboard.

To use the provided image set:
1. Drag `LaunchScreen.imageset` into `Assets.xcassets`.
2. In your `LaunchScreen.storyboard`, add an Image View and set its image to `LaunchScreen`.
3. Add constraints so it fills the safe area.

### 3. App Store Screenshots

`AppStoreScreenshots/` contains 16 PNGs in the four sizes Apple currently requires for iPhone apps:

| Filename suffix | Dimensions | Device category |
|---|---|---|
| `iphone67-1290x2796` | 1290×2796 | 6.7" (iPhone 15 Pro Max / 16 Pro Max) |
| `iphone65-1284x2778` | 1284×2778 | 6.5" (iPhone 14 Pro Max / 11 Pro Max) |
| `iphone61-1179x2556` | 1179×2556 | 6.1" (iPhone 15 Pro / 15) |
| `iphone55-1242x2208` | 1242×2208 | 5.5" (iPhone 8 Plus / SE 3rd gen can use this) |

Source mockups in `Screenshots/`:
- `screenshot-hub.png` — Home/hub screen
- `screenshot-race.png` — Active race screen
- `screenshot-end.png` — End-of-race celebration
- `screenshot-parent.png` — Parent progress dashboard

Upload the correctly sized screenshots in App Store Connect when you submit the app.

### 4. Marketing

`Marketing/app-store-hero.png` is a 16:9 marketing banner suitable for:
- App Store Connect promotional text
- Social media announcements
- Pitch decks
- Website hero images

## Regenerating Assets

If you redesign the master icon or screenshots, rerun the scripts:

```bash
# From the assets/ios directory:
python3 generate_ios_icons.py ../design/chunk-racer-icon.png ./ChunkRacer/Assets.xcassets/AppIcon.appiconset
python3 generate_screenshots.py ./ChunkRacer/Screenshots ./ChunkRacer/AppStoreScreenshots
```

The scripts require Python 3 and Pillow (`pip install pillow`).

## Notes for the Rest of the Series

The same pipeline works for the other Decoder apps:
1. Generate a 1024×1024 master icon for each app.
2. Run `generate_ios_icons.py` to create its `AppIcon.appiconset`.
3. Generate 9:16 screen mockups and run `generate_screenshots.py`.
4. Replace `LaunchScreen.imageset` with the new launch image.

Keep the shared color palette (teal, coral, yellow, off-white) across every app so the series feels like one platform.
