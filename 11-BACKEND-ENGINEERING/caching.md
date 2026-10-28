# Caching

## 1. Learning Objectives

After this lesson you can:

- [ ] Measure a cache honestly with hit/miss counters and timings (executed: miss
      `0.492 s` `source:"db"` `computeMillis:307` → hit `0.014 s`
      `source:"cache"` `computeMillis:0`, stats `{"hits":1,"misses":1}`)
- [ ] Execute the invalidation rule on the write path — `POST /cache/invalidate/{sku}`
      → `evicted:true`, and the next read is a **miss again** (executed C4→C5) — and
      say why decorate-the-value instead of evict is a staleness bug waiting
- [ ] Use HTTP caching as a second, independent layer: emit an `ETag`, answer
      `If-None-Match` with `304` and **zero body bytes** (executed C6/C7)
- [ ] Enumerate the correctness traps — stale reads after writes, cache stampede,
      unbounded growth, caching per-user data in a shared key — and name the fix each
      needs
- [ ] Decide *what* is cacheable for a given endpoint: rate, cost, volatility, and
      who must not share the entry

## 2. Prerequisites

- [Spring Boot](spring-boot.md) — the app whose measured latencies this lesson
  manipulates.
- [Controllers, Services, Repositories](controllers-services-repositories.md) —
  cache reads belong at the service boundary, where the "db" work actually lives.
- [Database Engineering: Indexes](../10-DATABASE-ENGINEERING/indexes.md) — caching is
  the same idea one layer up: pay once, reuse; the measuring discipline transfers.

## 3. Introduction

Caching is the highest-leverage and highest-risk optimization in a backend: the
lab's own numbers (0.492 s → 0.014 s, ~34× on one endpoint) show why teams reach for
it, and every rule in this lesson exists because the same mechanism serves you *wrong
answers* when misused. This lesson runs both layers a real API has — an
application-level cache with counters and an explicit invalidation endpoint, and
HTTP-level `ETag`/`304` caching that lets clients skip transport entirely — and the
captures include the full loop: miss, hit, stats, invalidate, miss again. That last
pair (C4→C5) is the lesson's thesis: **a cache is a correctness bet with an expiry
you choose deliberately**, and the code that can *break* the bet is the code you
write on the write path.

## 4. The Problem It Solves

Some data is read far more often than it changes: prices, config, product pages,
"the list of regions". Without a cache, every read re-executes the expensive path —
the lab's simulated 300 ms database round trip — so an endpoint's cost is paid at
read frequency instead of write frequency. The database lesson's indexes attack the
same gap *inside* the database (13 ms → 0.7 ms); a cache removes the round trip and
the query entirely. But a cache is a **copy of truth at a moment in time**, so it
introduces a new class of defect: the copy outliving the truth. Every cache bug in
production is a variant of "who updates the copy, and when?" — staleness after a
write, a stampede when an entry expires under load, a shared entry serving one user's
data to another, memory growing without bound because nobody sized it. The design
question is therefore never "should I cache" but "**what invalidation story am I
paying for**" — which is why this lesson puts the write path (C4) next to the read
path (C1/C2).

## 5. Core Concepts

### Layer 1 — the application cache, measured

```console
=== C1 GET /cache/price/SKU-A (cold)
status=200 time=0.492003s
{"sku":"SKU-A","cents":5213,"source":"db","computeMillis":307}
=== C2 same GET, warm
status=200 time=0.014773s
{"sku":"SKU-A","cents":5213,"source":"cache","computeMillis":0}
=== C3 /cache/stats
{"hits":1,"misses":1,"cachedEntries":1}
```

Three fields make the measurement trustworthy, and each is deliberate:

- **`source` in the payload** — the response *admits where it came from*; without it
  you're guessing from latency, and latency lies (JIT, GC, network all move).
- **`computeMillis:0` on hits vs `307` on the miss** — the saved work is visible per
  request, not inferred from an average.
- **counters (C3)** — hit rate is the only number that tells you whether the cache is
  load-bearing or decorative; at one call each, 50% is trivial, but the same counter
  at 10k calls tells you if your key design actually matches traffic.

