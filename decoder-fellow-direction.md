# Decoder — Fellow's Direction & Decision Log

**Owner:** Apple Fellow (design + roadmap authority)  
**Canonical repo:** https://github.com/AvaJ845/Decoder — moving-forward reference for all future work.
**Operating model:** the Fellow sets direction and makes design/architecture decisions; **DE-App** and **DE-Art** implement code, logic, and assets; the Fellow reviews all work against the bar below. Engineering owns *how*; the Fellow owns *what* and *whether it's good enough*.
Living document — decisions are numbered (D#) and dated; superseded ones are struck, not deleted.

---

## 1. The one goal that breaks ties

> **A kid with dyslexia or ADHD reads more, and more fluently, because the app made practice feel safe, fast, and worth coming back to.**

Every decision serves that. When two good options conflict, the one that better protects *safety (no shame), focus (calm), and fluency (reading reps)* wins. Cleverness, polish, and even delight are subordinate to it.

**Access-first — this leads the business model, not the other way around.** A kid who needs this must never be blocked from the *reading practice itself* by ability to pay. We monetize breadth and parent insight; we never monetize the child's reps; and a real scholarship / free-for-need / school-covered path is a **launch feature, stated up front**, not a later add-on. Every monetization decision is constrained by this (see D13). We lead with it.

---

## 2. The bar — Apple's principles, mapped to Decoder

These are the lenses I review against. Not decoration — the actual pass/fail criteria.

| Apple principle | What it means *here* |
|---|---|
| **Clarity** | The reading surface is sacred: high-contrast, legible, never decorated or animated. Content first; chrome recedes. If a screen makes a kid hunt for what to read, it fails. |
| **Deference** | The UI serves the content and the child, not itself. Motion and color earn their place by aiding the task; ambient flourish is a bug, not a feature (this is also our ADHD-calm requirement). |
| **Depth** | Layering and motion convey meaning — the race conveys pace, the reward conveys progress — but always purposefully, with a full static equivalent for Reduce Motion. |
| **Direct manipulation** | Kids act on the words directly (tap now, drag later). Big targets, immediate response, no indirection or menus between a child and the reading. |
| **Feedback** | Every action gets instant, legible, multi-sensory response (visual + audio + haptic-on-iPhone). Feedback is *encouraging or neutral — never punishing.* |
| **Consistency** | One visual language and one interaction grammar across all five apps (the platform thesis). A control does the same thing everywhere. |
| **Accessibility is the product** | VoiceOver, Dynamic Type, Reduce Motion, dyslexia typography, and color-independent signaling are ship-blockers, not settings we add later. |

**The non-negotiables (violations block merge):**
1. **No shame.** No red X, buzzer, frown, "wrong," or time-out-you-lose. Failure is invisible — a miss re-serves warmly.
2. **Reading type is never styled, animated, or baked into an image.** Always live, user-switchable (OpenDyslexic/Lexend), spacing-adjustable.
3. **Color never carries meaning alone.** Always paired with shape/icon/position/motion.
4. **Every animation has a Reduce-Motion equivalent** that loses no information.
5. **Off-white, low-glare grounds; AA contrast everywhere.**

---

## 3. Roadmap — the Fellow's sequence

I'm reordering the sprint plan around one conviction: **we earn the right to a kid playtest by making the loop *feel* like a race and by making it *safe and accessible* — in that order — before we add depth like profiles.** Rationale: the playtest (the real validation gate) tests feel and tone; those must be true first.

**Now → next (the current arc):**

1. **Make it race (feel).** The static tap-list becomes motion: words move, tempo drives the loop, the celebrate lands. *(DE-App + DE-Art)*
2. **Lock the tone to final.** Invisible-failure re-serve and the forgiving momentum meter at shipping quality. *(DE-App + DE-Art)*
3. **Reading-surface correctness.** Bundle real fonts; reading type honors Dynamic Type + spacing. *(DE-Art + DE-App)*
4. **Accessibility foundation — pulled EARLIER than the original plan.** VoiceOver, Dynamic Type, Reduce Motion, contrast. This gates the playtest, not just launch. *(DE-App)*
5. **Then depth:** learner profile + mastery persistence (survives relaunch). *(DE-App)*
6. **Kid playtest #1** on the real-feeling, accessible loop. The gate that decides everything after.

Everything past the playtest (content scale, privacy/offline, beta, launch) stays as the sprint plan has it. **Monetization (D12) is implemented after the accessibility gate and playtest #1:** StoreKit 2 subscription groups, trial flow, parent-gated paywall, and Family Sharing. iPad remains deferred; hold the §8.2 discipline.

**Build status (2026-07-26):**
- ✅ Interactive gray-box loop, locked v2.1 mechanic, runs on simulator.
- ✅ Step 1 *make it race* — progress-based race track + advancing racer, one-focal celebrate burst, kinetic round transitions, all with Reduce-Motion equivalents (D3/D4/D5).
- ✅ Step 2 tone — gentle re-serve + forgiving momentum in place; momentum now has a protected/rest-day state (D7 feedback system).
- ✅ Step 5 profile persistence — `LearnerProfile`, `SkillState`, `ProfileStore`, and `ForgivingMomentum` implemented in `DecoderCore`; adaptive engine uses persisted mastery; game persists after every answer.
- ✅ Review-fixes applied (2026-07-26): session-bounded adaptive engine (`nextItem(excluding:)`) so the race can complete; momentum saved after hit/miss; Dynamic Type fallback works even before bundled fonts land; 23 tests pass.
- ✅ Step 4 accessibility — **VoiceOver labels done** (cards, chunk prompt, race progress, momentum). **Dynamic Type wiring is done** (scales via system fallback now). **Contrast audit passed** across the four tints + dark mode with the adjusted palette (see D15). **Font drop** is the only remaining item before the accessibility gate closes.
- ⬜ Step 3 reading correctness (fonts) — blocked on DE-Art font drop; code is ready to load them automatically.
- Pending art (DE-Art): isolated Arlo sprites, real vehicle/track, celebrate particle (D11). Native placeholders in place.

---

## 4. Decision log

*(D# · date · decision · why)*

**D1 · 2026-07-26 · Mechanic = chunk-prompt → pick-the-word (schema v2.1).**
Better fluency practice (read whole words fast to spot a chunk) and matches the hero. Locked.

**D2 · 2026-07-26 · Reading text is rendered live, never baked into per-item images.**
A baked PNG can't switch to OpenDyslexic or honor a child's spacing — that violates the accessibility goal. The "cat" concept is a style reference, not an asset to clone. Applies to all five apps.

**D3 · 2026-07-26 · The race has no time-pressure fail state.**
Words move and tempo adapts to the child, but running out of time *re-serves* — it never says "you lost." Time pressure that punishes is off the table for this audience (protects non-negotiable #1). Speed is a difficulty *dial*, not a *threat*.

**D4 · 2026-07-26 · Motion is opt-out-equivalent, not opt-out-degraded.**
Reduce Motion swaps the race for a calm cross-fade/step presentation that conveys the same information (which word, that it moved on, that you succeeded). No feature is motion-only. Deference + accessibility.

**D5 · 2026-07-26 · The celebrate is one focal, brief, earned moment.**
Gold, ~0.6s, a single clear focal point (not confetti everywhere) — delight through restraint. Loud enough to feel earned, short enough to keep the 3–7 min session moving and not overstimulate. Static Reduce-Motion variant required.

**D6 · 2026-07-26 · Near-zero onboarding; learn by doing.**
No tutorial wall. The first item *is* the tutorial (direct manipulation). At most one line of guidance. Parent gate only where data/accounts are involved. Kids — especially ADHD kids — bounce off instruction screens.

**D7 · 2026-07-26 · Typography roles locked.** ~~Reading = OpenDyslexic default, Lexend Deca fallback~~ → **amended by D17.** Display = Fredoka One. Roles never bleed; reading type never animated.

**D17 · 2026-07-26 · Reading default = Lexend Deca; OpenDyslexic remains switchable (graphics lead + Fellow).**
Research on OpenDyslexic is mixed; it can also read as clinical. Ship both faces; default to Lexend Deca; let Playtest #1 treat font preference as a variable. DJ sources licensed files into `app/ChunkRacerApp/Resources/Fonts/`. See `docs/font-default-decision.md`.

**D18 · 2026-07-26 · Arlo identity locked: BOOK (graphics lead).**
Canonical Arlo is the book character (clean book-body, gold bookmark). The bear-in-kart concept is expression reference only — do not rig a bear. Book-Arlo must still hit bear-level warmth/readability of celebrate vs encourage; escalate before redesign if expression fails. See `docs/arlo-identity-decision.md`. Parallax environment remains cut (calm / ADHD).

**D8 · 2026-07-26 · Full dark-mode + all four bg tints are launch-required, designed (not inverted).**
Many dyslexic readers need a specific ground; parity is not optional.

**D9 · 2026-07-26 · Cue→haptic mapping is content-abstract and iPad-safe.**
Content fires `{emphasis,type}`; iPhone plays Core Haptics, iPad/no-haptics falls back to visual+audio with no content change. Keeps iPad cheap. (Confirmed; implemented in the spike.)

**D10 · 2026-07-26 · Accessibility gates move before the kid playtest.**
VoiceOver-operable, Dynamic Type, Reduce Motion, AA contrast, color-independent signaling must pass *before* we put it in front of kids — the playtest must test the real, inclusive experience.

**D11 · 2026-07-26 · Arlo must be delivered as isolated, transparent, single-pose sprites.**
The current character files are spec sheets with baked backgrounds — unusable in-game. Canonical Arlo (clean book-body, gold bookmark) rigged; idle/celebrate/encourage as transparent exports. Until then, a clean placeholder token stands in.

**D12 · 2026-07-26 · Monetization = subscription-first, trust-led, with a separate institutional track.**
Consumer: free download + 7-day trial + annual subscription ($39.99–$49.99/year, default), monthly ($5.99), lifetime ($79.99–$99.99). Family Sharing, parent-gated purchases, no ads/consumables/dark patterns. Institutional: $4–$8/student/year or $200–$400/classroom/year via Apple School Manager / volume purchase, targeting the iPad/school phase. This aligns with Apple's Clarity, Deference, Privacy, User control, and Trust principles; replaces ads/data monetization; and lets the trial prove skill growth before payment. StoreKit 2 implementation follows the accessibility gate and the first kid playtest. Full rationale in `docs/monetization-approach.md` and `.cursor/skills/decoder-monetization/`.

**D16 · 2026-07-26 · Created the `decoder-art-illustration` Cursor skill and the `Required DE-Art illustration` folder.**
Established a reusable art-generation workflow: Python/PIL for geometric placeholders, AI image generation for hero concepts, a contrast audit gate, and a DE-Art brief template. The first output is the Chunk Racer mockup-2 placeholder set (environment tiles, orange car, buttons, vertical ruler, Arlo hero concept, logo concept) plus a full DE-Art brief. This skill can be reused for Sound Forge, Clue Hunt, Focus Dojo, and Story Studio.

**D15 · 2026-07-26 · Palette adjusted to pass WCAG AA contrast audit across all four tints and dark mode.**
The art-bible teal (#2A9D8F) was too light for text on the reading surface and cream ground (≈3.2:1). Added a darker text variant `#1B7A6E` (`brandTealText`) for text on light surfaces while keeping the original teal as the brand accent for borders/fills/vehicle. Light-mode gold darkened to `#A67C2E` and light-mode gentleReserve darkened to `#5A8A8A` so they meet AA on the reading surface. The audit script is `assets/code/contrast_audit.py` and the full report is now green. This does not change the visual identity — it sharpens legibility and preserves the warm, accessible tone.

**D14 · 2026-07-26 · Fellow review of the other Fellow's profile/font pass — verdict: Ship with review-fixes applied.**
Reviewed against the bar: 23 tests pass, builds, launches. Found three issues and fixed them in the same pass: (1) the adaptive engine loop had regressed so it never returned nil, making the race never end and progress overflow past the finish line — fixed with a session-bounded `nextItem(excluding:)` seam; (2) momentum was saved before hit/miss was applied — fixed by persisting after the update; (3) the font fallback used fixed sizes so Dynamic Type didn't scale in the current fontless state — fixed to use semantic system styles. Added a regression test for session completion. Also flagged the mockup's "60s" countdown against D3: the app must stay time-pressure-free; any timer can only be a non-punishing pace element, never a lose-state. Verdict: cleared to move forward.

**D13 · 2026-07-26 · Monetization refinements — access-first (refines D12; Fellow-led, DJ-approved).**
Five principles the DEs build to, ordered by weight:
1. **Access-first, and we lead with it.** The child's core reading practice is *never* paywalled. A scholarship / free-for-need / school-covered path is a **launch feature**, designed up front — not a footnote. (Elevated into §1 as a stated mission commitment.)
2. **The paywall sits on breadth + parent/teacher evidence dashboard + cross-app + sync + new content — never on the child's reps.** This supersedes the "first 3 levels then pay" gate in the monetization doc: keep the core practice generously free; monetize insight and breadth.
3. **The subscription turns on with breadth.** Don't ship a thin single-game subscription that trains parents to cancel. Either a genuine content cadence exists from day one, or the subscription is enabled once app #2 / steady content exists. At flagship-only launch, prefer the lighter model.
4. **Lifetime is scoped to the flagship app only** (or a higher, clearly-labeled "founding family" tier) — never unlimited access to the whole growing suite, which would give away the future.
5. **Kids Category vs Education is an explicit, deliberate decision** (different App Store rules, discovery, and compliance) — made *before* any StoreKit work, not defaulted into.

Keep these top of mind on every monetization touchpoint; #1 is the lead.

**D17 · 2026-07-26 · Session stats are for the observing adult, never a score shown to the child.**
Fellow review of the session-summary PR caught a no-shame violation: an accuracy % + miss count on the child's "Race complete" screen is a shame surface (non-negotiable #1; playtest-1-plan §7). Fix merged: the kid sees a celebratory "You cleared N words!"; the `SessionSummary` (computed from the append-only event stream, persisted via `FileEventStore`) sits behind a default-off "For grown-ups" gate. A real parent gate arrives with the parent dashboard. This rule holds for every app: never surface a grade to the child.

**D18 · 2026-07-26 · Chunk Racer is code-complete for Playtest #1; remaining gates are DE-Art + recruiting, not code.**
The loop is playable and accessible (VoiceOver, Dynamic Type, Reduce Motion, reading ruler, four tints, dark mode, AA-verified) and each session yields evidence. Placeholder art + system fonts are acceptable for the playtest (we test the loop, not the finish). Open items before running it: DE-Art font drop + Tier-1 art (see `docs/de-art-asset-request.md`) and recruiting (see `docs/playtest-1-recruiting-kit.md`). **Open art decision to lock before rigging: Arlo's identity — canonical *book* (art bible) vs the *bear* in `arlo_kart_hero.png`. Fellow leans book; graphics lead's final call.**

---

## 5. How I review DE work

Every change is reviewed against, in order:

1. **The one goal (§1)** — does it make reading feel safer/faster/more repeatable?
2. **The non-negotiables (§2)** — any violation blocks merge, no exceptions.
3. **The relevant decisions (§4)** — consistent with the log, or a proposed, argued amendment.
4. **The asset Definition of Done** (art-bible §10) for anything visual.
5. **The invariants stay green** — content validator passes; the mechanic rule holds; DecoderCore tests pass.
6. **Craft** — spacing, motion timing, copy tone. Apple-level finish is the standard, calibrated to what the moment warrants.

Review verdicts: **Ship** / **Ship with notes** / **Rework** (with the specific principle or decision it missed). I'll be concrete about *why*, always tied to a principle or decision — never taste asserted as authority.

---

## 6. What each DE takes next

**DE-App**
- ✅ **Race motion system** (D3) — progress track, racer, finish flag, kinetic transitions, no time-pressure fail state.
- ✅ **Celebrate moment + invisible-failure re-serve + forgiving momentum** (D5/D7) — shipping-quality, with Reduce-Motion equivalent.
- ✅ **Accessibility foundation** (D10) — VoiceOver labels, Dynamic Type infrastructure (scales with system fallback), Reduce Motion wiring, reading ruler, accessibility settings sheet.
- ✅ **Learner profile + mastery persistence** — completed; now uses `ProfileStore`, `SkillState`, and `ForgivingMomentum`.
- **Next:** **Contrast audit** across the four background tints + dark mode; finalize reading-surface correctness once the DE-Art font drop lands. These gate the kid playtest.
- After playtest #1: implement **StoreKit 2 monetization** (D12 + **D13**): subscription groups, trial, restore, Family Sharing — but the **paywall never gates the child's core reading practice** (D13.2). Build the **access/scholarship path as a launch feature** (D13.1, this leads). Scope any lifetime tier to the flagship only (D13.4). Confirm the **Kids Category vs Education** decision before starting (D13.5).

**DE-Art**
- ✅ **Decisions locked (D17/D18):** Arlo = book; Lexend Deca reading default + OpenDyslexic switchable.
- **Fonts first (playtest-relevant):** DJ sources licensed files → `app/ChunkRacerApp/Resources/Fonts/` (`docs/font-default-decision.md`).
- **Chunk Racer Tier-1 ship art** on `art/chunk-racer-production` — follow `docs/de-art-asset-request.md` + `docs/arlo-identity-decision.md`. Priority: (1) book Arlo idle/celebrate/encourage/think; (2) book-Arlo in kart; (3) app icon; (4) feedback set; (5) reading ruler; (6) logo last.
- **Do not build** parallax hills/trees/clouds/sky.
- Everything to the art-bible §10 DoD before it's "done." Parallel to playtest recruitment; not protected against loop findings.

I'll review each as it lands and keep this log current.

---

*The Fellow's job is to keep the app honest to one goal and to Apple's bar, and to make the calls so engineering never has to guess what "good" means. Direction is set; build against it and I'll review.*
