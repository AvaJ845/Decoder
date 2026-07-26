#!/usr/bin/env python3
"""Generate placeholder art assets for the mockup-2 Chunk Racer target.

These are intentionally simple, flat, vector-style placeholders so the UI language
matches the high-fidelity mockup without requiring a full DE-Art sprint. They are
authored in the art-bible palette and exported at 2x/3x for the iOS bundle.
"""

from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = "/Users/dj/Documents/Decoder/app/ChunkRacerApp/Resources"
os.makedirs(OUT_DIR, exist_ok=True)

PALETTE = {
    "cream": "#F7F4EC",
    "teal": "#2A9D8F",
    "teal_text": "#1B7A6E",
    "dark_teal": "#166B60",
    "coral": "#E76F51",
    "orange": "#F4A261",
    "ink": "#264653",
    "white": "#FFFFFF",
    "gold": "#A67C2E",
    "yellow": "#E9C46A",
    "green": "#7FB069",
    "dark_green": "#4E7A3E",
    "sky": "#E8F4F8",
    "road": "#4A4A4A",
    "grey": "#9CA3AF",
    "black": "#1A1A1A",
}


def new(size, color=None):
    return Image.new("RGBA", (size, size), color or (0, 0, 0, 0))


def rounded_rect(draw, xy, radius, fill, outline=None, width=1):
    draw.rounded_rectangle(xy, radius=radius, fill=fill, outline=outline, width=width)