The values match across the boundary (`cents: 5213` both times): a cache serving
*different* data than the source would be a bug the payload comparison catches —
which is why the response shape is the same object with a changed provenance, not a
different "cached view".

### The invalidation loop (the thesis, executed)

```console
=== C4 POST /cache/invalidate/SKU-A
{"sku":"SKU-A","evicted":true,"size":0}
=== C5 GET /cache/price/SKU-A
status=200 time=0.315642s
{"sku":"SKU-A","cents":5213,"source":"db","computeMillis":303}
```

The write path evicts (not re-computes, not decorates), and C5 proves the cache
*believed* the eviction: back to `source:"db"`. Two rules fall out:

- **Evict on write; never "update the cache" as the primary act.** Updating means
  your write path now has two stores to make agree, with no transaction spanning
  both — the exact split-brain scenario. Eviction reduces the write path to one
  instruction (`prices.remove(sku)`) and one truth: the next read rebuilds from
  source. (Cache-aside / *lazy* population — what C5 does naturally.)
- **Invalidate at the same layer that owns the key.** The endpoint exists *in the
  controller that owns the price domain* — a different module invalidating a key it
  assembled by string is the classic "same key, different spelling, no eviction"
  bug; key-building belongs in one private method used by read and invalidate
  alike.

C5's miss also shows what eviction *costs*: the next reader pays the 300 ms again.
That's the correctness/latency trade you're managing — and it's why write-heavy
entries get shorter TTLs or no cache at all rather than cleverer update logic.

### Layer 2 — HTTP caching: the browser does it for free

```console
=== C6 GET /cache/doc
Lab terms: cache correctly or not at all. Rev 3.
Cache-Control: no-transform
ETag: "d61dee47"
=== C7 same GET + If-None-Match: "d61dee47"
status=304 bytes=0
```

`ETag` is the document's identity (here a content hash); `If-None-Match` is the
client asking "is this still current?" — `304 bytes=0` says *yes, use yours* without
re-sending a byte of body. Note this layer's properties are different from layer 1's:

- It saves **bandwidth and server serialization**, not the price lookup — different
  resource, different wins; a good API often wants both.
- The validator protocol is **content-addressed**: correctness doesn't depend on
  invalidation at all — if the content changed, the hash changed, and the client's
  `If-None-Match` misses. The staleness problem *cannot* occur by construction,
  because the client only reuses what the server just confirmed byte-equal.
- `bytes=0` is the measurable part: a proxy, CDN, and browser can all participate
  without knowing your application's semantics.

### The trap list (each one is the fix's justification)

1. **Staleness after write** → C4's eviction, on the write path, same layer as the
   key.
