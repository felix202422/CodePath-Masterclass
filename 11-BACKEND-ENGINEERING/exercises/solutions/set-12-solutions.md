# Set 12 solutions — API documentation · Logging · Backend testing → `api-documentation.md` · `logging.md` · `backend-testing.md`

*Executed in the batch: the OpenAPI validator run (4/4 green), the logging battery
runs A/B/C, and the final `mvn test` suite with the deliberate-break drill.*

## 1. Contract from code, checked against runtime

Validator capture (a real validator against the lab's `openapi.yaml`):

```
4/4 green — structure, references, schemas, examples all valid
```

Diff, two responses:

| Case | Documented | Actual | Resolution |
|---|---|---|---|
| `POST /api/orders` happy | 201 | 201 | match |
| Missing `sku` | 400, one `fieldErrors[0]` | 400, `fieldErrors` with `sku` **and** `qty` sorted | **doc fixed** — the contract undersold the server |

The discrepancy I chose *not* to "fix by loosening the doc": the documented 404 body
showed an envelope; the actual is empty (the IDOR rule). Code is right, doc was wrong —
the doc now says `Empty response body — see authorization note`, because documenting the
absence is what stops the next reader from "fixing" it.

## 2. Correlation logging, three level runs

One request's path, `rid=7f3c…` in every line (run A, INFO):

```
req  rid=7f3c method=POST path=/auth/login
login rejected user=ade          (WARN)
res  rid=7f3c status=401
```

Run B (`DEBUG`): added the auth-service decision lines (user found? bcrypt result) —
same rid, deeper story. Run C (`WARN`): only the WARN survived, and the `Started
SmokeApplication` banner disappeared too — **executed gotcha**: its logger *is* in
`com.example.smoke`, so the level override silenced my readiness signal; the fix was to
probe readiness with a framework logger or an HTTP endpoint instead of grepping for the
banner. Level policy written: ERROR = something failed and a human may need to act now;
WARN = abnormal but handled (the rejected login is *expected* flow — it is WARN because
it is security-relevant, not because it is broken); INFO = the state changes an on-call
engineer reconstructs a night from; DEBUG = decision-level detail, off in production.

## 3. The no-secrets scan

Full auth flow (register → login → authenticated GET → logout), all log files
collected, then:

```
$ grep -c 'correct horse' logs/*.log     # the password used in testing
0
$ grep -c 'eyJhbGciOi' logs/*.log        # the token prefix
0
```

Zero occurrences of each. The masking mechanism: `@JsonIgnore`-style serialization rules
don't reach logs — the actual worker was the manual mask in the auth logger (the
`login rejected user=…` line logs the *username only* by construction) plus Spring's
env masking (`******` for `DB_PASSWORD` in the actuator `env` capture). The line an
on-call engineer sees at 03:00, quoted:

```
2026-10-28 03:12:44 WARN  [rid=7f3c] c.e.s.AuthController - login rejected user=ade
```

— who, what, when, and the rid to grep the rest of the path with — and nothing that
would be a finding if the log were pasted into a ticket.

## 4. Independent — the red-green drill

The rule: *login failures are byte-identical*. Encoded as
`ApiContractTest.login_failures_are_byte_identical`.

**Green run:**

```
Tests run: 15, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

**The break** — one line in the 401 handler: `"detail", "no account for " + username`.
**Red capture:**

```
AssertionFailedError: no enumeration signal: both 401 bodies byte-equal
  ==> expected: <…"detail":"no account for ade">
       but was: <…"detail":"no account for ghost">
BUILD FAILURE
```

**Fixed →** `Tests run: 15 … BUILD SUCCESS` again.

One sentence on what the failure message proved that manual `curl` could not: the
diff was *printed by the build, on every future change, to anyone who touches the
handler* — a manual curl proves today's code once; this test proves the rule at every
commit, including the ones you do not remember making.
