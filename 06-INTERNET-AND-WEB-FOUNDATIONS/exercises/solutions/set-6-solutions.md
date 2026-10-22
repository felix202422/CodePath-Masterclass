# Solutions — Set 6: HTTP Fundamentals

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Label a verbose exchange

**Reference transcript (authoring machine):**

```console
$ curl -v http://127.0.0.1:8765/
> GET / HTTP/1.1
> Host: 127.0.0.1:8765
> User-Agent: curl/8.22.0
> Accept: */*
> 
< HTTP/1.0 200 OK
< Server: BaseHTTP/0.6 Python/3.13.5
< Content-Type: text/html
< Content-Length: 89
< ETag: "v1-89bytes"
<!DOCTYPE html>...
```

- **Labels:** request start line = `GET / HTTP/1.1`; blank-line boundary = the bare `> ` line
  (its `\r\n\r\n` ends the headers); three request headers = `Host`, `User-Agent`, `Accept`;
  response status line = `HTTP/1.0 200 OK`; required byte count = `Content-Length: 89`.
- **Cross-check:** body bytes = `wc -c` of the saved body → must equal **89** (TCP's byte
  counts from lesson 5 make this a checkable promise, not an estimate).
- **Criteria check:** ☐ five labels ☐ 89 == actual.

## Exercise 2 — Four methods, then idempotency

**Reference shape** (lab server statuses):

| Method | Path | Status | Notes |
|---|---|---|---|
| `POST` | `/echo` | `200` | body echoed |
| `PUT` | `/` | `200` (this lab) / `405` on strict APIs | either is a valid *capture* |
| `DELETE` | `/` | `200`/`204`/`405` | depends on the server's contract |
| `GET` | `/` | `200` | baseline |

- **Repeating the `PUT`:** legal *by semantics* — `PUT` means "replace with this state", so a
  second identical PUT reaches the same end state (idempotent, lesson §5's table). TCP/curl may
  already have retried it without you noticing, which is exactly why the table exists.
- **What would make your `POST` retry-safe:** a client-generated idempotency key the server
  deduplicates on (subject 11) — i.e. making a non-idempotent operation *appear* idempotent by
  identity, not by method.
- **Criteria check:** ☐ four statuses ☐ idempotency row cited ☐ one retry-safety sentence.

## Exercise 3 — The conditional dance

**Reference transcript (authoring machine):**

```console
$ curl -s -D - -o /dev/null http://127.0.0.1:8765/
HTTP/1.0 200 OK
Content-Type: text/html
Content-Length: 89
ETag: "v1-89bytes"

$ curl -s -D - -o /dev/null -H 'If-None-Match: "v1-89bytes"' http://127.0.0.1:8765/
HTTP/1.0 304 Not Modified
ETag: "v1-89bytes"

# after changing the served content (new ETag):
HTTP/1.0 200 OK
Content-Length: 93
ETag: "v2-93bytes"
```

- **Who decided:** the *server*, on the second request — it compared the client's
  `If-None-Match` token against its current `ETag`; equal → `304`, no body (the client's copy
  stands). Third request: token mismatch → full `200` with the new body.
- **Why no body on 304:** the method's contract — "not modified" *means* "use yours"; a body
  would defeat the bandwidth saving that was the entire point.
- **Criteria check:** ☐ `200 → 304 → 200` in sequence ☐ two sentences: server decided, by
  validator comparison.

## Exercise 4 — Status diagnoses

1. **`405` on `POST /login`:** fact = *the path exists, this method isn't allowed on it.*
   Fix: use the method the server advertises (check the `Allow:` header — likely `GET` or the
   route is elsewhere). Not a missing-resource bug.
2. **`403` on `/admin` while authenticated:** fact = *identity known, authorization refused.*
   Fix: grant the required role/permission — **not** resending credentials (the 401/403 trap).
3. **Loop with `401`:** fact = *not authenticated / credentials rejected or missing.* Fix: the
   credential acquisition itself (token expired → refresh flow; wrong scheme → check
   `WWW-Authenticate`), and stop the loop by bounding retries — a 401 loop usually means the
   client "re-sends" something the server never accepted.
- **Criteria check:** ☐ three statuses ☐ three distinct facts + fixes ☐ (b)'s fix ≠ resend
  credentials.

---

Next: [set-7-solutions.md](set-7-solutions.md)
