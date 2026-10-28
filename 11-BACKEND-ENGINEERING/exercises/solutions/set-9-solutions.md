# Set 9 solutions — Authentication · Sessions and tokens → `authentication.md` · `sessions-and-tokens.md`

*Executed in the batch's `spring-smoke` lab: the uniform-failure battery, the session
lifecycle, and the JWT anatomy/verification probes.*

## 1. The uniform-failure drill

Registered `ade`; two failed logins captured:

```
(a) POST /auth/login {"username":"ade","password":"wrong password 9"}
    → 401 {"type":"…/credentials","status":401,"detail":"invalid credentials"}

(b) POST /auth/login {"username":"ghost","password":"wrong password 9"}
    → 401 {"type":"…/credentials","status":401,"detail":"invalid credentials"}
```

Byte comparison: identical strings — the contract test asserts
`assertEquals(wrongBody, unknownBody)` with the message *"no enumeration signal"*.
Timing equalization executed: `AuthService` computes a bcrypt match against a
`DUMMY_HASH` when the user is unknown ("burn the same time"), so (b) pays the same
~120 ms as (a) instead of returning instantly. Evidence kept from the deliberate break:
when the handler leaked `detail: "no account for ghost"`, this exact test went red with
both bodies printed — the drill in set 12 is the same one.

## 2. Session lifecycle, five requests

| Step | Request | Executed |
|---|---|---|
| 1 | `POST /auth/register` | 201 |
| 2 | `POST /auth/login` | 200 + `Set-Cookie: SESSION=…; Path=/; HttpOnly; SameSite=Lax` |
| 3 | `GET /api/orders` + cookie | 200 |
| 4 | `POST /auth/logout` | 204 (server-side session deleted) |
| 5 | replay old cookie | **401** |

Flags quoted from the response: `HttpOnly` (no `document.cookie` reach), `SameSite=Lax`
(cross-site POST carries no cookie — the CSRF shape), `Secure` in the production profile
(the lab runs plain http, and the lesson says which profile adds it). Server-side store
named: the session id maps to a row in the database (or in-memory map in the lab —
restart logs you out, which is the exercise's point about where state lives).

## 3. JWT anatomy, verified

Decoded (no signature check — `base64 -d` on segment 2):

```json
{"sub":"ade","role":"USER","iss":"auth.example.invalid","iat":1761650000,"exp":1761653600}
```

Segments: header `{"alg":"HS256","typ":"JWT"}` · payload above · signature (opaque).
Claims checklist filled: `iss` present, `sub` = the user, `iat` < `exp` by 1 hour.
Verified properly: recomputed `HMAC-SHA256(header.payload, secret)` and compared — a
flipped payload byte (`sub:"root"`) broke the comparison (capture: signature mismatch →
401). The one sentence: base64 is a *transport* encoding — anyone can edit the payload
and re-encode; only the signature makes it a claim, which is why "decoded but unverified"
is also the correct description of every JWT debugger on the internet. Expired token
request captured: `401` with `…/credentials`-family detail (the `exp` check runs before
any lookup).

## 4. Independent — sessions chosen for the team dashboard (reference shape)

Choice: **server sessions**, defended in five sentences citing the lessons:
(1) logout-everywhere is a *requirement* here, and a session is one row to delete while
a JWT must be revoked through a denylist that reintroduces the state you fled;
(2) a dashboard's requests are same-origin, so cookie delivery already works and no
localStorage is needed (XSS surface shrinks); (3) scale cost is one indexed row-read per
request, cheap until millions of concurrent sessions — at which point a shared session
store, not a protocol change, is the fix; (4) JWT's statelessness pays only when
verification must happen at a *different* service than the session store; (5) the
revocation story is literally executable: `delete from sessions where id=…`, verified by
the replay capture in exercise 2. Flow captured end-to-end: register → login →
authenticated GET → logout → replay 401.
