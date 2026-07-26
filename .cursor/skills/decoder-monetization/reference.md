# Decoder Monetization Reference

Full background for the `decoder-monetization` skill. This document is meant to be read alongside the SKILL.md when a deeper rationale is needed.

## Product context

Decoder is a platform-first series of reading-strategy games for kids with dyslexia and ADHD. The flagship is **Chunk Racer**. The platform launches on iPhone, with iPad committed as a later phase tied to Clue Hunt / Story Studio and school conversations.

Key constraints that shape monetization:

- **Children's app**: COPPA / GDPR-K compliance required.
- **No ad SDKs**: already a product principle.
- **Privacy-first**: minimal PII, no data selling, no third-party behavioral tracking.
- **Trust-driven**: parents of neurodivergent kids are skeptical and need proof of skill growth.
- **Education channel**: schools, SLPs, and reading specialists are a natural long-term market, especially on iPad.
- **Calm energy**: the UI should never compete with the task; monetization should not add noise.

## Recommended consumer model

### Free tier

- Free download.
- First 3 levels or one daily race unlocked.
- Limited parent dashboard preview.
- No account wall before the child plays.

This design exists to build trust before asking for money. A parent must see the child engage, enjoy the experience, and ideally see a small skill signal before converting.

### Trial

- 7-day free trial as default.
- If efficacy data is weak, extend to 14 days to let the dashboard show progress.
- Trial length must be clearly stated before the user starts it.

### Subscription tiers

| Tier | Price | Notes |
|---|---|---|
| Annual | $39.99–$49.99/year | Default pricing anchor. Better LTV, lower churn, Apple-favored. |
| Monthly | $5.99/month | Secondary option for cautious parents. |
| Lifetime | $79.99–$99.99 | One-time unlock for parents who hate subscriptions. |

### Why subscription is the right model

- **Recurring value is real**: content packs, adaptive engine improvements, new strategy tools, and the parent dashboard all keep delivering value.
- **Positioning against tutoring**: one year costs less than a single hour with a reading specialist.
- **Trust before purchase**: trial lets the product prove itself.
- **Clean economics**: no need to monetize attention or data.
- **Family Sharing**: one subscription covers multiple learners, which matches how families actually buy.

### What the subscription unlocks

- All levels and content packs for the flagship app.
- Full parent / teacher dashboard.
- Progress sync across devices.
- Future strategy tools and seasonal content packs.
- Dark-mode and accessibility preferences (eventually).

Keep the free experience generous enough that the child feels the game is complete, but make the subscription clearly unlock the *evidence* and *progress* that parents care about.

## Recommended institutional model

This is a separate, B2B track that becomes important when the series expands to iPad and schools.

| Model | Pricing | When to use |
|---|---|---|
| Per-student | $4–$8/student/year | District or school-wide rollout. |
| Per-classroom | $200–$400/classroom/year | Single classroom or small-group purchase. |
| Site license | Custom | Larger districts; negotiate with SLP/curriculum leads. |

### Why this matters

- Kids in the 5–10 age band often do not own an iPhone but do use an iPad at home or school.
- Reading specialists, SLPs, and schools run on iPads.
- Comprehension and writing apps (Clue Hunt, Story Studio) genuinely want the larger canvas.
- Institutional revenue carries high trust value because schools validate the product for parents.

## Apple design principles applied to monetization

### Clarity

Pricing must be instantly understandable. The recommended model has one clear value proposition: *one subscription unlocks all learning content, progress tracking, and future packs for the flagship app.* No hidden tiers, no surprise costs, no coin economies.

### Deference

Monetization must not interrupt the learning flow. The paywall should never appear mid-race. It should be gated behind the parent experience and live outside the child's core session. The child should feel they are playing a complete game; the parent should see the value of unlocking the full dashboard.

### Privacy

Subscription revenue is the only clean model once ads and data selling are off the table. This aligns perfectly with Apple's privacy positioning and the app's own COPPA/GDPR-K design.

### User control

- Easy cancellation in Settings → Apple ID → Subscriptions.
- No pre-checked annual default unless monthly is equally visible.
- Restore purchases button that works.
- Parent gate on every purchase flow so children cannot subscribe accidentally.

### Accessibility

- Pricing screens use Dynamic Type.
- VoiceOver reads trial terms and feature lists.
- Contrast meets WCAG AA.
- No information is buried in dense legal text.

### Family Sharing

Enable Family Sharing from day one. This is how families buy kids' apps. It reduces churn, increases value, and aligns with Apple's editorial priorities.

### Trust

The free trial is the trust mechanism. If the dashboard shows measurable skill growth within the trial, the subscription becomes a no-brainer. The paywall should lead with the learning outcome, not feature bullets.

## Pricing rationale

- **$39.99/year**: introductory price when launching without published efficacy data. Low enough to reduce friction; high enough to signal quality.
- **$49.99/year**: target price once the parent dashboard shows real skill movement or after a small efficacy study.
- **$5.99/month**: exists only to catch parents who refuse annual plans. Price it so annual is obviously better value.
- **$79.99–$99.99 lifetime**: captures the anti-subscription segment. Set high enough that it does not cannibalize annual subscriptions.

## What to avoid

| Approach | Why it fails |
|---|---|
| Paid upfront only | Too high a barrier before trust is earned. |
| Ad-supported | Violates privacy, calm-energy, and COPPA/GDPR-K principles. |
| Consumable in-app currency | Confuses parents, complicates the adaptive engine, feels nickel-and-dimed. |
| Gating progress too aggressively | Free experience feels like a broken demo, not a real game. |
| Dark-pattern auto-renew | Violates user control and risks App Store rejection. |
| Complex multi-tier subscription confusion | Parents of kids with learning differences need simplicity, not decision fatigue. |

## Implementation notes for engineering

- Use **StoreKit 2** and SwiftUI from day one.
- Set up **subscription groups** in App Store Connect for future tiers (e.g., a "Decoder Plus" tier when multiple apps launch).
- Support **Family Sharing** and **Ask to Buy** correctly.
- Keep the parent-gated purchase flow separate from the child's game flow.
- Ensure the free experience does not rely on subscription state during a race.

## When to evolve the model

- **Launch (Horizon 1)**: Consumer subscription only. Keep institutional licensing on the roadmap but do not build it.
- **Efficacy data available**: Raise annual price, lead with outcomes, shorten or keep trial.
- **Clue Hunt / Story Studio launch**: Introduce a series-level subscription that covers all apps, with a single-app option for new users.
- **iPad + school channel (Horizon 2–3)**: Launch institutional pricing and admin dashboard for rostering, progress reporting, and classroom mode.

## The pitch to Apple

If presenting this to Apple editorial or a design review, the framing is:

> *"Decoder is a privacy-first, evidence-based subscription. Families try it free, see measurable skill growth, and subscribe once. No ads, no data selling, no manipulative mechanics. The revenue comes from the value we create, not from the child's attention."*

That is the monetization story Apple is most likely to promote.

## Summary

For the Decoder iOS series, the right monetization path is:

- **Free download + 7-day trial + annual subscription** as the consumer default.
- **Monthly and lifetime options** as secondary choices.
- **Family Sharing** enabled.
- **No ads, no data selling, no consumables, no dark patterns.**
- **Institutional licensing** prepared as a separate B2B track for the iPad/school phase.

This model aligns with Apple's design principles, protects the child's experience, and builds the trust that converts skeptical parents into long-term subscribers.
