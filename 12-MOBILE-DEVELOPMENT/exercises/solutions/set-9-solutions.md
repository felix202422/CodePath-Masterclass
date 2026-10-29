# Set 9 solutions — API integration · Local storage → `api-integration.md` · `local-storage.md`

*Executed in the batch's `scaffold` lab as batteries W9/W9b and W10 (`flutter test`,
Flutter 3.47.7). Blocks marked *reference* are shapes to run in your lab.*

## 1. Against a real local server (executed W9)

```
status=200 items=3
status=404 type=https://…/not-found detail="no such order"
```

The envelope's contract, read from the response itself: `type` is a URI the client can
*switch* on (stable machine key), `detail` is human text (never parsed), and the pair
travels under the HTTP status — the status says *family*, `type` says *which*, `detail`
says *what to show*.

## 2. Two failure modes, typed (executed W9)

```
caught=FormatException "Unexpected character"          ← body wasn't the JSON we expected
caught=TimeoutException "0:00:00.150000"               ← nothing arrived in time
```

Why `catch (e)` alone loses information: both land in one bucket, so retry policy can't
differ — a malformed body will *never* fix itself (don't retry, alert), a timeout may
(transient — retry with backoff). The `on Type` clauses are the branch point for that
decision.

## 3. The UI state walk (executed W9b)

```
loading → error → loading (attempt 2) → items=1
```

The `HttpOverrides` decision documented: the widget-test binding **stubs
`HttpClient`** — every group inherits a fake server, so the real-HTTP group must reset it
in `setUp`:

```dart
setUp(() => HttpOverrides.global = null);   // real sockets for this group only
```

Without it, `status=200 items=3` would be the binding's canned answer — green for the
wrong reason, exactly the trap set 8's drill is about.

## 4. Storage with receipts (executed W10)

```
prefs: theme=dark launches=7 → fresh handle → launches=8 missing-key=null
file store: wrote=2 read=2
corruption: recovered=[] file-repaired=true
```

Read the receipts: a *fresh handle* proves persistence (not in-memory state), `null` on a
missing key is the documented default (not an error), and corruption recovery overwrote
the file rather than crashing — the app rebuilt state from defaults and flagged it.

**Prefs vs file, from the size limit:** `shared_preferences` loads *all* values into memory
on open and is meant for small key-values (a theme flag, a counter, a launch count);
anything you'd stream, append to, or grow past a few hundred KB (notes, images, caches)
belongs in a file — the corruption test is a file-store test for that reason.
