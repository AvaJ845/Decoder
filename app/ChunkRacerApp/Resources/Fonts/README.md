# Font Drop — Chunk Racer

Drop the **licensed** font files here. The app registers them automatically at launch via `FontManager.registerBundledFonts()`.

## Required files (must match `Info.plist` UIAppFonts)

| Font | File(s) | Role | Source / License |
|---|---|---|---|
| **Fredoka One** | `FredokaOne-Regular.ttf` (or `.otf` / variable) | Display type: titles, buttons, celebration | Confirm iOS-embedding license |
| **OpenDyslexic** | `OpenDyslexic-Regular.otf` + `OpenDyslexic-Bold.otf` | Reading type default | Confirm iOS-embedding license |
| **Lexend Deca** | `LexendDeca-Regular.ttf` (+ weights if available) | Reading type fallback | Confirm iOS-embedding license |

## ⚠️ The silent-failure gotcha: internal name, not filename

The app looks fonts up by their **internal PostScript / family name**, via
`UIFont(name:)`, using these exact strings (from `DesignTokens.TypeRole`):
`Fredoka One`, `OpenDyslexic`, `Lexend Deca`. **The *filename* does not matter for the
lookup — the font's *internal* name does.** If a file's internal name differs even
slightly (e.g. `OpenDyslexicAlta`, `Open Dyslexic`, `Fredoka-Regular`), the app will
**silently fall back to the system font** and it will look like the drop did nothing.

To check a file's real name on macOS: `mdls -name com_apple_ats_name_postscript <file>`
(or open it in Font Book). **If the internal names differ from the three strings above,
tell the Fellow the actual names and we'll update `DesignTokens.TypeRole` to match** —
don't rename the files to compensate.

## Why this is the #1 blocker

These files are **licensed fonts**, not programmatically fetchable. Until they land in this folder, the app falls back to the system rounded font. The Dynamic Type and font-switching infrastructure is already in place; once these files are present (with matching internal names), the app will use them automatically.

## Before you commit

- [ ] Every font file has a confirmed license permitting embedding in a shipping iOS app.
- [ ] Filenames match the `UIAppFonts` array in `app/ChunkRacerApp/Info.plist` (or update `Info.plist` to match).
- [ ] Run `assets/code/contrast_audit.py` after the drop to confirm reading text still passes AA on all four tints + dark mode.
- [ ] Verify the app builds and Dynamic Type still scales in Settings → Accessibility.
