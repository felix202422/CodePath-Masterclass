# Set 2 solutions — HTTP and REST APIs → `http-and-rest-apis.md`

*Executed in the batch's `spring-smoke` lab; the method battery ran against `/api/orders`
and `/cache/price/{sku}` (Spring Boot 4.1.1).*

## 1. Method semantics battery, predicted first

Prediction table (paper first), then `curl -i` for each:

| Method | Predicted | Executed |
|---|---|---|
| `GET /api/orders/1` | 200 + body | 200 |
| `POST /api/orders` (valid) | 201 + Location | 201, `Location: /api/orders/9` |
| `PUT /api/orders/9` (full body) | 200, replay also 200 | 200, 200 |
| `DELETE /api/orders/9` | 204, replay 404 | 204, 404 |
| `HEAD /cache/price/X` | 200, headers, **no body** | 200, `Content-Type` present, 0 bytes |

Idempotency classification from the captures: GET safe; PUT idempotent (replay converges
— second call reproduced the same representation); DELETE idempotent in effect (terminal
state unchanged); POST neither (each call created a new id); HEAD safe (defined as GET
without the body).

## 2. `204` and the empty body

Capture: `HTTP/1.1 204 No Content` with **no** `Content-Type` and zero body bytes — the
replay with query noise gave the identical zero bytes. Contrast capture: `200` with
`{}` is a body (2 bytes) that a JSON parser must be invoked for. The difference for a
client: `204` guarantees "nothing to parse, your local state change is the whole
response"; `200 {}` forces a parse path and invites `body.field` access that throws on
some future change. `204` is the server saying *the representation is gone, not empty*.

## 3. Stateless proof

Same request with the session/token header → 200; with the header stripped → 401. The
server remembers nothing from call to call: what exists is a server-side session row (or
a verifiable token) **keyed by the credential**, plus nothing else — no conversational
state on the connection, no "logged in" flag tied to the TCP peer. Restarting the server
with sessions in the database keeps auth working; restarting with sessions in memory
logs everyone out — both are stateless *connections*, the state was always in a store
you chose.

## 4. Independent — five predictions against a public API (reference shape)

Predictions → captures → attribution, in the shape the set demands:

1. `GET` → 200 `application/json` — matched.
2. Page 2 of a list → same items as page 1 — **mismatch**: the API silently re-sorted;
   attributed to my assumption of server-side ordering, fixed by requesting `sort=id`.
3. A 404 on a bad id → JSON error body — **mismatch**: HTML error page (a proxy, not the
   API; the `Server` header named it).
4. A header `X-RateLimit-Remaining` — present, decreasing per call.
5. Pagination shape `next` URL — actual: opaque `cursor` string — matches "cursor, not
   offset" once you stop predicting your own design.

Lesson line: "REST" let all of this differ without breaking me because I depended on
status semantics and hypermedia-ish pointers, not on the server's private data shape.