#!/usr/bin/env python3
"""WCAG 2.1 contrast audit for the Decoder Chunk Racer gameplay UI.

Checks every foreground/background pair that appears in the gameplay surface
against the four light-mode tints and the dark-mode ground. The target is
AA 4.5:1 for normal text and 3:1 for large text / UI components.
"""

from typing import List, Tuple

# Palette from DesignTokens + AccessibilityPrefs
COLORS = {
    # Foregrounds
    "teal": ("#2A9D8F", "#4ECDC4"),            # brand accent (borders, fills)
    "tealText": ("#1B7A6E", "#4ECDC4"),          # text on light surfaces
    "ink": ("#264653", "#CED4DA"),
    "coral": ("#E76F51", "#F4A261"),
    "gold": ("#A67C2E", "#FFD670"),
    "gentleReserve": ("#5A8A8A", "#7AB0B0"),
    "white": ("#FFFFFF", "#FFFFFF"),
    # Backgrounds (light ground, dark ground, plus tints)
    "ground": ("#F7F4EC", "#1A1F23"),
    "surface": ("#FFFDF7", "#2A3036"),
    "tintCream": ("#F7F4EC", "#1A1F23"),   # same as ground
    "tintSoftBlue": ("#EAF4F4", "#1A1F23"),
    "tintSoftGrey": ("#F0F0F0", "#1A1F23"),
    "tintOffWhite": ("#FAFAF5", "#1A1F23"),
}

PAIRS: List[Tuple[str, str, str, float]] = [
    # (foreground key, background key, usage, min required ratio)
    ("tealText", "surface", "target chunk / title text on card", 4.5),
    ("tealText", "ground", "title text on tinted ground", 4.5),
    ("ink", "surface", "word buttons / body text", 4.5),
    ("ink", "ground", "instruction text on ground", 4.5),
    ("white", "tealText", "smiley icon face on darker teal button", 4.5),
    ("coral", "surface", "accent details on cards", 3.0),
    ("gold", "surface", "celebrate feedback / success card", 3.0),
    ("gentleReserve", "surface", "re-serve card border", 3.0),
    ("ink", "tintSoftBlue", "body text on soft-blue tint", 4.5),
    ("ink", "tintSoftGrey", "body text on soft-grey tint", 4.5),
    ("ink", "tintOffWhite", "body text on off-white tint", 4.5),
    ("tealText", "tintSoftBlue", "target chunk text on soft-blue tint", 4.5),
    ("tealText", "tintSoftGrey", "target chunk text on soft-grey tint", 4.5),
    ("tealText", "tintOffWhite", "target chunk text on off-white tint", 4.5),
    # Dark mode pairs
    ("tealText", "surface", "target chunk dark mode", 4.5),
    ("ink", "surface", "word buttons dark mode", 4.5),
    ("white", "tealText", "smiley icon face dark mode", 4.5),
    ("gold", "surface", "celebrate feedback dark mode", 3.0),
]


def hex_to_rgb(hex_str: str) -> Tuple[float, float, float]:
    s = hex_str.lstrip("#")
    return tuple(int(s[i:i+2], 16) / 255.0 for i in (0, 2, 4))


def luminance(rgb: Tuple[float, float, float]) -> float:
    def channel(c: float) -> float:
        return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    r, g, b = rgb
    return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)


def ratio(fg_hex: str, bg_hex: str) -> float:
    fg_l = luminance(hex_to_rgb(fg_hex))
    bg_l = luminance(hex_to_rgb(bg_hex))
    lighter = max(fg_l, bg_l)
    darker = min(fg_l, bg_l)
    return (lighter + 0.05) / (darker + 0.05)


def audit():
    failures = []
    print("Decoder Chunk Racer — contrast audit")
    print("=" * 60)
    for fg_key, bg_key, usage, required in PAIRS:
        # Determine which variants to test based on whether the pair is light or dark mode
        # If the background is a tint (light-only), test the light foreground.
        # If the background is surface/ground, test both light and dark variants.
        is_dark_bg = bg_key in ("surface", "ground") and False  # we test both explicitly
        variants = [("light", 0), ("dark", 1)] if bg_key in ("surface", "ground") else [("light", 0)]
        for mode, idx in variants:
            fg_hex = COLORS[fg_key][idx]
            bg_hex = COLORS[bg_key][idx]
            r = ratio(fg_hex, bg_hex)
            status = "PASS" if r >= required else "FAIL"
            print(f"{status} {mode:5} | {fg_key:13} on {bg_key:13} ({usage:35}) | {r:.2f}:1 (needs {required}:1)")
            if r < required:
                failures.append((fg_key, bg_key, mode, usage, r, required))
    print("=" * 60)
    if failures:
        print(f"\nFAILURES: {len(failures)} pair(s) below target")
        for fg_key, bg_key, mode, usage, r, required in failures:
            print(f"  - {fg_key} on {bg_key} ({mode}, {usage}): {r:.2f}:1 < {required}:1")
    else:
        print("\nAll pairs meet their target ratios.")
    return len(failures) == 0


if __name__ == "__main__":
    ok = audit()
    raise SystemExit(0 if ok else 1)
