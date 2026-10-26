# Solutions — Set 5: Routing → `routing.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe clusters E and I,
> `react-router`'s `MemoryRouter` in jsdom). Quoted outputs are real captures.

## Exercise 1 — The back-button contract

```tsx
render(
  <MemoryRouter initialEntries={["/a"]}>
    <Routes>
      <Route path="/a" element={<A />} />
      <Route path="/b" element={<B />} />
    </Routes>
  </MemoryRouter>
);
await user.click(screen.getByRole("link", { name: "to B" }));
expect(location.pathname).toBe("/b");  // with a location spy, or assert screen.getByTestId("view")=="B"
back();                                // screen.getByText("go back") → navigate(-1)
expect(location.pathname).toBe("/a");
expect(screen.getByTestId("view")).toHaveTextContent("A");
```

**Five assertions:** view B → path `/b` → `back()` → view A → path `/a`. Then the replace
case: `navigate("/c", { replace: true })` after A → B leaves history length unchanged —
assert with a spy on the history's `entries` length (MemoryRouter exposes it via
`unstable_dataRouter`-style probes, or count `back()` calls needed to leave `/c`: one,
because `/c` *replaced* `/b`).

**The push-vs-replace rule:** every navigation is a push by default — that's what makes
back work. Use `replace` for **redirects and post-submit hops** (login → app, wizard step
fwd) so Back doesn't replay a state that no longer means anything.

## Exercise 2 — Parameter boundary

```tsx
<Route path="/items/:id" element={<ItemRoute />} />
function ItemRoute() {
  const { id } = useParams();
  const decoded = safeDecode(id ?? "");           // decode ONCE, here
  const item = decoded !== null ? find(decoded) : undefined;
  return item ? <ItemView item={item} /> : <NotFound />;
}
```

Four cases asserted:

| id | Result |
|---|---|
| `1` | renders the item view |
| `999` | renders `NotFound` — unknown id is a *lookup miss*, not an error |
| `../../etc` | renders `NotFound` **and** the router's `location.pathname` still contains the encoded form (`%2E%2E%2F`) — no navigation, no fetch of a foreign path; assert `fetch` spy **not called** |
| empty (`/items/`) | no match on the route at all → the parent's catch-all/`NotFound` |

**The decode-once rule:** router params arrive *encoded*; decode exactly once, at the
route boundary, with a try/catch (`decodeURIComponent("%")` throws) — decoding in the
component *and* again in the fetch layer double-decodes `%252e%252e` into traversal. And
`to={userInput}` needs the same treatment in reverse: a user-supplied string interpolated
into `to` can change the route you land on — build `to` from a validated/encoded value or
a fixed path, never raw input.

## Exercise 3 — Nested routes and the active link

```tsx
<Route element={<Layout />}>
  <Route path="/a" element={<A />} />
  <Route path="/b" element={<B />} />
</Route>
// Layout: <nav>…<NavLink to="/a">…</nav> <Outlet />
```

Assert for **both** children: the layout's marker (`data-testid="layout"`) is present
*while* the child renders — one render pass, layout never unmounts. Then the active link:
`expect(screen.getByRole("link", { name: "a" })).toHaveAttribute("aria-current", "page")`
on `/a`, and `null` (or `"false"`) on `/b`. `NavLink` computes that attribute for you —
asserting it *by role+name* is the point, because assistive tech announces the current
item from the attribute, not from your CSS class.

**Why the layout must not remount between children:** remounting loses layout-local state
(scroll position, an open filter panel), tears down and re-runs every effect under it, and
flashes unstyled layout — the child changes, the shell's identity does not.

## Exercise 4 — The guarded round trip (independent)

```tsx
function Guard({ auth, children }: { auth: boolean; children: JSX.Element }) {
  const loc = useLocation();
  if (auth) return children;
  const next = encodeURIComponent(loc.pathname + loc.search);
  return <Navigate to={`/login?next=${next}`} replace />;
}
function LoginPage() {
  const [next] = useSearchParams();               // read once
  const to = safeNext(next.get("next"));          // relative-or-bust
  return <form onSubmit={…}>{/* on success: */}<Navigate to={to} replace />}</form>;
}
// safeNext: accept only values starting with a single "/" and not "//" — everything else → "/"
```

**Five assertions:** (1) anonymous `/app` renders the login view with
`?next=%2Fapp` (probe I5's receipt: *anonymous redirects with `?next=`*); (2) login
navigates; (3) **path is exactly `/app`** and the app view is on screen; (4) `back()` from
`/app` lands on *pre-login history*, **not** the login screen — because the guard and the
post-login hop both used `replace`, the useless login entry was overwritten, not stacked;
(5) `next=https://evil.example` → lands on `/` (or stays put), asserted by path — the
**open-redirect defense**: allow-list *relative* paths only (single leading `/`, no
scheme, no `//`), because an attacker-controlled `next` is a phishing vector the moment
the app navigates to it.

**The history model behind (4):** `replace` rewrites the current entry; `push` appends.
Redirects should rewrite — otherwise every auth hop leaves a poisoned entry that Back will
happily replay.

**Criteria check:** ☐ four view/path assertions + replace case ☐ four parameter cases with
the no-fetch proof ☐ decode-once rule + `to={userInput}` sentence ☐ layout-presence for
both children + `aria-current` by role ☐ five guard assertions incl. external-`next`
rejection ☐ open-redirect defense named.

---

Next: [README](README.md) — back to the index.
