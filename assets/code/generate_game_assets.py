#!/usr/bin/env python3
"""Generate Chunk Racer gameplay assets in the art-bible style.

Outputs 2x/3x PNGs into app/ChunkRacerApp/Resources so they are bundled by Xcode.
Style: thick outlines, flat color, teal + coral + dark ink palette, kid-friendly.
"""

from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = "/Users/dj/Documents/Decoder/app/ChunkRacerApp/Resources"
os.makedirs(OUT_DIR, exist_ok=True)

PALETTE = {
    "cream": "#F7F4EC",
    "teal": "#2A9D8F",
    "teal_text": "#1B7A6E",
    "teal_dark": "#21867A",
    "coral": "#E76F51",
    "ink": "#264653",
    "white": "#FFFFFF",
    "gold": "#A67C2E",
    "grey": "#9CA3AF",
    "black": "#1A1A1A",
}


def new(size, color=None):
    return Image.new("RGBA", (size, size), color or (0, 0, 0, 0))


def rounded_rect(draw, xy, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def draw_car(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    margin = size // 12
    w = size - 2 * margin
    h = int(w * 0.55)
    x0 = margin
    y0 = (size - h) // 2

    # Car body
    rounded_rect(d, [x0, y0, x0 + w, y0 + h], h // 3, fill=PALETTE["teal"], outline=PALETTE["ink"], width=size // 24)

    # Cabin / window
    win_w = int(w * 0.45)
    win_h = int(h * 0.5)
    win_x = x0 + int(w * 0.12)
    win_y = y0 - int(h * 0.15)
    rounded_rect(d, [win_x, win_y, win_x + win_w, win_y + win_h], win_h // 3, fill=PALETTE["coral"], outline=PALETTE["ink"], width=size // 30)

    # Wheels
    wheel_r = h // 3
    for wx in [x0 + int(w * 0.18), x0 + w - int(w * 0.18)]:
        cy = y0 + h - wheel_r // 2
        d.ellipse([wx - wheel_r, cy - wheel_r, wx + wheel_r, cy + wheel_r], fill=PALETTE["ink"], outline=PALETTE["black"], width=size // 40)
        d.ellipse([wx - wheel_r // 3, cy - wheel_r // 3, wx + wheel_r // 3, cy + wheel_r // 3], fill=PALETTE["grey"])

    return img


def draw_smiley(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    m = size // 12

    # Darker teal background so the ink face hits AA. White on teal fails WCAG;
    # ink on the darker tealText shade passes.
    bg = PALETTE["teal_text"]
    rounded_rect(d, [m, m, size - m, size - m], size // 6, fill=bg, outline=PALETTE["ink"], width=size // 24)

    face_color = PALETTE["white"]
    eye_r = size // 14
    d.ellipse([size // 3 - eye_r, size // 3 - eye_r, size // 3 + eye_r, size // 3 + eye_r], fill=face_color)
    d.ellipse([2 * size // 3 - eye_r, size // 3 - eye_r, 2 * size // 3 + eye_r, size // 3 + eye_r], fill=face_color)

    # Smile
    d.arc([size // 4, size // 3, 3 * size // 4, 3 * size // 4], start=0, end=180, fill=face_color, width=size // 18)

    return img


def draw_flag(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    m = size // 8

    # Pole
    pole_w = size // 12
    pole_h = int(size * 0.75)
    d.rounded_rectangle([m, m, m + pole_w, m + pole_h], radius=pole_w // 2, fill=PALETTE["ink"])

    # Checkered flag
    flag_w = size - 2 * m - pole_w
    flag_h = pole_h // 2
    flag_x = m + pole_w
    flag_y = m
    d.rounded_rectangle([flag_x, flag_y, flag_x + flag_w, flag_y + flag_h], radius=size // 20, fill=PALETTE["white"], outline=PALETTE["ink"], width=size // 30)

    # Checkerboard pattern
    rows = 3
    cols = 4
    cell_w = flag_w // cols
    cell_h = flag_h // rows
    for r in range(rows):
        for c in range(cols):
            if (r + c) % 2 == 1:
                x1 = flag_x + c * cell_w
                y1 = flag_y + r * cell_h
                d.rectangle([x1, y1, x1 + cell_w, y1 + cell_h], fill=PALETTE["ink"])

    return img


def draw_logo(size=320):
    img = new(size)
    d = ImageDraw.Draw(img)
    m = size // 12

    # Background banner
    banner_h = size // 2
    rounded_rect(d, [m, (size - banner_h) // 2, size - m, (size + banner_h) // 2], banner_h // 3, fill=PALETTE["teal"], outline=PALETTE["ink"], width=size // 24)

    # Try to load a font; fall back to default
    try:
        font = ImageFont.truetype("/System/Library/Fonts/Supplemental/FredokaOne-Regular.ttf", size // 5)
    except Exception:
        try:
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", size // 5)
        except Exception:
            font = ImageFont.load_default()

    text = "CHUNK RACER"
    bbox = d.textbbox((0, 0), text, font=font)
    tw = bbox[2] - bbox[0]
    th = bbox[3] - bbox[1]
    tx = (size - tw) // 2
    ty = (size - th) // 2 - size // 40
    d.text((tx, ty), text, font=font, fill=PALETTE["white"], stroke_width=size // 60, stroke_fill=PALETTE["ink"])

    return img


def save_at_scales(name, draw_fn, sizes=(120, 240, 360)):
    for s in sizes:
        img = draw_fn(s)
        if s == 240:
            suffix = "@2x"
        elif s == 360:
            suffix = "@3x"
        else:
            suffix = ""
        img.save(os.path.join(OUT_DIR, f"{name}{suffix}.png"))


def main():
    save_at_scales("racer_car", draw_car)
    save_at_scales("arlo_smiley", draw_smiley)
    save_at_scales("finish_flag", draw_flag)
    save_at_scales("chunk_racer_logo", draw_logo)
    print(f"Assets written to {OUT_DIR}")


if __name__ == "__main__":
    main()
