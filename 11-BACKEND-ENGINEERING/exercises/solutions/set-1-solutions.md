# Set 1 solutions — Backend fundamentals → `backend-fundamentals.md`

*Executed in the batch's `spring-smoke` lab (Spring Boot 4.1.1, PostgreSQL 18.6) and the
logging runs A/B/C. Blocks marked *reference* are shapes to run in your lab.*

## 1. The request's life, drawn then executed

**Paper first (the drawing):**

```
curl → OS socket → Tomcat listener :8790
     → filter chain (correlation filter assigns rid, logs "req start")
     → DispatcherServlet → ApiExceptionHandler? (no — success path)
     → AuthController  [HTTP layer: parse, validate, status]
     → AuthService     [business layer: bcrypt compare, uniform failure]
     → (login: no repository — the user map)  /  (orders: repository → JPA → PostgreSQL)
     → response 200/401 → access log line "res status=… rid=…"
```

**Executed check** — the same request through the correlation filter, run A:

```
req rid=7f3c-… method=POST path=/auth/login
login rejected user=ade                (WARN, same rid)
res rid=7f3c-… status=401
```

Every line carries the rid — the hop-to-hop mapping is the exercise. The hop you could
not observe: time inside PostgreSQL (the JDBC round trip) — no log line exists between
`HikariPool` checkout and row return; you need SQL-level logging or `pg_stat_statements`
to see it, which is exactly why the N+1 lesson (set 8) turns statement logging on.

## 2. Status-code triage, four outcomes predicted first

Prediction table (written before running):

| Case | Predicted | Executed |
|---|---|---|
| Valid login | 200 | 200 |
| Password fails rules at register | 400 + envelope | 400 `invalid-parameter` |
| Unknown user at login | 401 + envelope | 401 `credentials` |
| Foreign order id | 404 (empty body) | 404, `Content-Length: 0` |

Envelope check: the three 4xx bodies each carried `type`, `status`, `detail` — the
`type` URI differing per family (`validation`/`invalid-parameter`/`credentials`), which is
the client's switch. The 4xx/5xx line: 4xx = the request is wrong and retrying
unchanged is pointless; 5xx = our fault and retrying *may* work — the client's correct
response differs accordingly (fix input vs back off).

## 3. Idempotency you can feel

Four captures: `DELETE /api/orders/7` → `204`; replay → `404` (my contract: delete is
idempotent *in effect* — the resource's terminal state does not change, and the second
call reports it is already absent). `POST /api/orders` twice → `201` + `201` — two
distinct resources, because POST is *not* idempotent and the client must dedup if it
cares (the Idempotency-Key battery in set 3 is the fix).

The sentence: `GET`/`PUT`/`DELETE` replay safety is a design decision because the server
*chooses* what "the same request" means — PUT keyed by the URL (replay converges), DELETE
keyed by absence (replay converges), POST keyed by nothing (replay multiplies). Luck is
when a naive implementation accidentally converges; a decision is when you tested the
second call.

## 4. Independent — library decomposition (reference shape)

Endpoint table (written first):

| Action | Method + path | Success | Errors |
|---|---|---|---|
| Search catalog | `GET /books?title=` | 200 | — |
| Borrow | `POST /books/{id}/loans` | 201 + Location | 404, 409 (on loan) |
| Return | `DELETE /loans/{id}` | 204 | 404 |
| Staff override | same endpoints | — | 403 for members (service-layer gate) |

Implemented `POST /books/{id}/loans`, executed four outcomes: 201 (available), 409
(already on loan — the domain refusal), 404 (no such book), 403 (member attempting an
override route). Deviation from my table: I had written `400` for the already-on-loan
case; executing it, 409 was the honest code — the request *understands* the resource,
it conflicts with its current state. The table changed, not the code.