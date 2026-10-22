# Solutions — Set 8: URLs and Ports

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Decompose three URLs

**Reference transcript (authoring machine):**

```console
$ python url_parts.py
scheme  : https
host    : www.example.com
port    : 443
path    : /blog/post
query   : {'id': '42', 'ref': 'home'}
fragment: comments
```

- **Three daily URLs** (yours): each row marks server-received = scheme-derived host (via
  `Host`/SNI), path, query — and **fragment: never**. A URL with no fragment still has an
  *empty* fragment column; a URL with `?a=b#x` shows the split exactly as above.
- **The rule cited:** the fragment is client-only — consumed by the browser before the request
  is built (byte-level proof in the lesson: the request line read `GET / HTTP/1.1` with no
  `#secret`).
- **Criteria check:** ☐ three script-produced tables ☐ fragment excluded every row ☐ rule cited.

## Exercise 2 — Five listening ports

**Reference transcript (authoring machine):**

```console
$ netstat -ano | grep LISTENING | head -10
  TCP    0.0.0.0:135    ...  LISTENING  1496
  TCP    0.0.0.0:445    ...  LISTENING  4
  TCP    0.0.0.0:5432   ...  LISTENING  15748
  TCP    0.0.0.0:5672   ...  LISTENING  14084
  TCP    0.0.0.0:6379   ...  LISTENING  12392
```

- Five matched: `135` RPC (Windows), `445` SMB, `5432` PostgreSQL (`postgresql://host:5432/db`),
  `5672` AMQP/RabbitMQ (its own protocol), `6379` Redis (`redis://host:6379/0`).
- **Non-HTTP entry explained:** AMQP on `5672` — a client speaks *AMQP*, not URL-path HTTP;
  the URL grammar still addresses it via scheme (`amqps://`) but the "port 80 = web" intuition
  is what the **port implies nothing** rule forbids.
- **Bind scope:** all five show `0.0.0.0` (all interfaces — reachable from the LAN), versus the
  lab server's deliberate `127.0.0.1` (loopback only).
- **Criteria check:** ☐ five entries ☐ ≥1 non-HTTP + rule ☐ bind scope per entry.

## Exercise 3 — The four-rung failure ladder

**Reference shape** (one host; each rung's real message class):

| Rung | How you produced it | Real message | Component |
|---|---|---|---|
| DNS failure | `curl -v http://typoeexamplee.invalid/` (or the `nslookup` typo: `*** ... can't find ...: Non-existent domain`) | `Could not resolve host` | Host → DNS (lesson 4) |
| Refused | `curl -v http://127.0.0.1:9/` (nothing listening) | `Connection refused` | Port (lessons 2/5) |
| 404 | `curl -v http://127.0.0.1:8765/missing` | `HTTP/1.0 404 Not Found` | Path → application (lesson 6) |
| Success | `curl -v http://127.0.0.1:8765/` | `HTTP/1.0 200 OK` | all clear |

- **Why "refused" proves DNS worked:** the message is a *TCP* reset from a resolved address —
  you cannot have a refused connection to a name that never resolved; DNS already succeeded
  and TCP (lesson 5) reported the port's state.
- **Criteria check:** ☐ four real outputs ☐ four component rows ☐ the DNS-worked sentence.

## Exercise 4 — Partner report URL (independent)

**Reference shape** (one valid design):

```
https://api.partner.com/v1/reports/export
    ?month=2026-10
    &format=csv
    &name=Q3%20summary%20%26%20notes%20%E2%80%94%20final
    &view=spreadsheet#annotations
```

- **Report name → query value, percent-encoded.** Justification: names may contain *reserved*
  characters (`&`, spaces, `#`, non-ASCII); in a query value, each must be encoded (`%20`,
  `%26`, UTF-8 bytes like `%E2%80%94`) or it would be parsed as structure — an unencoded `&`
  splits it into a second parameter, an unencoded `#` truncates everything after as a fragment.
  (Alternative accepted: a *path segment* with `/`-safe encoding — but then every reserved
  character needs path-segment encoding; query is simpler here.)
- **Annotation → fragment (`#annotations`).** Justification: the fragment is **never sent** —
  proven in the lesson's raw request — so a client-side-only annotation cannot leak into logs,
  caches, or the partner's server. Caveat: it *is* in the browser's history — fine for
  annotations, never for secrets.
- **Existing parameters survive:** `month`/`format` untouched; new `name` is *appended* with
  `&` (never `?` twice), preserving order semantics for the partner.
- **Server-side matching:** decode exactly once (after routing) — `urllib.parse.parse_qsl`
  does encoding-aware splitting, so `name` arrives as `Q3 summary & notes — final`; never
  hand-split on `&` first (that's where `&`-in-value bugs come from).
- **Test matrix (≥6 rows):**

| Input name | Encoded as | Server must receive |
|---|---|---|
| `Q3 summary` | `Q3%20summary` | `Q3 summary` |
| `a&b=3` | `a%26b%3D3` | `a&b=3` (one param, not two) |
| `100%` | `100%25` | `100%` (not `%`→decode loop) |
| `café` | `caf%C3%A9` | `café` (UTF-8 bytes) |
| `#tag` | `%23tag` | `#tag` (never a fragment) |
| `a+b` | `a%2Bb` | `a+b` (literal plus ≠ space) |
| `already%20x` | `already%2520x` | `already%20x` (no double-decode) |

- **Stated risk:** query parameters are **visible** to any intermediary after TLS termination
  and land in logs — report names may be sensitive; if a name can carry secrets it belongs in a
  header/body instead (the placement rule cuts both ways).
- **Criteria check:** ☐ full URL + per-component justification ☐ fragment argued from
  never-sent ☐ ≥6-row matrix ☐ one stated risk.

---

Next: [set-9-solutions.md](set-9-solutions.md)
