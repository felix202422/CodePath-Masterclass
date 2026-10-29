# Set 4 solutions — Asynchronous Dart → `asynchronous-dart.md`

*Executed as the batch's d5/d5b probes (`dart run`, Dart 3.12). Blocks marked *reference*
are shapes to run in your lab.*

## 1. Ordering, predicted then executed (executed)

**Prediction written first:** `1 sync → 2 microtask → 3 timer`, then `1b` after the await.
Executed capture (`d5.txt`):

```
1 sync
2 microtask
3 timer (event)
1b after first await
```

Each line's queue, named: `1 sync` — the current turn runs to its first suspension;
`2 microtask` — microtasks drain *before* the event loop picks the next event; `3 timer` —
the event (macrotask) queue waits until microtasks are empty; `1b` — the await resumes via
a microtask once its future completes. The await's position matters: `scheduleMicrotask`
before or after the timer both land before it.

## 2. Sequential vs parallel, measured (executed)

Predicted: parallel ≈ half of sequential. Executed (three runs, pattern stable):

```
2 sequential=188ms parallel=96ms results=[orders, lines]
```

Why it isn't exactly half: two timers' setup overlap plus event-loop scheduling jitter —
but the signal is unambiguous (≈2×), and the prediction being *ratios*, not exact
milliseconds, is what makes it survive your machine's noise.

## 3. Errors and streams (executed)

Typed catch at the await:

```
3 caught: boom took longer than 10ms
```

— the throw happened inside `fetch('boom', …)`, the `on TimeoutException` clause matched
by type, and `catch (e)` alone would have hidden *which* failure it was.

Single-subscription stream, second listener (executed `d5b.txt`):

```
Unhandled exception: Bad state: Stream has already been listened to.
#3      main (…d5b_single_subscription.dart:8:14)
```

Fix: `StreamController<int>.broadcast()` — then the same program prints for both listeners
(reference: `4A listener saw 1 / 4B listener saw 1` interleaved).

## 4. Independent — two tasks, one main isolate (executed shape)

```
5 main isolate alive while workers run
5 one-run=97ms two-isolates=129ms checksum=1701830==1701830
```

Defensible reading of *my* numbers: if two `Isolate.run` calls took ~2× the single run,
they overlapped — but here **129 ms for two runs vs 97 ms for one is not 2×**, so the
workers genuinely ran concurrently (spawn + message overhead accounts for the gap above
97). The checksum equality proves both workers did identical work — concurrency without
a correctness claim is untested. The alternate choice, plain `await`s, would be right only
if the work were I/O-bound; CPU loops in the main isolate would have serialized *and*
frozen UI frames, which is the one-line defense for `Isolate.run` here.
