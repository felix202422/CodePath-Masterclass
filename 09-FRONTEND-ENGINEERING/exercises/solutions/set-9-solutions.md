# Solutions — Set 9: Frontend authentication → `frontend-authentication.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe cluster I).
> Quoted outputs are real captures.

## Exercise 1 — The trade-off, then the memory flow

**The written comparison (the criteria demand prose, so here is the shape):**

| Store | XSS read | CSRF | Survives reload | Verdict for this subject |
|---|---|---|---|---|
| `localStorage` | **any same-origin script** | no (custom header needed) | yes | simplest; costs *all* XSS defence for the token |
| memory only | no | no | **no** (re-login) | strongest against XSS; refresh flow is mandatory |
| httpOnly cookie | no (JS can't read) | **yes — needs SameSite + CSRF token** | yes | best default *when a backend owns cookies* |

**Executed receipts:** probe I1 —

```console
I1 token stored: "secret-jwt-123" | any same-origin script can read it: true
```

(the XSS trade-off demonstrated, not asserted) — and probe I2:

```console
I2 before reload: mem-token | after: logged out (memory dies; localStorage would survive)
```

**Three assertion groups on the memory + refresh flow:** (a)
`expect(Object.keys(localStorage)).toHaveLength(0)` **and** the same for
`sessionStorage` after login — the key-count receipt; (b) renewal: fake timers advance to
just before expiry → the refresh endpoint called, the new token in the in-memory variable
(and `sessionStorage` still empty); (c) a 401 mid-session → the refresh-or-logout branch
runs **exactly once** (spy), not once per request.

**Threat-model sentence you must own:** in *this* subject's assumptions (no backend to
issue httpOnly cookies yet), memory-only wins because the attacker I'm modelling is an
XSS script on my origin — it can read `localStorage` in one line (I1) but can't read a JS
closure. The cost is honest: a refresh loses the session, so silent renewal on focus is
part of the design, not a nicety. CSRF barely enters (no cookies → no ambient credential).

## Exercise 2 — Guard round trip

```tsx
<Route path="/app" element={<Guard><App /></Guard>} />
<Route path="/login" element={<Login />} />
function Guard({ children }) {
  const auth = useAuth(); const loc = useLocation();
  if (!auth) return <Navigate to={`/login?next=${encodeURIComponent(loc.pathname)}`} replace />;
  return children;
}
```

**Five assertions:** (1) anonymous `/app` → login view, `next=%2Fapp` (probe I5:
*anonymous redirects with `?next=`*); (2) login → **`/app`** path asserted exactly;
(3) app view rendered; (4) logout → login view, path `/login`; (5) **browser back after
logout** → the protected view is *gone* — assert `queryByRole` for the app region is
`null`, not hidden. Why it holds: the guard renders `<Navigate>` instead of children, so
the protected tree **unmounted** at the redirect; hiding (CSS/`display:none`) would fail
this test, which is exactly the distinction the exercise wants.

**Guard placement:** *inside* the router, wrapping the protected branch of the route tree
(so it can read the location), above the protected elements but below providers — the
server still sees every request regardless, which is the one-sentence framing: **client
guards are UX, not security**; they save a pointless render and a confusing screen, while
the API is the thing that must refuse.

## Exercise 3 — The refresh race

```ts
let refreshing: Promise<string> | null = null;
async function token() {
  if (!refreshing) refreshing = refresh().finally(() => { refreshing = null; });
  return refreshing;                                  // the singleton: one in-flight promise
}
async function authedFetch(url: string, init: RequestInit = {}) {
  const t1 = await token();
  let res = await fetch(url, { ...init, headers: { Authorization: `Bearer ${t1}` } });
  if (res.status !== 401) return res;
  const t2 = await token();                           // all three callers land HERE
  return fetch(url, { ...init, headers: { Authorization: `Bearer ${t2}` } });
}
```

**Assertions:** three parallel requests through a mocked 401 → refresh spy called
**once** (probe I3's receipt, two requests edition):

```console
I3 two 401s → refresh calls: 1 | both got: "new-token"
```

— and each original request retried once **after** resolution (assert each sees the
post-refresh data). Then the failing branch: `refresh()` rejects → all three promises
reject with it (they share the same promise object — assert identity), the session clears
(`user === null`, the guard redirects), and `refreshing` was reset so a *later* attempt
can retry (the `.finally` is what prevents a poisoned permanent null-throw).

**Sequencing written:** an **in-flight flag holding one shared promise**, not a serialized
queue — a queue would add round-trip latency per waiter for no benefit (all waiters want
the *same* new token), and the flag is 3 lines with no ordering bug possible.

## Exercise 4 — The auth boundary audit (independent)

**The table (shape — ≥8 surfaces, each with a control):**

| # | Surface | Leak class | Control |
|---|---|---|---|
| 1 | `localStorage`/`sessionStorage` | storage (XSS read) | memory-only; assert key count 0 |
| 2 | In-memory auth context | log (devtools dump) | never `console.log` the context; lint the pattern |
| 3 | `fetch` wrapper `Authorization` header | error message (thrown init object) | redact headers in error serializers |
| 4 | Router `?token=` / `?next=` | URL (history, referrer, share) | never put tokens in URLs; scrub with `replace` if a legacy flow does |
| 5 | Logout button handler | tab (shared machine) | clear memory + storage + in-memory cache; `Cache-Control: no-store` server-side |
| 6 | Error boundary messages | error message | generic copy to the user, detail to the log with IDs |
| 7 | Analytics/events | log | deny-list: never send tokens/emails to analytics |
| 8 | Service worker / prefetch cache | storage on disk | `no-store` for authenticated responses |
| 9 | Screenshot-able UI (masked fields) | screen | redact token-shaped strings in renders |
| 10 | URL history after login | URL | `replace` the post-login hop (set 5's rule) |

**Two client-impossible items, with server counterparts:** (i) *stopping a stolen token
from working* — the client can only store/hide it; the server must expire it, bind it,
and revoke it (refresh-token rotation + revocation list); (ii) *refusing an unauthorized
request* — a guard is a render decision; the **server authorizes every endpoint** (the
authorization lesson's line: client guards are UX).

**One control implemented (the URL-token scrub, with tests):**

```tsx
useEffect(() => {
  const u = new URL(window.location.href);
  if (u.searchParams.has("access_token")) {
    u.searchParams.delete("access_token");
    window.history.replaceState({}, "", u);           // replace, not push
    setToken(u.searchParams.get("access_token")!);    // read BEFORE scrubbing
  }
}, []);
```

Before: `location.search` still contains `access_token=…` (assert the raw string). After:
the parameter is gone from `location.href` **and** from `history` (assert both —
`replaceState` rewrote the entry, so back/forward and "copy link" are all clean), while
the session works (guard renders the app).

**Criteria check:** ☐ three assertion groups incl. `Object.keys(localStorage)` length ✓
trade-off naming the threat model ☐ five guard assertions incl. back-after-logout ✓
one-refresh spy + failure branch + sequencing written ☐ audit table ≥8 surfaces, one
implemented control with before/after, two client-impossible items named with server
counterparts.

---

Next: [README](README.md) — back to the index.
