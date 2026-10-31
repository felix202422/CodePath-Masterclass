# API Testing

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Assert the full contract of an endpoint: status, headers, and problem-detail body
- [ ] Test authz as a first-class contract: missing token, wrong token, right token
- [ ] Write validation-failure tests that pin the *message the client reads*, not just 400
- [ ] Choose the harness: in-process HTTP (`RANDOM_PORT`) vs a deployed jar — and say what each proves
- [ ] Design an API test set as a status-code × role matrix with every interesting cell filled

## 2. Prerequisites

- [Integration Testing](integration-testing.md) — the app slice this level runs over a socket
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — `http-and-rest-apis.md`'s method semantics and `api-design.md`'s pagination/idempotency contracts

## 3. Introduction

An API test treats the HTTP interface as a *published contract*: every response is
evidence about status line, headers, and body — and every refusal (400, 401, 404) is
as much a designed surface as the success path. The tests run over a real socket
(`webEnvironment = RANDOM_PORT`), so routing, serialization, and the auth filter are
in the loop — but the browser isn't; this level's user is another program.

## 4. The Problem It Solves

Backend bugs hide in exactly the cells nobody tests: the 401 that leaks whether the
user exists, the 400 whose body is a stack trace instead of a field message, the 201
without a `Location`, the 404 that returns `200 null`. The lab's API under test was
written with these cells in mind — and the battery executes each one, including the
content-type discrimination that lets clients branch on `application/problem+json`.

## 5. Core Concepts

### The contract matrix

For each endpoint: **status codes** (2xx/4xx/5xx paths) × **roles** (anonymous,
wrong credential, right credential) × **body shape** (success schema, problem-detail
schema). Every *interesting* cell gets a test; boring-but-legal cells get one test or
none — but the matrix is written down so "we didn't test that" is visible.

### RFC 7807 problem-details

A failure body that carries `type`/`title`/`status`/`detail` — testable fields
instead of prose. Executed shapes: `{"title":"unauthorized","status":401,"detail":
"missing or invalid bearer token"}` and `{"title":"validation failed","status":400,
"detail":"net must not be negative"}`.

### The harness ladder

