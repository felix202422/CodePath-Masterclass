# Set 10 solutions — Authorization · OAuth2 and OpenID Connect → `authorization.md` · `oauth2-and-openid-connect.md`

*Executed in the batch's security run: the IDOR and role-gate batteries in
`spring-smoke`, and the full local OIDC code+PKCE flow with three rejected attacks.*

## 1. The IDOR drill

Two users, one resource: `ade` creates order `id=1`.

```
GET /api/orders/1   (X-User: bea)  → 404, Content-Length: 0
GET /api/orders/424242 (X-User: bea) → 404, Content-Length: 0
```

Byte comparison: `assertEquals(foreign, missing)` passes on the raw strings — both
empty, so there is no existence oracle: the response cannot say *exists-but-yours*
vs *does not exist*. The broken variant, captured: I temporarily made the handler
return `404 {"detail":"order not found"}` for foreign and `404 {"detail":"no such
order"}` for missing — two runs, two bodies, and the contract test went red on the
same assertion with both bodies printed. Fixed by routing both through
`ResponseEntity.notFound()` (empty body), green again. The rule written: existence is
not observable; *authorization failures must be indistinguishable from absence*.

## 2. Role gate at the service layer

Two captures: `POST /internal/reports` as `role=USER` → **403** envelope
(`…/forbidden`); as `role=ADMIN` → 200. The gate located by reading (quoted):

```java
if (!isAdmin) throw new Forbidden("platform statistics require ADMIN");
```

…inside `OrderService.platformStats(...)` — *not* in the controller, even though the
403 appears there: the advice maps `Forbidden → 403`, the service decides. The test
(executed, plain unit):

```java
assertThrows(OrderService.Forbidden.class, () -> svc.platformStats("ade", "USER"));
assertNotNull(svc.platformStats("root", "ADMIN"));
```

Why the service: the same method is reachable from a scheduled job and a CLI import —
a controller-only check would let both waltz past. One sentence, one capture: moving the
check is what makes it hold for every transport.

## 3. OAuth2 authorization-code flow, walked (executed)

Four captures from this batch's provider probe:

1. **Authorize redirect** — `…/authorize?response_type=code&client_id=…&redirect_uri=…&
   scope=openid profile&state=7f3c…&code_challenge=…&code_challenge_method=S256` →
   consent → `302` to the app's callback with `code` and the **same** `state`.
2. **Callback** — app verifies `state` matches (capture: mismatched state → the flow
   aborts before any token request).
3. **Token exchange** — `POST /token` with `grant_type=authorization_code`, `code`,
   `redirect_uri`, `code_verifier` → `200` with `access_token`, `id_token`, `expires_in`.
4. **Authenticated request** — `Authorization: Bearer …` on `/me` → `200`, claims
   checklist filled from the id token (`iss`, `sub`, `aud`, `exp`, `nonce` verified).

The three attacks, each rejected with its capture: **state swap** (attacker's `state`
in the callback) → rejected before the token call; **code replay** (second exchange of
the same code) → refused — the provider marks the code used (capture: `invalid_grant`);
**missing PKCE** (request without challenge / wrong verifier) → `invalid_grant`, S256
verifier mismatch quoted. The lesson's point proven by execution: all three defenses
are *server-side* — the app's own code is what refuses, not the browser's.

## 4. Independent — authorization matrix (reference shape)

The matrix for the brief-2 API (roles × actions):

| Action | MEMBER | OWNER | ADMIN |
|---|---|---|---|
| Read own orders | ✓ (by ownership) | ✓ | ✓ |
| Read anyone's orders | ✗ 403/404 | ✓ | ✓ |
| Delete any order | ✗ | own only | ✓ |
| Manage users | ✗ | ✗ | ✓ |

Three cells implemented in the service; four tests green — including
`owner_reads_foreign_and_missing_are_indistinguishable` (cell 2) and the
`platformStats` gate (cell 4). The escalation test, red-then-green: I deleted the
ownership line in `find`, ran only `OrderServiceTest`, captured the red
(`foreign reader gets empty ==> expected true but was false`), restored the line, and
re-ran to green. The captured red is the artifact the set demands: it is the test
*proving* it would catch the regression, not merely passing while it exists.
