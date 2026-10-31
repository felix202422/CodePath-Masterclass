# Set 11 solutions — Event-driven architecture · Distributed systems → `event-driven-architecture.md` · `distributed-systems.md`

*Executed in the batch's `evt-probes.sh` and `dist-probes.sh` batteries (Java 25,
Windows 11). Blocks marked *reference* are shapes to run in your lab.*

## 1. Fan-out proven by hash

Executed:

```
--- P1 producer does not know its consumers (fan-out decoupling)
third subscriber added without touching the producer
```

Rebuild: hash the producer source, register two subscribers, capture hash; add a third,
re-hash, compare — `sha256sum` of both runs identical. The third subscriber's output line
proves it actually received the event (hash equality alone can mean "no change was
attempted" — the lesson pairs a structural claim with a behavioral one every time).

## 2. The naive consumer vs the guarded one

Same five-event stream (two duplicates, one reordered) through both:

```
naive: wrong balance by 60.0
final: balance=130.0 duplicates rejected=2 out-of-order rejected=1
```

Attribute each fix, line by line: **`duplicates rejected=2`** — the seen-set keyed by
event id (`if (!seen.add(id)) { duplicates++; return; }`), the idempotency key; without
it the two replayed credits double-counted, which is the `wrong balance by 60.0`.
**`out-of-order rejected=1`** — the sequence guard (drop or buffer an event whose seq
precedes the last applied); without it an old snapshot overwrote a newer balance.
Expected correct total `130.0`: rebuild the five events, sum the true unique deltas on
paper first, then confirm both guards' final balance against your number — a final
balance you didn't predict proves nothing.

## 3. Timeout ambiguity → idempotency key

Executed:

```
caller gave up after 100ms while the server was still working
server executed 'charge' 2 times for 1 logical request
```

then with the idempotency key: one applied effect, the retry answered from the recorded
result. Rebuild: handler sleeps past the caller's timeout, caller retries, count
executions — `2 times for 1 logical request` is the ambiguity (the retry is not a lie;
the first request really was still running). Add `key = (orderId, operation)` and a
recorded-result map: second call with the same key returns the first call's outcome.
**What survives a restart:** state the storage honestly — an in-process map dies with
the JVM, so production needs the key table in the database (unique constraint) or a
durable store; the exercise's contract line must name which one you chose.

## 4. The partition pair

Executed:

```
side AB has 2/3 votes -> write accepted
side C has 1/3 votes -> write rejected with unavailable
```

Story A (last-writer-wins): the acknowledged write on the minority side is overwritten
by the later write from the majority — an acknowledged `true` becomes `false`, silently.
Story B (quorum): the same partition has side C *refuse* the write with `unavailable` —
nothing acknowledged is ever lost. Which side of CAP each sacrifices: LWW sacrifices
**consistency** (availability won; the client got an ack that didn't stick); quorum
sacrifices **availability** (consistency won; the client got an error it can retry after
the partition heals). Rebuild both: a 3-node simulated map, force the split, run one
write on side C, print both outcomes.

## 5. Independent — the contract for a real flow (reference shape)

```
key format:     (order_id, event_type) — globally unique, client-generated
dedup window:   24 h (survives at least one deploy + replay window)
out-of-order:   buffer events with seq > last+1 up to 10s; reject seq ≤ last-applied
reconciliation: hourly job re-checks every acked order's applied-seq vs source-of-truth
```

Executed simulation: one duplicate (rejected, balance unchanged), one reordered event
(buffered, applied after its predecessor), one handler crash between apply and ack
(restart replays; idempotency key makes the replay a no-op — final state identical).
The reconciliation query's inputs: order id, expected seq set, applied seq set, last
reconcile timestamp — anything whose applied set has a gap gets re-fetched. Label what
is measured (the transcript) vs assumed (your window and buffer limits — they come from
your traffic, and the exercise accepts an assumption only when it says "assumption".