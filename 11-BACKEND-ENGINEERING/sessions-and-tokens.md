# Sessions and Tokens

## 1. Learning Objectives

After this lesson you can:

- [ ] State the difference between a **session** (opaque reference) and a **token**
      (self-contained claim) in one sentence each — then point at the executed proofs:
      the cookie `LABSESSION=dc96e1...` that resolves server-side versus the
      three-part JWT readable with `base64url -d`
- [ ] Execute the session lifecycle end to end — issue, use, miss, guess, revoke
      (executed: `S1` cookie set `HttpOnly` → `S2` authenticated `ageMillis` →
      `S3/S4` `401` → `S5 revoked:true serverSessions:0` → **`S6` same cookie now 401**)
- [ ] Build a JWT *without a library* and understand what each part is — signed
      two-part input with HMAC-SHA256 appended (executed: clean `verify: true`)
- [ ] Test a token like an attacker: tampered payload, wrong key, expired claim,
      `alg=none` line (executed: `false`, `false`, *signature true but expired=true*,
      `false`)
- [ ] Choose between the two for a given system using the real trade-offs —
      revocation vs statelessness, server memory vs signature verification — and name
      which one the lab's authorization header swap (Exercise 13.5) requires
- [ ] Recognize the classic token defects in review: `base64` mistaken for
      encryption, `==` on signatures, `alg` taken from the token, `exp` never checked

## 2. Prerequisites

- [Authentication](authentication.md) — credentials verified; this lesson issues the
  proof that travels on subsequent requests.
- [Authorization](authorization.md) — the header stand-in this lesson retires
  (`X-User`/`X-Role` → verified session cookie or token claims).
- [HTTP and REST APIs](http-and-rest-apis.md) — cookies, headers, and why stateless
  protocols need carried identity at all.

## 3. Introduction

