# URLs and Ports

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Parse any URL into its components (scheme, authority, host, port, path, query, fragment) and state which layer each one reaches
- [ ] State what a port number does, distinguish well-known from ephemeral, and read a live listener listing correctly
- [ ] Explain how a browser gets from a typed string to `host:port` — including default ports, SNI, and the `Host` header
- [ ] Diagnose ordinary failures at each component: DNS failure vs refused connection vs 404 vs a broken query string
- [ ] Decide what belongs in a path, a query, or a fragment — and what must never go in any of them

## 2. Prerequisites

- [HTTP Fundamentals](http-fundamentals.md) — the request line's path and the `Host` header
- [DNS](dns.md) — the host component is resolved by the system of lesson 4
- [IP Addressing and Subnets](ip-addressing.md) — ports sit on addresses

## 3. Introduction

A URL is the most-typed string in computing and the least examined: `https://example.com:443/search?q=ttl#results`
packs five lessons of machinery into one line. Scheme selects the protocol, host names the
machine, port selects the service, path names the resource, query carries parameters, fragment
stays on the client. This lesson takes the string apart component by component, showing for
each one exactly which earlier lesson handles it and what it looks like on the wire — then uses
a live listener listing to make "port" concrete rather than notional.

## 4. The Problem It Solves

A resource on a network needs a *complete addressing chain*, and no single layer can supply it
all: the internet layer knows addresses (lesson 3), the transport knows ports (lesson 5), the
application knows *which document* on a server (lesson 6). Each layer's addressing is only
meaningful with the others — and humans need one string that composes them.

The URL's design (Berners-Lee, 1994) was to make that composition explicit and hierarchical:
scheme first (what conversation), then authority (which machine:port), then location-within
(the resource), then modifiers (parameters, client-side anchor). Two properties made it stick:

- **It is layered.** Each component is consumed by a different participant — the browser
  handles scheme/port defaults, DNS handles host, TLS handles SNI, HTTP handles path/query —
  which is why lessons 1–7 each touched a piece of this string without ever needing the whole.
- **It is a contract.** Because servers route on path and query (they are *visible to
  intermediaries* — a point lesson 6's caching and lesson 7's encryption both turn on), moving
  a parameter from query to fragment has security and caching consequences. Most URL bugs are
  really component-placement bugs.

