# Chunk Racer — Kid Playtest #1 Plan

**Owner:** Fellow · **Status:** ready to run once scheduled
**This is the gate that decides everything after it** (roadmap step 6, decision D10).

> We are not testing whether the app is pretty or finished. We are testing whether the
> *loop is safe and understood.* Placeholder art and system fonts are fine. If the loop
> works with kids, we invest in art and fonts. If it doesn't, we fix the loop first.

---

## 1. What this playtest decides

The whole thesis rests on three claims. This playtest either supports or breaks them:

1. **Understood without instruction** (D6) — a kid figures out "find the word with this chunk" on their own, because the first item *is* the tutorial.
2. **Failure is safe** (non-negotiable #1) — when a kid misses, they do **not** shut down, get frustrated, or show shame. The gentle re-serve reads as "try again later," not "wrong."
3. **Worth coming back to** — after a short race, the kid *wants* to keep playing.

If all three hold, we've earned the right to build art, drop fonts, and scale content.
If any breaks, we stop and fix the loop — no art investment until it's fixed.

## 2. Participants

- **4–6 kids.** Small on purpose — this is qualitative; you learn the big things in the first 3.
- **Ages ~6–9**, reading at or below level, with **dyslexia and/or ADHD** (the actual audience). A mix of both profiles if possible.
- **A parent/guardian present** for every session.

## 3. Setup

- One device, **1:1, observed**. Simulator is fine; a real iPhone in the kid's hands is better if signing is ready.
- **~10–15 min per kid.** Stop earlier if they're done or restless — never push.
- Two people ideally: one to sit with the kid, one to take notes. If solo, notes after.
- Turn on the session summary / event log so you can review accuracy + latency after (see §7).

## 4. Protocol — run it the same way every time

1. **Hand it over with almost nothing.** "Want to try a racing game?" Open it at the game screen. **Do not explain the mechanic.** Then watch.
2. **First 30 seconds — the comprehension test.** Do they read the chunk, scan the words, and tap? Do they get it *without* being told? Note exactly what (if anything) you had to say.
3. **Let them play the full race.** Stay quiet. Only step in if they're stuck >20s and visibly frustrated — and note that you had to.
4. **The critical moment — the first miss.** This is the most important 5 seconds of the whole test. Watch their **face and body**: do they slump, sigh, disengage, look to the parent, say "I'm bad at this"? Or do they shrug and keep going? Note it precisely.
5. **At "Race complete" — the re-engagement test.** Don't prompt. Do they ask to play again? Reach for it? Or hand it back / lose interest?
6. **Two questions, after** (optional, keep it light): "What did you like?" and "Was anything tricky or confusing?" Kids under-report frustration, so weight what you *saw* over what they *say*.

## 5. Observation rubric (one row per kid)

| Signal | Capture |
|---|---|
| Understood the mechanic **unaided**? | Yes / Needed a nudge / No — and what you said |
| Time to first correct answer | seconds (rough) |
| **Reaction to first miss** (shame scale) | 0 = shrugged & continued · 1 = paused · 2 = frustrated/looked away · 3 = shut down/upset |
| Re-engaged after a miss? | Yes / No |
| Asked/tried to play again at the end? | Yes / No |
| Legibility issues | anything hard to read (font, size, contrast) |
| Overwhelm / calm | any signs the screen was too much (ADHD) |
| Verbatim quotes | anything they said, good or bad |

## 6. Decision criteria

**GO (build art + drop fonts + scale content):**
- Most kids understood the mechanic unaided or with one tiny nudge.
- **Miss reactions are mostly 0–1** (no shame, no shutdown).
- Most kids re-engaged after a miss and/or wanted to play again.

**REWORK the loop first (do NOT invest in art/fonts yet):**
- Kids consistently *didn't* get the mechanic without being told → rethink the first-run / prompt.
- **Any pattern of shame or shutdown on a miss** (2–3) → the re-serve tone or pacing is wrong; this is the highest-priority fix, full stop.
- Kids disengaged fast / didn't want to continue → the loop isn't fun yet.

One clear shame reaction is a louder signal than five kids saying "it was fun." Weight it accordingly.

## 7. Data capture (nice-to-have, not blocking)

The app logs a `LearningEvent` per answer (correct, latency ms). For a reviewable
session, persist those to a file and show a short end-of-session summary (accuracy,
which items were re-served, median latency). **This is a small DE-App task** — wire
`FileEventStore` into `GameModel` and surface a summary on the "Race complete" screen.
Not required to run the playtest, but it turns each session into evidence and rehearses
the parent-dashboard pipeline.

## 8. Explicitly out of scope for this test

- Art polish, final vehicle/Arlo sprites, the licensed fonts (placeholders are fine).
- Content depth (12 items is plenty to read the loop).
- Monetization, onboarding flows, settings depth.

## 9. Ethics & care

- **Parental consent** before anything; parent present throughout.
- This is **play, not assessment** — say so to the kid and the parent. Never frame it as a reading test; this audience carries enough of that.
- **Stop immediately** if the child is distressed or done. Their comfort outranks the data.
- No recording of the child's face/voice without explicit written consent; notes are enough.
- Keep any notes de-identified (first name or initials only).

---

*The point of playtest #1 is to look a real kid in the face at the moment they get one
wrong. If that moment is safe, we have a product. Everything else is downstream of it.*
