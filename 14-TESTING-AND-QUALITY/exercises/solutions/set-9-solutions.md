# Set 9 solutions — Security testing → `security-testing.md`

*Executed in the batch's Maven lab: `SecurityBatteryTest` (5 probes over the real filter
chain) plus a shell secrets scan. OWASP dependency-check / ZAP are *labelled reference*.*

## 1. The Content-Type probe + secrets scan

Shape of the added probe (P6): assert the 401 body's `Content-Type` is
`application/problem+json` — it passes on the fixed app. The sentence you owe: if it ever
returned `text/html`, a browser would *render* the error body, and any future debug detail
placed in it becomes an injection surface in the client — content type is a security control,
not metadata.

Secrets scan over your project: the lessons' run was a grep for credential shapes
(access-key prefixes, private-key headers, literal passwords) over the source tree:

```
0 matches (scope: source files only — no history, no dependencies, no build output)
```

Interpretation, two lines: zero means no secret is *formatted* like a secret in the files
scanned; it says nothing about history, blobs, or secrets that don't match known shapes —
which is why the scan is a pre-commit stage (set 11) and not a penetration test.

## 2. Authorization as a table test

Six parameterized cases: {anonymous, wrong token} × {endpoint A, endpoint B} = 4 denials,
plus {right token × 2 endpoints} = 2 successes. Assert per endpoint that the anonymous and
wrong-token bodies are **identical** — the lessons' P1 asserted exactly this
(`401 x2 identical; challenge=Bearer realm="lab"`), because a difference tells the caller
which credential form to focus on.

## 3. Reintroduce a gap (the battery must fail again)

Executed first run of the battery, before the fixes:

```
[ERROR] Tests run: 5, Failures: 2, Errors: 0
  ApiSecurityTest.authorization » 401 must include a WWW-Authenticate challenge
  ApiSecurityTest.hardeningHeaders » X-Content-Type-Options: nosniff must be set
                                   ==> expected: <nosniff> but was: <<absent>>
```

Remove the `WWW-Authenticate` line from production code → same red on P1 → restore →
`Tests run: 5, Failures: 0` with `challenge=Bearer realm="lab"`. Both transcripts quoted is
the criterion: a battery that has only ever been green is unproven. And the fix location:
**both original gaps were fixed in production code** (the challenge line; a
`SecurityHeadersFilter` at `Ordered.HIGHEST_PRECEDENCE` so it wraps the auth filter and
still runs on 401 responses) — never by weakening an assertion.

## 4. Independent — stored-filename traversal (reference test)

Written test, three parts you must state:

- **Payload:** `../../etc/passwd` (POSIX) and `..\..\Windows\win.ini` (Windows), plus a
  URL-encoded `%2e%2e%2f` variant.
- **Assertion point:** *after* storage — list the real directory the server writes to and
  assert the file exists **inside** it (asserting only the request path proves nothing,
  because naive code concatenates exactly where you did not look).
- **Expected failure transcript for a naive implementation:** the disk listing shows the
  file outside the root, or the write throws; your test asserts `assertFalse(outsideRoot)`
  and the naive code turns it red.

```
# naive impl, executed shape:
stored: /var/app/uploads/../../etc/passwd  -> ESCAPED ROOT => test RED
fixed impl (sanitize + resolve + startsWith check):
stored: /var/app/uploads/passwd            -> inside root => test GREEN
```

Part you cannot run locally (a real container's filesystem layout) is labelled reference
with the exact environment it needs; the naive-vs-fixed pair you *can* run in a temp
directory today — run it.