| Harness | Proves | Cost |
|---|---|---|
| `@WebMvcTest` + MockMvc | controller + filter in-process | fastest, no real socket |
| `RANDOM_PORT` + real client | full stack over a loopback socket | one context boot (executed here) |
| Deployed jar + external client | the shipped artifact | build + process lifecycle (the E2E lesson's seat) |

### What only API tests assert cleanly

Header contracts (`Location`, `Content-Type: application/problem+json`), exact JSON
field names, and authz refusals — lower levels can't see headers; higher levels see
too much.

## 6. How It Works

1. `@SpringBootTest(webEnvironment = RANDOM_PORT)` boots the app on an ephemeral
   port; `@LocalServerPort` injects it into the test.
2. The test speaks plain `java.net.http.HttpClient` — no framework magic between the
   assertion and the socket, so what's asserted is what any client would see.
3. Each test creates its own data via `POST` and cleans up (`deleteById`) — no
   cross-test rows (the isolation rule of [testing-fundamentals.md](testing-fundamentals.md)).
4. The auth filter rejects before the controller — so a 401 test proves *routing
   order*, not just a status code.

## 7. Practical Examples

All executed (Java 25, Spring Boot 4.1.1, Windows 11; `mvn test -Dtest=OrdersApiTest`).

**Example 1 — the success cell: 201 + Location + echo** (executed)

```java
HttpResponse<String> res = post("{\"customer\":\"ada\",\"net\":42.00}", "Bearer " + TOKEN);
assertEquals(201, res.statusCode());
assertTrue(res.headers().firstValue("Location").orElse("").matches(".*/api/orders/\\d+"),
        "201 must carry a Location header");
```

```
API: POST valid -> 201, Location=/api/orders/1
```

**Example 2 — validation cells: 400 with the client-readable message** (executed)

```java
assertTrue(res.body().contains("\"detail\":\"customer must not be blank\""), res.body());
```

```
API: blank customer -> 400 {"type":"about:blank","title":"validation failed","status":400,
     "detail":"customer must not be blank"}
API: negative net -> 400 ... "detail":"net must not be negative"
```

Asserting the `detail` text pins what *clients render* — if someone replaces the
message with `error 40001`, that's a breaking change and this test is the changelog.

**Example 3 — the authz cells** (executed)

```java
// no header
assertEquals(401, post(json, null).statusCode());
// wrong token
assertEquals(401, post(json, "Bearer wrong").statusCode());
// right token -> reaches the controller (Example 1's 201)
```

```
API: no token -> 401 {"title":"unauthorized","status":401,"detail":"missing or invalid bearer token"}
API: wrong token -> 401
```

The 401 is identical for "no user" and "bad credential" — a deliberate non-leak the
tests *pin* so a future `404 user not found` on the same route fails the suite.

**Example 4 — read path: 200 → 404** (executed)

```
API: GET 1 -> 200 {"id":1,...}; GET 999999 -> 404 {"title":"order not found",
     "status":404,"detail":"no order with id 999999"}
```

- **How to run:** `mvn test -Dtest=OrdersApiTest` (6 tests, all green in the final suite).
- **Assumptions:** lab token `dev-token-42`; ephemeral port per run — no port conflicts by construction.

## 8. Real-World Applications

API tests are the contract layer in contract-testing pipelines (Pact-style consumer
prousts in microservices), the authz regression net of every service (subject 15's
labs turn these same cells into security proofs), and the source of OpenAPI examples
that never drift. In CI they sit right above units: real socket, seconds, every push.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Status-only assertions | quickest to write | 400 asserted, body is a stack trace | assert shape + one message field per failure |
| Untested authz cells | auth "covered by one test" | wrong-token path untested | the role column of the matrix, always |
| Shared fixtures across tests | convenience | order-dependent API failures | each test POSTs its own data, deletes it |
| Asserting whole JSON blobs | fear of drift | every added field breaks tests | assert the fields the contract promises |
| Testing only happy paths | time | 201 green, 404 returns 200 null | matrix first: statuses × roles |

## 10. Best Practices

- **Matrix first, tests second** — write status × role on paper; fill each interesting cell.
- **Pin messages clients render, not internal codes** — `detail` is the contract.
- **Ephemeral ports** — `RANDOM_PORT` removes an entire class of CI flakes (executed here: every run, no conflicts).
- **Own your data** — create in-test, delete in-test; cleanup even on failure (`finally`/`@AfterEach`).
- **One harness per claim** — in-process for controller/filter semantics, deployed jar (E2E lesson) for the artifact.

## 11. Limitations and Trade-Offs

In-process HTTP doesn't prove the packaged jar boots or that a reverse proxy
preserves headers — that's [end-to-end-testing](end-to-end-testing.md)'s seat.
Problem-detail assertions couple tests to wording: keep them to *stable* fields.
And the matrix grows combinatorially with roles — the discipline is choosing the
interesting cells, not filling all of them.

## 12. Practical Exercises

### Introductory

1. **Exercise 8.1** — run the six-cell battery as-is and map each test to its matrix cell. **Completion criteria:** the matrix with all six cells filled and named by test method.
2. **Exercise 8.2** — add one endpoint of your own with both a 401 and a 400 cell. **Completion criteria:** four captures (success, validation, no token, wrong token).

### Intermediate

3. **Exercise 8.3** — break the API deliberately: make the 404 return 200 with `null`. **Completion criteria:** the red capture, the revert, the green — plus the sentence about why status-only tests would have missed it.
4. **Exercise 8.4** — add a `DELETE /api/orders/{id}` contract (204, 401, 404) following the method semantics from subject 11's `http-and-rest-apis.md`. **Completion criteria:** the three cells executed.

### Independent problem-solving

5. **Exercise 8.5** — design the API test plan for a service you own: matrix on one page, harness choice with justification, and the authz non-leak property stated as an assertion. **Completion criteria:** the plan plus at least eight executed cells.

*Solutions: attempt first. They live in [`solutions/`](exercises/solutions/README.md) of this subject.*

## 13. Knowledge Check

1. Why does an identical 401 for "no token" and "wrong token" deserve its own test?
2. Which of the four harnesses would catch a jar that fails to start? Which catches a wrong `Content-Type` on 400?
3. What's the risk in asserting the entire JSON body of every response?

## 14. Completion Criteria

- [ ] You can write the status × role matrix before touching a test file
- [ ] You can assert status, header, and body with one test per cell and know what each part proves
- [ ] You can state the authz non-leak property as a concrete assertion
- [ ] You can pick the harness for a claim in one sentence

## 15. Summary

- An API response contract has three parts — status, headers, body; test all three.
- Executed cells: 201+`Location`, 400×2 with pinned `detail`, 401×2, 200→404 — six green tests over a real socket.
- The 401 must look identical across refusals; pin it against future leaks.
- Matrix first; ephemeral ports; own your data.
- Harness follows claim: in-process → `RANDOM_PORT` → deployed jar.

## 16. Next Steps

- Next lesson: [Performance Testing](performance-testing.md) — budgets over the same socket
- Practice: [exercise set](exercises/README.md)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)