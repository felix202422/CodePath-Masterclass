# HTTP and REST APIs

## 1. Learning Objectives

After this lesson you can:

- [ ] Model a domain as resources with noun-shaped URIs and say what each URI *is*, not
      what it does
- [ ] Classify every method — safe, idempotent, cacheable — and **prove** the claims by
      executing repeats (executed: `PUT` twice produced byte-identical responses and a
      `GET` before/after the repeat diffed **IDENTICAL**; `DELETE` then `DELETE` →
      `204` then `404`)
- [ ] Produce the resource-lifecycle status contract from one handler set (executed:
      `201 Created` + `Location`, `200 OK`, `204 No Content` with zero body bytes,
      `404`, `405` + `Allow`)
- [ ] Explain a representation as a *view of* the resource, and demonstrate the seam
      honestly (executed: `Accept: application/xml` answered with JSON — the probe
      ignores negotiation, and the lesson says so instead of pretending)
- [ ] Use `HEAD` correctly — same status and headers as `GET`, no body — and capture
      both sides (executed: `Content-length: 15` advertised, `0 body bytes`)
- [ ] Argue when REST is the wrong shape (RPC, GraphQL) using the uniform-interface
      trade rather than fashion

## 2. Prerequisites

- [Backend Fundamentals](backend-fundamentals.md) — the accept/parse/route/handle/respond
  loop this lesson's server already runs; all probes reuse it.
- [Internet & Web Foundations](../06-INTERNET-AND-WEB-FOUNDATIONS/README.md) — HTTP
  methods, status codes, and headers as protocol-level facts.
- [Database Engineering](../10-DATABASE-ENGINEERING/README.md) — helpful: the resources
  here live in memory, and the lesson is honest that a real API's representations come
  from rows.

## 3. Introduction

