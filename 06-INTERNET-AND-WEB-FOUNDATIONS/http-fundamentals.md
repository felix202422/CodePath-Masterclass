# HTTP Fundamentals

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Read any HTTP/1.x request and response message and label every part (start line, headers, body, CRLF framing)
- [ ] State what each method promises semantically (idempotent, safe, cacheable) rather than only its common use
- [ ] Choose a status code for a stated outcome and explain what it promises the client
- [ ] Use `curl` to capture headers, send bodies, and drive conditional requests (`304`) against a real server
- [ ] Diagnose ordinary HTTP failures — wrong method, missing header, stale cache — from a captured message

## 2. Prerequisites

- [TCP and UDP](tcp-and-udp.md) — HTTP runs on TCP streams; Content-Length depends on byte counts
- [Client–Server Architecture](client-server-architecture.md) — request/response roles, ports
- [03-DEVELOPER-TOOLS/terminal-fundamentals.md](../03-DEVELOPER-TOOLS/terminal-fundamentals.md) — piping and flags

## 3. Introduction

HTTP is the grammar the web speaks. It is a text protocol: you can read it with your eyes and
type it by hand, which is exactly what this lesson does — first capturing real messages with
`curl`, then sending raw bytes over a bare socket to prove there is nothing hidden underneath.
Everything in the rest of this curriculum that touches a URL — frontend fetches, backend APIs,
reverse proxies, caches, auth — is HTTP. Learn to read the message and most "web bugs" become
plain: a wrong header, a misunderstood status, a cache that was never told to revalidate.

## 4. The Problem It Solves

Two programs on a TCP connection (lesson 5) can exchange bytes. Bytes are not a language:
how does the receiver know where one message ends and the next begins, which bytes are
instructions versus payload, and what a reply *means*? Early internet protocols (Gopher, FTP)
each invented their own answers, usually binary and application-specific.

HTTP's founding idea: make the protocol **human-readable, stateless, and self-describing**.

- **Human-readable** — a request is ASCII lines: a method, a path, headers, a blank line, then
  an optional body. You can debug it in a terminal. (Lesson 6's raw-bytes transcript proves it:
  the "wire format" is exactly what you would type.)
- **Stateless** — each request carries everything needed to understand it; the server keeps no
  required session between requests. A server can therefore serve any request on any
  connection, scale horizontally, and crash without corrupting a conversation. (This is a
  *cost* the application must repair — cookies and tokens exist for exactly this reason.)
- **Self-describing** — headers declare what the body is (`Content-Type`), how long it is
  (`Content-Length`), and how it may be cached — metadata and payload in one message.

The trade: text is verbose, and statelessness makes every request re-establish context. HTTP's
history since then is a sequence of repairs — keep-alive for connection reuse, cookies for
state, compression for verbosity, HTTP/2 and /3 for head-of-line and latency — all layered
onto this grammar without abandoning it.

## 5. Core Concepts

### Message anatomy

An HTTP/1.x message is one **start line**, a block of **headers** (each `Name: value`), an
empty line (`CRLF` — the blank line *is* the separator), then an optional **body**:

```http
GET / HTTP/1.1
Host: 127.0.0.1:8765
Accept: */*
```

(Request start line = method + path + version. The blank line's `\r\n\r\n` is the framing
boundary — two CRLFs — which is why the raw socket example below shows it literally.)

A response mirrors it:

```http
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Content-Type: text/html
Content-Length: 89
ETag: "v1-89bytes"
```

(Response start line = version + status code + reason phrase. Headers, blank line, body of
exactly `Content-Length` bytes.)

### Method semantics — the part people skip

A method is a *promise about semantics*, not a URL in disguise:

| Method | Safe (no server mutation) | Idempotent (repeat = same end state) | Common use |
|---|---|---|---|
| `GET` | ✓ | ✓ | Read a resource |
| `HEAD` | ✓ | ✓ | Headers only — size/validity checks |
| `PUT` | ✗ | ✓ | Replace with this exact state |
| `DELETE` | ✗ | ✓ | Remove (second delete = already gone) |
| `POST` | ✗ | ✗ | Create / process / submit — **not** repeatable |
| `PATCH` | ✗ | ✗ (usually) | Partial update |