def draw_orange_car(size=240):
    """Stylized orange race car for logo and track."""
    img = new(size)
    d = ImageDraw.Draw(img)
    m = size // 12
    w = size - 2 * m
    h = int(w * 0.45)
    x0 = m
    y0 = (size - h) // 2 + m // 2

    # Body
    rounded_rect(d, [x0, y0, x0 + w, y0 + h], h // 2, fill=PALETTE["coral"], outline=PALETTE["ink"], width=size // 24)
    # Stripe
    rounded_rect(d, [x0 + w // 4, y0 + h // 3, x0 + 3 * w // 4, y0 + 2 * h // 3], h // 8, fill=PALETTE["yellow"])
    # Cabin
    rounded_rect(d, [x0 + w // 5, y0 - h // 4, x0 + w // 2, y0 + h // 3], h // 4, fill=PALETTE["teal"], outline=PALETTE["ink"], width=size // 30)
    # Wheels
    wheel_r = h // 2
    for wx in [x0 + int(w * 0.22), x0 + w - int(w * 0.22)]:
        cy = y0 + h
        d.ellipse([wx - wheel_r, cy - wheel_r, wx + wheel_r, cy + wheel_r], fill=PALETTE["ink"], outline=PALETTE["black"], width=size // 40)
        d.ellipse([wx - wheel_r // 3, cy - wheel_r // 3, wx + wheel_r // 3, cy + wheel_r // 3], fill=PALETTE["grey"])
    # Motion lines
    for i, lx in enumerate([x0 - size // 10, x0 - size // 12, x0 - size // 16]):
        ly = y0 + h // 3 + i * (h // 4)
        d.line([(lx, ly), (lx + size // 12, ly)], fill=PALETTE["ink"], width=size // 30)
    return img


def draw_pause_button(size=120):
    img = new(size)
    d = ImageDraw.Draw(img)
    d.ellipse([0, 0, size, size], fill=PALETTE["teal"], outline=PALETTE["ink"], width=size // 16)
    bar_w = size // 8
    bar_h = size // 3
    gap = size // 12
    cx = size // 2
    cy = size // 2
    d.rounded_rectangle([cx - gap // 2 - bar_w, cy - bar_h // 2, cx - gap // 2, cy + bar_h // 2], radius=bar_w // 4, fill=PALETTE["white"])
    d.rounded_rectangle([cx + gap // 2, cy - bar_h // 2, cx + gap // 2 + bar_w, cy + bar_h // 2], radius=bar_w // 4, fill=PALETTE["white"])
    return img


def draw_sound_button(size=160):
    img = new(size)
    d = ImageDraw.Draw(img)
    rounded_rect(d, [0, 0, size, size], size // 3, fill=PALETTE["teal"], outline=PALETTE["ink"], width=size // 18)
    # Speaker cone
    sx = size // 4
    sy = size // 2
    d.polygon([(sx, sy - size // 8), (sx + size // 8, sy - size // 6), (sx + size // 4, sy - size // 4), (sx + size // 4, sy + size // 4), (sx + size // 8, sy + size // 6), (sx, sy + size // 8)], fill=PALETTE["white"])
    # Sound waves
    d.arc([sx + size // 5, sy - size // 5, sx + size // 2, sy + size // 5], start=270, end=90, fill=PALETTE["white"], width=size // 18)
    return img


def draw_skip_button(size=160):
    img = new(size)
    d = ImageDraw.Draw(img)
    rounded_rect(d, [0, 0, size, size], size // 3, fill=PALETTE["yellow"], outline=PALETTE["gold"], width=size // 18)
    # Two triangles
    tri_h = size // 3
    tri_w = size // 6
    cy = size // 2
    for dx in [0, tri_w + size // 20]:
        x1 = size // 2 - tri_w // 2 + dx
        d.polygon([(x1, cy - tri_h // 2), (x1 + tri_w, cy), (x1, cy + tri_h // 2)], fill=PALETTE["white"])
    return img


def draw_vertical_ruler(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    w = size // 3
    x0 = (size - w) // 2
    rounded_rect(d, [x0, 0, x0 + w, size], w // 4, fill=PALETTE["teal"], outline=PALETTE["white"], width=size // 16)
    # Dashed white border effect (draw a dashed inner border)
    dash = size // 10
    for y in range(0, size, dash * 2):
        d.line([(x0 + size // 30, y), (x0 + size // 30, min(y + dash, size))], fill=PALETTE["white"], width=size // 40)
        d.line([(x0 + w - size // 30, y), (x0 + w - size // 30, min(y + dash, size))], fill=PALETTE["white"], width=size // 40)
    return img


def draw_road_tile(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    # Sky top half
    d.rectangle([0, 0, size, size // 2], fill=PALETTE["sky"])
    # Grass middle
    d.rectangle([0, size // 2, size, 2 * size // 3], fill=PALETTE["green"])
    # Road bottom
    d.rectangle([0, 2 * size // 3, size, size], fill=PALETTE["road"])
    # Teal stripe at road bottom edge
    d.rectangle([0, size - size // 12, size, size], fill=PALETTE["teal"])
    # Dashed center line
    dash = size // 10
    for x in range(0, size, dash * 2):
        d.line([(x, 5 * size // 6), (x + dash, 5 * size // 6)], fill=PALETTE["white"], width=size // 30)
    return img


def draw_hill(size=240):
    img = new(size)
    d = ImageDraw.Draw(img)
    d.pieslice([0, size // 4, size, size], start=180, end=360, fill=PALETTE["green"])
    return img


def draw_tree(size=160):
    img = new(size)
    d = ImageDraw.Draw(img)
    trunk_w = size // 6
    trunk_h = size // 3
    d.rounded_rectangle([size // 2 - trunk_w // 2, size - trunk_h, size // 2 + trunk_w // 2, size], radius=trunk_w // 4, fill=PALETTE["dark_green"])
    d.ellipse([size // 6, size // 6, 5 * size // 6, 2 * size // 3], fill=PALETTE["green"], outline=PALETTE["dark_green"], width=size // 24)
    return img


def draw_cloud(size=160):
    img = new(size)
    d = ImageDraw.Draw(img)
    d.ellipse([0, size // 3, size // 2, 2 * size // 3], fill=PALETTE["white"])
    d.ellipse([size // 4, size // 6, 3 * size // 4, 2 * size // 3], fill=PALETTE["white"])
    d.ellipse([size // 2, size // 3, size, 2 * size // 3], fill=PALETTE["white"])
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
    save_at_scales("racer_car_orange", draw_orange_car)
    save_at_scales("ui_button_pause", draw_pause_button)
    save_at_scales("ui_button_sound", draw_sound_button)
    save_at_scales("ui_button_skip", draw_skip_button)
    save_at_scales("ui_ruler_vertical", draw_vertical_ruler)
    save_at_scales("racer_track_road", draw_road_tile)
    save_at_scales("racer_track_hill", draw_hill)
    save_at_scales("racer_track_tree", draw_tree)
    save_at_scales("racer_track_cloud", draw_cloud)
    print(f"Mockup 2 placeholder assets written to {OUT_DIR}")


if __name__ == "__main__":
    main()
