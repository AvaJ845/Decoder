# Graphics Lead Decision — Arlo: Book (locked)

**Owner:** Graphics lead (DE-Art / art direction)  
**Date:** 2026-07-26  
**Status:** **LOCKED** — rig only this character. Do not produce a bear Arlo.

## Decision

**Arlo is the book character** — clean book-body, gold bookmark, no cape.  
The teal bear in `Required DE-Art illustration/arlo_kart_hero.png` is **warmth / expression reference only**, not the shipping character.

## Why book wins

| Criterion | Book | Bear |
|---|---|---|
| Brand / ownability | Distinctive: a reading buddy that *is* a book | Generic kids-app mascot |
| On-mission for Decoder | Directly tied to reading | Soft, but not about reading |
| Warmth / kid bond | Harder if stiff | Easier (face, fur, ears) |
| Rig / expression risk | Higher — must invent expressive anatomy | Lower — natural limbs |

Brand + mission outweigh ease. A stiff book would fail; an expressive book is the win condition.

## Production requirement (non-optional)

Rigging the book is only acceptable if it matches the bear concept on **warmth and readability of emotion**. Before shipping idle/celebrate/encourage:

1. **Face plane** — clear eyes + mouth shapes that read at 60 px (celebrate vs encourage must not look alike).
2. **Bookmark / limbs as puppets** — gold bookmark and soft limb-like edges carry gesture (wave, hug, lean).
3. **Kart adaptation** — book-Arlo sits in the go-kart as the on-track racer (`racer_kart_*`); helmet/stripe accents allowed; still clearly a book, not a bear with a book prop.
4. **Tone check** — warm, never babyish, never corrective (art-bible DoD).

If expression tests fail (celebrate/encourage unreadable), escalate to Fellow before redesign — do **not** silently switch to bear.

## Asset keys to produce

- `kit_guide_arlo_idle` / `_celebrate` / `_encourage` / `_think`
- `racer_kart_idle` / `_hit` (book-Arlo in kart = on-track racer)

## Explicitly cancelled

- Bear Arlo as a shipping character or alternate mascot
- Dual-character production (“both for now”)

## Reference

- Canonical look: art-bible / gentle-reserve / kit guide concepts (book-body)
- Expression / kart energy reference only: `Required DE-Art illustration/arlo_kart_hero.png`
- Full production list: `docs/de-art-asset-request.md`
