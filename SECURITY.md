# Security & Privacy — Decoder / Chunk Racer

Decoder is built for children with dyslexia and ADHD, so privacy is an architectural
commitment, not a policy afterthought. **Privacy by architecture, not by promise.**

## Posture (as of the 2026-07-27 Fellow security review)

- **No data is collected or transmitted.** The app makes **no network calls** — no
  analytics, ad, crash-reporting, or telemetry SDKs. It is fully offline-first.
- **No third-party code.** The only dependency is the first-party `DecoderCore` Swift
  package, so there is no supply-chain attack surface.
- **Minimal, non-PII data, on-device only.** A learner profile holds mastery, momentum,
  and reading preferences; the event log holds `{ appId, itemId, correct, latencyMs, ts }`
  and a local `learnerId` ("demo"). No real name (defaults to "Player"), email, date of
  birth, address, phone, location, or device identifier is collected.
- **Encrypted at rest.** Profile and event files are written to the app sandbox with
  `completeFileProtectionUntilFirstUserAuthentication`.
- **No sensitive permissions.** The app requests no camera, microphone, location,
  contacts, or photo-library access.

## What was verified

Network usage, third-party dependencies, secrets in the repo and history, PII in the data
model, sensitive-permission prompts, risky APIs (`UIPasteboard` / `WKWebView` / `NSTask` /
eval / unsafe casts), entitlements, and data-at-rest protection. No critical or high
findings; the one recommendation (encrypt at rest) has been applied.

## When this changes, so does the review (forward-looking)

These are **not current issues** — they become required work if/when the feature lands:

1. **Real names become PII.** If onboarding ever lets a parent type the child's real name,
   that is stored PII: COPPA/GDPR-K data-handling (export/delete, parent gate, privacy
   label) then applies. Keep the name generic or gate its entry.
2. **Over-the-air content.** Content packs are bundled and trusted today. If packs become
   downloadable (ODR / OTA), the loader must authenticate the source and the
   `AssetKeyResolver` must guard against path traversal; treat downloaded content as
   untrusted input and validate before use.
3. **Accounts / purchases (monetization, parent dashboard).** Any account, purchase, or
   data-export action must sit behind a real parent gate (COPPA). Access-first (D13): the
   child's core reading practice is never gated.

## App Store privacy label

File as **"Data Not Collected."** This is accurate today and is the strongest possible
position for review, schools, and parents.

## Reporting a concern

Open a private issue or contact the project owner (AvaResearchLLC). Do not include child
data in any report.