**Idempotent is the load-bearing word**: a client (or proxy, or TCP retransmission — lesson 5)
that retries a `PUT` can safely do so; retrying a non-idempotent `POST` can double-charge,
double-create, double-send. Idempotency is *why* automatic retries are legal for some methods
and dangerous for others, and it is the first thing a careful API designer specifies.

### Status codes — contracts, not trivia

Classes carry the meaning; the number tells you where you are:

- **1xx** informational (rare in application code)
- **2xx success** — `200 OK` (here it is), `201 Created` (+ `Location` header), `204 No Content` (success, deliberately empty body)
- **3xx redirection / caching** — `301 Moved Permanently` (permanent), `302`/`307` temporary, `304 Not Modified` (your cached copy is still valid — **no body**), `308` permanent POST-safe redirect
- **4xx client fault** — `400 Bad Request` (malformed), `401 Unauthorized` (who are you? → authenticate), `403 Forbidden` (I know who you are; no), `404 Not Found` (no such resource), `405 Method Not Allowed` (right path, wrong verb), `409 Conflict`, `429 Too Many Requests`
- **5xx server fault** — `500 Internal Server Error` (your code threw), `502 Bad Gateway` (upstream gave garbage), `503 Service Unavailable` (overloaded or shutting down), `504 Gateway Timeout` (upstream too slow)

The `401`/`403` distinction (above) and `404`/`405` distinction are tested constantly in
interviews and in production: each is a different *fact* about the server's knowledge.
For the full contract of every status — including which are idempotent, retryable, or
cacheable — see the [HTTP status codes reference](../21-REFERENCE-LIBRARY/http-status-codes.md).

### Headers you must actually know

