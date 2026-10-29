# Set 12 solutions — Mobile testing · Android release · iOS release → `mobile-testing.md` · `android-release.md` · `ios-release.md`

*Executed in the batch's `scaffold` lab: the full `flutter test` suite, the deliberate-break
drill, and the two Android builds (Gradle 9.3.1 wrapper, Android SDK 36.1.0, Windows 11).
The iOS half is **labelled reference** — no macOS/Xcode on the authoring machine.*

## 1. The full suite as a gate (executed)

```
+25: All tests passed!        (~13s wall)
```

That ~13 s is the pre-commit budget. The CI split I would write: **unit tests** (pure Dart,
sub-second, every push), **widget/battery tests** (the W1–W14 suites, ~13 s — same job),
**integration/drive tests** (device/emulator, per-PR label or nightly — the cost lives
there, not in the 13). The gate is: unit + widget green before merge; timing regressions
show up as the widget tier creeping past its budget.

## 2. The deliberate-break drill, complete (executed)

All four captures, in sequence, with exit codes:

| Round | State | Capture | Exit |
|---|---|---|---|
| 1 | break live, test only prints | `email-error="<absent>"` → **`+25: All tests passed!`** | 0 (false green) |
| 2 | assertion added | `Found 0 widgets with text "Enter an email"` → `Some tests failed` | **1** |
| 3 | break reverted | `+25: All tests passed!` | 0 |

Round 1 is the lesson: the suite was green *with the bug present* because round one's
"test" observed and printed instead of asserting. The drill's value is that you have now
seen your own suite lie — and know the fix is an `expect`, not more tests.

## 3. The executed release pair, my machine (executed)

```
flutter build apk --debug         → √ Built …app-debug.apk        154,535,224 B   881.7s cold
flutter build appbundle --release → √ Built …app-release.aab (43.0MB)            689.7s
  Font asset "MaterialIcons-Regular.otf" was tree-shaken, reducing it from
  1645184 to 1368 bytes (99.9% reduction).
```

Four numbers, and the size gap explained: the debug APK (~147 MB) keeps symbols and skips
shrink/strip; the release bundle is **R8 Dex shrinking** plus **icon tree-shaking** (only
the codepoints you use survive — 99.9% of MaterialIcons didn't apply) plus release-only
stripping. The 881.7 s is Gradle 9.3.1's one-time download — warm rebuilds are far
faster, which is why CI caches `~/.gradle`.

## 4. Independent — release runbook, executed through step 3 (reference shape)

| Step | Machine | Evidence here |
|---|---|---|
| Keystore custody (gen + gitignore check) | local | *deferred* — a throwaway key was generated for wiring only; no store identity created by this repo |
| `versionCode` from CI build number | CI | rule written; monotonicity from the pipeline, not a human |
| Debug + release builds | local | **executed** — the four numbers in exercise 3 |
| Internal-track upload + split-APK test | Console | deferred — needs a Play account |
| Data-safety inventory | Console | source identified: the storage/API lessons' data flows |
| Staged rollout + exit criteria | Console | percentages written: 10% → 24 h, crash-free ≥ 99.5%, then 50 → 100 |
| iOS half (signing, plist, review) | **macOS** | *labelled* — [ios-release.md](../../../12-MOBILE-DEVELOPMENT/ios-release.md) §5–§9 assigned to a Mac; nothing pretended |

Completion evidence = the runbook with this exact honesty: every step carries where it
ran, and no step claims a transcript it does not have. The iOS row is the test of that —
the whole half is deferred to macOS, and saying so *is* the pass condition.
