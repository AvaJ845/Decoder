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
