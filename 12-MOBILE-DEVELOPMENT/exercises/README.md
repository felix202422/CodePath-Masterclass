# Exercises — 12 Mobile Development

**Lessons:** this subject's nineteen lessons, in order, plus the release pair.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–12 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Completing all twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md) Milestone 7 (mobile exercises), and they are the build-up to
the capstone brief in [projects/](../projects/README.md).

**The lab you need.** Everything here runs against a `flutter create` scaffold you may break
and rebuild at will — the exact shape the lessons were executed in:

```bash
flutter create scaffold && cd scaffold
flutter pub add provider shared_preferences qr   # the batteries' packages
flutter test                                      # your green baseline
flutter analyze                                   # should print No issues found!
```

The lessons were executed with **Flutter 3.47.7 / Dart 3.12** on Windows (Android SDK
36.1.0, Gradle 9.3.1 wrapper for the release builds) — policy matches
[VERSIONS.md](../../VERSIONS.md): where your versions differ, the *behaviour* is the
criterion and the exact text is yours to capture. Set 12's release pair also needs an
Android SDK; the iOS half needs a macOS machine and says so at every step.

**Predict before you run.** Every set below that says "predict" means paper first: write the
expected rebuild counts, error text, timing ratio, or widget-tree shape *before* running
`flutter test` — a prediction you did not write down is not a prediction. Where a set says
"assert", it means a `testWidgets`/`expect` in a test file, not a `print` you eyeballed
(that exact trap is set 8's opening exercise, captured in
[mobile-testing.md](../mobile-testing.md)).

---

## Set 1 — Mobile development fundamentals → `mobile-development-fundamentals.md`

1. Rebuild the documented scaffold and annotate it: run `flutter create`, then label the
   shared `lib/`+`test/` and the per-platform folders (`android/`, `ios/`, …) with what
   lives where and who reads it.
   **Criteria:** a directory tree with each entry's owner annotated; the two facts that
   make Flutter "one codebase, native shells" stated from the tree, not from memory.
2. Platform branching you can observe: write a `Platform.isX` branch, run it, and capture
   the line on two platforms (or one real + one documented why you can't).
   **Criteria:** the executed branch line (the lessons captured `Platform.isWindows=true`);
   one sentence on what `dart:io`'s platform truth does to widget tests.
3. Diagnose a cold start: time `flutter test` and `flutter analyze` on a fresh scaffold and
   read the numbers as warm-up vs steady-state (the lessons recorded `ran in 94.7s` cold).
   **Criteria:** two timings captured, cold vs warm; which number you would quote in CI and why.
4. **Independent:** you are handed a repo with `lib/` at top level and platform folders
   deleted. State exactly which commands regenerate what, and which files are
   irreplaceable-by-regeneration (signing keys, bundle ids, custom platform code).
   **Criteria:** a written regenerate-vs-preserve list, each entry justified from the
   scaffold anatomy you annotated in exercise 1.

## Set 2 — Dart fundamentals → `dart-fundamentals.md`

1. Run the d1 battery shape: integer division vs doubles, collection `if`/`for` and spreads,
   record literals, and a switch expression — predict each expression's value first.
   **Criteria:** a prediction table with at least eight rows, then the run capture with each
   mismatch explained (the lessons captured `int 4.5 double` and a merged `{a: 2, ...}`).
2. The cascade/const/mixin ladder: build an object with cascades, a `const` constructor with
   compile-time constants, a mixin applied to two classes, and an extension on a type you
   don't own.
   **Criteria:** one runnable file compiling clean under `flutter analyze`; the const
   constructor's canonical-instance proof (the lessons captured equal `0:00:30.000000`
   identities).
3. Model real data: define a record-returning function and a sealed-ish set of types for a
   discriminated value, then destructure both.
   **Criteria:** the destructuring compiles without casts; one sentence on when a record beats
   a class here — and when it doesn't.
4. **Independent:** port a small JSON-shaped data model (a product with variants) to Dart:
   `fromJson`/`toJson`, defaults for missing keys, and an unknown-key policy you state up
   front.
   **Criteria:** round-trip test `fromJson(toJson(x)) == x` passing under `flutter test`;
   the unknown-key policy written down and exercised with one surprise key.

## Set 3 — Null safety → `null-safety.md`

