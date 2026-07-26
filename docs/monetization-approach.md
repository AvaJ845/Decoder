# Decoder Monetization Approach

**For the fellow working in Claude Code on the Decoder iOS app series.**

This doc outlines the monetization path chosen for Decoder, a platform-first series of reading-strategy games for kids with dyslexia and ADHD, launching on iPhone with iPad as a committed later phase.

## The decision

**Access-first, then subscription-led, with a separate institutional track.**

Access comes first and constrains everything else. On top of it we run a trust-led subscription that monetizes *breadth and parent insight* — never the child's reading practice — plus an institutional track for schools. This fits the audience, the App Store, and Apple's design principles.

## Access-first (this leads — Fellow decision D13.1)

A kid who needs this must never be blocked from the *reading practice itself* by ability to pay. Concretely:

- **The child's core reading practice is never paywalled.** We monetize breadth and parent insight, not a struggling reader's reps.
- **A scholarship / free-for-need / school-covered path is a launch feature**, designed up front and stated plainly in the App Store listing — not a later add-on.
- This is both mission-right and the strongest defense against the "you're paywalling struggling kids" criticism that Apple's kids-app review scrutinizes.

Everything below sits on top of this. If any pricing choice conflicts with access-first, access wins.

## Consumer model

### 1. Free tier

- Free download.
- **The core reading practice stays generously free** — we never gate a kid's reps behind payment (D13.2). Unlimited core play on the flagship's base content.
- Limited parent dashboard preview (skill-over-time evidence is the paid upgrade).
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
| Lifetime | **$79.99–$99.99** | For parents who refuse subscriptions. **Scoped to the flagship app only** (or a higher "founding family" tier) — never unlimited access to the whole growing suite (D13.4). |

### Why subscription?

- **Trust before purchase**: parents of neurodivergent kids need to see progress before paying.
- **Recurring value is real**: content packs, adaptive engine improvements, and the parent dashboard keep delivering value.
- **Privacy-safe**: no ads or data selling required.
- **Family Sharing**: one subscription covers multiple learners.
- **Positioned against tutoring**: one year costs less than one hour with a reading specialist.

## What the subscription unlocks

The subscription monetizes **breadth and insight — never the child's core reps** (D13.2):

- The **full parent / teacher evidence dashboard** with skill-over-time — the primary paid value.
- **Breadth**: additional apps in the suite and expanded / seasonal content packs beyond the free base.
- Cross-device progress sync.
- Future strategy tools.

The child's core practice on the flagship stays free (see Access-first).

### Timing — the subscription turns on with breadth (D13.3)

A recurring subscription for a *single* small game churns. Don't ship a thin single-game subscription that trains parents to cancel. Either a genuine content cadence exists from day one, **or** the subscription is enabled once app #2 / steady content exists. At flagship-only launch, prefer the lighter model and ramp into the subscription as the suite fills in.

## App Store category decision (make before StoreKit — D13.5)

**Kids Category vs Education is a deliberate, explicit choice**, not a default. They carry different App Store rules, discovery paths, and compliance obligations (data handling, purchase gating). Kids Category buys trust and a targeted audience but restricts more; Education gives room and school-channel credibility. Decide before any StoreKit work, because it shapes the whole compliance and review path.

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

- [ ] **Access-first: the child's core reading practice is never behind the paywall** (D13.2) — verify a non-paying kid can practice the flagship's base content indefinitely.
- [ ] **Scholarship / free-for-need path shipped as a launch feature** (D13.1) — redemption/eligibility flow + listing copy.
- [ ] **App Store category decided (Kids vs Education) before StoreKit work** (D13.5).
- [ ] StoreKit 2 subscription groups set up in App Store Connect.
- [ ] Annual plan is the default; monthly is secondary.
- [ ] **Lifetime tier scoped to the flagship only** (D13.4), labeled clearly.
- [ ] Subscription turns on with breadth, not a thin single-game sub (D13.3).
- [ ] Family Sharing enabled.
- [ ] Parent gate on every purchase flow.
- [ ] Restore purchases button works.
- [ ] Trial terms are in plain language.
- [ ] Paywall gates **breadth + the evidence dashboard + sync**, never the core reading loop.
- [ ] Institutional pricing plan documented for future sales.

## The Apple pitch

> *Decoder is a privacy-first, evidence-based subscription. Families try it free, see measurable skill growth, and subscribe once. No ads, no data selling, no manipulative mechanics. The revenue comes from the value we create, not from the child's attention.*

This is the monetization story Apple is most likely to feature and support.

## Next steps

1. **Design the access/scholarship path first** — this leads (D13.1): eligibility, redemption, and how it reads in the listing.
2. Decide the **App Store category** (Kids vs Education) — before any StoreKit work (D13.5).
3. Implement the StoreKit 2 subscription flow — paywall on breadth + dashboard, never the core reps.
4. Design the parent-gated paywall that leads with skill outcomes.
5. Instrument the trial-to-paid funnel so you can measure conversion by skill growth.
6. Prepare institutional pricing and an admin dashboard for the iPad/school phase.
