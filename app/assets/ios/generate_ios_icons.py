#!/usr/bin/env python3
"""Generate all iOS app icon sizes from a 1024x1024 master icon.

Usage:
    python3 generate_ios_icons.py <master_icon.png> <output_dir>

Example:
    python3 generate_ios_icons.py ../design/chunk-racer-icon.png ./ChunkRacer/Assets.xcassets/AppIcon.appiconset
"""

import sys
import json
from pathlib import Path
from PIL import Image

# iOS App Icon sizes.
# Each entry: (point_size, scale, pixel_size, idiom, platform)
IOS_ICON_SPEC = [
    # iPhone
    (20, 2, 40, 40, "iphone", "ios"),
    (20, 3, 60, 60, "iphone", "ios"),
    (29, 2, 58, 58, "iphone", "ios"),
    (29, 3, 87, 87, "iphone", "ios"),
    (40, 2, 80, 80, "iphone", "ios"),
    (40, 3, 120, 120, "iphone", "ios"),
    (60, 2, 120, 120, "iphone", "ios"),
    (60, 3, 180, 180, "iphone", "ios"),
    # iPad
    (20, 1, 20, 20, "ipad", "ios"),
    (20, 2, 40, 40, "ipad", "ios"),
    (29, 1, 29, 29, "ipad", "ios"),
    (29, 2, 58, 58, "ipad", "ios"),
    (40, 1, 40, 40, "ipad", "ios"),
    (40, 2, 80, 80, "ipad", "ios"),
    (76, 1, 76, 76, "ipad", "ios"),
    (76, 2, 152, 152, "ipad", "ios"),
    (83.5, 2, 167, 167, "ipad", "ios"),
    # App Store
    (1024, 1, 1024, 1024, "ios-marketing", "ios"),
]


def generate_icons(master_path: Path, output_dir: Path):
    output_dir.mkdir(parents=True, exist_ok=True)
    master = Image.open(master_path).convert("RGBA")
    master = master.resize((1024, 1024), Image.Resampling.LANCZOS)

    images = []
    for size_pt, scale, px_w, px_h, idiom, platform in IOS_ICON_SPEC:
        filename = f"icon-{size_pt}pt@{scale}x.png"
        resized = master.resize((px_w, px_h), Image.Resampling.LANCZOS)
        resized.save(output_dir / filename, "PNG")

        image_entry = {
            "filename": filename,
            "idiom": idiom,
            "scale": f"{scale}x",
            "size": f"{size_pt}x{size_pt}"
        }
        images.append(image_entry)
        print(f"Generated {filename} ({px_w}x{px_h})")

    contents = {
        "images": images,
        "info": {
            "author": "xcode",
            "version": 1
        }
    }
    (output_dir / "Contents.json").write_text(
        json.dumps(contents, indent=2), encoding="utf-8"
    )
    print(f"\nWrote Contents.json with {len(images)} icons to {output_dir}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)

    generate_icons(Path(sys.argv[1]), Path(sys.argv[2]))
