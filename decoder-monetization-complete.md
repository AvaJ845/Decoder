---
name: decoder-monetization
description: Recommends a monetization strategy for the Decoder iOS app series that aligns with Apple design principles, privacy standards, and children's-app requirements. Use when discussing pricing, subscriptions, App Store business models, or monetization for Decoder, Chunk Racer, or the broader series.
---

# Decoder Monetization Strategy

## Purpose

Recommend a monetization path for the Decoder iOS app series (kids with dyslexia and ADHD) that is Apple-aligned, privacy-safe, and parent-trustworthy.

## The recommended approach

**Subscription-first, trust-led, with a separate institutional track.**

### Consumer model

1. **Free to download**
   - First 3 levels or one daily race unlocked.
   - Parent dashboard shows a limited preview.
   - No account wall before the child tries the game.

2. **7-day free trial**, then subscription
   - **Annual default**: $39.99–$49.99/year.
   - **Monthly option**: $5.99/month (less prominent).
   - **Family Sharing** included.

3. **Lifetime unlock as a secondary option**
   - $79.99–$99.99 for parents who strongly prefer one-time purchases.
   - Includes all future flagship content packs tied to the subscription.

### Institutional model

- School / SLP / district licensing through Apple School Manager or volume purchase.
- Per-seat pricing: $4–$8/student/year at scale.
- Classroom tier: $200–$400/classroom/year.
- This channel becomes important when Clue Hunt and Story Studio launch (iPad-forward titles).

## Apple design principles applied

- **Clarity**: One clear value proposition. No hidden tiers, no consumable coin economies, no surprise paywalls.
- **Deference**: Monetization never interrupts the learning loop. Paywalls live outside the core game session; the parent gate handles purchases.
- **Privacy**: Subscription revenue replaces ads and data monetization. No ad SDKs, no behavioral profiling, minimal PII.
- **User control**: Easy cancellation, transparent trial terms, restore purchases, no auto-renewal traps.
- **Accessibility**: Pricing screens use Dynamic Type, VoiceOver, and WCAG contrast.
- **Family Sharing**: One subscription covers multiple learners in a household.
- **Trust**: Free trial lets families see measurable skill growth before paying.

## What to avoid

| Approach | Why it fails for Decoder |
|---|---|
| Paid upfront only | Too high a barrier before trust is earned. |
| Ad-supported | Violates privacy promise and the calm-energy principle. |
| Consumable currency | Confusing, nickel-and-diming, complicates the adaptive engine. |
| Aggressive gating | Shuts down the learning experience too early; feels punitive. |
| Dark-pattern auto-renew | Violates user control; risks App Store rejection. |

## Implementation checklist

- [ ] StoreKit 2 subscription groups set up in App Store Connect.
- [ ] Annual plan is the default pricing anchor; monthly is secondary.
- [ ] Family Sharing enabled.
- [ ] Parent gate on every purchase flow.
- [ ] Restore purchases button present and functional.
- [ ] Trial terms written in plain language, not buried in legal text.
- [ ] Paywall appears outside the core game loop, never mid-race.
- [ ] Subscription unlocks content packs, adaptive features, and full parent dashboard.
- [ ] Institutional tier documented separately for B2B sales.

## When to adjust

- **No efficacy data yet**: Price at the lower end ($39.99/year) and use a longer trial (14 days).
- **Efficacy data available**: Move to $49.99/year and lead with outcomes in the paywall.
- **Expanding to schools**: Introduce institutional pricing before the iPad launch of Clue Hunt / Story Studio.

## Reference

For the full rationale, pricing analysis, and Apple-principle mapping, see [reference.md](reference.md).
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
# Decoder Monetization Approach

**For the fellow working in Claude Code on the Decoder iOS app series.**

This doc outlines the monetization path chosen for Decoder, a platform-first series of reading-strategy games for kids with dyslexia and ADHD, launching on iPhone with iPad as a committed later phase.

## The decision

**Subscription-first, trust-led, with a separate institutional track.**

This is the model that best fits the audience, the App Store, and Apple's design principles.

## Consumer model

### 1. Free tier

- Free download.
- First 3 levels or one daily race unlocked.
- Limited parent dashboard preview.
- No account wall before the child plays.

### 2. Free trial

- 7-day free trial as default.
- 14 days if efficacy data is still being collected.
- Trial length shown clearly before the user starts it.

### 3. Subscription pricing

| Plan | Price | Role |
|---|---|---|
| Annual | **$39.99–$49.99/year** | Default pricing anchor. |
| Monthly | **$5.99/month** | Secondary option for cautious parents. |
| Lifetime | **$79.99–$99.99** | For parents who refuse subscriptions. |

### Why subscription?

- **Trust before purchase**: parents of neurodivergent kids need to see progress before paying.
- **Recurring value is real**: content packs, adaptive engine improvements, and the parent dashboard keep delivering value.
- **Privacy-safe**: no ads or data selling required.
- **Family Sharing**: one subscription covers multiple learners.
- **Positioned against tutoring**: one year costs less than one hour with a reading specialist.

## What the subscription unlocks

- All levels and content packs for the flagship app (Chunk Racer at launch).
- Full parent / teacher dashboard with skill-over-time evidence.
- Cross-device progress sync.
- Future strategy tools and seasonal content packs.

## Institutional model (B2B)

Target schools, SLPs, reading specialists, and districts — especially once Clue Hunt and Story Studio launch on iPad.

| Model | Pricing |
|---|---|
| Per-student | $4–$8/student/year |
| Per-classroom | $200–$400/classroom/year |
| Site license | Custom negotiation |

## Apple design principles

The monetization model must align with how Apple thinks about product quality:

- **Clarity**: one clear value prop, no hidden tiers, no consumables.
- **Deference**: paywalls never interrupt the child's learning session.
- **Privacy**: subscription revenue replaces ads and data monetization.
- **User control**: easy cancellation, restore purchases, parent-gated buying.
- **Accessibility**: pricing screens use Dynamic Type, VoiceOver, and good contrast.
- **Family Sharing**: one subscription covers the household.
- **Trust**: the trial proves value before the parent pays.

## What to avoid

- Ads or ad SDKs.
- Consumable in-app currency.
- Aggressive gating that breaks the free experience.
- Dark-pattern auto-renewal tricks.
- Complex multi-tier subscription confusion.

## Engineering checklist

- [ ] StoreKit 2 subscription groups set up in App Store Connect.
- [ ] Annual plan is the default; monthly is secondary.
- [ ] Family Sharing enabled.
- [ ] Parent gate on every purchase flow.
- [ ] Restore purchases button works.
- [ ] Trial terms are in plain language.
- [ ] Paywall lives outside the core game loop.
- [ ] Subscription unlocks content, dashboard, and sync.
- [ ] Institutional pricing plan documented for future sales.

## The Apple pitch

> *Decoder is a privacy-first, evidence-based subscription. Families try it free, see measurable skill growth, and subscribe once. No ads, no data selling, no manipulative mechanics. The revenue comes from the value we create, not from the child's attention.*

This is the monetization story Apple is most likely to feature and support.

## Next steps

1. Implement the StoreKit 2 subscription flow.
2. Design the parent-gated paywall that leads with skill outcomes.
3. Instrument the trial-to-paid funnel so you can measure conversion by skill growth.
4. Prepare institutional pricing and an admin dashboard for the iPad/school phase.
