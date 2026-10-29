# Camera and QR Codes

## 1. Learning Objectives

After this lesson you can:

- [ ] Generate a QR code as data, not as pixels-by-hand — and read what the
      matrix *is* (executed: `W12 qr: size=25x25 dark=332/625 data="https://
      example.com/o/7"` from `qr` 4.0.0's encoder)
- [ ] Parse scan payloads by shape — URL, WiFi configuration, garbage — with a
      typed result the UI must handle exhaustively (executed: `WebLink host=
      example.com`, `WifiNetwork ssid=CafeNet auth=WPA`, `UnknownPayload`)
- [ ] Explain the camera capture flow as a state machine and drive all its states
      with a faked controller (executed: the `CaptureController` phases and the
      permission gate of the next lesson's battery)
- [ ] Cross the platform boundary knowingly: where the camera HAL, the scanner
      library, and your Dart code actually meet — and which side each bug lives on
- [ ] Handle the permission sequence camera use demands: request at the moment of
      need, explain the rationale, and degrade gracefully to a fallback flow
- [ ] State what runs on the authoring machine and what needs a device — honest
      provenance for every capture in this lesson

## 2. Prerequisites

- [Mobile Development Fundamentals](mobile-development-fundamentals.md) — the
  platform-channel boundary every camera API sits behind.
- [Asynchronous Dart](asynchronous-dart.md) — streams from the camera preview and
  permission futures.
- [Permissions and Notifications](permissions-and-notifications.md) — the request
  flow this lesson's capture depends on (studied immediately after, in this batch).

*Toolchain: Flutter 3.47.7 / Dart 3.13.5, `qr` 4.0.0, Windows 11 — verified in
[VERSIONS.md](../VERSIONS.md). The QR encode and payload-parse captures are
**executed** (pure Dart — they run anywhere). The camera HAL, permission dialog,
and on-device scanning are **labelled reference**: this machine has no device
session; exercises run them on yours and the lesson says exactly which is which.*

## 3. Introduction

A camera is the feature most tightly welded to the platform: the preview stream,
the shutter, the torch, and the permission dialog all belong to the OS — while the
*processing* (scanning, decoding, validating) is yours. This lesson splits the two
sides cleanly, executes everything that's pure Dart, and gives you the state-machine
pattern that makes the device half testable anyway.

## 4. The Problem It Solves

QR codes became the offline-to-online bridge (payments, logins, Wi-Fi sharing)
because they're structured text a camera can read in a second — but the format is
*data with rules*, and apps that treat scan results as trusted strings get owned:
`wifi:` payloads can drop a user onto an attacker's network, URLs can carry
phishing links, and malformed payloads crash naive parsers. Meanwhile raw camera
code tends to entangle permission, preview, capture, and save into one untestable
blob. The fix on both sides is the same: typed data with exhaustive handling, and a
state machine with faked boundaries.

## 5. Core Concepts

### What a QR code actually is

A QR code is a **matrix of modules** (light/dark squares) encoding bytes with
error-correction redundancy. Version 25×25 means type number 6: `moduleCount =
typeNumber * 4 + 17`. Executed:

```
W12 qr: size=25x25 dark=332/625 data="https://example.com/o/7"
```

332 of 625 modules are dark — the pattern is deterministic per (payload, error
correction level, mask), which is why the same URL always encodes identically.
Error correction (`low ~7%` … `high ~30%`) trades density for damage tolerance —
choose by how beat-up the printed code will be, not by habit.

### Scanning = capture → decode → parse, with different owners

| Stage | Owner | Failure you'll see |
|---|---|---|
| Preview stream | platform (camera plugin) | black frame, orientation bugs |
| Frame decode | scanner library (native) | slow/no detection — lighting, size |
| **Payload parse** | **your Dart** | wrong behavior on valid scans |

Most "QR bugs" are the third stage: the scanner *correctly* read a payload your
code assumed was a URL. The parse must be typed and exhaustive:

```dart
sealed class ScanResult { const ScanResult(); }
class WebLink extends ScanResult { const WebLink(this.uri); final Uri uri; }
class WifiNetwork extends ScanResult {
  const WifiNetwork({required this.ssid, required this.auth, this.password});
  final String ssid; final String auth; final String? password;
}
class UnknownPayload extends ScanResult { const UnknownPayload(this.raw); final String raw; }

ScanResult parseScan(String raw) { /* shape-first: scheme, then wifi:, else junk */ }
```

Executed across the three shapes:

```
W12 scan "https://example...." → WebLink host=example.com
W12 scan "wifi:S:CafeNet;T..." → WifiNetwork ssid=CafeNet auth=WPA
W12 scan "just some garbag..." → UnknownPayload
```

The battery earned its keep during authoring: the first run parsed
`ssid=` *empty* because the `wifi:` prefix was never stripped — a shape bug the
executed capture showed instantly. (Your parser's third-round edit is exactly this
class of fix: split on the real field boundaries, not on the string you imagined.)

- **Note the format detail:** the standard is `wifi:S:<ssid>;T:<type>;P:<pass>;;`
  — the `S:` field is part of the payload grammar; a capture that skips it parses
  as empty, which is the drill this battery ran.

### The capture flow as a state machine

```dart
enum CapturePhase { idle, capturing, saved }

class CaptureController extends ChangeNotifier {
  CapturePhase phase = CapturePhase.idle;
  Future<void> snap(Future<void> Function() platformCapture) async {
    phase = CapturePhase.capturing; notifyListeners();
    await platformCapture();          // the real one talks to the camera HAL
    phase = CapturePhase.saved;   notifyListeners();
  }
}
```

Every state is reachable and assertable **without a camera** because the HAL call
is a function the test injects. That's the whole trick for device features: *put
the platform behind a parameter.* The permission side gets the same treatment in
the next lesson's executed gate.

### Permissions, in order of the real flow

1. Check status first — never request blindly.
2. Request **at the moment of need** (after the user taps "scan"), with a
   rationale screen *before* the system dialog when the OS allows pre-prompting.
3. Denied once → re-request is fine; permanently denied → you cannot ask anymore;
   deep-link to settings (executed in W13's battery).
4. No permission → the feature degrades: file picker, manual entry — never a dead
   button.

## 6. How It Works

```mermaid
flowchart LR
    T[Tap "scan"] --> P{permission granted?}
    P -- no --> R[Explain → system dialog<br/>platform channel]
    R --> G{granted?}
    G -- settings-blocked --> D[Degraded flow]
    G -- yes --> C[Preview stream from HAL]
    C --> F[Frame → scanner library<br/>native decode]
    F --> S[ScanResult: typed parse — W12]
    S -- WebLink --> U[Confirm → open]
    S -- WifiNetwork --> W[Join network dialog]
    S -- UnknownPayload --> X[Show raw + report]
    T --> M[Capture path: idle → capturing → saved<br/>HAL behind an injected function]
```

Two independent paths share the permission gate: scan (continuous decode) and
capture (one photo). Both cross the channel boundary; both keep their *logic* in
Dart where W12's tests live.

## 7. Practical Examples

**Example 1 — encode and parse, executed (W12)**

```dart
// flutter test --reporter expanded test/offline_device_test.dart
final code = encodeQr('https://example.com/o/7');   // QrImage(QrCode(...))
var dark = 0;
for (var r = 0; r < code.moduleCount; r++) {
  for (var c = 0; c < code.moduleCount; c++) {
    if (code.isDark(r, c)) dark++;
  }
}
print('W12 qr: size=${code.moduleCount}x${code.moduleCount} dark=$dark/...');

for (final raw in cases) { print('W12 scan ... → ${describe(parseScan(raw))}'); }
```

Full capture in section 5. **How to run:** `flutter test --reporter expanded
test/offline_device_test.dart` — pure Dart, no device.

**Example 2 — the faked capture flow (reference, on the lab's controller)**

```dart
testWidgets('capture walks idle → capturing → saved without a camera', (tester) async {
  final controller = CaptureController();
  final phases = <CapturePhase>[];
  controller.addListener(() => phases.add(controller.phase));

  await controller.snap(() async =>
      Future<void>.delayed(const Duration(milliseconds: 50))); // fake HAL

  print('W12 capture phases: $phases');
  expect(phases, [CapturePhase.capturing, CapturePhase.saved]);
});
```

- **Expected behavior:** two notifications, in order; the real swap is one argument
  — the camera plugin's `takePicture`.
- **Assumptions:** Flutter 3.47.7; the real HAL needs a device (labelled).

## 8. Real-World Applications

Payments (scanning a merchant code), Wi-Fi sharing (`wifi:` payloads — where the
typed parse prevents joining hostile networks), ticketing and check-in, 2FA pairing
URLs, inventory scanning with bulk-mode decode, and photo upload flows where the
capture machine adds compression before save. The state-machine-with-injected-HAL
pattern generalizes to every device feature: barcode, NFC, biometrics, geolocation.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | Prevent it with |
|---|---|---|---|
| Trusting scan text as a URL | It usually is | `launchUrl(scanRaw)` opens javascript: or attacker URLs | Typed parse + confirm-before-open (W12's sealed results) |
| Ignoring the `wifi:` grammar | Prefix never split off | Empty SSID — the battery's own caught bug | Parse the standard's real field structure |
| Requesting permission at launch | Eager = "simple" | Users deny without understanding, feature dead | Request at the moment of need + rationale |
| Untestable camera code | HAL calls inline | Logic only ever runs on a device | Inject the platform function (CaptureController) |
| Assuming decode is instant | Scanner is native and async | UI freezes or shows stale frames | Stream-based preview; gate capture on scanner busy state |
| Forgetting exit path | Happy flow only | Permanently denied = broken screen | Degraded flow always (W13 battery shows the gate) |

## 10. Best Practices

- **Parse every payload with a sealed type** and a compiler-enforced exhaustive
  switch — `UnknownPayload` is a real UI state, not an exception.
- **Confirm before acting on a scan** (open URL, join network) — the camera can be
  pointed at anything, including a code printed on a phishing flyer.
- **Inject every platform call** — the executed phases test is the template.
- **Request permissions in context** with a rationale; handle the permanently-
  denied branch as a first-class screen (executed in W13).
- **Label provenance** — "pure Dart, executed" vs "device, run the exercise" keeps
  your own debugging honest: you know which failures you've actually seen.
  *Stops applying the moment you own a device farm — then everything is executed.*

## 11. Limitations and Trade-Offs

- **Pure-Dart tests can't see the camera** — preview orientation, torch, and
  autofocus bugs only appear on devices; budget real-device passes.
- **Scanner libraries differ by platform** — detection speed and format support
  vary; validate on both OSes before committing to one.
- **QR is a dumb channel** — no authenticity: signing payloads (or server-side
  verification of whatever the code references) is your job, not the format's.
- **Error correction ≠ encryption** — a damaged code still decodes *intact*;
  never treat visual robustness as security.
- **`qr` generates; it doesn't render** — drawing (Painter/CustomPainter) and
  scanning are separate libraries; pick them separately.

## 12. Practical Exercises

### Introductory

1. **Exercise 14.1** — reproduce both W12 groups: the matrix stats line and the
   three parse results. **Completion criteria:** four captures, with the module
   count explained by `typeNumber * 4 + 17`.
2. **Exercise 14.2** — encode the same payload at `low` and `high` error
   correction and compare module counts. **Completion criteria:** two captures and
   one sentence stating which you'd pick for a printed sticker and why.

### Intermediate

3. **Exercise 14.3** — extend `parseScan` with a `mailto:` and a bare-domain case;
   add them to the capture battery. **Completion criteria:** five typed results
   printed, exhaustiveness enforced by the compiler (try leaving a case out of the
   switch and record the error).
4. **Exercise 14.4** — run the `CaptureController` phases test from Example 2, then
   inject a *failing* HAL call and show the state machine staying in `capturing`
   — and decide what your UI must show. **Completion criteria:** both captures plus
   the design decision written down.

### Independent problem-solving

5. **Exercise 14.5** — design a check-in flow: camera permission (including the
   permanently-denied path), scan, payload validation against *your* server's
   format, and a degraded manual-entry path. **Completion criteria:** a state
   diagram covering every gate plus two executed tests (parse validation of a
   well-formed and a tampered payload) — with the device-only steps clearly
   labelled as such.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. The scanner reads `wifi:S:;T:WPA;P:x;;` and your app joins a network. Which
   parse bug produced it, and what in section 5 would have caught it before
   shipping?
2. Why can't the W12 captures prove that scanning *works*? State precisely what
   they do prove, and what only a device can.
3. A teammate requests camera permission at app launch "so it's ready." Name two
   failure modes of that choice from this lesson's flow.

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You have reproduced the QR matrix line and the three typed parse results
- [ ] You can write a sealed `ScanResult` parse with an exhaustive switch from
      memory
- [ ] You can explain the capture state machine and its injected-HAL test
- [ ] You can name which pieces of this lesson are executed here and which require
      a device, and why
- [ ] You can diagnose all six mistakes in section 9 on sight

## 15. Summary

- QR is structured data with grammar — parse it into sealed types; `UnknownPayload`
  is a UI state.
- Executed: `25×25` matrix, `WebLink`/`WifiNetwork`/`UnknownPayload` results —
  pure Dart, runnable anywhere.
- Device features become testable by injecting the platform call; permission gates
  are state machines with a permanently-denied branch.
- Confirm before acting on a scan; the camera reads *anything*.
- Provenance is part of the lesson: label what ran where.

## 16. Next Steps

- Next lesson: [Permissions and Notifications](permissions-and-notifications.md) —
  the gate W13 already walks, plus the Android/iOS differences that break naive
  implementations.
- Practice: [exercise sets](exercises/README.md) for this subject.
- Where it is applied: [Project 06](../20-PROJECT-LABORATORY/README.md) — check-in
  by scan uses this lesson's parse-and-confirm flow.