HTTP forgets: every request arrives alone, and the server's memory of your login must
be *re-established* each time. Two families of answer exist, and this lesson executes
both from scratch. The **session** is a handshake — the server invents an unguessable
string, stores the state, and the browser returns the string as a cookie; the lesson's
S-battery shows the full life including the part that matters most, S5→S6: deleting
the server-side entry kills the credential even though the cookie still exists. The
**token** is a document — header, payload, signature, verified without any server
memory — built here with `javax.crypto.Mac` and decoded with `base64url -d` so that
every claim about JWT internals ("it's just encoded, not encrypted", "verification is
one HMAC and a constant-time compare") comes from output you produced, not from a
diagram.

## 4. The Problem It Solves

Before carried identity, servers had two bad options. **Re-login every request** —
correct but unusable. **Server-side memory with no credential discipline** — an
identifier so guessable that "session fixation" and "session guessing" were once
routine (sequential ids, no expiry, no rotation). The session pattern fixed the *wire*
problem (one strong random reference, HttpOnly cookie, expiry, revocation) but keeps a
per-user cost on the server: every login is a row in memory, so the design doesn't
horizontally scale without shared storage, and logout is only as real as the store's
delete. Tokens — JWTs specifically — fixed the *scale* problem: any server with the
key (or public key) validates a request alone, no shared state. But a self-contained
claim **cannot be revoked before `exp`** without reintroducing state, and its readable
payload invites the belief that encoding hides claims. Both designs are correct;
choosing one means naming which constraint you actually have — which is what the two
executed batteries, side by side, are for.

## 5. Core Concepts

### The session: a reference, executed

```console
=== S1 login
status=200  {"serverSessions":1,"user":"ade","status":200}
#HttpOnly_127.0.0.1  FALSE / FALSE 1793182382  LABSESSION  dc96e14e7d604557a2f91836e35c1ce5
=== S2 me with cookie      status=200 {"user":"ade","ageMillis":646}
=== S3 me without cookie   status=401 {"detail":"no active session"}
=== S4 guessed sid         status=401 {"detail":"no active session"}
=== S5 logout              status=200 {"revoked":true,"serverSessions":0}
=== S6 same cookie after   status=401 {"detail":"no active session"}
```

Read each capture as a property:

- **The cookie carries no identity** — 32 hex chars of server-invented randomness;
  `ade` appears only in the server's `sessions` map. Steal the cookie and you get the
  session (the point of HttpOnly + Secure + SameSite), but learn nothing from reading
  it.
- **HttpOnly and SameSite=Strict are visible in the jar line** (`#HttpOnly`, the
  `Strict` attribute from the `ResponseCookie` builder) — the script-theft and
  cross-site-request mitigations are wire facts you can `grep` in a cookie jar.
- **Miss and guess are indistinguishable** (S3 ≡ S4): a random unknown id and no id
  at all produce the same `401` — the same no-oracle discipline as lesson 13.
- **S5→S6 is revocation, proven**: the *same cookie bytes* that worked in S2 return
  `401` after the server-side delete. This is the session's headline advantage over
  tokens, captured in two lines.

### The token: a document, executed — built without a library

```java
String signingInput = b64url(header) + "." + b64url(payload);
signature = b64url(HMACSHA256(signingInput, SECRET));
jwt = signingInput + "." + signature;                 // three parts, one key
```

```console
--- 1. sign
  eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZGUiLCJyb2xlIjoiVVNFUiIsImlhdCI6MTc5MzE4MDM2MiwiZXhwIjoxNzkzMTgwNjYyfQ.DlljSyOcukF8bArPwoqsZcXGSGfYMxAGDntpAUCvi4A
--- 2. the payload is readable (base64url is not encryption)
  header = {"alg":"HS256","typ":"JWT"}
  payload = {"sub":"ade","role":"USER","iat":1793180362,"exp":1793180662}
--- 3. verify: true
```

Three facts fall out of sections 1–3: the signature covers **exactly** `header.payload`
(the signing input — tamper with either and the bytes change); the payload is **in the
clear** to anyone (this is by design — tokens are for claims you'd also log, never for
secrets — and the reason "it's encrypted" is the most expensive wrong belief in this
subject); and verification is *recomputation plus constant-time compare*
`MessageDigest.isEqual`, because `==` on strings is the timing seam section 8 flags.

### Attacking your own token, executed

```console
--- 4. tamper: flip role USER -> ADMIN in the payload
  verify(tampered): false
--- 5. wrong key
  verify(wrong key): false
--- 6. expiry: exp in the past
  verify(stale): true  but expired=true -> rejected by CLAIM, not by signature
--- 7. alg=none attack
  verify(none-variant): false  (our verifier requires 3 parts + HMAC)
```

- **4 and 5**: the two refusals that make a token a credential — content integrity
  and key knowledge. Note *which* part failed: `verify` says the signature doesn't
  match the bytes, so the role can never be flipped without the secret.
- **6 is the subtle one**: the signature is *valid* on the expired token — expiry is
  a **claim the verifier enforces**, not a cryptographic fact. A verifier that checks
  signature but not `exp` accepts stale credentials forever; the probe prints both
  booleans precisely because they fail for different reasons (and because refresh
  tokens, session expiry, and lesson 12's cost parameters are all the same idea:
  *time-bounded credentials*).
- **7**: `alg=none` historically worked because verifiers read `alg` *from the token*
  — the attacker-declared field. Our verifier hard-codes HMAC-SHA256 and requires
  three parts, so the empty signature can never match. The rule generalizes: **the
  verifier chooses the algorithm, never the token.**

### The trade-off, side by side

| Property | Session (S1–S6) | JWT (probe) |
|---|---|---|
| Server state | one map entry per login | none — verification is a computation |
| Revocation | **instant** (S6: same cookie, now 401) | only by waiting out `exp` or adding state anyway |
| Scale-out | needs shared store across nodes | any node with the key validates alone |
| Readable content | nothing on the wire | **everything in the payload** (probe 2) |
| Logout semantics | delete the row | a fiction until `exp` passes |

Neither row is a verdict — it's the decision surface. Browser app on one server →
sessions (S5/S6 semantics are what "log me out" must mean). Service-to-service calls
or a mobile app across nodes → short-lived token + refresh flow, accepting that
"logout" revokes *storage*, not the token, unless a revocation list re-introduces the
state you fled.

## 6. How It Works

```mermaid
flowchart LR
    subgraph SESSION [Session — reference]
        L1["POST /session/login"] --> S1["server map<br/>sid -> user"]
        L1 --> C["Set-Cookie: LABSESSION (HttpOnly, Strict)"]
        C --> R1["GET /session/me<br/>+ cookie"]
        R1 --> S1
        R1 --> OK1["200 user/age"]
        LOG["POST /logout"] -.->|"remove(sid)"| S1
        S1 -.->|"gone"| R1 --> E1["401 (S6)"]
    end
    subgraph TOKEN [Token — document]
        SG["sign(header.payload,<br/>HMAC-SHA256)"] --> TK["jwt three parts"]
        TK --> V{"verify: recompute HMAC<br/>+ constant-time compare<br/>+ check exp"}
        V -->|"sig ok, exp ok"| OK2["200 claims"]
        V -->|"tampered / stale"| E2["401 rejected"]
    end
    KEY["the verifier's key<br/>(never the token's alg)"] --> V
```

The left graph is *state with a delete button*; the right is *a computation with two
checks*. Everything else in this subject's security run is built on one of these two
pictures.

## 7. Practical Examples

**Example 1 — the session lab, in full (executed as quoted in section 5)**

```java
String sid = UUID.randomUUID().toString().replace("-", "");
sessions.put(sid, new Session(sid, creds.username(), System.currentTimeMillis()));
ResponseCookie cookie = ResponseCookie.from("LABSESSION", sid)
        .httpOnly(true).path("/").maxAge(Duration.ofMinutes(30)).sameSite("Strict").build();
```

- Revocation is one line — `sessions.remove(sid)` — which is exactly what S6 tested.
- **How to run it:** `mvn -q -DskipTests package`, `java -jar target/spring-smoke-0.0.1-SNAPSHOT.jar`
  (wait for `Started SmokeApplication` — measured 11–25 s with the JPA lab present),
  then the six `curl` steps with a cookie jar (`-c` to store, `-b` to send).
- **Expected output:** the S1–S6 transcript, including the jar line and `revoked:true`.
- **Assumptions:** in-memory sessions and accounts (restart resets everything);
  lab-only account bootstrap in `SessionLab` — a real login reuses lesson 12's
  `authenticate`.

**Example 2 — the whole JWT probe in one block (executed as quoted in sections 5)**

```java
Mac mac = Mac.getInstance("HmacSHA256");
mac.init(new SecretKeySpec(secret.getBytes(UTF_8), "HmacSHA256"));
String input = b64url(header) + "." + b64url(payload);
String jwt = input + "." + b64url(mac.doFinal(input.getBytes(UTF_8)));
// verify: recompute over the same input, MessageDigest.isEqual(expected, actual)
```

- **How to run it:** `javac -encoding UTF-8 JwtProbe.java && java JwtProbe` (no
  dependencies — JDK only).
- **Expected output:** the eight-section transcript: `verify: true`, tampered `false`,
  wrong key `false`, stale `true`+`expired=true`, `alg=none` `false`.
- **Assumptions:** JDK 25 (`javax.crypto.Mac`), Windows 11 + Git Bash; the lesson's
  secret is a lab string — production keys come from a secret store, rotated.

## 8. Real-World Applications

The two mechanisms are deployed exactly as measured: browser apps run the S-path —
server-side session (or an opaque, HttpOnly, `Secure`, `SameSite` reference backed by
a shared store) so logout and admin-forced-termination *mean* something, with
absolute and idle timeouts as the `exp` idea applied to sessions. APIs and microservices
run the T-path — short-lived access tokens (minutes) verified by signature, with
refresh happening elsewhere — because every node validating alone is what lets the
service fleet scale horizontally. The lessons stack: [Authentication](authentication.md)
verified the password *once*; this lesson carries that fact across requests; the
[Authorization](authorization.md) exercise's forged-header re-run now has its answer —
identity comes from `sid` lookup or verified claims, so `X-Role` is finally
trustworthy. The probe's defects are the field's recurring villains in production
reviews: tokens used as *secret* storage (payload is readable — probe 2), missing
`exp` checks (probe 6), algorithm confusion (probe 7), and `==` signature comparison
(probe 8). Every one of them was executed here in its fixed or refused form.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Treating `base64url` as encryption | "it's not plain text" | payload decodes with any tool (probe 2) | only claims you'd log in tokens; secrets stay server-side |
| Verifier trusts token's `alg` | spec-following library defaults | `alg=none` or HMAC/RSA confusion accepted | hard-code allowed algorithms (probe 7's verifier) |
| No `exp` check (or absurd lifetimes) | signature-only mindset | tokens valid forever (probe 6's failure mode) | verify `exp`/`nbf` on every request; minutes, not days |
| `==` on signatures | convenience | string compare of base64 signatures | `MessageDigest.isEqual` — constant-time (probe 8) |
| Long-lived tokens because logout "works anyway" | state forgotten | logout button clears storage; token still valid | short `exp` + refresh rotation, or accept and document the gap |
| Sessions with guessable/expired ids | pre-discipline habits | short or sequential sids; no rotation | 128+ bits of randomness (probe: 32 hex chars), absolute + idle expiry, rotate on login |
| Cookie missing HttpOnly/Secure/SameSite | defaults skipped | readable by `document.cookie`, sent over http, cross-site | assert all three — the jar line proves HttpOnly (S1) |
| Shared session map with no cleanup | lab code in prod | memory grows, dead sessions linger | TTL sweep/expiry — sessions are state, and state needs a reaper |
| `X-User`-style identity headers surviving past the lab | stand-in forgotten | any header-based identity | retire stand-ins explicitly — Exercise 13.5's re-run is the checkpoint |

## 10. Best Practices

- **Pick by revocation requirement first**: anything a user or admin must be able to
  *end* (browser apps, support-driven sign-outs) leans sessions (S5/S6 is the
  acceptance test); anything scale-bound and short-lived leans tokens.
- **Short `exp` + refresh for tokens**, refresh tokens stored server-side with reuse
  detection — the revocation you can't do to the access token lives one layer down.
- **Cookies for browser credentials**: `HttpOnly; Secure; SameSite`, narrow `path`,
  session rotation on privilege change — and keep tokens in memory, not `localStorage`
  (script theft is the browser's real threat model).
- **Verify in this order, every time**: signature with *your* algorithm → `exp`/`nbf`
  → issuer/audience if federated → then claims for authorization.
- **Treat tokens as claims, not secrecy**: if a payload would hurt to read, it
  doesn't belong in one.
- **Rotate and store keys as secrets** — never in the repo (the lab's string is a lab
  string).

## 11. Limitations and Trade-Offs

The session lab's `ConcurrentHashMap` is a **single node's memory**: restart the jar
and everyone is logged out (executed implicitly — every battery re-registers), and two
nodes would hold disjoint maps — production needs a shared store (Redis/DB) or
sticky routing, and that's a real dependency sessions reintroduce. The JWT probe
verifies **HS256 with a shared secret**: anyone holding the *verifying* key can also
*sign*, which fails the "several services must validate, one must sign" case — RSA/EdDSA
key pairs fix that at the cost of larger tokens and key distribution, a decision
outside this lab's executed scope. **Neither battery tested the transport**: cookies
and tokens over plain HTTP are sniffable — TLS is assumed, not demonstrated. The
`exp` rejection in probe 6 is *our* verifier's discipline; a third-party library
would do it for you, and the lesson's point is understanding what you're delegating,
not hand-rolling tokens for production. Finally, **`alg=none` and confusion attacks
are library-era history** — modern libraries refuse them by default — so the honest
use of probe 7 is as *review vocabulary*: when you adopt a JWT library, confirm its
algorithm allowlist and `exp` policy rather than re-deriving them.

## 12. Practical Exercises

### Introductory

1. **Exercise 14.1** — run the S battery twice, capturing both cookie jars; then
   answer: how many bits of entropy does `LABSESSION` carry (count the hex chars),
   what does S3 vs S4 prove, and which single line would you delete to lose revocation?
   **Completion criteria:** two jars; the entropy calculation (128 bits from 32 hex);
   S3≡S4 and the `sessions.remove` line identified — and a run confirming S6 flips
   back to `200` once you delete it.
2. **Exercise 14.2** — decode any JWT (the probe's own, from section 1) with nothing
   but `base64url` decoding; print header, payload, and the signing input; then modify
   the payload's `role` and re-verify with the probe's `verify()` — capture `false`
   and explain precisely which bytes changed and why the old signature can't cover
   them.
   **Completion criteria:** decoded parts; the modified-verify capture; a two-sentence
   account of what the signature *is* a function of.

### Intermediate

3. **Exercise 14.3** — expiry as policy: build tokens with `exp` at +5 min, −5 min,
   and +100 years; run a verifier that checks signature **then** claim; capture all
   three outcomes; then delete the `exp` check and capture what the stale token now
   does — restore it, and write the two-line justification you'd give in review for
   your chosen lifetime.
   **Completion criteria:** three captures + the no-check capture showing acceptance;
   your lifetime argument naming both attacker value and user friction.
4. **Exercise 14.4** — session expiry lab: add absolute (30 min) and idle (15 min)
   timeouts to `SessionLab` — capture a session killed by age (401 with the same
   "no active session" body), and a *rotated* sid on re-login (old cookie dead,
   new one alive).
   **Completion criteria:** both captures; the state fields you added; one paragraph
   on why rotation on privilege change matters (fixation) even though your lab has no
   attacker in the middle.

### Independent problem-solving

5. **Exercise 14.5** — implement the hybrid and measure it: sessions as the primary
   credential, with a short-lived HS256 access token minted from the session and
   presented as `Authorization: Bearer`, verified *statelessly* on each request while
   the session row provides logout. Execute: login → access token works → logout →
   **session is dead (401 on session routes) but the access token still verifies**
   until its `exp`. Then make the access token's `exp` 5 seconds and capture its
   natural death. Write the deployment note your team needs: which credential dies
   when, and what an attacker holding only the access token gets for how long.
   **Completion criteria:** four captures (token valid / session dead / token expiry
   / forged token rejected); the verifier wiring (one line choosing the algorithm);
   the note as a table — credential, lifetime, revocation path, blast radius.

*Solutions: attempt first. They live in `exercises/solutions/` of this subject.*

## 13. Knowledge Check

1. S5 revoked the session and S6 returned `401` — the cookie was unchanged. What
   property made that work, and why can't a plain JWT do it? … *(The cookie is a
   **reference** into server state; deleting the entry makes every future lookup miss.
   A JWT carries its own claims — validation is a computation over bytes — so there's
   nothing to delete; without added state the credential lives until `exp`.)*
2. Probe 6 prints `verify(stale): true` *and* `expired=true`. Why are both printed,
   and which one does your verifier reject on? … *(Signature and expiry fail for
   different reasons: the crypto is sound, the claim is out of date. A correct
   verifier checks both, in that order, and rejects on the claim — a verifier doing
   only the first accepts the stale token forever, which is exactly why both booleans
   are surfaced in the probe.)*
3. Your teammate puts the user's database id and their role in a JWT "because it's
   signed." What do you say? … *(Signed ≠ hidden — probe 2 decoded the payload with
   two lines. Anything readable by anyone who holds the token (logs, referrer leaks,
   browser storage) is exposed by design. Signed is integrity; it says nothing about
   confidentiality. Keep the payload to claims you'd log; resolve anything sensitive
   server-side by id.)*

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] The S1–S6 battery ran with your cookie jar — including S6's `401` after S5's
      `revoked:true`
