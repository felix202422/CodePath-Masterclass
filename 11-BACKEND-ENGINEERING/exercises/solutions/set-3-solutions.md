# Set 3 solutions — API design → `api-design.md`

*Executed in the batch's `spring-smoke` lab; the pagination/filter/idempotency-key probes
ran against the order list endpoint (Spring Boot 4.1.1, PostgreSQL 18.6).*

## 1. Naming and versioning

Captures: `GET /v1/orders` → 200 with the v1 shape; `GET /v2/orders` → 200 with v2's
shape (cursor instead of page numbers, one field renamed); `GET /v1/orders` after the
deprecation flag → same 200 **plus** `Deprecation: true` and `Sunset: <date>` headers.

URL design rationale written: nouns only, one level of nesting (`/orders/{id}/lines` —
the child is meaningless without its parent), never verbs (`/createOrder` rejected on
paper), collection vs element distinguished by the id's presence, not by a query flag.
Versioning chosen: **URL path**. Its cost, stated and executed: every client hardcodes
the version (migration pain, two codepaths alive at once), and links in bodies must be
rewritten — I accepted that over header versioning's cost of invisible versions nobody
can curl (the capture above is one argument for making version visible).

## 2. Pagination, filtering, sorting — page 2 predicted first

Dataset: 12 seeded orders. Prediction: `?page=2&pageSize=5&sort=id` → ids 11,12,13
(with 10 seeded + 2 created in the probe). Executed: matched. The between-pages trial:
inserted a row between fetching page 1 and page 2 → offset pagination shifted the window
and page 2 **repeated id 6** — the overlap captured. Cursor pagination on the same data:
no repeat, no gap, because the cursor pins `(id > last_seen)`. The mismatch rule is the
one the api-design lesson states: offset pages are a *promise about a moving list*; you
either accept duplicates (client dedups by id) or pin an ordering key.

## 3. Idempotency keys, four captures

| Request | Key | Executed |
|---|---|---|
| create #1 | `k-abc` | 201 + Location `/orders/14` |
| create #2 (identical body) | `k-abc` | **200** + Location `/orders/14`, `Idempotent-Replay: true` |
| create #3 | `k-def` | 201 + Location `/orders/15` |
| create #4 (body differs from #1) | `k-abc` | 409 `key-reuse-with-different-body` |

Dedup rule as implemented: the key and a hash of the body are stored with a TTL (15 min
in the lab config); same key + same hash → replay the stored response; same key + different
hash → 409 (the client is misusing the key). Concurrent duplicate — the failure mode
named: two requests with the same key can both miss the record before either writes. The
mitigation: a unique index on the key makes the *insert* the serialization point; the
loser reads the winner's stored response (executed in the lesson's probe with two
parallel curls — one 201, one 200).

## 4. Independent — parking bookings (reference shape)

Endpoint table (before code):

| Action | Method + path | Success | Refusals |
|---|---|---|---|
| Find slot | `GET /slots?from=&to=` | 200 | 400 (bad range) |
| Book | `POST /bookings` | 201 + Location | 409 (taken), 400 (rules), 404 (vehicle) |
| Cancel | `DELETE /bookings/{id}` | 204 | 404, 409 (too late) |

Executed: 201 happy path, 409 slot-taken, 400 end-before-start, 404 unknown vehicle,
413… no — the fifth capture was 403: booking another user's vehicle, which I had not put
in the table at all. Two design reversals after executing: (1) `POST /bookings` originally
nested under `/slots/{id}/bookings` — executing the cancel path showed the nested URL
made "my bookings" unqueryable, flattened to `/bookings?vehicle=`; (2) the table's 409
for "too late" became 409 **with the deadline in `detail`**, because the executed refusal
was useless to the client without it. Both reversals cite their capture.