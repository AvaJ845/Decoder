# Font Drop — Chunk Racer

Drop the **licensed** font files here. The app registers them automatically at launch via `FontManager.registerBundledFonts()`.

## Required files (must match `Info.plist` UIAppFonts)

| Font | File(s) | Role | Notes |
|---|---|---|---|
| **Lexend Deca** | `LexendDeca-Regular.ttf` (+ weights if available) | **Reading default** | Locked default (D19) |
| **OpenDyslexic** | `OpenDyslexic-Regular.otf` + `OpenDyslexic-Bold.otf` | Reading — user-switchable | Not the default; still ship it |
| **Fredoka One** | `FredokaOne-Regular.ttf` (or `.otf` / variable) | Display: titles, buttons, celebration | Low risk |

See `docs/font-default-decision.md` for why Lexend is default.

## Who sources

**DJ / project owner** obtains the licensed files (or designates a vendor). Confirm each license permits embedding in a shipping iOS app. If PostScript / internal names differ from the strings above, tell DE-App so `DesignTokens` and `FontManager` match.

## Why this matters for Playtest #1

Fonts are the one art-adjacent dependency that affects the playtest's **legibility** signal. Placeholders for Arlo/kart are fine for the playtest; missing reading fonts are not ideal. Until files land, the app falls back to the system rounded font (Dynamic Type still scales).

## Before you commit

- [ ] Every font file has a confirmed license permitting embedding in a shipping iOS app.
- [ ] Filenames match the `UIAppFonts` array in `app/ChunkRacerApp/Info.plist` (or update `Info.plist` to match).
- [ ] Run `assets/code/contrast_audit.py` after the drop.
- [ ] Verify the app builds and Dynamic Type still scales; try Lexend vs OpenDyslexic in Reading settings.
