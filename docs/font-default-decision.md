# Graphics Lead Decision — Reading Fonts (locked)

**Owner:** Graphics lead + Fellow (accessibility)  
**Date:** 2026-07-26  
**Status:** **LOCKED** for sourcing and defaults. Playtest may still change the *preferred* default based on kid preference/performance.

## Decision

| Role | Font | Default? |
|---|---|---|
| **Reading (default)** | **Lexend Deca** | Yes |
| **Reading (switchable)** | **OpenDyslexic** (Regular + Bold) | Offered, not default |
| **Display** | **Fredoka One** | Yes (titles / buttons / celebrate) |

Ship **both** reading faces. Do not treat OpenDyslexic as the settled “correct” dyslexia font.

## Why Lexend Deca is the default

Research is mixed: several studies find little measured gain for OpenDyslexic vs a clean humanist sans; some dyslexic readers prefer / read Lexend faster. OpenDyslexic can also *look* clinical (“remedial”), which fights Decoder’s “never feels remediated” bar. Lexend is cleaner and still highly readable; OpenDyslexic remains available for kids/parents who want it.

**Playtest #1:** treat font as a variable — let kids try both when practical; note preference and any legibility comments. Defaults can change after evidence without redoing art.

## Files to drop

Into `app/ChunkRacerApp/Resources/Fonts/` (must match `Info.plist` `UIAppFonts` or update plist + PostScript names together):

- `LexendDeca-Regular.ttf` (+ weights if available)
- `OpenDyslexic-Regular.otf`
- `OpenDyslexic-Bold.otf`
- `FredokaOne-Regular.ttf` (or `.otf` / variable)

Confirm each license allows embedding in a shipping iOS app. If internal PostScript names differ from the strings above, **tell DE-App the exact names** so `DesignTokens` / `FontManager` match.

## Who sources

**DJ / project owner sources the licensed files** (or designates a vendor). DE-Art does not invent fonts; DE-App wires names once files land.

## Code default

`DesignTokens.TypeRole.readingDefault` = Lexend Deca; `readingFallback` / switchable = OpenDyslexic. Accessibility settings keep the System / Lexend / OpenDyslexic picker.