1. Make the compiler refuse: reproduce the d3 errors — assign `null` to a non-nullable
   variable and pass a `String?` where `String` is required — and read the analyzer's
   messages as *design feedback*.
   **Criteria:** the exact analyzer output captured (the lessons got `2 issues found` with
   `invalid_assignment` and `argument_type_not_assignable`); one rewrite per error that
   keeps the intent.
2. Three ways to be wrong at runtime: execute a `!` on null, a `late` field read before
   assignment, and an `is`-narrowing that succeeds — capture all three texts.
   **Criteria:** three captures — the null-check message, the `LateInitializationError`
   field name, and the narrowed branch's output; for each, the safe-rewrite (?. / initializer
   / promotion) that removes it.
3. Design a nullable API: write `String? findUser(String id)` and its three call sites
   (default, propagate, early-return), choosing `!` nowhere.
   **Criteria:** the function and call sites compile with `flutter analyze` clean; each call
   site's choice justified in one line (when propagating beats defaulting).
4. **Independent:** audit a 30-line snippet for null-risk: list every `!`, `late`, and
   `as` cast, classify each as provably-safe or replaceable, and rewrite the replaceables.
   **Criteria:** the audit table (site / risk / verdict) with executed analyzer evidence that
   the rewritten version still compiles.

## Set 4 — Asynchronous Dart → `asynchronous-dart.md`

1. Ordering prediction: before running, write the print order for a sync statement, a
   microtask, a timer, and an `await`; then execute and capture.
   **Criteria:** prediction written first; the capture showing `1 sync → 2 microtask →
   3 timer (event)` (or your shell's real order) with each line's queue named.
2. Sequential vs parallel, measured: time two 80 ms awaits back-to-back vs
   `Future.wait`, predict the ratio, then run it three times.
   **Criteria:** six timings and the ratio pattern (the lessons captured `sequential=188ms
   parallel=96ms`); one sentence on why the parallel figure isn't exactly half.
3. Errors and streams: force a typed failure across an `await` and catch it *at the await*;
   then feed a single-subscription stream two listeners and capture the crash plus the
   `broadcast` fix.
   **Criteria:** the `on TimeoutException` catch output; the `Bad state: Stream has already
   been listened to` trace; the same program green with `StreamController.broadcast()`.
4. **Independent:** two "CPU" tasks and one main isolate — prove parallelism (or its absence)
   with timings, choosing `Isolate.run` vs plain awaits deliberately.
   **Criteria:** a timing table (one run vs two) with the concurrency claim you can defend
   from *your* numbers, not the lessons' (`one-run=97ms two-isolates=129ms` is the reference
   shape).

## Set 5 — Flutter fundamentals · Widgets and layouts → `flutter-fundamentals.md` · `widgets-and-layouts.md`

