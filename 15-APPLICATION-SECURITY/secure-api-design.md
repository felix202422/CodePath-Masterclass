# Secure API Design

> Every transcript in this lesson was executed on the authoring machine (Windows 11,
> Python 3.13.5, standard library only) in the batch-17 `seclab-C` scratch lab. The
> database URL, password, and stack frames in the capture are **lab fixtures**, not real
> systems; distributed (multi-node) rate limiting, `X-Forwarded-For` handling, and API
> security scanners were not run and are marked *labelled reference*.

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Explain what rate limiting protects and why it must be keyed per client, not globally
- [ ] Demonstrate a fixed-window limiter: five successes, then `429` with `Retry-After`, while a second client stays unaffected
- [ ] Diagnose error responses that leak internals — a connection string with a password, a stack frame — and replace them with a stable envelope carrying a code and request id
- [ ] List the design-level controls (mass-assignment allowlists, uniform errors, bounded queries) and say which layer each belongs to
- [ ] Distinguish what error hygiene hides from what it does not fix (authorization, logic bugs)

## 2. Prerequisites

- [Access Control](access-control.md) — authentication identifies the client; authorization decides what it may do — rate limiting is neither
- [SSRF](ssrf.md) — the outbound-fetch feature whose hardened endpoint this lesson complements
- [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — routing, request handling, and the response conventions this lesson refines
- [14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — proving each control with a test, as the probe's phases do

*No code prerequisite beyond reading Python — the probe is printed in full and uses only the standard library.*

## 3. Introduction

Secure API design is the discipline of deciding *before the attacker does* how much a
single client may ask for, what a failure is allowed to say, and which fields a request
may set. Most API incidents are not clever exploits: they are an endpoint that accepts
ten thousand login attempts a minute, an exception handler that helpfully returns the
database connection string, or a `PATCH /me` that happily sets `is_admin`. This lesson
runs all three shapes locally — a limiter that trips at exactly the fifth request, and
two error paths that leak versus hide — so the differences are bytes you can compare.

## 4. The Problem It Solves

APIs are machine-facing, so abuse is cheap and volume is the default:

- **No rate limit means unlimited guesses.** Credential stuffing, token brute force, enumeration of user ids, scraping — all at the attacker's bandwidth, on your compute. Phase 1 is the control: five requests pass, the next four answer `429`.
- **Exceptions are documents.** A raw error names the database host, the user, the library version, the query — every line is reconnaissance. Phase 2's leaky response publishes `postgres://api_app:DevPass99@...` to whoever triggered the failure.
- **The request body is not your object.** Frameworks that bind the JSON straight onto the record (`update(**payload)`) let the client decide which columns exist — the origin of `is_admin=true` escalations (mass assignment, section 5).
- **Debug mode outlives development.** `"debug": true`, stack traces, `dev` headers: settings that were correct on a laptop and shipped to production by accident.

Designing these three answers *once* — how much, what to say, what to bind — turns a
class of incidents into configuration.

## 5. Core Concepts

### Rate limiting, keyed fairly

A **rate limiter** counts requests per **client key** inside a **time window** and rejects
the excess with `429 Too Many Requests`. The probe uses a **fixed window**: keep
`[window_start, count]` per key; reset when the window elapses; reject when
`count > max`. Two properties matter:

- **Per-client keying.** Phase 1's client-A exhausts `5 per 10s` while client-B's login still returns `200` — a *global* counter would let one abusive client lock out everyone (denial of service as a service).
- **A speakable retry.** `429` carries `Retry-After: 9` (seconds until the window resets) and `X-RateLimit-Limit`, so an honest client can back off instead of hammering.

Alternatives — **token bucket** (bursts allowed, steady drain) and **sliding windows**
(no boundary burst) — change the arithmetic, not the contract. Limiter state across
multiple server nodes needs a shared store (Redis etc.); the probe's dict is one process
— *labelled reference*.

### Error hygiene

**Error hygiene** is the rule that a failure response contains only what a *client* can
act on: a stable envelope, a machine-readable `code`, and a `request_id` that ties the
response to server-side logs. It never contains connection strings, stack frames, query
text, or internal hostnames. Phase 2 and phase 3 each run the same failure twice —
`leaky` then `fixed` — so you can diff the two bodies line by line.

- **The leak is not theoretical:** phase 2's leaky body includes a *password* (`DevPass99`) because a DSN was interpolated into the message.
- **The fix is not silence:** `{"error": "internal error", "code": "AUTH_UPSTREAM", "request_id": "req_lab_0001"}` still tells the client *which kind* of failure occurred and gives support a correlation id — the details live in the log the request id points to.

### Mass assignment

**Mass assignment** is when request fields map directly onto stored object fields. The
control is an **allowlist of writable fields** per endpoint — the client may set
`email` and `displayName`; it never sets `role`, `is_admin`, `balance`, or `id`.
Framework conveniences (`Model(**request.json)`, `update_attributes(params)`) are the
usual cause; the fix is explicit field lists, enforced *server-side*.

### Bounded everything

Every list endpoint needs a **pagination cap**, every search a **time budget**, every
export a **row limit** — unbounded reads are a rate-limit bypass that costs one request
per gigabyte. Combined with the limiter, this is the "how much may one client ask for"
half of API design; error hygiene is the "what may one failure say" half.

## 6. How It Works

```mermaid
flowchart LR
    C[Client A] --> L{Rate limiter: 5 / 10s}
    L -->|count 1..5| H[Handler: 200 OK]
    L -->|count 6+| R[429 + Retry-After]
    C2[Client B] --> L
    L -->|own bucket| H
    H -->|raises| E{Error handler}
    E -->|leaky: str e / stack| X[500 with DSN + stack frame]
    E -->|hygienic envelope| Y[500 with code + request_id]
```

The limiter sits *before* the handler — a rejected request must never touch your
database — and the error handler is the *last* layer every exception funnels through,
so one sanitizing handler fixes every route at once.

## 7. Practical Examples

**Example 1 — the full probe: the limiter tripping, then leaky vs hygienic errors**

```python
# SEC-11 secure-API probe: per-client rate limiting with 429, and error responses
# that leak vs. hide internals. Standard library only. Run: python api_probe.py
import json
import threading
import time
import http.client
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 8101
LIMIT = {"enabled": True, "max": 5, "window": 10.0}
BUCKETS = {}                     # client key -> [window_start, count]
ERRORS = {"leaky": True}         # True: raw traceback text; False: sanitized envelope
DB_URL = "postgres://api_app:DevPass99@10.0.4.11:5432/prod"


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):
        pass

    def _send(self, code, obj, extra=None):
        body = json.dumps(obj).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def _rate_limited(self, key):
        if not LIMIT["enabled"]:
            return False
        now = time.time()
        start, count = BUCKETS.get(key, (now, 0))
        if now - start > LIMIT["window"]:
            start, count = now, 0
        count += 1
        BUCKETS[key] = [start, count]
        if count > LIMIT["max"]:
            retry = max(1, int(start + LIMIT["window"] - now))
            self._send(429, {"error": "rate limit exceeded"},
                       {"Retry-After": str(retry), "X-RateLimit-Limit": str(LIMIT["max"])})
            return True
        return False

    def do_POST(self):
        n = int(self.headers.get("Content-Length", 0))
        data = json.loads(self.rfile.read(n or 0) or b"{}")
        if self.path == "/login":
            client = self.headers.get("X-Client-Id", "anon")
            if self._rate_limited(client):
                return
            if data.get("user") == "boom":            # forces the handler to crash
                try:
                    raise ValueError(f"login failed against {DB_URL}")
                except ValueError as e:
                    if ERRORS["leaky"]:
                        return self._send(500, {"error": str(e), "debug": True})
                    return self._send(500, {"error": "internal error",
                                            "code": "AUTH_UPSTREAM",
                                            "request_id": "req_lab_0001"})
            self._send(200, {"user": data.get("user"), "token": "lab-token"})
        elif self.path == "/admin/config":
            if ERRORS["leaky"]:
                return self._send(500, {"error": "unhandled", "debug": True,
                                        "stack": "File app.py line 42\n  connect(DB_URL)"})
            return self._send(500, {"error": "internal error", "code": "INTERNAL",
                                    "request_id": "req_lab_0002"})
        else:
            self._send(404, {"error": "not found"})


def req(method, path, body=None, client=None):
    c = http.client.HTTPConnection("127.0.0.1", PORT, timeout=5)
    h = {"Content-Type": "application/json"}
    if client:
        h["X-Client-Id"] = client
    c.request(method, path, json.dumps(body) if body is not None else None, h)
    r = c.getresponse()
    raw = r.read().decode()
    retry = r.getheader("Retry-After")
    c.close()
    return r.status, raw, retry


server = HTTPServer(("127.0.0.1", PORT), Handler)
threading.Thread(target=server.serve_forever, daemon=True).start()

print("=== 1. rate limiting: 8 logins from one client, limit 5 per 10s ===")
statuses = []
for i in range(8):
    st, body, retry = req("POST", "/login", {"user": "alice"}, client="client-A")
    statuses.append(st)
print(f"  status codes: {statuses}")
st, body, retry = req("POST", "/login", {"user": "alice"}, client="client-A")
print(f"  9th request -> {st}: {body} Retry-After: {retry}")
st, body, retry = req("POST", "/login", {"user": "alice"}, client="client-B")
print(f"  other client unaffected -> {st}: {body}")

print()
print("=== 2. error hygiene: what a failed login returns ===")
ERRORS["leaky"] = True
st, body, _ = req("POST", "/login", {"user": "boom"})
print(f"  leaky : {st}: {body}")
ERRORS["leaky"] = False
st, body, _ = req("POST", "/login", {"user": "boom"})
print(f"  fixed : {st}: {body}")

print()
print("=== 3. error hygiene: a crashing admin route ===")
ERRORS["leaky"] = True
st, body, _ = req("POST", "/admin/config", {})
print(f"  leaky : {st}: {body}")
ERRORS["leaky"] = False
st, body, _ = req("POST", "/admin/config", {})
print(f"  fixed : {st}: {body}")

server.shutdown()
```

- Phase 1's status list is the limiter's contract made visible: exactly five `200`s, then `429`s — and the `9th request` line shows the `Retry-After` the client is told to obey, while client-B proves the counter is per-client.
- Phases 2 and 3 each compare the *same* failure under both handlers. The leaky bodies carry a DSN with a password and a stack frame naming `DB_URL`; the fixed bodies differ only in `code` and `request_id`, never in internals.
- The `boom` trigger and the crashing admin route stand in for any exception your code can raise — the handler is where hygiene is enforced, not each `except`.
- **Expected output:** the capture below.
- **How to run it:** `python api_probe.py` (Windows 11, Python 3.13.5).
- **Assumptions:** standard library only; single process (in-memory buckets); DSN/password are fixtures.

**Executed capture:**

```text
=== 1. rate limiting: 8 logins from one client, limit 5 per 10s ===
  status codes: [200, 200, 200, 200, 200, 429, 429, 429]
  9th request -> 429: {"error": "rate limit exceeded"} Retry-After: 9
  other client unaffected -> 200: {"user": "alice", "token": "lab-token"}

=== 2. error hygiene: what a failed login returns ===
  leaky : 500: {"error": "login failed against postgres://api_app:DevPass99@10.0.4.11:5432/prod", "debug": true}
  fixed : 500: {"error": "internal error", "code": "AUTH_UPSTREAM", "request_id": "req_lab_0001"}

=== 3. error hygiene: a crashing admin route ===
  leaky : 500: {"error": "unhandled", "debug": true, "stack": "File app.py line 42\n  connect(DB_URL)"}
  fixed : 500: {"error": "internal error", "code": "INTERNAL", "request_id": "req_lab_0002"}
```

**Example 2 — writable-field allowlist against mass assignment (illustration)**

```python
# PATCH /api/me  body: any JSON object the client sends
WRITABLE = {"email", "displayName"}          # explicit per-endpoint allowlist

def apply_profile(user, payload):
    for field, value in payload.items():
        if field not in WRITABLE:
            raise ValueError(f"field '{field}' is not writable")   # reject, don't ignore
        setattr(user, field, value)
    db.save(user)

# NEVER:  user.__dict__.update(payload)
# NEVER:  Model.objects.filter(id=uid).update(**payload)   # binds 'is_admin' too
# The deny-by-default list is the control; ORM shortcuts are how it gets skipped.
```

- **Expected output:** no output — the shape of the control this lesson argues for; test it with `{"is_admin": true}` expecting the `ValueError`.
- **Assumptions:** illustration; the probe executed the limiter and error paths only.

## 8. Real-World Applications

- **Login, password-reset, and OTP endpoints** are the canonical rate-limited routes — the limiter in phase 1 is the anti-stuffing control in front of [password-security.md](password-security.md).
- **Public APIs** ship `429` + `Retry-After` + `X-RateLimit-*` as documented contract; clients and SDKs are written against them.
- **Uniform error envelopes** with request ids appear in every mature API's changelog — support starts from the id, logs hold the stack, the client sees neither.
- **Allowlisted writes** are the standard review point for `PATCH`/`PUT` endpoints and ORMs with mass-assignment protections (Rails `strong_parameters`, Django `ModelForm` explicit fields).
- Paired with: [access-control.md](access-control.md) for *which* client may call the endpoint at all, and [secrets-management.md](secrets-management.md) for the DSN that phase 2's leaky body would have exposed.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| No limit on auth routes | "UI disables the button" | Thousands of `/login` attempts accepted | Limiter before the handler, keyed per client (phase 1) |
| One global bucket | Simplicity | One client's burst 429s everyone | Key by authenticated client (and IP fallback for anonymous) |
| `429` without `Retry-After` | Status code alone | Clients retry instantly and worsen the storm | Always send `Retry-After` + limit headers |
| Raw exception as response | Default error middleware | Phase 2's DSN with password in the body | One central handler emitting the fixed envelope |
| `"debug": true` in production | Config never flipped | Stack frames on public endpoints | Debug flag from environment; error pages never branch on it |
| Request body bound straight to the model | Framework convenience | `is_admin` settable via `PATCH /me` | Per-endpoint writable-field allowlist (Example 2) |
| Unbounded list/export endpoints | "We need all rows" | One request returns millions of rows | Pagination caps and row limits on every collection |
| Error text echoing user input | Helpful messages | Reflected payload in error JSON | Codes + request ids; details in logs, not responses |

## 10. Best Practices

- **Limit before you parse and before you touch storage.** The rule stops where cost is genuinely proportional to work you've already done — but for auth and search, order matters: cheap rejection first.
- **Key limits by identity, fall back to IP.** Behind a proxy, trust `X-Forwarded-For` only from your own proxy — otherwise clients forge it (this was not exercised — *labelled reference*).
- **Make `429` cooperative**: `Retry-After` computed from the window (the probe's `int(start + window - now)`), plus the headers clients document against.
- **One error handler for the whole API.** Every exception funnels to it; it logs the stack with the request id and returns the envelope — the pattern of phases 2–3, applied once centrally.
- **Treat every error body as public.** If a message would embarrass you in a log line a stranger read, it doesn't go in the response.
- **Allowlist writable fields explicitly** and *reject* unknown fields, so a client typo fails loudly instead of silently doing nothing.
- **Put caps on collections by default**: default and maximum page sizes live in the framework layer, not per-route memory.

## 11. Limitations and Trade-Offs

- **The probe's limiter is fixed-window and in-process.** Fixed windows allow a burst across a boundary (up to `2×max` around the edge); a dict does not survive multiple server nodes — production needs a shared store or an edge limiter, neither run here (*labelled reference*).
- **Error hygiene hides internals, not facts.** A stable `AUTH_UPSTREAM` code still tells an attacker the login path touches an upstream — pairing it with [access-control.md](access-control.md) and generic auth failures ("invalid credentials", not "no such user") limits enumeration.
- **Rate limits are not authorization.** They slow guessing; they don't decide who may read what, and a limit keyed too loosely lets an attacker *buy* time by rotating keys/IPs.
- **Allowlisting write fields adds friction.** Every new field needs a deliberate edit — that friction is the feature, but teams must accept it rather than adding a "just allow all" escape hatch.
- **This lesson timed nothing real.** No scanner, no load generator, no distributed counter — the claims are about the bytes in the capture and the design reasoning around them.

## 12. Practical Exercises

### Introductory

1. **Exercise 11.1** — Run the probe and write down both error bodies from phase 2 side by side; underline every byte the leaky one exposes that the fixed one doesn't. **Completion criteria:** a diff listing including the password and the `debug` flag, each labelled with the risk it creates.
2. **Exercise 11.2** — Change `LIMIT["max"]` to 3, rerun, and explain the new status list using the window arithmetic (`now - start > window`). **Completion criteria:** a capture with three `200`s and a one-sentence explanation of when the window resets.

### Intermediate

3. **Exercise 11.3** — Make the limiter return `429` for client-B too (a global bucket) and capture the difference from phase 1; then restore per-client keying. **Completion criteria:** two captures showing client-B blocked in one and `200` in the other, with a paragraph on which behavior an attacker would prefer.
4. **Exercise 11.4** — Add `X-RateLimit-Remaining` and `X-RateLimit-Reset` headers to every response, not just the `429`. **Completion criteria:** a capture where a passing request reports `Remaining: 4` after the first call.

### Independent problem-solving

5. **Exercise 11.5** — Design the API error contract for your Project 07 backend: envelope shape, code taxonomy, request-id lifecycle, and what is never included. **Completion criteria:** a one-page contract plus a failing-then-passing test that a raised exception returns the envelope with *no* substring from the original message — using phase 2's DSN as the test input.

*Solutions: attempt first. They live in `solutions/` of this subject.*

## 13. Knowledge Check

1. Phase 1 shows client-B unaffected. What breaks if the counter were global, and what changes if the key were only the client's IP address behind a corporate NAT?
2. What does the fixed phase-2 body give the *client* that the leaky one doesn't — and what does it deliberately withhold, where does the withheld information live instead?
3. Why does mass assignment belong to *design* rather than *validation*, and which request methods are its usual vehicles?
4. When would a tighter rate limit be the wrong fix for an abuse you're seeing?

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You can explain rate limiting in terms of client keys and windows, and justify `429` + `Retry-After` as a contract
- [ ] You can reproduce phases 1–3 from a blank editor and interpret every status code and header
- [ ] You can rewrite a leaky error response into the fixed envelope without losing client-actionable information
- [ ] You can spot mass assignment in code you read and name the allowlist fix
- [ ] You can state two things error hygiene does *not* protect against

## 15. Summary

- API abuse is volume; a per-client limiter (5 per 10s in the probe) bounds it, and `Retry-After` tells honest clients how to back off.
- One client's burst must never consume another's budget — keying is the design decision, not the threshold.
- Error bodies are public documents: the leaky phases publish a DSN password and a stack frame; the fixed ones publish a code and a request id.
- Hygiene lives in one central handler, so every route inherits it at once.
- Mass assignment is the design twin of both: decide the writable fields before the client suggests them.

## 16. Next Steps

- Next lesson: [Secrets Management](secrets-management.md) — where the credentials those leaky errors expose should live instead
- Practice: the subject's exercise set (written with its exercise installment)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)'s
  security checklist, and the safe-use rules in [SECURITY.md](../SECURITY.md)