# Decoder / Chunk Racer — User Flows

## 1. Kid Flow: First-Time Play

```
Launch app
  → Animated splash with mascot (2s)
  → Parent gate: "Ask a grown-up to help set up." (simple math or swipe)
  → Create learner profile (nickname, age band, accessibility defaults)
  → Quick one-minute onboarding race (tutorial)
  → Hub screen with Chunk Racer tile unlocked
  → Kid taps Chunk Racer → race starts immediately
```

**Accessibility notes for onboarding:**
- All text is read aloud by default.
- Off-white background and OpenDyslexic font are pre-selected.
- No requirement to type; nickname chosen from a scrollable list or voice.
- Parent can override settings later.

## 2. Kid Flow: Daily Race

```
Open app
  → Hub shows mascot + streak flame + today's recommended activity
  → Kid taps Chunk Racer
  → 3-second countdown with breathing prompt (ADHD regulation cue)
  → Target chunk appears + TTS reads it
  → Cards scroll for 60–90s
  → Race ends → celebration animation
  → Summary: "You matched 8 chunks! Best streak: 4."
  → Return to hub or replay
```

## 3. Adaptive Engine Flow (invisible to kid)

```
After each event:
  → Update learner skillState for the practiced node
  → If correct + fast: lower mastery uncertainty, schedule next review further out
  → If incorrect or slow: increase review frequency, drop difficultyBand by 1
  → If mastery threshold reached: unlock next skill node
  → Select next item to serve: edge of ability, spaced review, or session shaping
```

## 4. Parent/Teacher Flow

```
Parent opens companion view (from app or web)
  → Login / account switch
  → Select child
  → Dashboard shows:
      - This week: 4 races, 12 minutes total
      - Skills moving: CVC decoding +8%, sight words +3%
      - Suggested home activity: "Read 'cat' family words together"
  → Settings: font, background, session length, voice, haptics
  → Data export / delete request
```

## 5. Session-Shaping Rules

- Race ends on a win (positive final state).
- If the kid taps pause, the timer pauses and a calm "Take a break" screen appears.
- If the app loses focus, the race pauses automatically.
- Three short races (3–7 min total) are recommended per day; no penalty for stopping.

## 6. Error / Edge Cases

| Scenario | Behavior |
|---|---|
| No internet | Full offline race; sync on reconnect |
| TTS unavailable | Visual cue is larger; hint button still works |
| Child taps everywhere rapidly | Ignore extra taps within 300ms; no shame feedback |
| Accessibility settings change mid-race | Apply after current race to avoid distraction |
| Content pack fails validation | Fall back to last known good pack; log error |

---

*Next: see `implementation-plan.md` for build order.*
