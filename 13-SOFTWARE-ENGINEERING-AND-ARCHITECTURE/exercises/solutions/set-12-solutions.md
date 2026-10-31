# Set 12 solutions — Microservices · Scalability and reliability · Technical debt → `microservices.md` · `scalability-and-reliability.md` · `technical-debt.md`

*Executed in the batch's `micro-probes.sh`, `scale-probes.sh`, and `debt-probes.sh`
batteries (Java 25, Windows 11). Blocks marked *reference* are shapes to run in your lab.*

## 1. The saga, both ways

Executed:

```
no saga:    order=true payment=false stock=true -> money lost? no; goods held? yes; order visible? yes -> inconsistent
ok   saga-clean after compensation: order=false payment=false stock=false -> consistent, just failed
```

First tuple: payment failed mid-flow with no compensation — three services each locally
valid, globally wrong (stock reserved, order visible, no money). Second: the compensating
actions ran and every flag returned to `false` — **consistent, just failed**, which is
the saga's promise: not that nothing fails, but that failure leaves no lie behind.

Compensation's own failure mode, named: the compensating message is *itself* a message —
it can be lost, delayed, or fail (what if refunding payment fails?). Mechanisms you would
give it: **retry with bounded backoff** for transient faults, a **dead-letter queue** for
poison compensations, and an **alert + reconciliation** for anything sitting in the DLQ
past a threshold — because a stuck compensation is exactly the inconsistent tuple you
built the saga to prevent, just wearing a different hat.

## 2. The hop tax

Executed — three independent 50 ms calls:

```
ok   parallel-faster sequential=151ms parallel=62ms (3 x 50ms calls)
```

Budget arithmetic for five hops under 300 ms: serial 5 × 50 = 250 ms leaves 50 ms for
your own work — one slow hop (a 120 ms dependency) and you're over. With max parallelism
among independent hops, wall clock ≈ slowest hop (50 ms) + your work — but state what
stays serial: **dependencies of dependencies** (you can't fetch the user before the
session resolves, and the payment before the cart total), and anything sharing one
connection pool queue. The lesson's rule: parallelism exists only between *independent*
hops; find them by asking "could this call start if that one hadn't returned?"

## 3. The contract experiment

Executed — shared type renamed (`total` → `grandTotal`), consumer untouched:

```
P3a: shared contract, rename in producer ->
InvoiceService.java:1: error: cannot find symbol
// → error: cannot find symbol  variable total
P3c: consumer-owned contract -> the producer's rename compiles clean, consumer redeploy count = 0
```

Three compile outcomes to capture: P3a — the producer compiles, the *consumer* fails
from its own untouched source (that's the coupling: your rename breaks a build you don't
own); P3b — copying the contract into the consumer (consumer-owned variant, e.g.
`class ConsumerOrder { String id; double total; } // consumer-owned copy of v1`)
compiles clean after the producer's rename; P3c — `consumer redeploy count = 0`, because
the consumer keeps its v1 copy until it *chooses* to move. Migration policy for the
versioned copy: old versions stay served for a stated deprecation window; consumers pin
a version and upgrade on their own schedule; the producer may add fields but never
rename/remove within a served version — which is the rule that turns a coordinated
deploy (the release train microservices were supposed to escape) into an independent one.

## 4. A cache sized honestly

Executed — hot-set workload, then uniform, same LRU(50):

```
no cache:  avg latency = 500.0ms (10000 requests x 50ms)
LRU(50):   hits = 5650/10000 -> hit ratio = 56.5%, avg latency = 223.2ms
uniform workload on the same LRU(50): hit ratio = 5.2%
```

Both ratios are meaningless without the workload statement: 56.5% came from a workload
whose keys had locality (a hot set smaller than 50), and the *identical* cache on a
uniform random workload delivered 5.2% — same hardware, near-useless cache. Provision
size from evidence: your measured key distribution (the hot set size), not a guess —
the lesson's 50-entry LRU covers its hot set; on real traffic you'd measure the working
set first. **Labelled reference:** production sizing from real traffic is the part the
authoring machine can't execute — in your environment, capture hit ratio per size (an
eviction/size sweep) and the tail-latency delta, not just the mean.

## 5. Retry with backoff

Executed — 30 clients × 4 attempts = 120 attempts, server recovers at t=500 ms:

```
naive:    120 requests, all retries sent before t=300ms -> every retry lands while the server is down (recovers at t=500ms)
backoff:  120 requests, 90 arrived during the outage, later attempts spread past recovery
ok   backoff-spreads same 120 attempts, but only 90 land during the outage vs 120 for immediate retries
ok   recovery-reached backoff attempts continue after recovery; the retry budget outlasts the outage
```

`120 → 90`: 30 attempts escaped the outage — those are the ones that can succeed —
because jittered exponential delays pushed them past t=500 ms. Your policy as four
numbers: **attempts** 3 per logical request, **delays** 100 ms base × 2ⁿ exponential,
**jitter** full jitter (`random(0, base·2ⁿ)`), **deadline cap** 10 s total — never retry
past the client's own deadline, and don't retry non-idempotent operations without an
idempotency key (set 11's lesson).

**Labelled reference:** the on-call/observability half (alert thresholds, dashboards)
can't be executed without a production system; capture in yours: retry-rate metric,
error-budget burn alert, and a DLQ depth panel — the lesson's sections name each.

## 6. Independent — the debt register

Executed shapes:

```
messy: lines=17 decisionPoints=10 duplicatedTaxLadders=2
clean: lines=10 decisionPoints=2 duplicatedTaxLadders=1
messy: tax(100) = 8.0 with 0 tests running -> bug escaped
clean suite: RED   tax(100) = 8.0 want 7.0 -> caught by the test the refactor wrote
repay-now=160.0, repay-at-6=192.1, never=542.1
```

Three captures, in order. (a) The counts: `duplicatedTaxLadders=2` is the meaningful
number — the tax rule exists in two places, so the next tax change edits both or diverges
both; `decisionPoints 10 → 2` prices comprehension. (b) The injected-bug demonstration:
plant the same tax bug in each version and see which suite turns RED — messy escaped
(with zero tests, nothing can catch), clean turned RED *before* the fix, because a test
already named the expected value. (c) The repayment curve: repay now costs 160.0
(feature-cost units), waiting until release 6 costs 192.1, never costs 542.1 — run it
with **your** growth assumption (the curve's slope is assumed, the direction is not) and
say so.

Register entry: *trigger change* — "any change to the tax rules" (because the ladder is
duplicated), *estimate* — 160.0 feature-cost units (measured from the curve), *honest
ledger* — measured: lines/decision points/duplicate counts, bug-catch outcomes, curve
totals; assumed: growth rate feeding the curve and the feature-cost unit itself.