# Projects — 12 Mobile Development

One capstone brief for this subject: everything the lessons executed — the fetch
state machine, the offline contract, the permission gate, the test tiers — becomes
acceptance criteria on one real app. Project 06 is the subject's exit ticket:
you cannot complete it without every lesson's central discipline showing up in
running code.

## Brief — Project 06: an offline-first, API-driven app → `api-integration.md` · `offline-functionality.md` · `state-management.md` · `forms-and-validation.md` · `navigation.md` · `secure-storage.md` · `permissions-and-notifications.md` · `mobile-testing.md`

Build a Flutter app that talks to a real HTTP API, works when the network
doesn't, stores credentials in the platform vault, and ships with a test suite
you can trust. Pick a domain with genuine sync pressure — field notes, a shared
shopping list, a delivery log — so the offline and conflict requirements are real
rather than performed.

**The API may be the one from [11-BACKEND-ENGINEERING](../../11-BACKEND-ENGINEERING/README.md)'s
briefs, a public sandbox API, or your own — but it must be an API you don't
control the failure schedule of, because the failure paths are half the grade.**

### Milestones

**M1 — Navigable, testable shell.** Route table with named routes and one
awaited result; app state split by domain behind Provider (or an equivalent you
can defend); a widget test per screen asserting visible behavior. *Discipline
from `navigation.md`, `state-management.md`, `mobile-testing.md`.*

**M2 — The four states, everywhere.** Every data screen implements loading →
error → retry → success with a visible attempt count; parsers are pure and
fixture-tested; all requests carry timeouts. *Discipline from `api-integration.md`
— the W9/W9b battery is the reference shape.*

**M3 — Forms that gate.** Validators as pure functions with a table test; the
three-round battery (empty, bad, valid) per form; a submit guard proving one tap
= one request. *Discipline from `forms-and-validation.md` — W8 is the template.*

**M4 — Offline as a contract.** Reads return `(data, source)` with a stale label;
writes queue durably and replay in order with idempotency keys; a conflict policy
written down per data type. Kill the app mid-edit and it must come back with the
edit intact. *Discipline from `offline-functionality.md` — W14's three lines are
the acceptance tests.*

**M5 — Platform seams.** Tokens in the platform vault, never preferences; logs
redacted; notification taps route through a pure payload function with a safe
default; the permission flow handles denied → permanently denied → settings, with
the Android/iOS differences documented as you implement them. *Discipline from
`secure-storage.md`, `permissions-and-notifications.md` — W11/W13.*

**M6 — Release readiness.** Version/build strategy for both stores; the signing
and plist/manifest checklists filled in with your app's real values; a red/green
deliberate-break drill performed on your own suite and quoted in the report.
*Discipline from `android-release.md`, `ios-release.md`, `mobile-testing.md`.*

### Required exercises (from the subject README)

These four are mandatory components of the brief, not optional stretch goals:

1. **Failure handling** — handle a failed API call with a retry and an error
   screen (M2).
2. **Offline cache** — implement an offline cache that survives a restart (M4:
   the kill-and-relaunch capture).
3. **Widget test** — write a widget test asserting visible behavior (M1; at
   least one test that fails when the behavior breaks).
4. **Platform comparison** — implement the same permission flow for Android and
   iOS and document the differences (M5: your own filled-in version of the
   lessons' comparison table, with device captures for each side).

## What "done" looks like

- [ ] All six milestones accepted against their named disciplines, each with
      captured evidence (test output, kill/relaunch transcript, drill red/green
      pair) — the same provenance standard this subject's lessons held.
- [ ] Full suite green and fast enough to run always (`flutter test`, recorded
      runtime); one deliberate break per tier captured (unit, widget, integration).
- [ ] Stale/queue/conflict contracts demonstrated, not described: the three W14-
      style read lines, a queue surviving process death, a written conflict policy.
- [ ] No plaintext credentials in preferences or logs; the wipe-on-logout test
      passes.
- [ ] Permission flow handles all four states, with the permanently-denied
      settings path shown on both platforms.
- [ ] Store checklists (Android and iOS) filled with real values; every
      macOS/Windows/Android-only step labelled with the machine that runs it.
- [ ] A short write-up: three decisions you'd change in a rewrite, each traceable
      to a lesson's trade-off section.
