# Set 4 solutions — Java backend development → `java-backend-development.md`

*Executed with the batch's plain-Java layered probe (`javac Layered.java && java Layered`,
transcript captured to `layered-transcript.txt`) and the `spring-smoke` app.*

## 1. The layered structure, executed

Package tree written first:

```
com.example.smoke
├── web/        OrderController      (HTTP: parse, status codes)
├── service/    OrderService         (rules: stock, ownership, roles)
└── repository/ OrderRepository      (persistence: SQL/JPA only)
```

Probe trace (executed, plain Java — no framework between the layers and the trace):

```
POST /api/orders  → OrderController.handle(...)      [web]
  → OrderService.create(...)                          [service]
     validate qty → check stock (domain rule)
     → OrderRepository.insert(...)                    [repository]
       SQL: insert into orders (...) values (...)
     ← 1 row
  ← created id=9
201 Location: /api/orders/9
```

Each line attributed to its layer as it descends; the response as it ascends. What each
layer may not know: the controller may not know SQL or stock rules (it only maps
exceptions → statuses); the service may not know `HttpServletRequest` or status codes
(the probe's service returns domain exceptions, never ints); the repository may not know
which HTTP call it serves (it returns rows/`Optional`, never a response object).

## 2. Exceptions across layers

Service: `throw new StockConflict("sku SKU-A has 3 in stock, requested 5")`. Edge: one
`@ExceptionHandler` mapping it to the envelope with `409`.

Client capture:

```
HTTP/1.1 409 Conflict
{"type":"https://errors.example.invalid/stock-conflict","status":409,
 "detail":"sku SKU-A has 3 in stock, requested 5"}
```

Server log of the same failure (run A): one WARN line, same correlation id, **no stack
trace** (a domain refusal is expected flow — stack traces are for defects). The rule:
the *service* knows the exception type and the message; the *controller/advice* knows
HTTP statuses. The counterexample executed during authoring: an unhandled
`NullPointerException` escaped to the default handler — the client received a 500 with
the framework's error body and the log filled with a 40-line stack. Fix: catch at the
edge as 500-without-details (or eliminate the defect), log the trace server-side, give
the client the envelope + a correlation id to quote.

## 3. DTOs at the boundary

Before: `GET /users/1` → `{"id":1,"name":"ade","email":"a@x","passwordHash":"$2a$10$…"}`
— the entity serialized raw, hash on the wire (the capture is the lesson's cautionary
example). After: `UserResponse{id,name}` — the same endpoint:

```
{"id":1,"name":"ade"}
```

Why the entity must not be the wire format: (1) the schema becomes an API — every column
rename is a breaking change; (2) lazy associations serialize as proxies or throw at the
edge; (3) anything sensitive on the row is one annotation away from leaking, as above.
The DTO is the *contract*, the entity is the *storage shape*, and they are allowed to
disagree.

## 4. Independent — brief-1 package layout (reference shape)

Concern-placement table:

| Concern | Lives in | Why |
|---|---|---|
| Validation | web (shape) + service (invariants) | parsing is HTTP; business limits are rules |
| AuthN | filter/security config | before any controller runs |
| AuthZ | **service** | survives a second transport (queue, CLI) |
| Persistence | repository | the only layer with SQL |
| Pagination | web (parse) → repository (execute) | the service sees a `PageRequest`, not a page number |
| Logging | correlation filter + layer loggers | rid at the edge, context in each layer |

Riskiest endpoint implemented: the list with pagination + filter + sort end to end. Two
captures: 200 with page metadata, 400 with the envelope when `pageSize=0`. The weakest
placement named: pagination parsing in web is right, but *authorization of the filter's
owner scope* must not be — the service applies `owner = current user` before the
repository query, and the test for that lives in set 10.