The companion concept — the **port** — exists because one address hosts many services
(lesson 2's `netstat` listing showed ten on one machine). The port is the demultiplexing
number that decides which of them you are addressing; the URL's optional `:port` is where a
human overrides the default.

## 5. Core Concepts

### Anatomy of one string

```
https://user:pass@www.example.com:443/blog/post?id=42&ref=home#comments
└┬┘ └──────────────┬──────────────┘└┬─┘└─────────┬────────┘└───┬───┘
 scheme        authority         port        path+query      fragment
             (userinfo, host)
```

| Component | Value here | Who consumes it | Reaches the server? |
|---|---|---|---|
| **Scheme** | `https` | Client: selects TLS + port default + protocol | No (chooses how) |
| **UserInfo** | `user:pass@` | Client (deprecated for credentials) | Sent in HTTP/1.1, stripped by browsers — never use |
| **Host** | `www.example.com` | DNS (lesson 4) → address (lesson 3) | Via `Host` header + TLS SNI |
| **Port** | `443` | Transport (lesson 5): which service | Implicit in the connection |
| **Path** | `/blog/post` | Server router (lesson 6's request line) | **Yes** — visible to every intermediary |
| **Query** | `?id=42&ref=home` | Server/application parameters | **Yes** — visible, *and cached* by intermediaries |
| **Fragment** | `#comments` | **Client only** (browser scrolls / JS reads) | **Never sent** — not in the request at all |

The table *is* the lesson: three components cross the wire in plaintext-ish places (path and
query inside TLS, but visible to the server and any proxy that terminates it — lesson 7's
termination boundary), while the fragment provably does not — which is why secrets belong
nowhere, and why a fragment cannot be an authorization mechanism.

### Default ports and why the string omits them

Every scheme has a default port — `http`→80, `https`→443, `ftp`→21 — so `https://example.com`
and `https://example.com:443` are the same address:port. Omitting the default is convention,
not magic. Ports come in ranges:

- **0–1023: well-known** — bound with privilege on Unix; `22` SSH, `80` HTTP, `443` HTTPS, `53` DNS (lesson 4), `5432` Postgres, `6379` Redis are the ones you will actually see
- **1024–49151: registered** — assigned by IANA to named applications
- **49152–65535: ephemeral** — the OS hands these out to clients (lesson 2's `51294` was one); they are *not* fixed services and must not be relied on

A port is not a protocol (lesson 2's mistake table): 8080 is commonly HTTP, but it is equally
a Java debugging agent or anything else — the number is a rendezvous, the protocol is what both
sides agree to speak.

### What the browser actually does with the string

1. **Parse** into the table's components (standards: WHATWG URL; the grammar has many legacy edge cases)
2. **Default the port** from the scheme; apply proxy settings if any
3. **DNS-resolve the host** (lesson 4) — often preferring IPv6 (happy-eyeballs racing both families)
4. **TCP connect** to `host:port` (lesson 5)
5. **TLS handshake with SNI = host** (lesson 7) — the host is sent *inside* the handshake so a shared server knows which certificate to present; then `Host:` (HTTP/1.1) or `:authority` (HTTP/2) repeats it in the encrypted request
6. **Send** `GET <path>?<query> HTTP/1.1` — fragment deliberately excluded
7. **Render** — and the fragment, retained client-side, anchors the view or reaches JavaScript

The host appears three times (DNS, SNI, Host header) because three layers each need it; the
fragment appears zero times on the wire because it was never the server's business.

### Ports on a live machine

Lesson 2 introduced this listing; here it is as a URL-consumer's document. Executed on the
authoring machine:

```console
$ netstat -ano | grep LISTENING | head -10
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       1496
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:623            0.0.0.0:0              LISTENING       12980
  TCP    0.0.0.0:2179           0.0.0.0:0              LISTENING       3532
  TCP    0.0.0.0:3389           0.0.0.0:0              LISTENING       6464
  TCP    0.0.0.0:4369           0.0.0.0:0              LISTENING       15020
  TCP    0.0.0.0:5040           0.0.0.0:0              LISTENING       7964
  TCP    0.0.0.0:5432           0.0.0.0:0              LISTENING       15748
  TCP    0.0.0.0:5672           0.0.0.0:0              LISTENING       14084
  TCP    0.0.0.0:6379           0.0.0.0:0              LISTENING       12392
```

Read as addressing: local address = `interface:port` (`0.0.0.0` = all interfaces — lesson 2's
binding lesson), last column = owning process ID. These are services reachable *by port* right
now: 135 (RPC), 445 (SMB), 3389 (RDP), 5432 (Postgres), 5672 (AMQP), 6379 (Redis), 4369 (Erlang
port mapper for the broker on 5672) — and a URL's authority component is how any client on the
network addresses exactly one of them: `postgresql://host:5432/db` is the same grammar as
`https://host/db` with a different scheme and default.

### Failure at each component, by symptom

| Symptom (real message class) | Failing component | Lesson |
|---|---|---|
| `Could not resolve host: typo.examplee.com` | Host → DNS | 4 — name never became an address |
| `Connection refused` (host resolved) | Port → nothing listening | 2/5 — right address, wrong or absent service |
| `Connection timed out` | Path/firewall | 1 — packets went somewhere silent |
| `404 Not Found` / `405` | Path → application routing | 6 — reached the app, wrong resource/verb |
| Parameter ignored / wrong record shown | Query construction | 6 — encoding, duplicates, or placement |
| "Works pasted in browser, fails in code" | Fragment or encoding silently handled by browser | here — the browser did something your code didn't |

The ladder is the diagnostic habit: the URL's own left-to-right order tells you where to look —
scheme/host (1–4), then path/query (6), because that is the order components are consumed.

## 6. How It Works

### Decompose and resolve, end to end

Take the opening string and follow every component into its layer:

```console
$ nslookup www.example.com
Non-authoritative answer:
Server:  ns.ditnet.ac.tz
Address:  102.208.185.3

Name:    www.example.com
Addresses:  2606:4700:10::6814:179a
	  172.66.147.243
```

(Host → address: lesson 4's machinery, producing lesson 3's addresses. On this machine the
default resolver answered — a copy, labelled as such.)

```console
$ curl -s -o /dev/null -w "scheme https, port 443 → HTTP %{http_code} in %{time_total}s\n" https://example.com/
scheme https, port 443 → HTTP 200 in 0.102...
```

(`{http_code}` is lesson 6's contract; `{time_total}` is lesson 1's round trip plus everything
else — measured per request, which is the number URLs-in-performance-conversations turn on.)

And the component that never leaves: open `https://example.com/#secret`, run
`curl -v https://example.com/#secret`, and the request line in the verbose output reads
`GET / HTTP/1.1` — no `#secret`, ever. The fragment is consumed before the request is built.
(Lesson 7 makes this load-bearing: anything secret in a fragment leaks into browser history
and Referer-adjacent surfaces for nothing, since the server never sees it anyway.)

### The raw request, showing exactly what crosses

Lesson 6's socket transcript, re-read as a URL lesson — the authority, path and headers that
actually travel:

```console
--- bytes sent ---
b'GET / HTTP/1.1\r\nHost: 127.0.0.1:8765\r\nConnection: close\r\n\r\n'
```

- **Scheme and port are absent from the message.** The scheme chose TLS-or-not before this;
  the port chose *this* service when the socket connected (both are layer decisions, already
  spent). What the server needs to reconstruct the authority — for HTTP/1.1 virtual hosting —
  is the `Host` header, which carries host *and* non-default port.
- **The path here is `/`** — the origin form. Absolute-form paths (`GET http://host/path`)
  appear only when talking to proxies, a detail that matters when you write one (subject 16).
- **Nothing after a `#` appears** — again the fragment's client-only rule, now visible at byte level.

### URL encoding, the silent correctness rule

The query grammar is `key=value` pairs joined by `&`; any reserved character *inside* a value
must be percent-encoded (`space`→`%20`, `&`→`%26`, `?`→`%3F`, non-ASCII as UTF-8 bytes:
`é`→`%C3%A9`). The rule that prevents a whole bug class: **encode when constructing, decode
once when reading** — a value containing `&` unencoded becomes two parameters (the "wrong
record shown" row above), and double-encoding (`%2520`) is the mirror-image bug. Paths have
their own reserved set (`/`, `?`, `#`) — which is why a search query containing `#` belongs in
the query component, never the path.

## 7. Practical Examples

**Example 1 — decompose any URL with a table you can trust**

```python
# url_parts.py — the lesson's table, executed on an arbitrary URL
from urllib.parse import urlsplit, parse_qsl

u = "https://user:pass@www.example.com:443/blog/post?id=42&ref=home#comments"
p = urlsplit(u)
print("scheme  :", p.scheme)                       # https   → chooses protocol + default port
print("host    :", p.hostname)                     # www.example.com → DNS (lesson 4)
print("port    :", p.port or "(scheme default)")   # 443     → transport (lesson 5)
print("path    :", p.path)                         # /blog/post → server routing (lesson 6)
print("query   :", dict(parse_qsl(p.query)))       # {'id': '42', 'ref': 'home'} → parameters
print("fragment:", p.fragment)                     # comments → CLIENT ONLY, never sent
```

- **Expected output:** the six labelled lines with those exact values (port prints `443`
  here because it was written explicitly; `urlsplit("https://example.com/").port` is `None` —
  the default was never *in* the string).
- **What the important lines do:** `urlsplit` performs the standard's decomposition; `parse_qsl`
  applies the `&`/`=` grammar *and* percent-decoding in one call — doing this by hand with
  `split("&")` is where the encoding bugs of section 6 come from.
- **How to run it:** `python url_parts.py` (standard library only). **Assumptions:** Python 3.13.
  Executed on the authoring machine.

**Example 2 — the default-port equivalence and its cost**

```console
$ curl -s -o /dev/null -w "no port in URL → resolved to port %{remote_port}, HTTP %{http_code}\n" https://example.com/
no port in URL → resolved to port 443, HTTP 200
$ curl -s -o /dev/null -w "explicit :443 → port %{remote_port}, HTTP %{http_code}\n" https://example.com:443/
explicit :443 → port 443, HTTP 200
$ curl -s -o /dev/null -w "non-default :8443 → " https://example.com:8443/ ; echo "exit=$?"
```

- `%{remote_port}` proves the transport ended up on the *same* 443 whether or not the URL
  named it: the scheme supplied the default (section 5's table). The third command's failure
  (no service on 8443) demonstrates the flip side — an explicit port overrides the default,
  and the service must actually be there (the `Connection refused`/timeout row of the failure
  ladder).
- **How to run it:** read-only against `example.com`; `-w` formats per-transfer measurements
  (lesson 6's toolkit).
- **Assumptions:** curl 8.22.0; results recorded in your own output when rerun.

## 8. Real-World Applications

- **Every API call you ever make is this lesson.** REST endpoints (subject 11) live in the
  path; pagination, filtering and sorting live in the query; versioning is chosen between the
  two (path `v1/` vs `Accept` header) — each choice becomes a compatibility contract clients
  depend on. Placing an identifier that contains `/` in a path segment (encode it) versus a
  search string in the query is daily API design.
- **Webhooks and redirects** carry return URLs (`redirect_uri`) whose exact component
  composition is a security boundary (subject 15): matching `https://app.example/callback`
  while allowing `https://app.example/callback.evil.com` is an authority-parsing bug — which is
  why validation uses parsed components (Example 1), never string prefix checks.
- **Server configuration is port/authority arithmetic.** `Listen 443` + `server_name` blocks in
  nginx, `0.0.0.0:8080` in a container with a published port, `--port` flags on every
  dev server — subjects 16–17 are full of decisions that this lesson's components make legible.
- **Deep links and shareability** are why fragments exist: a URL that scrolls to
  `#section` or carries client state in the fragment shares without leaking to the server —
  single-page apps (subject 08) put routing state there precisely *because* of the never-sent
  rule.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Treating a URL as an opaque string | Concatenation "works" until it doesn't | Parameters vanish when a value contains `&` or spaces | Parse with `urlsplit`/`parse_qsl`, build with an encoder (Example 1); never string-concatenate |
| Expecting the server to see the fragment | Fragments are ubiquitous in web URLs | Server logs show no `#value`; feature works in dev where a helper strips it | Fragments are client-only by spec — test at the boundary, not in the browser's address bar |
| Assuming port implies protocol | "It's on 8080 so it's HTTP" | Connection succeeds, protocol garbled | Protocol is negotiated, not numbered; send a probe and read the response (lesson 6's `curl -v`) |
| Putting secrets in query or path | Convenient, and redirects/logs tempt it | Tokens in access logs, Referer headers, browser history | Secrets go in headers or bodies (lesson 15); queries are *cacheable, logged, and visible* |
| Forgetting a default port in firewall/URL maths | 443 and 80 treated as special | Something works with explicit port and fails without, or vice versa | State the resolved `host:port` explicitly when debugging; `%{remote_port}` (Example 2) makes it visible |

## 10. Best Practices

- **Always parse, never split.** Standard-library URL parsers implement the spec's edge cases
  (IPv6 hosts in brackets, empty ports, unicode hosts/punycode); hand-rolled splitting is a
  recurring vulnerability source — Example 1's five lines replace most of it.
- **Decide component placement once, document it in the API.** Identifiers that may contain
  reserved characters, or parameters that must not be cached/logged, each get a declared home
  (path-encoded vs header vs body); consistency across endpoints is what makes clients simple.
- **Log the parsed components, not the raw string.** A log line with scheme, host, path and a
  redacted query gives triage the failure ladder of section 5 without leaking whatever a client
  put in a parameter — and survives URL-encoding differences across callers.
- **Bind deliberately and check with `netstat`.** Development services on `127.0.0.1:port`
  (lesson 2), ephemeral ports for clients, well-known only behind a proxy — the live listing
  in section 5 is the audit you run before saying a service is "local only".

## 11. Limitations and Trade-Offs

- **The URL grammar is old and load-bearing.** `?` and `&` were chosen for simplicity, not
  expressiveness; nested structures force repeated keys or JSON-in-a-parameter — which is why
  APIs increasingly move complex input to bodies (POST-with-query is a real, if awkward,
  compromise: query for *routing/cache key*, body for content).
- **Query strings are not private by construction.** They are visible to every intermediary
  before TLS termination, to server logs, and to browsers' history; fragments are private from
  the server but *not* from the browser. "URL" is not a security boundary — lesson 15's threat
  model is.
- **Port semantics erode behind abstraction.** Containers, reverse proxies and load balancers
  rewrite the authority: the URL's `:443` may terminate three hops before the process that
  serves it (lesson 7's termination diagram). Debugging "which port is this really on" requires
  checking *each* hop's configuration — the URL alone no longer tells you.
- **Fragment state is invisible to the server — by design, sometimes a limitation.** Analytics
  on in-page anchors, server-side rendering of scrolled position, or fragment-based auth handoffs
  all fight the never-sent rule; the answer is usually to move state into the query (accepting
  visibility) or a header/body, not to "just send the fragment".

## 12. Practical Exercises

### Introductory

1. **Exercise 6.1** — Decompose three URLs you use daily (a page, an API call, a search results
   page) with Example 1's script: for each, fill the component table (scheme/host/port/path/
   query/fragment) and mark which components a server at that origin would actually receive.
   **Completion criteria:** three tables from real URLs, produced by the script; the
   "would receive" column correct (fragment excluded in every row) with one sentence citing the
   rule.
2. **Exercise 6.2** — Capture your own machine's listening ports (`netstat -ano | grep LISTENING`
   or `ss -tlnp`) and match five entries to their service names. For each, state its URL scheme
   if a client uses one (`postgresql://`, `redis://`, `https://`) or "not HTTP" if it speaks its
   own protocol.
   **Completion criteria:** five real entries identified; at least one non-HTTP entry explained
   with the port-implied-nothing rule quoted; the wildcard bind (`0.0.0.0` vs `127.0.0.1`)
   noted for each.

### Intermediate

3. **Exercise 6.3** — Build the failure ladder yourself: against one host, produce (a) a DNS
   failure, (b) a refused connection (closed port), (c) a 404, and (d) a successful request —
   with `curl -v` capturing the distinct error for each.
   **Completion criteria:** four real outputs; each mapped to its component row in section 5's
   table; one sentence on why (b) proves DNS *worked* (the address resolved before the refusal).
4. **Exercise 6.4** — Encoding: request `?q=hello world` unencoded, then `?q=hello%20world`,
   then `?q=a%26b=3` against a server that echoes its received query (your lab server's
   `path=` echo suffices). Capture what the server reports parsing for each.
   **Failure to diagnose:** three transcripts; the unencoded case's actual behaviour explained
   (what the HTTP request line becomes when a space is in it); the third case showing `&`
   encoded as a *value* yields one parameter, not two — with the encode-when-constructing rule
   stated.

### Independent problem-solving

5. **Exercise 6.5** — *Problem:* an existing integration at
   `https://api.partner.com/v1/reports/export?month=2026-10&format=csv` must additionally accept
   arbitrary user-supplied report names (which may contain spaces, `&`, `#`, and non-ASCII
   characters) and an optional client-side annotation that must never reach the server. Specify
   the new URL design: which component holds the report name and how it is encoded, which
   holds (or does not hold) the annotation, how the partner's existing parameters survive, and
   what your server must do with encoding before matching.
   **Completion criteria:** a complete new URL with every component justified from section 5's
   placement rules; the annotation's placement argued from the fragment's never-sent property;
   a test matrix (name × special character → expected server-received value) of at least six
   rows; one stated risk of the placement you chose.

*Solutions: attempt first. They live in `exercises/solutions/` of this subject.*

## 13. Knowledge Check

1. A browser loads `https://shop.example/a?x=1#top`. List every component, and for each say
   whether it was used before the connection, travelled in the TLS-encrypted request, or never
   left the browser.
2. Why does the same host appear in DNS, in TLS's SNI, and in the HTTP `Host` header — what
   would break if any one of them were dropped?
3. A service "works on port 8080 in staging and 443 in production, same code." Explain what
   stayed constant across both URLs and what each environment's default did.

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You decomposed real URLs with a parser and correctly marked what reaches the server (exercise 6.1)
- [ ] You identified five live listening services and their addressing from your own machine (exercise 6.2)
- [ ] You produced the four-step failure ladder against a real host (exercise 6.3)
- [ ] You can state the fragment's never-sent rule and its three consequences (secrecy, analytics, state)
- [ ] You can diagnose all five mistakes in section 9

## 15. Summary

- A URL composes five layers into one string: scheme (protocol), host (DNS), port (service), path/query (application), fragment (client only).
- The fragment is never transmitted — proven in the raw request — while path and query are visible to any intermediary after TLS termination.
- Ports are rendezvous numbers, not protocols: well-known for services, ephemeral for clients, and `netstat` shows the live truth.
- The failure ladder follows the URL left to right: resolve → connect → request → route, and each rung has its own message.
- Parse URLs with real parsers, encode on construction, decode once — component-placement and encoding are correctness *and* security decisions.

## 16. Next Steps

- Next lesson: [Browsers and Rendering](browsers-and-rendering.md) — what happens after the bytes arrive: HTML into DOM into pixels
- Practice: [exercises/](exercises/README.md) set 8
- Where it is applied: [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) (routing and query design) and [15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md) (SSRF, open redirects, and token placement)
