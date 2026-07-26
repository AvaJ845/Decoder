# Chunk Racer — Product Specification

**Flagship title for the Decoder iPhone app series.**  
**Audience:** Kids 6–10 with dyslexia and/or ADHD.  
**Platform:** iOS (iPhone), Swift/SwiftUI + SpriteKit recommended.  
**Session length:** 60–90 seconds by default.

---

## 1. Elevator Pitch

Chunk Racer is a rhythm-racing game where kids spot target word chunks inside scrolling words. The faster and more accurately they recognize chunks, the more the race speeds up — but never in a punishing way. Misses are invisible; the game just serves the chunk again later.

## 2. Core Loop

1. A target chunk appears at the top of the screen (e.g. **AT**).
2. Word cards slide horizontally across a "reading ruler" lane.
3. The kid taps any card whose word contains the target chunk (e.g. **cat**, **bat**, **hat**).
4. Correct taps award points and increase a forgiving streak.
5. Misses keep the card moving and quietly schedule the chunk for later review.
6. Every 60–90 second race ends on a win, reports hits/streak/score, and returns to the hub.

## 3. Core Mechanics

### 3.1 Target Chunk
- Pulled from the current skill node the adaptive engine wants to practice.
- Displayed in large, bold, dyslexia-friendly type at the top of the screen.
- Read aloud via TTS when it first appears.
- Can be a whole word for sight-word practice (e.g. **the**).

### 3.2 Word Cards
- Each card shows one word with the target chunk highlighted (e.g. **c**at**).**
- Cards slide from right to left at a pace tuned by the adaptive engine.
- Cards are large enough for fat-finger taps; minimum 88pt tap target.
- Distractor cards contain words that do NOT include the target chunk.
- Target ratio: roughly 55% target, 45% distractor (tunable).

### 3.3 Input
- Primary: tap the card.
- Secondary: "Read word" button (TTS) repeats the word aloud.
- Haptic feedback on correct hit (short, 12ms vibration).
- No audio or visual punishment for wrong taps.

### 3.4 Pace & Difficulty
- Base speed increases slightly with each correct hit (max +50%).
- Speed drops gently if the kid misses several in a row.
- Spawn interval is driven by the item's difficultyBand (1 = 1400ms, 5 = 850ms).
- The adaptive engine overrides these defaults per learner.

## 4. Accessibility Defaults

| Feature | Default | Why |
|---|---|---|
| Font | OpenDyslexic or Comic Sans style | Reduces letter rotation/swapping |
| Background | Off-white (#F7F4EC) | Reduces glare |
| Reading ruler | On | Visual anchor for scanning |
| Letter spacing | Slightly increased | Reduces crowding |
| Line height | Generous | Easier tracking |
| TTS | On | Multisensory reinforcement |
| Haptics | On | Tactile feedback without noise |
| VoiceOver | Supported | Full screen-reader labels |

## 5. Scoring & Economy

- **Points:** 10 base + streak bonus per correct hit.
- **Streak:** Number of consecutive correct hits. Resets on miss but is never displayed as a loss.
- **Decoder Kit currency:** Small reward per completed race; used to unlock car colors, themes, or characters.
- **Mastery signal:** The adaptive engine uses hits, misses, and response time to update the skill graph, not just score.

## 6. Evidence Captured

Every event is append-only and tied to the learner profile:

```json
{
  "learnerId": "uuid",
  "appId": "chunk-racer",
  "itemId": "cr-001",
  "skillId": "decode-cvc",
  "correct": true,
  "latencyMs": 842,
  "ts": "2026-07-26T12:34:56Z"
}
```

Metrics surfaced to the parent/teacher dashboard:
- Decoding accuracy per skill node
- Average latency per chunk type
- Streak persistence
- Session stamina (time on task)
- Daily/weekly retention

## 7. Content Requirements

- Content loaded from validated JSON/CBOR packs (see `assets/code/content-pack-schema.json`).
- Each pack declares: id, version, locale, skillIds, and items.
- Each item declares: word, chunk, distractors, difficultyBand, and optional audio/mouth-shape assets.
- New packs (seasonal, curriculum-aligned, languages) ship without an app-store release.

## 8. Out-of-Scope for v1

- Multiplayer or leaderboards
- Complex character progression trees
- Parent dashboard (data is collected, dashboard is Horizon 3)
- Custom user-generated content
- Android port

---

*Next: see `user-flows.md` and `implementation-plan.md`.*
