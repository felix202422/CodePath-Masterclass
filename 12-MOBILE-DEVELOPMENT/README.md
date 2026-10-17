# 12 — Mobile Development

This subject teaches cross-platform mobile development with Dart and Flutter, from language basics
to store release — including the platform differences, the offline realities, and the security
expectations that separate a demo from a product.

## What this subject covers

- Mobile development fundamentals: the platform model, device constraints, and what Flutter shares
  versus what stays platform-specific.
- Dart fundamentals: syntax, types, collections, classes, and tooling.
- Null safety: `null` as a type, nullability annotations, and how the compiler removes a whole bug
  class.
- Asynchronous Dart: `Future`, `Stream`, `async`/`await`, and isolates.
- Flutter fundamentals: the widget tree, `MaterialApp`, and the build lifecycle.
- Widgets and layouts: composition, row/column, stacks, and responsive layout.
- Navigation: routes, passing data, and deep links.
- State management: `setState` → `InheritedWidget` → `Provider`/`Riverpod`, each with its honest cost.
- Forms and validation: form controllers, validators, and submission.
- API integration: HTTP clients, JSON serialization, and error handling.
- Local storage: preferences, SQLite, and when each fits.
- Secure storage: keychain/keystore, token handling, and what "secure storage" actually promises.
- Camera and QR codes: permissions, capture flow, and scanning libraries.
- Permissions and notifications: the Android/iOS differences that break naive implementations.
- Offline functionality: caching, queues, and conflict handling.
- Mobile testing: unit, widget, and integration tests with `flutter_test`.
- Android release: signing, bundles, and Play Store requirements.
- iOS release: signing, provisioning, and App Store requirements.

## Why it matters

Mobile is where backend meets constrained devices, unreliable networks, and platform gatekeepers —
forces that make you design honestly. One codebase reaching both platforms is a real industry
economizer, and the discipline this subject teaches (null safety, offline-first thinking, secure
storage, permission flows) is what separates apps that ship from apps that crash.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — control flow, functions,
  and data structures.
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — the API this subject's app talks
  to (you may study 12 in parallel with the later lessons of 11 if you already have an API to use).

## Lessons

Flutter 3.47.x / Dart 3.13.x stable channel; pinned in [VERSIONS.md](../VERSIONS.md).

- `mobile-development-fundamentals.md` · `dart-fundamentals.md` · `null-safety.md`
- `asynchronous-dart.md` · `flutter-fundamentals.md` · `widgets-and-layouts.md`
- `navigation.md` · `state-management.md` · `forms-and-validation.md`
- `api-integration.md` · `local-storage.md` · `secure-storage.md`
- `camera-and-qr-codes.md` · `permissions-and-notifications.md` · `offline-functionality.md`
- `mobile-testing.md` · `android-release.md` · `ios-release.md`

## Exercises and practice

Each lesson ships a runnable snippet plus a focused exercise; `projects/` holds the brief for
Project 06. Exercises include: handle a failed API call with a retry and an error screen; implement
an offline cache that survives a restart; write a widget test asserting visible behavior; and a
platform-comparison exercise where you implement the same permission flow for Android and iOS and
document the differences.

## Expected outcomes

You can build a navigated, form-driven app that talks to a real API with proper loading/error/
empty states; persist data locally and tokens securely; implement an offline path; write unit and
widget tests; and produce a signed build for at least one platform, knowing exactly what the other
platform requires differently.

## Common blockers

- **Business logic inside widgets.** Widgets render; they do not decide. State management is where
  decisions live.
- **Assuming the platforms match.** Permissions, notifications, and signing differ between Android
  and iOS — the lessons name each difference instead of hiding it.
- **Testing only the happy path.** Mobile apps fail offline by default; the offline path is a
  first-class feature, not an edge case.

## Next

[13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md) —
step back from individual systems to how they should be designed, judged, and evolved.