**REST** (Representational State Transfer) is not "JSON over HTTP with pretty URLs" —
it is a set of *constraints* (Fielding's thesis, 2000): identify everything with one
URI, manipulate it only through a small uniform set of methods, carry state in the
representation rather than in the connection, and let every message be self-describing.
The payoff is unglamorous and enormous: intermediaries (caches, proxies, monitors) can
reason about your traffic *without understanding it*, retries are decidable in advance,
and clients depend on four verbs instead of fifty endpoint names.

This lesson executes those claims on the same framework-free server as the last one —
eleven requests, one transcript, every method claim tested by **doing the repeat**.

## 4. The Problem It Solves

The pre-REST habit was RPC-style HTTP: `POST /getUser`, `POST /deleteOrder`,
`POST /updateOrderStatus` — one URL per verb, everything a `POST`, the protocol reduced
to a transport for function calls. It works until the costs land: caches can't tell a
read from a write (so nothing is cacheable), every retry is a coin flip (is
`deleteOrder` safe to send twice?), the URL vocabulary grows without bound (each client
app wires to different verbs), and monitoring can only ever say "POST happened."

SOAP attempted the same shape with envelopes; the web itself had already solved the
problem — it is made of documents and links, addressed by URI, fetched with methods
whose semantics everyone already agrees on. REST's move was to *stop fighting the
protocol*: use what GET/PUT/DELETE already promise instead of renaming everything to
`doSomething`.

## 5. Core Concepts

### Resource and naming

A **resource** is any named thing the client addresses: `"/orders/1"` is an order;
`"/orders"` is the collection. URIs carry **nouns**, methods carry **verbs** — the
sentence "PUT /orders/1" already reads as "replace order 1." A path like
`/orders/1/cancel` is a *state transition* some APIs legitimately need (it is not a
verb-noun violation so much as an operation resource); what has no place is
`/getOrder?id=1`, where the verb duplicates the method you used to fetch it.

### Representation ≠ resource

The **resource** is the server-side truth; the **representation** is the JSON document
(plus `Content-type`, `Content-length`, later `ETag`) sent to you. Same resource, many
representations: a summary view, an XML form, a filtered projection. The executed seam:
this probe answers `Accept: application/xml` with **JSON anyway (B8)** — it has one
representation and no negotiation. Saying that plainly is the lesson; a client that
believes you negotiated XML because it *asked* would be broken, and the fix is either to
implement negotiation or to document "JSON only."

### The method matrix (the claims this lesson executes)

| Method | Safe (no server effect) | Idempotent (repeat = first) | Cacheable |
|---|---|---|---|
| `GET`, `HEAD` | yes | yes | yes |
| `PUT` | no | **yes** (full replace) | only on success-ish |
| `DELETE` | no | **yes in effect** (state converges; repeat answers `404`) | no |
| `POST` | no | no (new resource per call) | rarely |
| `PATCH` | no | not defined | no |

**Idempotent ≠ same response, same effect.** Executed nuance: the first `DELETE`
answers `204`, the repeat answers `404` — *different responses, converged state*. A
retrying client must treat `404` after its own `DELETE` as success, not as a new failure.
`PUT` is the stronger one: same request in, same response out (B4 and B6 return the same
`200` body; B5 and B7 diff **IDENTICAL**).

### Status contract for the lifecycle

`201 Created` + `Location` (where it now lives) → `200 OK` (representation) → `204 No
Content` (accepted deletion, **no body** — the log records `0 bytes`) → `404` (gone) →
`405` + `Allow` (wrong verb on a real resource). `400` for malformed input stays from
the previous lesson. These six are the vocabulary; `api-design.md` adds pagination,
conflict codes, and rate limits on top.

### Statelessness, uniform interface, HATEOAS

**Statelessness** (carried from BACK-02): every request carries everything needed —
the server keeps no per-connection memory. The **uniform interface** is the constraint
that buys interop: four verbs, self-describing messages, hypermedia links. **HATEOAS**
(hypermedia as the engine of application state) means responses *link* to what's next;
this probe implements the humblest slice — `Location` on create (B2) — and nothing more.
Most production APIs sit at that level too; the honest move is to say so and document
the contract, rather than to claim hypermedia you don't send.

### Content negotiation

`Accept` asks, `Content-Type` answers — the pair that lets one URI serve many formats.
The probe's answer to B8 proves why undocumented "I ignore Accept" is a contract bug:
the request said XML, the response was JSON, and nothing in between told the client.

## 6. How It Works

```mermaid
flowchart LR
    P["POST /orders"] -->|"201 + Location: /orders/1"| G["GET /orders/1"]
    G -->|"200 representation"| U["PUT /orders/1"]
    U -->|"200 (repeat = same, idempotent)"| U2["PUT /orders/1 again"]
    U2 -->|"state identical: B5 ≡ B7"| D["DELETE /orders/1"]
    D -->|"204, 0 bytes"| G2["GET /orders/1"]
    G2 -->|"404 not_found"| D2["DELETE /orders/1 again"]
    D2 -->|"404 — state already converged"| END["done"]
```

Read the arrows as a retry policy: everything up to `PUT` may be repeated safely;
`DELETE` may be repeated *effectively* (the second answers `404`, which a client that
just sent `DELETE` treats as converged); only `POST`'s create cannot be blindly repeated
— that is why it is the one method needing an idempotency key (a topic `api-design.md`
takes up).

## 7. Practical Examples

**Example 1 — the resource lifecycle, executed**

```console
=== B2 POST /orders (create)
HTTP/1.1 201 Created
Location: /orders/1

{"id":1,"item":"KBD-001","qty":2}

=== B4 PUT /orders/1 (replace, first)
HTTP/1.1 200 OK

{"id":1,"item":"MON-271","qty":1}

=== B6 PUT /orders/1 (same body again - idempotent repeat)
HTTP/1.1 200 OK

{"id":1,"item":"MON-271","qty":1}

=== B10 DELETE /orders/1 (first delete)
HTTP/1.1 204 No Content

   ← (no body)
=== B11 GET /orders/1 (gone)
HTTP/1.1 404 Not Found

{"error":"not_found","path":"/orders/1"}
=== B12 DELETE /orders/1 (repeat delete)
HTTP/1.1 404 Not Found
```

**The idempotency check, executed as a diff:** `diff` of B5's response against B7's
(after B6's repeat PUT) → **IDENTICAL** (zero differing bytes). Server side, the log
agrees:

```console
SEND 200 /orders/1 -> 33 bytes     ← B5
SEND 200 /orders/1 -> 33 bytes     ← B6 (the repeat PUT)
SEND 200 /orders/1 -> 33 bytes     ← B7 (state proof)
SEND 204 /orders/1 -> 0 bytes (no body)   ← B10
```

- Predict before you run: `201, 200, 200, 200, 405, 204, 404, 404` — eight codes,
  written down first; a miss means you didn't understand the routing *or* the method.
- **How to run it:** start the probe (`javac Probe.java && java -cp . Probe`), then the
  eleven `curl -si` requests of `transcript2.txt` in order.
- **Assumptions:** Java 25.0.4.1, curl 8.22.0, Windows 11 + Git Bash, loopback only,
  in-memory store (durability is deliberately another lesson).

**Example 2 — HEAD, wrong verbs, and the negotiation seam (executed)**

```console
=== B1 HEAD /health (headers only, no body)
HTTP/1.1 200 OK
Content-type: application/json
Content-length: 15
   ← (no body)

=== B9 PATCH /orders/1 (verb the resource does not support)
HTTP/1.1 405 Method Not Allowed
Allow: GET, PUT, DELETE

{"error":"method_not_allowed","allow":"GET, PUT, DELETE"}

=== B8 GET with Accept: application/xml (representation seam)
HTTP/1.1 200 OK
Content-type: application/json

{"id":1,"item":"MON-271","qty":1}
```

- `HEAD` returned the exact headers `GET` would (`Content-length: 15` matches B3's) with
  zero body bytes — server log: `SEND 200 /health -> HEAD: content-length 15
  advertised, 0 body bytes`. **The seam, recorded:** the JDK server *warns* if a handler
  passes a content length on a HEAD request, so the probe advertises the length in a
  header and suppresses the body itself — frameworks do this for you; the protocol rule
  is what matters (HEAD = GET's headers, no body).
- `Allow` on the `405` is the self-describing contract: `PATCH` supporters can discover
  from one failure that `GET, PUT, DELETE` are the verbs this resource accepts.
- B8's JSON-under-`Accept: application/xml` is the *bug-shaped evidence* discussed in
  section 5: the probe documents "JSON only" instead of pretending to negotiate.

## 8. Real-World Applications

The method/status contract is the API's public API: frontend `fetch` wrappers branch on
it, mobile clients (subject 12) retry by it, and gateways cache by it — `GET` is
cacheable precisely *because* the protocol says it must not change state, and that
guarantee is only worth as much as your discipline in keeping reads pure. Where REST
fits badly, name it: an action-heavy domain (a build pipeline: `trigger`, `cancel`,
`approve`) is honestly RPC — gRPC or JSON-RPC endpoints whose *names* are verbs — and a
client fetching deeply-nested, view-shaped data often wants GraphQL's single-request
shape. The trade being managed is always the same one: **uniform interface** (cheap for
infrastructure, sometimes wasteful for the client) versus **bespoke interface**
(explicit, uncachable, coupled). REST is a default, not a virtue.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Verbs in URIs (`/getOrder`) | RPC habits | method is always POST/GET of an action | nouns in paths; the method already is the verb |
| `GET` with side effects (marking read) | convenience auditing | repeated GET changes state; caches corrupt it | audit reads in the log: `GET` must only `SEND 200` |
| `200` + empty body for "missing" | avoiding 404s | clients can't branch on status | `404` with the error envelope |
| `PUT` sent with a partial body | PUT/PATCH confusion | fields vanish after a "successful" PUT | document PUT = full replace; use PATCH for partial — and implement it (probe answers `405` rather than half-doing it) |
| `204` with a body (or HTML error page) | not knowing 204 forbids bodies | client reads garbage or a phantom parse | the probe's `send()` branches on 204/304: headers only |
| Blind retries of `POST` | treating all methods alike | duplicate resources appear under load | idempotency keys for creates (`api-design.md`) |
| Claiming negotiation you don't do | spec-driven design | client sends `Accept`, gets something else (B8) | implement it or document "JSON only" |
| `405` without `Allow` | copying status codes loosely | client can't recover | `Allow` on every 405 (B9 as the template) |

## 10. Best Practices

- **Let the method choose the semantics** before the handler: if the operation is a
  replace, it is `PUT` — no code review needed about retries. The rule stops applying
  where the domain truly is an action (`/orders/1/cancel`), where you should model the
  *state* (`status: cancelled`) and let `PATCH`/`PUT` move it.
- **Write the retry policy next to the method matrix** (the table in section 5) —
  clients and gateways both need it, and it's two columns: safe? idempotent?
- **`204` for deletes with nothing to say**; `200` + body when the client needs the
  final state. Choose per endpoint and document which.
- **Log method, path, status, and response bytes** (the probe's `RECV`/`SEND` lines) —
  `GET` lines that `SEND 4xx/5xx` are your read-purity alarm, and `0 bytes` on 204 is a
  correctness receipt.
- **Document the seams you chose** (JSON-only, Location-only hypermedia). Undocumented
  deviations from the standard contract are the bugs clients file at 2 a.m.

## 11. Limitations and Trade-Offs

What this probe deliberately does *not* do, each pointing at a later lesson or a real
production concern: **no conditional requests** — no `ETag`/`If-None-Match`, so every
GET re-sends the body and concurrent `PUT`s would silently last-write-wins (the lost
update the isolation lesson executed in the database — the same hazard one layer up;
`api-design.md` picks up `If-Match`/409); **no auth** — anyone can `DELETE` (authentication
and authorization lessons); **no versioning** — `/v1/orders` vs `Accept`-versioning is a
real decision neither implemented (`api-design.md`); **no pagination or filtering** on
the collection — `?page=` comes next lesson; **single representation** — B8 exposed the
negotiation gap; **HATEOAS partial** — `Location` only, no `rel`-style links to
sibling actions; **in-memory, single process** — restart loses everything (persistence
is BACK-11's job); and the two captured tool seams (JDK's HEAD warning handled manually,
`Content-type` header set even on the probe's `204` responses — harmless noise a
framework would omit).

## 12. Practical Exercises

### Introductory

1. **Exercise 3.1** — predict-then-run the lifecycle battery: write the eight status
   codes (B2–B12) on paper, then execute the transcript and compare.
   **Completion criteria:** eight predicted codes; the executed table; every miss
   explained from the method matrix, not from "the server did that."
2. **Exercise 3.2** — reproduce the idempotency proof: repeat `PUT`, `GET` before/after,
   and `diff` the two responses yourself; then repeat `DELETE` and capture the
   `204 → 404` pair with the sentence explaining why *state* converged even though the
   *responses* differ.
   **Completion criteria:** a zero-byte diff for the PUT path; both DELETE captures; the
   retry-client rule written ("404 after my own DELETE = success").

### Intermediate

3. **Exercise 3.3** — add `HEAD /orders/1` to the probe: prove its headers equal `GET`'s
   (`diff` of the header blocks, `Date` aside) while the body stays empty, and capture
   the server's `HEAD: … 0 body bytes` log line.
   **Completion criteria:** header-diff output showing only `Date` differs; both log
   lines; one sentence on why HEAD exists (existence/liveness probes without transfer).
4. **Exercise 3.4** — implement conditional GET: send an `ETag` with `GET /orders/1`,
   then re-request with `If-None-Match` and answer `304` with no body (the probe's
   `send()` already handles 304 like 204); capture the byte savings on the second call.
   **Completion criteria:** three executed calls (GET → ETag, conditional GET → 304/0
   bytes, changed PUT → new ETag); the caching rule written (what a proxy may now do);
   the ETag choice justified (what it must change with).

### Independent problem-solving

5. **Exercise 3.5** — model a domain of yours (a booking system, a game's inventory, a
   wiki) as resources: URIs for every noun, a method/status matrix per URI (what each
   verb answers), safe/idempotent columns filled in, a retry policy per method, one
   action-shaped state transition justified, and a short "why not RPC/GraphQL here"
   paragraph citing the uniform-interface trade.
   **Completion criteria:** ≥6 URIs with complete matrices; every idempotency claim
   defended by what the *repeat* would do to state; the REST-vs-alternative paragraph
   naming one cost of your choice; two seams in your design you'd have to implement
   before claiming them (mirroring B8).

*Solutions: attempt first. They live in `exercises/solutions/` of this subject.*

## 13. Knowledge Check

1. Your client sent `DELETE /orders/7` twice and got `204` then `404`. Is the second a
   failure? … *(No — `DELETE` is idempotent in effect: state converged after the first;
   a client that sent the request must treat `404` as "already done." The failure would
   be `5xx` or a `403`.)*
2. Why does a cache store your `GET` but never your `PUT`? … *(`GET` is safe and
   cacheable by protocol promise — replaying it can't change state; `PUT` changes state,
   so replaying a cached response would lie about the world.)*
3. When is a `/orders/1/cancel` path *not* a REST violation? … *(When cancel is a real
   domain operation with its own rules — auth, validation, side effects — you're naming
   a sub-resource/transition, and the method still does the transport work; it becomes a
   violation when the verb merely restates the method, like `GET /getOrder`.)*

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You ran B1–B13 yourself with all eight predicted codes correct before execution
- [ ] You can state safe/idempotent/cacheable for five methods without notes, and one
      example of what "idempotent in effect" means for each
- [ ] Your PUT-repeat diff was byte-identical and your 204 showed zero body bytes
- [ ] You can name three seams this probe has (from section 11) and which lesson or
      decision closes each
- [ ] You can argue one case where REST is the wrong shape, naming the trade

## 15. Summary

- Resources get nouns, methods get verbs; the URI never says "get" or "update."
- `GET`/`HEAD` are safe, `PUT`/`DELETE` are idempotent, `POST` is neither — executed by
  repeat until the bytes agreed (`B5 ≡ B7`, `204 → 404`).
- A representation is a view, not the resource; negotiate honestly or document JSON-only
  (B8 as the anti-pattern caught in the act).
- The lifecycle contract — `201`+`Location`, `200`, `204`, `404`, `405`+`Allow` — is
  what clients, caches, and monitors all branch on.
- REST is a trade: a uniform interface buys infrastructure and retries at the price of
  occasionally awkward modeling; name the alternative when you decline it.

## 16. Next Steps

- Next lesson: [API Design](api-design.md) — naming conventions, pagination, filtering,
  idempotency keys for `POST`, versioning, and the full error contract.
- Practice: [exercise sets](exercises/README.md) for this subject.
- Where it is applied: [Project 04 — REST API](../20-PROJECT-LABORATORY/project-04-rest-api/README.md)
  — this contract grown into a service with persistence behind it.