# Solutions — 12 Mobile Development

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lessons of the same name. Transcripts marked as
*authoring machine* were executed during this batch against the batch's `scaffold` lab
(**Flutter 3.47.7, Dart 3.12**, packages `provider`, `shared_preferences`, `qr`) plus the
plain-Dart probes (d1–d5b), the widget-test batteries W1–W14, and the two Android builds
(Gradle 9.3.1, Android SDK 36.1.0). Your versions' exact text will differ — the
**behaviour and the reasoning** are the criteria; your own captured output is your evidence.

| Set | Lesson(s) | File |
|---|---|---|
| 1 | Mobile development fundamentals | [set-1-solutions.md](set-1-solutions.md) |
| 2 | Dart fundamentals | [set-2-solutions.md](set-2-solutions.md) |
| 3 | Null safety | [set-3-solutions.md](set-3-solutions.md) |
| 4 | Asynchronous Dart | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Flutter fundamentals · Widgets and layouts | [set-5-solutions.md](set-5-solutions.md) |
| 6 | Navigation | [set-6-solutions.md](set-6-solutions.md) |
| 7 | State management | [set-7-solutions.md](set-7-solutions.md) |
| 8 | Forms and validation | [set-8-solutions.md](set-8-solutions.md) |
| 9 | API integration · Local storage | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Secure storage · Camera and QR codes | [set-10-solutions.md](set-10-solutions.md) |
| 11 | Permissions and notifications · Offline functionality | [set-11-solutions.md](set-11-solutions.md) |
| 12 | Mobile testing · Android release · iOS release | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring
machine's real capture — the d3 analyzer's `2 issues found`, the `Null check operator used
on a null value` trace, `sequential=188ms parallel=96ms`, the W-battery widget assertions
(`pageBuilds=2 constChildBuilds=1`, overflow `740 pixels`, `narrow w=390 → wide w=1280`),
the W8 red/green drill with `Found 0 widgets with text "Enter an email"`, the W9–W11
storage and HTTP receipts, the W12 QR matrix `size=25x25 dark=332/625`, the W14 offline
queue `dedup-skipped=1`, the full suite `+25: All tests passed!`, and the executed build
pair (`app-debug.apk` 154,535,224 B / `app-release.aab (43.0MB)` with icons tree-shaken
`99.9%`). Where a solution gives a *shape* (a table, a runbook, a rubric), no single
correct text exists — the criteria in the set's [README](../README.md) define what a
reviewer looks for.

**Device- and platform-honest items:** three kinds of work in this subject could not run on
the authoring machine (Windows, no device, no Xcode) and are *labelled reference* wherever
they appear: the Keychain/Keystore round-trip, on-device permission dialogs and camera
scans, and the entire iOS half of set 12. Their solution sections say exactly what to
capture on your device or Mac — they never pretend a transcript exists.

**Executed corrections worth knowing** (re-verified while writing these solutions): the
test binding's `HttpClient` stub silently intercepts *all* requests, so a real-HTTP test
group must reset `HttpOverrides.global` in `setUp` or it exercises a fake server and passes
for the wrong reason; a test whose first assertion round only `print`s is green while your
bug is live — assert the text, not the intent; `renderObject` needs its `<RenderBox>` type
argument before `.size` reads; a single-subscription `StreamController` accepts exactly one
listener and throws `Bad state: Stream has already been listened to` on the second; and
`flutter build apk --debug` on a cold machine spends ~15 minutes fetching Gradle 9.3.1 —
budget it once in CI, not per run.