- [ ] The JWT probe ran: `true` / tampered `false` / wrong key `false` / stale
      `true`+expired / `alg=none` `false`, all from your terminal
- [ ] You decoded a payload by hand and modified it to see verification fail
- [ ] Exercise 14.5's hybrid (or your own expiry test) executed with the "dies when"
      table written
- [ ] The `X-User` stand-in question answered: which credential now feeds
      authorization, with one line of your code that reads it

## 15. Summary

- A **session** is a reference into server state: execute issue → use → miss → guess
  → revoke → dead (S1–S6), and revocation is instant because the state is deletable.
- A **JWT** is a signed document: built here with one HMAC — payload readable (not
  encrypted), signature over `header.payload`, verified by recomputation +
  `MessageDigest.isEqual`.
- Attacking your own token exposes the four review classics: tampering `false`, wrong
  key `false`, **expiry is a claim not a crypto fact**, and the verifier — never the
  token — chooses the algorithm.
- The trade-off is revocation vs statelessness; pick by what must be *ended*, keep
  lifetimes short, and remember logout means different things on each side.
- Credentials are time-bounded by design — sessions (`maxAge`, timeouts) and tokens
  (`exp`) are the same idea wearing different clothes.

## 16. Next Steps

- Next lesson: [OAuth2 and OpenID Connect](oauth2-and-openid-connect.md) — delegating
  the whole credential problem to a provider, and what "Login with X" moves.
- Practice: [exercise sets](exercises/README.md) for this subject.
- Where it is applied: [Project 05 — Full-Stack App](../20-PROJECT-LABORATORY/project-05-full-stack-app/README.md)
  — browser sessions on top of the API these lessons built.