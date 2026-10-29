# Set 10 solutions — Secure storage · Camera and QR codes → `secure-storage.md` · `camera-and-qr-codes.md`

*Executed in the batch's `scaffold` lab as batteries W11 and W12 (`flutter test`,
`qr 4.0.0`). Platform vault steps are **labelled reference** — the authoring machine is a
Windows box with no device; the lessons say so and so does every capture below.*

## 1. The redline — prove what's on disk (executed W11)

```
contains-token=true bytes=27          ← plaintext file literally holds the token
log: {"token":"***"}                  ← same value, redacted at the log boundary
```

Threat ruled out: **casual file read** — anyone who opens the file or greps the log sees
`***`, not the bearer credential. Threat *not* ruled out: a rooted/jailbroken device
running code **as your process**, which can call the same API you do — that is the vault's
job (next exercise), and no app-side encoding fixes it.

## 2. Platform vaults, on a device (labelled reference)

Shape to execute on hardware — the abstraction that keeps platform code out of the app:

```dart
abstract class SecretStore { Future<void> put(String k, String v);
  Future<String?> get(String k); Future<void> delete(String k); }
// impls: KeychainStore (iOS) / KeystoreStore (Android) / prefs for dev fallback
```

Your capture: `put` → kill app → relaunch → `get` returns the same secret, on a device,
with the platform channel used *only* inside the impl. Completion = that round-trip
capture; the lessons honestly marked this **not executed** (no device on the machine), so
*your* transcript is the first one in the record.

## 3. QR encode, typed (executed W12)

```
matrix size=25x25 dark=332/625
WebLink host=example.com          ← 'https://…' payload, parsed by prefix + URI
WifiNetwork ssid=CafeNet auth=WPA ← typed from the WIFI: scheme
UnknownPayload                    ← the malformed / unknown-prefix payload
```

The capture that earned its keep: a payload crafted to *start with* a Wi-Fi-looking prefix
but parse wrong landed in `UnknownPayload` — the typed discriminator routes by **parsed
structure**, not string prefix, and the battery caught the prefix-only bug before the
lesson text did.

## 4. Independent — scan → typed action pipeline (reference shape)

```
scan(raw) → discriminate → { WebLink → open URL (allow-listed hosts)
                             WifiNetwork → join sheet
                             UnknownPayload → non-blocking notice + no-op }
rate limit: max 10 accepted scans / 10s per session, then debounce the camera feed
```

Completed when: the three branches exist behind one typed seam (the set-10 exercise's
discriminator reused), and the unknown-policy test asserts the *user-visible* behavior —
one notice, navigation unchanged, no exception — because "what the user sees on garbage
input" is the actual requirement, not the absence of a crash.
