# Set 7 solutions — API testing → `api-testing.md`

*Executed in the batch's Maven lab: six-cell battery over `RANDOM_PORT` (real socket,
`java.net.http`), Spring Boot 4.1.1, Java 25.*

## 1. The six-cell matrix

The lessons' executed battery, one line per cell:

```
POST   /api/orders  valid            → 201, Location=/api/orders/1
POST   /api/orders  blank customer   → 400, pinned detail
POST   /api/orders  negative net     → 400, pinned detail
GET    /api/orders/1 no token        → 401
GET    /api/orders/1 wrong token     → 401, body byte-identical to the no-token 401
GET    /api/orders/999999            → 404, `no order with id 999999`
```

Mapping rule: rows are *resource + verb*, columns are *client state* (valid / invalid input /
unauthenticated). Two empty columns on your own endpoint mean two failure classes nobody
checks — the 401 and 400 cells are the ones exercise 2 demands for each new endpoint.

## 2. Your endpoint, four captures

Success / validation / no token / wrong token. Two things to get right: the 404-style body
must be *pinned* (`assertEquals` on the exact detail string, not just the status), and the
two 401 bodies asserted identical:

```java
assertEquals(bodyWithoutToken, bodyWithWrongToken);
```

That identity assertion is a security property in test clothing: if the two ever differ
("token expired" vs "no header"), the endpoint hands an attacker an oracle for which
credential form to focus on (the same rule set 9 asserts across the whole battery).

## 3. Break the API: 404 → 200 with null

```
red:   expected: <404> but was: <200>   (or the body assertion: expected <no order…> but was <null>)
revert → green
```

The sentence: a status-only test suite sees `200 OK` and stops looking — it was the *body*
assertion (and the pinned detail) that failed. Status codes are the API's coarse contract;
the body is where semantic regressions hide. Hence the battery's rule: pin both.

## 4. Independent — the API test plan (reference shape)

One page: matrix (endpoints × client states), harness choice justified (real-socket vs
mock-MVC — the lessons chose `RANDOM_PORT` because filters, Jackson binding, and the
container's 404 exist only in the real pipeline), and the non-leak property stated as an
assertion (`assertEquals` of the two 401 bodies, plus "no endpoint reveals existence to an
unauthenticated caller": 401 for wrong token, never 404). Then execute ≥ 8 cells of your
own service — the plan is judged by the transcript that follows it, not by its diagram.