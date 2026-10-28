# Set 11 solutions — File uploads · Caching · Background jobs → `file-uploads.md` · `caching.md` · `background-jobs.md`

*Executed in the batch's `spring-smoke` lab: the upload gate battery, the cache
provenance probe, and the job lifecycle battery.*

## 1. Upload gate battery, four predictions first

| Case | Predicted | Executed |
|---|---|---|
| Valid `report.pdf` | 201 | 201, `{"stored":"9f2c…-report.pdf"}` |
| `evil.exe` | 400 | 400 envelope `…/invalid-parameter` |
| `.jpg` file, `Content-Type: text/html` | 415 | 415 `…/unsupported-media-type` |
| 12 MB body (limit 10 MB) | 413 | 413 `…/too-large` |

Stored name quoted from disk: `9f2c4a1e-77b0-4c31-9d3e-report.pdf` — the client's name
kept only as a suffix for humans, the identity coming from a server UUID. Why extension
*and* content-type: extension checking alone accepts `evil.jpg` that is really HTML
(what your lesson's XSS-via-upload shows), and content-type alone accepts a `.exe`
labelled `application/pdf` — the first catches the *name*, the second the *declared
intent*, and the honest implementations check both plus sniff bytes when the file will
ever be served back to a browser.

## 2. Cache provenance, three captures

```
GET /cache/price/TEST-A   → {"sku":"TEST-A","cents":4200,"source":"db"}
GET /cache/price/TEST-A   → {"sku":"TEST-A","cents":4200,"source":"cache"}
PUT /cache/price/TEST-A {cents:4500} → 200
GET /cache/price/TEST-A   → {"sku":"TEST-A","cents":4500,"source":"db"}
```

Invalidation-on-write policy in one line: *the writer evicts after the database commit
returns*, so a reader can only ever fetch the old value from cache in the window before
the eviction, never after a committed new value exists. The concurrency argument, stated
honestly: a read that starts before the write may serve `4200` from cache while `4500`
is already committed (a bounded staleness window); what cannot happen under this order
is the reverse — evict-then-commit would let a concurrent reader repopulate cache with
the *old* value *after* eviction and never converge. If your price feed cannot tolerate
the window, the mitigation is version-keyed entries (key includes the row version) —
then the stale entry is simply never read again, though it lingers until TTL.

## 3. Job lifecycle, four captures

```
POST /jobs {"kind":"echo","key":"nightly-1"}  → 202
  {"id":"…","status":"QUEUED","duplicate":false}, Location: /jobs/…
GET  /jobs/…                                   → 200 {"status":"SUCCEEDED"}
POST /jobs {"kind":"echo","key":"nightly-1"}   → 200 (replay)  "duplicate":true
forced failure (poison payload)                → status FAILED → retry 1 → SUCCEEDED
```

Retry policy written: 3 attempts, exponential backoff (2 s, 4 s + jitter), then `FAILED`
terminal with the last error in the record — a job that exhausts retries is *visible*,
not silently dropped. Why idempotency despite dedup: dedup covers the *submission* key;
it cannot cover a retry that happens after a worker crash post-write — the job body must
itself be safe to run twice (the echo job's target system tolerates duplicates by
design; your nightlies should key writes the way set 3's idempotency keys do).

## 4. Independent — one operation behind `202` (reference shape)

The slow operation: a report builder. Synchronous control kept as a test (same inputs →
same report bytes). Contract captures: `POST /reports` → `202` + `Location`; poll →
`RUNNING` → `SUCCEEDED` with a download link; poisoned input → `FAILED` with
`{"error":"unparseable row 12"}` surfaced to the client (not a bare 500); a fourth
capture: status poll after the job succeeded returns the same terminal record (status
endpoint is a read, not a replay of the work). Error contract written: failed jobs are
*data* — status, attempts, last error — because the client's correct response (show the
error, offer retry) needs more than an HTTP code can carry on a poll.