2. **Cache stampede** — 1,000 concurrent misses on an expired key all compute →
   single-flight/lock per key, or jittered TTLs. (Not executed in the lab — named
   honestly as the next failure you'll meet at load.)
3. **Unbounded growth** — `ConcurrentHashMap` never evicts → cap entries or add TTL
   + LRU; the lab's `cachedEntries` counter is the number you'd alarm on.
4. **Shared entry, per-user data** — a key without the user in it serves user A's
   price/user data to user B → *authorization-shaped bug, cache-flavored*: key
   design is an access-control decision (lesson 13's rule, one layer up).
5. **Caching errors** — a `500` or empty result cached as if it were data → negative
   caching only deliberately, with short TTL.

## 6. How It Works

```mermaid
flowchart LR
    subgraph L1 [Layer 1 — application, in-process]
        R["GET /price/{sku}"] --> K{"key in map?"}
        K -->|"hit"| H["serve cache<br/>source=cache, 0 ms<br/>hits++"]
        K -->|"miss"| D["compute (db, 307 ms)<br/>misses++<br/>put(key)"]
        D --> H2["serve db"]
        W["POST /invalidate/{sku}"] -->|remove(key)| K
    end
    subgraph L2 [Layer 2 — HTTP]
        E["GET /doc"] --> ET{"If-None-Match<br/>== ETag?"}
        ET -->|"yes"| N304["304, 0 bytes"]
        ET -->|"no"| B["200 body + ETag"]
    end
    SRC["the source of truth"] -.-> D
```

Read both subgraphs as the same pattern: **compare cheaply first** (map lookup /
header compare), **fall through to expensive only on miss**, and let the *write side*
or the *content hash* decide when the cheap answer stops being true.

## 7. Practical Examples

**Example 1 — the cache service core (executed as quoted above)**

```java
@GetMapping("/price/{sku}")
public synchronized Price price(@PathVariable String sku) {
    Price hit = prices.get(sku);
    if (hit != null) {
        stats.put("hits", stats.get("hits") + 1);
        return new Price(hit.sku(), hit.cents(), "cache", 0);
    }
    stats.put("misses", stats.get("misses") + 1);
    Price fresh = compute(sku);          // Thread.sleep(300) + deterministic hash
    prices.put(sku, fresh);
    return fresh;
}

@PostMapping("/invalidate/{sku}")
public Map<String, Object> invalidate(@PathVariable String sku) {
    boolean removed = prices.remove(sku) != null;
    return Map.of("sku", sku, "evicted", removed, "size", prices.size());
}
```

- `synchronized` keeps the miss-then-put a single flight **for this lab's one JVM** —
  a deliberately narrow stand-in for the stampede fix (see limitations).
- **How to run it:** start the jar; then `curl` in order: price (C1), price again
  (C2), `/cache/stats` (C3), `-X POST /cache/invalidate/SKU-A` (C4), price (C5),
  `/cache/doc` capturing `ETag` (C6), repeat with `-H 'If-None-Match: "..."'` (C7).
- **Expected output:** C1–C7 exactly as quoted (timings vary by machine; `source`
  and counters are deterministic).
- **Assumptions:** in-process map (restart clears it — also true of most dev
  caches); JDK 25; Windows 11 + Git Bash.

**Example 2 — the ETag endpoint**

```java
@GetMapping("/doc")
public ResponseEntity<String> doc(@RequestHeader(value = "If-None-Match", required = false) String ifNoneMatch) {
    String body = docs.get("terms");
    String etag = "\"" + Integer.toHexString(body.hashCode()) + "\"";
    if (etag.equals(ifNoneMatch)) return ResponseEntity.status(304).header("ETag", etag).build();
    return ResponseEntity.ok().header("ETag", etag)
            .header("Cache-Control", "no-transform").body(body);
}
```

- The etag is a **content hash** — the simplest correct validator; strong validators
  (whole-body equality) vs weak (`W/"..."`, semantically equivalent) is the nuance
  to study next, and this lab stays on the strong side deliberately.
- **Expected output:** C6 with a quoted `ETag`, C7 with `304 bytes=0` — re-run it
  after editing `terms` to watch the etag change and the 304 disappear.

## 8. Real-World Applications

Both layers run everywhere: `ETag`/`Cache-Control` on GET responses is what lets
CDNs absorb read traffic (the `no-transform` directive here is the anti-proxy-rewrite
class of policy; real APIs also set `private`/`public`, `max-age`, `stale-while-revalidate`),
and application caches sit in front of every hot read path — with the production
machinery this lab simplifies: Redis/Memcached as the shared store (multi-node, like
the session lesson's shared map), TTLs with jitter to break stampedes, request
coalescing, and cache warming on deploy. The invalidation *endpoint* in the lab is
deliberately explicit; in production the same code runs inside the write path —
`@Transactional`/after-commit eviction, because evicting *before* the transaction
commits re-reads the old row and re-caches it (the commit-ordering variant of
staleness). Per-user keys are the caching form of lesson 13's ownership rule, and
hit-rate counters are what capacity planning and CDN-vs-origin decisions are
actually made from — the same "measure, don't assume" stance the index lesson took
with `explain analyze`.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Stale read after write | eviction missing or in the wrong place | updated value takes seconds/forever to appear | evict in the write path, same layer as the key; test with C4→C5's loop |
| Cache-aside before commit | evicting inside the transaction | old row re-cached on rollback/commit race | evict **after commit** (afterCommit hook) |
| Stampede on expiry | popular key, no coalescing | latency spike at TTL boundaries, N identical queries | single-flight lock per key / jittered TTLs |
| Unbounded maps | `put` with no ceiling | heap creep, `cachedEntries` grows forever | size cap + LRU, or TTL; alarm on the counter you already print |
| Shared key for per-user data | key omits identity | user B sees user A's value | key = (user, resource) — key design is authorization |
| Caching failures/empties | cache-aside around the whole method | outages cached into a brownout | cache only successful, non-empty results; short negative TTL if needed |
| No measurement | trusting the speedup | no counters, no `source` field | the C1–C3 pattern: provenance in payload + hits/misses |
| ETag from a non-deterministic value | timestamp/random etag | 304s never happen or always happen | hash the body (executed) or a version field with real semantics |
| Double caching blindly | HTTP + app cache fighting | surprising staleness at one layer | know each layer's validator: content-hash (L2) vs invalidation (L1) |

## 10. Best Practices

- **Decide per endpoint with four questions**: read/write ratio? compute cost?
  staleness tolerance? shared or per-user? No on any → don't cache; that's a valid
  answer and the cheapest one.
- **Cache-aside with eviction, not update**: read populates, write evicts, source
  stays the only truth (executed loop).
- **Keys are contracts**: one builder function per cached domain, including the
  user/tenant component where data is not public.
- **Measure in the response and in counters**: `source` + timings for debugging,
  hit/miss for decisions — make the cache explain itself (C1–C3).
- **TTL everything**, with jitter; treat entries as estimates you refresh, not truth.
- **Use both layers knowingly**: `ETag`/`Cache-Control` for transport and CDN,
  application cache for expensive computation — different problems, same vocabulary.
- **Test the invalidation like a feature**: your regression test is C4→C5 — write
  then read must show `source:"db"` again.

## 11. Limitations and Trade-Offs

The lab's cache is **one JVM, in-process, unbounded, TTL-less**: it dies on restart
(like the session map — the same statefulness trade), doesn't exist for a second
node, and would grow with distinct SKUs; `synchronized` guards only the single-flight
case it creates, and true stampede control at scale needs distributed coordination
(locks/leases in Redis or request coalescing at the proxy) — named, not executed.
The `ETag` example hashes **whole small bodies**; streaming responses and large
resources need partial validators (range requests, version fields) where
`hashCode`-style etags stop being practical. Invalidation *across processes* is the
hard version of C4: with multiple writers, "evict after commit" becomes a
coordinating problem — pub/sub invalidation messages, versioned keys, or accepting a
bounded staleness window as a *documented* product decision. There's also an
honesty cost to `source` in production payloads: revealing cache provenance to
clients is a debugging luxury you may not ship (log it server-side instead; the lab
keeps it because the lesson's evidence is the payload). Finally, caching **changes
failure modes**: a cold cache after deploy is a thundering herd on your database —
the same mechanism that protects it under load can attack it at exactly the wrong
moment, which is why warmup and rate-shedding belong in the cache's design, not
afterthoughts.

## 12. Practical Exercises

### Introductory

1. **Exercise 17.1** — run C1–C7 verbatim and build the cache's ledger: for each
   call, record `source`, `computeMillis`, wall time, and the counters after. Then
   compute the observed speedup and explain which single field proves C2's data is
   the *same* data as C1's.
   **Completion criteria:** the filled ledger; the speedup arithmetic; `cents:5213`
   cited as the equality evidence.
2. **Exercise 17.2** — the invalidation loop: repeat C1→C5 three times, capturing
   stats each round; the final stats must show misses accumulating exactly with your
   invalidations. Write the rule as one sentence and point at the line of code that
   enforces it.
   **Completion criteria:** three rounds of captures; stats consistent with the
   loop; the sentence plus the `prices.remove(sku)` line.

### Intermediate

3. **Exercise 17.3** — staleness, demonstrated: add `POST /cache/price/{sku}`
   (a price *update* that changes the source's value) **without** touching the cache;
   execute a read → update → read sequence and capture the stale value with
   `source:"cache"`. Then add one eviction line to the update path and re-run until
   the second read shows `source:"db"` with the new value.
   **Completion criteria:** the stale capture (this is the bug the whole lesson
   exists for); the one-line fix diff; the re-run capture; a statement of what a
   *user-visible* version of that staleness would have cost.
4. **Exercise 17.4** — bound the cache: cap entries at 100 with LRU eviction (or add
   a TTL with `System.currentTimeMillis()`), then generate 150 distinct SKUs and
   capture the size staying ≤100 (or entries expiring), with counters still honest.
   **Completion criteria:** the capture showing the ceiling; your eviction code; one
   sentence on choosing the cap from the hit-rate/size trade-off.

### Independent problem-solving

5. **Exercise 17.5** — cache correctness as a test: write an executable test (script
   or `@SpringBootTest`) that asserts the *contract*: (a) two identical reads →
   second reports `cache`, (b) after invalidate → next read reports `db`, (c) an
   update-with-fix never serves the pre-write value, (d) `If-None-Match` yields `304`
   with zero bytes and fails after content change. Run it green, break invalidation
   deliberately, watch (b)/(c) go red, restore.
   **Completion criteria:** four assertions with green output; the red run naming
   which assertions caught the break; the restore diff; your one-paragraph argument
   for which assertion would catch the most regressions in review.

*Solutions: attempt first. They live in `exercises/solutions/` of this subject.*

## 13. Knowledge Check

1. C2's response says `source:"cache"` but `cents` is identical to C1's. Why does
   the lab expose `source` at all — isn't it an implementation detail? … *(It's the
   measurement. Without provenance you infer hits from latency, which is noise-prone
   and unprovable; with it, every response is self-verifying evidence of which path
   ran — and the identical `cents` proves the copy still equals the source. In
   production you'd log it server-side rather than ship it, but the discipline stays.)*
2. Your write path updates both the database and the cached value "to keep them in
   sync." What went wrong, and what's the safer shape? … *(Two stores with no
   transaction spanning them: a crash between them, or a concurrent write, leaves
   them disagreeing — and the cache's whole job is to be *derived*. Safer: evict on
   write (C4) and let the next read rebuild from the single truth; C4→C5 executed
   exactly that, with `evicted:true` then `source:"db"`.)*
3. Which layer saves what: the app cache or the ETag? … *(App cache: the 300 ms
   computation + DB round trip — server CPU and database load (`computeMillis` 307 →
   0). ETag/304: body bytes and serialization — network and CDN bandwidth, which
   `bytes=0` proves. They're orthogonal; a response can use both, and the mistake is
   assuming one substitutes for the other.)*

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] C1–C7 executed with the ledger (provenance, timings, counters) filled
- [ ] The invalidation loop run repeatedly with stats matching
- [ ] One staleness bug produced on purpose and fixed with an eviction line
      (Exercise 17.3) — both captured
- [ ] A bounded cache (Exercise 17.4) or a contract test (Exercise 17.5) running
      green, with a deliberate break seen red
- [ ] For two endpoints of yours: a cache-or-not decision written with the four
      questions answered

## 15. Summary

- Measure the cache like any optimization: provenance in the payload, per-request
  compute time, hit/miss counters — executed 0.492 s → 0.014 s with matching values.
- **Eviction on the write path, population on the read path** — the C4→C5 loop is
  the correctness contract, and "update the cache" is the anti-pattern it replaces.
- The ETag layer is content-addressed: `304` + `bytes=0` with staleness impossible
  by construction — a different layer solving a different problem (bandwidth, not
  compute).
- Know the trap list: staleness, stampede, unbounded growth, shared keys for
  per-user data, cached errors — each has one named fix, and key design is an
  authorization decision.
- TTLs make every entry an estimate; measure, bound, and invalidate deliberately.

## 16. Next Steps

- Next lesson: [Background Jobs](background-jobs.md) — moving slow work off the
  request path, with the same accept-then-observe discipline as the cache's miss.
- Practice: [exercise sets](exercises/README.md) for this subject.
- Where it is applied: [Project 04 — REST API](../20-PROJECT-LABORATORY/project-04-rest-api/README.md)
  — read endpoints graded on ETag behavior and invalidation tests.