1. Rebuild counts, predicted: in a `testWidgets`, predict how many times a page and its
   `const` child build after one setState; then capture the counters.
   **Criteria:** prediction first; the capture matching the lessons' `pageBuilds=2
   constChildBuilds=1`; the rule for when `const` actually skips a rebuild stated from it.
2. Read the real tree: dump the element tree for a small screen and annotate three levels
   (widget → element → render object), locating the `RenderParagraph` size.
   **Criteria:** the dump captured (the lessons recorded 77 lines and `size=114x20`); one
   line explaining which level carries layout state.
3. Layout drills: provoke a `RenderFlex` overflow and *catch the exception in the test*;
   then write one screen that responds at a width breakpoint (`narrow w=390` →
   `wide w=1280`) and assert both branches.
   **Criteria:** the overflow message with its pixel count captured via `takeException`; two
   asserted viewport widths; the Stack/Positioned geometry asserted with `getTopLeft`
   (reference: `topLeft=(50.0, 40.0)`).
4. **Independent:** design a screen (list + detail) that survives: 320 px width, a 2× text
   scale, and landscape — without overflow exceptions.
   **Criteria:** a test per axis of variation, all green, each asserting *geometry* rather
   than screenshots.

## Set 6 — Navigation → `navigation.md`

1. The push/pop lifecycle, executed: navigate to a detail route, assert the previous route
   is gone, pop, assert it is back.
   **Criteria:** both assertions in one `testWidgets` (reference: `home-gone=true` then
   `detail-gone=true`); the moment the old route stops rebuilding stated from the capture.
2. Arguments and results: pass a typed argument in, return a typed result out, and consume
   the awaited result behind a `mounted` check.
   **Criteria:** one test covering both directions (reference: `confirm order 7` in,
   `result: confirmed` out); the `mounted` check explained — what crashes without it.
3. Deep links and unknown routes: hand your router an unknown path and capture the fallback
   behavior; then deep-link directly to a detail route and verify its state is correct
   *without* the parent having been pushed.
   **Criteria:** the fallback captured; the deep-link test proving the detail route builds
   standalone (no nulls from a skipped parent).
4. **Independent:** a two-tab app with independent stack histories per tab: switching tabs
   must preserve each tab's position.
   **Criteria:** a test navigating in tab A, switching to B and back, asserting A's exact
   route — with your chosen strategy (IndexedStack / nested navigators) named and defended.

## Set 7 — State-management → `state-management.md`

1. Rebuild accounting with InheritedNotifier: predict which dependents rebuild after a
   notification, then assert the counts.
   **Criteria:** prediction first; the mount/after counts captured (reference:
   `dependent=1 bystander=1` → `dependent=2 bystander=1`); the dependency mechanism stated
   in one sentence.
2. The split-state test: with Provider, change *one* piece of state and prove an unrelated
   consumer does not rebuild.
   **Criteria:** two counters asserted around one change (reference: theme-consumer build
   count stays at `1` after the increment).
3. Undo/redo on paper: design the state shape for a text editor with undo history — command
   objects or snapshots, with the memory trade-off written down — then implement the reducer
   and unit-test three operations.
   **Criteria:** the design note (shape + trade-off) before code; three green unit tests
   covering apply/undo/redo including the empty-undo edge.
4. **Independent:** choose a state approach for a cart that outlives screens (but not app
   restarts) and defend it against two alternatives in a short ADR.
   **Criteria:** the ADR with the persistence requirement as the deciding factor; a test
   proving state survives navigation and does not survive a cold start (or, if it must, the
   deliberate contradiction noted).

## Set 8 — Forms and validation → `forms-and-validation.md`

1. The print-vs-assert trap, first: write a validation test that *prints* the error state,
   watch it pass with a deliberately broken validator, then give it an assertion and watch it
   fail — the exact red/green drill the lessons executed.
   **Criteria:** three captures — green-with-broken-code, red with `Found 0 widgets with text
   "Enter an email"`, green after revert; one sentence on why `print` is not a test.
2. Validation on submit: an empty and an invalid submit paint errors and *do not* call the
   submit callback; a valid submit clears errors and calls it with the parsed values.
   **Criteria:** all three states asserted in one suite (reference: `callback=not called` on
   bad input, `email=ada@example.com` on good); the error-text source (validator vs
   state) identified.
3. Async validation: validate a username against a fake server with debounce — assert no
   request fires until typing stops, and late responses don't clobber newer ones.
   **Criteria:** the debounce asserted with a fake clock; the stale-response race reproduced
   in a test *before* you fix it (capture the red), then green.
4. **Independent:** an edit form (not create) — initial values prefilled, dirty tracking,
   and a discard-changes guard on back navigation.
   **Criteria:** tests for all three behaviors; the guard's exit paths (discard vs stay)
   both asserted.

## Set 9 — API integration · Local storage → `api-integration.md` · `local-storage.md`

1. Against a real local server: serve three items, capture a 200, then a 404 with the
   error envelope's `type` and `detail` fields.
   **Criteria:** two `status=` captures (reference: `200 items=3` and the `/not-found`
   envelope); the envelope's contract written down from the response itself.
2. Two failure modes, typed: force a malformed-body failure and a timeout, and catch each
   with its own `on` clause.
   **Criteria:** `FormatException` and `TimeoutException` captures with their messages (the
   lessons recorded `0:00:00.150000`); one line on why `catch (e)` alone loses information.
3. The UI state walk: drive loading → error → retry → loading → success against a flaky
   server, asserting each state.
   **Criteria:** the full walk asserted (reference: `attempt 2 → items=1`); the test's
   `HttpOverrides` decision documented — the test binding stubs `HttpClient`, so a real-HTTP
   group must clear `HttpOverrides.global` (as `api-integration.md` §7 shows).
4. Storage with receipts: persist a counter and a theme across a simulated restart
   (fresh storage handle), then corrupt a file and prove recovery.
   **Criteria:** the before/after values captured (`launches=7 → 8`, missing key → `null`);
   the corruption run's output with the repair flag (`file-repaired=true`); one sentence on
   which of these belongs in prefs vs a file — with the size limit that decides it.

## Set 10 — Secure storage · Camera and QR codes → `secure-storage.md` · `camera-and-qr-codes.md`

1. The redline: write a token to your chosen store, then *read the raw bytes back* and prove
   what's on disk — followed by a log line that redacts it.
   **Criteria:** `contains-token=true`-style proof from your machine plus a captured log
   line showing `***` instead of the token; the threat this rules out (casual file read)
   and the one it doesn't (a rooted device with your process) stated honestly.
2. Platform vaults, on a device: wire Keychain (iOS) / Keystore (Android) and round-trip a
   secret through your app's storage abstraction.
   **Criteria:** a device/simulator capture of write → restart → read; the abstraction's
   interface shown so the app code never imports the platform channel directly. (The
   lessons could not execute this on a Windows machine — your capture is the transcript.)
3. QR encode, typed: generate a payload matrix and parse it back through a typed
   discriminator (`WebLink` / `WifiNetwork` / `UnknownPayload`) — including one payload
   designed to fool a prefix-check.
   **Criteria:** the matrix stats captured (reference: `size=25x25 dark=332/625`); all three
   parse results asserted, the malformed one landing in `UnknownPayload`.
4. **Independent:** design the QR scan → typed action pipeline for a check-in app, with an
   unknown-payload policy and rate limiting on scans.
   **Criteria:** the pipeline diagrammed then implemented to the typed-parsing test above;
   the unknown policy stated as behavior (what the user sees), with one test proving it.

## Set 11 — Permissions and notifications · Offline functionality → `permissions-and-notifications.md` · `offline-functionality.md`

1. The permission walk, on a device: drive unknown → denied → permanently-denied → granted
   and capture each state's UI, including the settings-intent hint.
   **Criteria:** four state captures (the lessons' reference: the walk ending `camera
   unlocked`); the code path that differs at permanently-denied stated from your capture.
2. Notification routing: send two payloads — one routable, one garbage — and assert where
   each lands.
   **Criteria:** both navigations asserted (reference: `order → /confirm?id=7`,
   `mystery → /`); the routing table's default entry justified.
3. Offline reads and writes, executed: mark the network unreachable mid-session and capture
   `source=network` → `source=cache(stale)`; then queue two writes, deliver one, and prove
   dedup and pending counts.
   **Criteria:** the stale-cache capture with its flags; the queue's receipts (reference:
   `sent=[PUT 1, PUT 2] dedup-skipped=1 kept-pending=1`); the conflict policy applied to
   three version pairs (remote-wins / local-wins / no-op) with outputs.
4. **Independent:** specify an offline-first sync contract for a field-notes app: what is
   written locally first, what happens on reconnect, and how conflicts are surfaced to the
   user (not silently resolved).
   **Criteria:** the contract as a table (operation / offline behavior / reconnect behavior /
   conflict rule), with three of its rows implemented as tests.

## Set 12 — Mobile testing · Android release · iOS release → `mobile-testing.md` · `android-release.md` · `ios-release.md`

1. The full suite as a gate: get the scaffold's suite green, then time it — this number is
   your pre-commit budget.
   **Criteria:** the summary capture (reference: `+25: All tests passed!` ~13 s) and your
   wall time; the split you'd put in CI (fast unit vs widget vs integration) written down.
2. The deliberate-break drill, complete: break a validator, capture green (if your first
   round is print-only), fix the assertion, capture red with the failure text, revert,
   capture green.
   **Criteria:** all four captures in sequence with exit codes — the exact drill recorded in
   [mobile-testing.md](../mobile-testing.md) §9.
3. The executed release pair, your machine: `flutter build apk --debug` and `flutter build
   appbundle --release`, recording sizes and timings and reading the tree-shaking line.
   **Criteria:** four numbers (cold/warm debug timings, bundle size, bundle time) plus the
   explanation of the debug-vs-release size gap with R8 and icon tree-shaking named
   (reference: 154,535,224 B debug vs 43.0 MB bundle, `99.9%` icons shaken).
4. **Independent:** write your app's release runbook end-to-end — keystore custody,
   monotonic `versionCode` from CI, internal-track upload, data-safety inventory source,
   staged rollout with exit criteria — and mark every step with the machine it runs on
   (local / CI / Console / macOS-only).
   **Criteria:** the runbook executed once on a throwaway app through step 3; the iOS half
   carried out on a Mac (or explicitly deferred with the macOS prerequisite named); no step
   claiming execution you did not perform.

*Solutions: attempt first. They live in [solutions/](solutions/README.md) of this subject.*