- **`Host`** — required by HTTP/1.1: the server hosts many sites on one IP; `Host` picks the
  virtual host. (In lesson 6's raw bytes, omitting it changes routing behaviour on real servers.)
- **`Content-Type` / `Content-Length`** — what the body is, and how many bytes: length is
  framing, content-type is interpretation. `Transfer-Encoding: chunked` replaces length for
  streams of unknown size.
- **`Connection: keep-alive` / `close`** — the transport's (lesson 5) reuse decision: does the
  TCP connection stay open for the next request?
- **`Accept`, `Accept-Encoding`, `Accept-Language`** — client preferences; the server's matching
  reply (`Content-Type`, `Content-Encoding`) is **content negotiation**.
- **`User-Agent`** — client software identification (analytics, compatibility branches — and a
  fingerprinting vector).
- **Validators: `ETag`, `If-None-Match`, `Last-Modified`, `If-Modified-Since`** — cache
  revalidation (executed below): the ETag is a version token; `If-None-Match` says "give me the
  body only if this changed."

### Statelessness and its repairs

HTTP itself carries no memory of previous requests. Repairs: **cookies** (server-set, client
returned — session IDs), **authorization headers** (tokens), and **HTTP/2's multiplexing** —
all application- or transport-level additions, not part of the core grammar. When you debug
"logged out randomly", you are debugging one of these repairs, not HTTP.

## 6. How It Works

### One request, fully verbose — against a real server

A local Python server (lesson 2's pattern) on `127.0.0.1:8765`; `curl -v` prints everything
crossing the wire. Executed on the authoring machine (Windows 11, Git Bash, curl 8.22.0):

```console
$ curl -v http://127.0.0.1:8765/
*   Trying 127.0.0.1:8765...
* Established connection to 127.0.0.1 (127.0.0.1 port 8765) from 127.0.0.1 port 51668
> GET / HTTP/1.1
> Host: 127.0.0.1:8765
> User-Agent: curl/8.22.0
> Accept: */*
> 
* Request completely sent off
< HTTP/1.0 200 OK
< Server: BaseHTTP/0.6 Python/3.13.5
< Date: Thu, 22 Oct 2026 07:15:20 GMT
< Content-Type: text/html
< Content-Length: 89
< ETag: "v1-89bytes"
< 
<!DOCTYPE html>
<html><head><title>Lab</title></head>
<body><h1>hello</h1></body></html>
```

Line by line, this is every concept above: `>` lines are the client's request (start line,
then headers, then the blank line — the lone `> ` with nothing after it *is* the CRLF framing
boundary); `<` lines are the response's start line and headers; then the body of exactly
`Content-Length: 89` bytes. Note `HTTP/1.0` on the response — this minimal server replies with
1.0; version is negotiated per message and curl accepts both. Note too that the request says
`Host:` even though the address is already known — HTTP/1.1 requires it.

### Methods and status codes, executed

```console
$ curl -s -D - -X POST -H "Content-Type: application/json" -d '{"name":"ada"}' http://127.0.0.1:8765/echo
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Date: Thu, 22 Oct 2026 07:15:20 GMT
Content-Type: application/json
Content-Length: 60

{"echo": "{\"name\":\"ada\"}", "ctype": "application/json"}
$ curl -s -I http://127.0.0.1:8765/
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Date: Thu, 22 Oct 2026 07:15:21 GMT
Content-Type: text/plain
Content-Length: 4

$ curl -s -o /dev/null -w "GET /missing -> %{http_code}\n" http://127.0.0.1:8765/missing
GET /missing -> 404
```

Three demonstrations in three lines of evidence:

1. **POST carries a body.** The request's `Content-Type: application/json` told the server how
   to interpret the bytes; the server echoed both the body *and* the header back — proving the
   header is metadata about the body, travelled separately, and was readable. (The echoed JSON
   shows the body as an escaped string — the server wrapped your JSON in its own JSON.)
2. **HEAD (`-I`) returns headers only** — same headers a `GET` would send, zero body bytes.
   That is how a client checks size or validity cheaply: the `Content-Length: 4` above tells it
   the body's size without downloading the body — safe precisely because `HEAD` is *safe* and
   *idempotent* (section 5's table).
3. **404 is the server's knowledge claim** — this path has no resource. (Its sibling, `405`,
   would mean the path exists but this *method* does not — different fact, different fix.)

### Conditional requests: the 200 → 304 dance, executed

This is caching's core mechanism, and the server above implements it deliberately:

```console
$ curl -s -D - -o /dev/null http://127.0.0.1:8765/
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Date: Thu, 22 Oct 2026 07:15:20 GMT
Content-Type: text/html
Content-Length: 89
ETag: "v1-89bytes"

$ curl -s -D - -o /dev/null -H 'If-None-Match: "v1-89bytes"' http://127.0.0.1:8765/
HTTP/1.0 304 Not Modified
Server: BaseHTTP/0.6 Python/3.13.5
Date: Thu, 22 Oct 2026 07:15:22 GMT
ETag: "v1-89bytes"
```

First fetch: `200` with a body and an `ETag: "v1-89bytes"` (the server's version token).
Second fetch: the client *returns the token* in `If-None-Match`, and the server — seeing its
own current token matches — answers `304 Not Modified` **with no body**. The client uses its
cached copy. Bandwidth spent on the second exchange: the headers you see and nothing else.
This is the same staleness-vs-cost reasoning as DNS TTLs (lesson 4), but with a per-request
check instead of a timer: TTLs expire blindly, validators *ask*.

### HTTP as plain bytes over a bare socket

The claim "HTTP is a text protocol" deserves proof. This sends the request by hand — no curl,
no library — just a TCP socket (lesson 5's API):

```console
$ python raw_http.py
--- bytes sent ---
b'GET / HTTP/1.1\r\nHost: 127.0.0.1:8765\r\nConnection: close\r\n\r\n'
--- status line + headers received ---
HTTP/1.0 200 OK
Server: BaseHTTP/0.6 Python/3.13.5
Date: Thu, 22 Oct 2026 07:16:21 GMT
Content-Type: text/html
Content-Length: 89
ETag: "v1-89bytes"
--- body: 89 bytes ---
<!DOCTYPE html>
<html><head><title>Lab</title></head>
<body><h1>hello</h1></body></html>
```

The request in `repr()` form shows the framing literally: `\r\n` (CR LF) after every line, and
**two** at the end — the blank line that ends headers. The response arrives with the same
grammar. Nothing else exists: HTTP/1.1 is a convention about how to arrange ASCII lines inside
a TCP stream, and both sides honour it. (`Connection: close` was sent to tell the server to
end the stream after one response — otherwise a client library would keep the socket open for
reuse, which `keep-alive` is the explicit form of.)

## 7. Practical Examples

**Example 1 — a `curl` toolkit for reading any API**

```console
$ curl -s -D - -o /dev/null https://example.com/     # headers only, discard body
$ curl -s -X POST -H 'Content-Type: application/json' -d '{"a":1}' https://api.example.com/x
$ curl -s -o /dev/null -w '%{http_code} %{time_total}s\n' https://example.com/   # status + total seconds
$ curl -v https://example.com/ 2>&1 | grep '^<'       # only response lines, verbose
```

- `-D -` writes response headers to stdout; `-o /dev/null` throws the body away: pure headers.
- `-w` formats the transfer's measurements — `%{http_code}` and `%{time_total}` are the two
  numbers every HTTP performance conversation starts with (lesson 1's round-trip argument,
  measured against a real endpoint).
- `grep '^<'` on `-v` output extracts exactly the response's lines — the lesson's section 6
  format, on any URL.
- **Assumptions:** curl 8.22.0 (authoring machine); every command is read-only against a URL
  you choose. Run them against `https://example.com` to start.

**Example 2 — write a correct client: parse status, then length, then body**

```python
# tiny_http_client.py — manual HTTP/1.1 over a TCP socket, framing done by the book
from socket import socket, AF_INET, SOCK_STREAM

with socket(AF_INET, SOCK_STREAM) as s:
    s.connect(("127.0.0.1", 8765))
    s.sendall(b"GET / HTTP/1.1\r\nHost: 127.0.0.1:8765\r\nConnection: close\r\n\r\n")
    buf = b""
    while chunk := s.recv(4096):          # read until the server closes (Connection: close)
        buf += chunk

head, _, body = buf.partition(b"\r\n\r\n")         # split ONCE at the blank line
status = head.split(b"\r\n")[0].decode()
length = next(h.split(": ")[1] for h in head.split(b"\r\n")[1:]
              if h.lower().startswith(b"content-length"))
print(status)                            # HTTP/1.0 200 OK
print(f"header bytes={len(head)} body bytes={len(body)} declared={length}")
assert len(body) == int(length), "framing violated: body does not match Content-Length"
```

- **What the important lines do:** `partition(b"\r\n\r\n")` locates the single blank-line
  boundary; headers are then read line-by-line from the first half; `Content-Length` is parsed
  from the header block, never guessed; the assert turns the protocol's promise into a test.
- **Expected output:** `HTTP/1.0 200 OK` and `header bytes=... body bytes=89 declared=89`.
- **How to run it:** start the lab server (lesson 2's `hello.py`), then `python tiny_http_client.py`.
- **Assumptions:** Python 3.13, the lab server on 8765 (its ETag/404/POST behaviour is what
  section 6's transcripts captured). Executed on the authoring machine.
- **Why this client exists:** it is every HTTP library's skeleton. Requests, fetch, curl — all
  parse exactly these bytes; you have now seen the layer beneath them.

## 8. Real-World Applications

- **Every API you build is an HTTP message contract.** Subjects 10 and 11 (REST design,
  backend frameworks) are spent choosing methods, statuses and headers; the earlier you treat
  them as *semantics* (section 5's tables) the fewer breaking redesigns you ship.
- **Caching and CDNs** run on validators and status codes: `304` saves bandwidth, `Cache-Control`
  (subject 11) directs intermediaries, `Vary` splits caches by negotiated dimension. The 200→304
  dance above is the traffic of the entire web.
- **Debugging production** almost always starts with one captured exchange: `curl -v` against
  the failing URL separates "DNS failed" (lesson 4) from "connect refused" (lesson 5) from
  "wrong status" (here) from "slow body" (performance) — the triage ladder, message by message.
- **Auth and security** live in headers: `Authorization`, cookies, CORS preflights (an
  `OPTIONS` request asking permission before a real one), and CSRF tokens are all HTTP-level
  mechanisms — subjects 14 and 15 add the threat model on top of this grammar.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Treating status codes as trivia to memorize | Interview prep culture | You pick `404` for "wrong method" and clients mis-handle it | Learn each code as a *fact + client instruction*; retry logic depends on it |
| Retrying a `POST` automatically | "Network error, resend!" feels safe | Duplicate orders/charges after a timeout-and-retry | Retry only idempotent methods, or make the operation idempotent (idempotency keys, subject 11) |
| Ignoring `Content-Length` vs chunked | Bodies usually "just arrive" | Parsers hang (waiting for bytes) or truncate (stopping early) | Always frame by header: length when present, chunked when declared, connection-close only as fallback |
| Confusing `401` with `403` | Both mean "not allowed" to casual reading | A client sends credentials to a `403` and loops | `401` = authenticate (send `WWW-Authenticate`); `403` = authenticated-but-refused, don't resend credentials |
| Assuming HTTP is stateless *and* therefore connectionless | Different layers, constantly conflated | You expect every request to open a TCP connection | Stateless = no required session; keep-alive = reuse of one TCP connection for many requests |

## 10. Best Practices

- **Capture before you theorize.** One `curl -v` transcript ends most arguments about what a
  server did — the header either is or is not there. From this subject onward, "I think the
  API returns X" is replaced by "here is the message".
- **Design idempotency in first.** Make `PUT`/`DELETE` naturally idempotent, and give `POST`
  that needs retries an idempotency key — because proxies and TCP (lesson 5) *will* retry
  underneath you whether you planned for it or not.
- **Set validators on anything cacheable.** An `ETag` costs a few bytes per request and buys
  the 304 path forever; content that never varies should carry a stable token (the lab's
  `"v1-89bytes"` is a hand-rolled version number — real servers hash the bytes).
- **Use `HEAD` for probes.** Checking whether a file exists, its size, or its type without
  downloading it is exactly what safe/idempotent methods are for; scraping bodies for metadata
  wastes the client's bandwidth and the server's.

## 11. Limitations and Trade-Offs

- **Text costs bytes and parsing.** Every header line is ASCII overhead; HTTP/2's binary framing
  exists to compress it (and header compression — HPACK — fixes the redundancy). The lesson's
  readability argument and HTTP/2's efficiency argument are both true; different layers made
  different trades.
- **HTTP/1.1's head-of-line blocking is architectural.** One TCP connection carries requests in
  order: a slow response stalls those behind it, and browsers' old 6-connections-per-host limit
  was a workaround, not a fix (HTTP/2 multiplexes; lesson 8's rendering makes this visible).
- **Statelessness moves complexity to the client.** Every request re-sends context; sessions,
  tokens and cookies re-add what the core protocol removed — and each repair is a place bugs
  (and vulnerabilities) hide.
- **200 does not mean "the operation succeeded as you hope."** `200 OK` means the *request* was
  understood and handled; business failures can legitimately arrive in a `200` body (or should
  be a `409`/`422` — a design decision, not an accident). Never infer semantics from status
  class alone without reading the API's contract.

## 12. Practical Exercises

### Introductory

1. **Exercise 6.1** — Capture a complete verbose exchange with `curl -v` against a local server
   or `https://example.com`. Label, in your own output: the request's start line, the blank-line
   boundary, three request headers, the response's start line, and the byte count that the body
   must satisfy.
   **Completion criteria:** all five labelled from your transcript; the `Content-Length` value
   cross-checked against the body's actual byte count (`wc -c` or your client's output).
2. **Exercise 6.2** — Send `POST`, `PUT`, `DELETE` and `GET` to the same path on your lab
   server; record each response's status. Then repeat `PUT` twice with the same body and state
   why the second was legal to repeat.
   **Completion criteria:** four statuses captured; the idempotency table's `PUT` row cited as
   the reason; one sentence on what would make your `POST` retry-safe.

### Intermediate

3. **Exercise 6.3** — Drive the conditional flow end to end: `GET` with `-D -` to harvest the
   `ETag`, then `GET` with `If-None-Match` carrying it; capture both exchanges. Then modify the
   served file (or the token in your server), repeat, and capture the `200`.
   **Completion criteria:** `200` → `304` → (after change) `200` captured in sequence; a
   two-sentence explanation of who decided each response and why no body appeared on the second.
4. **Exercise 6.4** — Diagnose from messages alone: (a) `curl -X POST /login` returns `405`;
   (b) an authenticated user receives `403` on `/admin`; (c) a client loops sending credentials
   and keeps receiving `401`. For each: name the fact the status asserts and the *one* fix.
   **Failure to diagnose:** three real or faithfully-reproduced statuses; each mapped to
   method-not-allowed / authenticated-but-refused / not-authenticated with a distinct fix —
   (b)'s fix must NOT be "send credentials again" (that is the trap of confusing 401/403).

### Independent problem-solving

5. **Exercise 6.5** — *Problem:* design the HTTP interface for a note-taking service's core
   operations: create a note, list a user's notes, update one field, delete, and export all
   notes as a file. Choose method + status code + one key header per operation, justify each
   choice from this lesson's tables (idempotency and semantics, not habit), and specify exactly
   what a client may safely retry after a timeout.
   **Completion criteria:** a five-row contract table (operation / method / status / header /
   retryable?) with every cell justified from section 5; the retry policy stated as a rule the
   client can implement mechanically; one edge case you identified yourself (empty list? large
   export?) and how your contract handles it.

*Solutions: attempt first. They live in `exercises/solutions/` of this subject.*

## 13. Knowledge Check

1. Draw an HTTP request from memory with all four structural parts, and state what each `\r\n`
   does. What breaks if the blank line is missing?
2. A `POST /orders` times out and your client's TCP layer retransmits (lesson 5). What does
   HTTP's method table say about the risk, and what single mechanism removes it?
3. Your browser re-visits a page and the server returns `304`. Which bytes were saved, who
   held the copy, and what would have happened without the `ETag`?

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You captured and labelled a full verbose exchange from your own machine (exercise 6.1)
- [ ] You can read any status code and state the fact it asserts plus the client's correct response
- [ ] You executed the 200 → 304 → 200 conditional sequence yourself (exercise 6.3)
- [ ] You wrote the raw-socket client and it passed the `Content-Length` assertion (Example 2)
- [ ] You can diagnose all five mistakes in section 9

## 15. Summary

- HTTP is a readable text grammar: start line, headers, blank line (`\r\n\r\n`), body — nothing more, as the raw-socket transcript proves.
- Methods carry semantics: *safe* and *idempotent* determine what clients and proxies may retry.
- Status codes are contracts: each class asserts a different fact (401 vs 403, 404 vs 405), and clients act on it.
- Validators (`ETag`/`If-None-Match`) turn caching into a per-request question answered by a bodyless `304`.
- The protocol is stateless by design; sessions, cookies and keep-alive are repairs layered on top.

## 16. Next Steps

- Next lesson: [HTTPS and TLS](https-and-tls.md) — wrapping this readable protocol in a channel that cannot be read or altered in transit
- Practice: [exercises/](exercises/README.md) set 6
- Where it is applied: [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) (REST API design) and [21-REFERENCE-LIBRARY/http-status-codes.md](../21-REFERENCE-LIBRARY/http-status-codes.md) (the complete status table)
