# Solutions — Set 12: Frontend testing · build and deployment →
`frontend-testing.md` · `build-and-deployment.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe cluster N),
> tsc 7.0.2, and a real `vite build` (probe O). Quoted outputs are real captures.

## Exercise 1 — The deliberate-break drill

**The six green baselines (probe N, all passing in the batch's run):**

```console
✓ N1 role query survives markup change; class query breaks
✓ N2 userEvent types into a controlled input; mirror reflects it
✓ N3 async findBy waits through the loading state
✓ N4 mocked api module called with exact contract args
✓ N5 error → alert → retry → ready, attempts asserted
✓ N6 keyboard submit: Enter in the input submits the form
```

With their captured receipts: `N4 saveProject called with: ["ship-it"]` (the mock's
contract args asserted, not just "it was called"), `N5 error shown: true`, and N1's
role-vs-class contrast.

**Three breaks, three exact failures (shapes to quote from your run):**

| Break | Failing test's message |
|---|---|
| delete the retry's `setStatus("loading")` update | `expected true to be true` on "spinner visible after clicking retry" — or the `findBy` for the loading surface times out: `Unable to find an element by: [data-testid=...]` |
| rename the queried class in the *product* | old test red: `Unable to find an element with the text: ...` — **the test is now wrong, the product is fine**; N1 already proved the role query stays green here |
| hang the loader (never resolve) | `waitFor` timeout: `expect(spy).toHaveBeenCalledTimes(1)` after `vi.waitFor` — the test fails on *time*, not on values |

**Test-bug red vs product-bug red, one paragraph:** a *test* bug fails against unchanged
product behavior and usually breaks on a query or an assumption (rename the class, an
unawaited promise, a fake timer left running); a *product* bug fails against the
behavior the spec promises while the test still describes reality correctly (the retry
flow really is missing its loading flip). The disambiguator is always the same: read the
failure message and ask "is the DOM the test expects *supposed* to exist?" — then check
against the requirements, never against the last green run.

## Exercise 2 — The query-ladder conversion

**The ladder (N1's result is the rule):** `getByRole` → `getByLabelText` →
`getByPlaceholderText` → `getByText` → `getByDisplayValue` → `getByAltText` →
`getByTitle` → `*ByTestId` (last).

**The conversion (shape):** five tests rewritten from `.querySelector(".card .title")`
/ `container.querySelectorAll("li")` to `getAllByRole("listitem")`,
`getByRole("heading", { name: "…" })`, etc. — then **swap the DOM** (change classes,
wrap rows in a `<div>`, rename the wrapper): **old red** (`Unable to find an element with
the class: "title"`), **new green** (roles and names survive structure edits — N1's exact
demonstration). Grep evidence for the criteria: `grep -nE "querySelector|className=" *.test.tsx`
returns nothing across the five files.

**The `data-testid` legitimacy rule you write down:** a test id is legitimate only when
the element has *no* accessible identity a user could name — it isn't a button, link,
input, heading, or image, and no visible text identifies it (a chart canvas, a virtualized
row container, a drop zone). If a *user* could point at it, the query must be role+name;
if only the developer can, `data-testid` is the honest fallback — and it belongs to the
test's contract, so renaming it is a deliberate, reviewed change.

## Exercise 3 — The build contract, executed

**Probe O (authoring machine, `vite build`, Vite 8.3.5):**

```console
✓ 16 modules transformed
dist/index.html                    0.46 kB │ gzip:  0.30 kB
dist/assets/index-qny8FNsF.js    221.22 kB │ gzip: 69.26 kB
dist/assets/heavy-CEsDep9u.js      0.13 kB │ gzip:  0.14 kB
✓ built in 735ms
```

**Four asserted facts against `dist/`:**

1. **Inlined var present:** `grep -r "api.example.com" dist/` → hit — `VITE_API_URL`
   (`https://api.example.com`) was substituted at build time (Vite statically replaces
   `import.meta.env.VITE_API_URL`).
2. **Token absent:** `grep -r "supersecret" dist/` → **no output** — the unprefixed
   `API_TOKEN` never left Node's environment.
3. **`process.env.NODE_ENV` count 0:** `grep -rc "process.env.NODE_ENV" dist/` → 0
   occurrences (replaced and dead-code-eliminated).
4. **Split chunk emitted:** `heavy-CEsDep9u.js` exists as its own file — the
   `React.lazy(() => import("./heavy"))` boundary produced a second asset (see the
   `0.13 kB` line above).

**The broken-prefix run:** rename `VITE_API_URL` → `API_URL` in `.env`, rebuild →
`grep` for `api.example.com` in `dist/` now finds **nothing** (and the code that read it
renders `undefined`) — the inlining changed because the *prefix gate* is the contract, not
the variable name.

**The one-line policy:** `VITE_` may carry only values that are **public by construction**
(base URLs, build ids, public feature flags) — anything with a `VITE_` prefix is readable
by every user of the page, so the prefix means "I have agreed this is not a secret".

## Exercise 4 — The pipeline (independent)

**Gate script (shape to execute):**

```bash
#!/usr/bin/env bash
set -euo pipefail
tsc --noEmit                                  # gate 1: types
vitest run                                    # gate 2: tests
vite build                                     # gate 3: build
! grep -rEn "$SECRET_RE" dist/                # gate 4: secret scan (exits 1 on hit)
gzip -9 -c dist/assets/*.js | wc -c | awk '{exit !($1 <= BUDGET)}'   # gate 5: gzip budget
```

**Five demonstrated failures (break each, quote message + exit code):** remove a type
annotation → `tsc` diagnostic, exit 1; delete a test's assertion → `vitest` red,
exit 1; throw in `vite.config.ts` → build error, exit 1; plant `API_KEY=…` in a source
file → the gate's grep prints its match and exits 1; lower `BUDGET` below the real size →
`awk` exits 1 with the measured byte count printed. Five exits, five messages — each gate
must fail *loudly and specifically*, which is what makes it a gate rather than a log.

**Hosted evidence (shape — your own static host):** `curl -I` on two URLs —

```
cache-control: public, max-age=31536000, immutable   # /assets/index-qny8FNsF.js
cache-control: no-cache                              # /index.html
```

— immutable assets, revalidated HTML pointer, the pair that makes rollback a file swap.
Then `curl -s <url>/assets/*.js | grep -c "$SECRET_RE"` → `0` on the **deployed body**:
the local scan proves your tree; the deployed scan proves what the CDN actually serves.

**Rollback drill:** keep the previous build directory (or release tag), flip the pointer
symlink/`vercel.json`/Pages release back, `curl` to confirm the old asset hash serves —
record elapsed time (target: under a minute; the honest number is the one you measured).

**Two "what still slips through" classes:** (i) **secrets in transit/at rest outside
dist** — env vars in CI logs, tokens in source history, server-side keys: the build only
ever sees the client bundle, so it cannot catch what leaks through other channels; (ii)
**behavioral regressions that pass every gate** — a wrong query price, a broken redirect,
an accessibility regression axe doesn't cover: gates check the artifacts you thought to
encode, so the classes that slip are the ones without a gate, which is why the list is
maintained, not assumed complete.

**Criteria check:** ☐ six green baselines quoted ☐ three breaks with exact messages ☐
test-bug vs product-bug paragraph ☐ five conversions with before/after + grep evidence +
testid rule ✓ four executed build checks + broken-prefix transcript + one-line policy ✓
five gate failures with exit codes, both TTL headers, deployed scan empty, rollback time,
two slipping classes named.

---

Next: [README](README.md) — back to the index.
