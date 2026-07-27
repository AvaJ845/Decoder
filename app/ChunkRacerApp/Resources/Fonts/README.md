# Font Drop — Chunk Racer

Licensed OFL font files are bundled here. The app registers them at launch via `FontManager.registerBundledFonts()` and `Info.plist` `UIAppFonts`.

## Bundled files (D19)

| File | PostScript name (use in code) | Role | License |
|---|---|---|---|
| `LexendDeca-Regular.ttf` | `LexendDeca-Regular` | **Reading default** | OFL (`OFL-LexendDeca.txt`) |
| `OpenDyslexic-Regular.otf` | `OpenDyslexic-Regular` | Reading — switchable | OFL (`OFL-OpenDyslexic.txt`) |
| `OpenDyslexic-Bold.otf` | `OpenDyslexic-Bold` | Reading bold | OFL |
| `FredokaOne-Regular.ttf` | `Fredoka-Regular` | Display (Fredoka OFL; replaces Fredoka One) | OFL (`OFL-Fredoka.txt`) |

`DesignTokens.TypeRole` uses the PostScript names above so `Font.custom` / `UIFont(name:)` resolve after registration.

## Sources

- Lexend Deca — [google/fonts ofl/lexenddeca](https://github.com/google/fonts/tree/main/ofl/lexenddeca) (static instance at wght 400)
- Fredoka — [google/fonts ofl/fredoka](https://github.com/google/fonts/tree/main/ofl/fredoka) (static instance; file kept as `FredokaOne-Regular.ttf` for stable path)
- OpenDyslexic — [antijingoist/opendyslexic](https://github.com/antijingoist/opendyslexic) `compiled/`

## Verify after drop

```bash
cd app && swift test
# In Simulator: Reading settings → Lexend Deca / OpenDyslexic should change face when fonts load
```
