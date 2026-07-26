#!/usr/bin/env python3
"""Resize 9:16 screenshot mockups to all required iPhone App Store screenshot sizes.

Usage:
    python3 generate_screenshots.py <screenshots_dir> <output_dir>

Example:
    python3 generate_screenshots.py ./ChunkRacer/Screenshots ./ChunkRacer/AppStoreScreenshots
"""

import sys
import json
from pathlib import Path
from PIL import Image

# iPhone App Store screenshot sizes as of 2026.
IPHONE_SIZES = [
    ("iphone65", 1284, 2778),   # 6.5" (also accepted for 6.7" if uploaded as 6.5")
    ("iphone67", 1290, 2796),   # 6.7"
    ("iphone61", 1179, 2556),   # 6.1"
    ("iphone55", 1242, 2208),   # 5.5"
]

BACKGROUND = (247, 244, 236)  # Off-white #F7F4EC


def resize_to_size(img: Image.Image, width: int, height: int) -> Image.Image:
    """Resize to fit inside target dimensions, preserving aspect ratio, then letterbox."""
    target_ratio = width / height
    source_ratio = img.width / img.height

    if source_ratio > target_ratio:
        # Source is wider relative to target: fit to width
        new_width = width
        new_height = int(width / source_ratio)
    else:
        # Source is taller relative to target: fit to height
        new_height = height
        new_width = int(height * source_ratio)

    resized = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    canvas = Image.new("RGB", (width, height), BACKGROUND)
    x = (width - new_width) // 2
    y = (height - new_height) // 2
    # Convert RGBA to RGB if needed before pasting
    if resized.mode == "RGBA":
        canvas.paste(resized, (x, y), resized)
    else:
        canvas.paste(resized, (x, y))
    return canvas


def generate_screenshots(input_dir: Path, output_dir: Path):
    output_dir.mkdir(parents=True, exist_ok=True)
    screenshots = sorted(input_dir.glob("*.png"))

    manifest = {}
    for size_id, width, height in IPHONE_SIZES:
        manifest[size_id] = {"width": width, "height": height, "files": []}

    for screenshot in screenshots:
        img = Image.open(screenshot).convert("RGBA")
        base_name = screenshot.stem

        for size_id, width, height in IPHONE_SIZES:
            out = resize_to_size(img, width, height)
            out_name = f"{base_name}-{size_id}-{width}x{height}.png"
            out_path = output_dir / out_name
            out.save(out_path, "PNG", optimize=True)
            manifest[size_id]["files"].append(out_name)
            print(f"Generated {out_name}")

    (output_dir / "manifest.json").write_text(
        json.dumps(manifest, indent=2), encoding="utf-8"
    )
    print(f"\nWrote manifest.json. Total files: {len(screenshots) * len(IPHONE_SIZES)}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    generate_screenshots(Path(sys.argv[1]), Path(sys.argv[2]))
