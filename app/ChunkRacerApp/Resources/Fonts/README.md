# Font Drop — Chunk Racer

Drop the **licensed** font files here. The app registers them automatically at launch via `FontManager.registerBundledFonts()`.

## Required files (must match `Info.plist` UIAppFonts)

| Font | File(s) | Role | Source / License |
|---|---|---|---|
| **Fredoka One** | `FredokaOne-Regular.ttf` (or `.otf` / variable) | Display type: titles, buttons, celebration | Confirm iOS-embedding license |
| **OpenDyslexic** | `OpenDyslexic-Regular.otf` + `OpenDyslexic-Bold.otf` | Reading type default | Confirm iOS-embedding license |
| **Lexend Deca** | `LexendDeca-Regular.ttf` (+ weights if available) | Reading type fallback | Confirm iOS-embedding license |

## Why this is the #1 blocker

These files are **licensed fonts**, not programmatically fetchable. Until they land in this folder, the app falls back to the system rounded font. The Dynamic Type and font-switching infrastructure is already in place; once these files are present, the app will use them automatically.

## Before you commit

- [ ] Every font file has a confirmed license permitting embedding in a shipping iOS app.
- [ ] Filenames match the `UIAppFonts` array in `app/ChunkRacerApp/Info.plist` (or update `Info.plist` to match).
- [ ] Run `assets/code/contrast_audit.py` after the drop to confirm reading text still passes AA on all four tints + dark mode.
- [ ] Verify the app builds and Dynamic Type still scales in Settings → Accessibility.
