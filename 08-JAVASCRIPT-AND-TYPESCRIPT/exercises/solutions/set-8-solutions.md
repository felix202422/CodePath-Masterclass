# Solutions — Set 8: Error Handling

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The four `finally` probes

**Reference transcript (authoring machine, Node 24.13.1):**

```console
try
finally
after
finally (no return)
b(): from try
c(): from finally
d(): swallowed (no exception escaped)
```

- **(a) order:** `try → finally → after` — `finally` runs on the way out of a *successful*
  try; the `catch` line was skipped because nothing threw.
- **(b) no return in `finally`:** `finally` logged, then the function returned `from try` —
  it does not intercept returns, it only runs.
- **(c) `finally` returns:** `c(): from finally` — an explicit return in `finally`
  **overrides** the try's return value.
- **(d) `finally` returns while `try` throws:** `d(): swallowed` and **no exception escaped** —
  the return also swallows a pending throw. This is the dangerous one: a `return` cleanup in
  `finally` can silently discard the very error you needed.
- **Complete override list (one sentence):** `finally`'s own `return` (or throw) overrides a
  pending return *and* a pending throw; with no return/throw of its own, it never changes
  anything.
- **Criteria check:** ☐ four transcripts ☐ (d) showing no escape ☐ override list complete.

## Exercise 2 — Two-level hierarchy and the `name` pitfall

**Reference transcript (authoring machine):**

```console
dispatch PaymentError: payment:DECLINED
dispatch DomainError: domain:VALIDATION
without this.name: Error | with assignment: PaymentError
```

- Dispatch at three levels works because `instanceof` walks the **prototype chain**:
  `PaymentError → DomainError → Error → Object`. Check the most specific class *first* —
  after `e instanceof DomainError` matches, the narrower test below is unreachable.
- The pitfall, executed: a subclass that does **not** assign `this.name` reports `Error`,
  because `Error.prototype.name` is `"Error"` and the subclass never shadowed it. Both classes
  above assign `this.name` in their constructors — that is the fix, and it is why the
  inheritance example's constructors contain that seemingly redundant line.
- **Class per handling difference:** `DomainError` exists because some layer treats the
  failure as *domain-shape* (validation, message to translate); `PaymentError` exists because
  *another* layer must handle it differently (decline → user-facing retry path). If two
  classes would be caught by the same branch in every `catch`, they are one class.
- **Criteria check:** ☐ dispatch transcripts at each level ☐ `name` pitfall captured with fix ☐
  one sentence per class.

## Exercise 3 — The wrapping audit

**Reference transcript (authoring machine):**

```console
cause: TypeError: root cause: not a number
aggregate root: TypeError: root cause: not a number
aggregate root: RangeError: second root
```

- **Without `cause`:** `new Error("failed to total the invoice")` throws away the original
  `TypeError` — logs show only the wrapper, and the *actual* defect (`not a number`) is gone
  (`cause: undefined` in your own run).
- **With `cause`:** `new Error(msg, { cause: root })` keeps the root reachable as
  `wrapped.cause` — the transcript's second line is the full original chain preserved.
- **`AggregateError`:** wrapping two failures in one and iterating `agg.errors` listed *both*
  roots — use it when several independent things fail in one unit of work (parallel fetches,
  multi-field validation) rather than reporting only the first.
- **Wrap-vs-rethrow policy:** *translate* (new message + `cause`) when the caller needs a
  different abstraction level — rethrow *unchanged* when they might handle the original;
  never wrap without `cause`, and never wrap just to add a synonym message.
- **Criteria check:** ☐ before/after transcripts ☐ both roots listed ☐ one-line policy.

## Exercise 4 — The payments error taxonomy (independent)

**Reference shape** (taxonomies have no single correct text; a reviewer checks the columns):

| Class | Code | Expected/Unexpected | Layer action | Response | Log |
|---|---|---|---|---|---|
| `ValidationError` | `VALIDATION` | expected | parse/validate: translate + `cause` | 400 + field list | warn + field names, no stack |
| `DeclinedError` | `DECLINED` | expected | charge: no retry, map to UX | 402 + decline reason | info + processor code |
| `TimeoutUnknownError` | `UNKNOWN_OUTCOME` | unexpected | charge: **retry with same idempotency key** | 504 + "retrying" | error + key + attempt count |
| `BugError` | `INTERNAL` | unexpected | boundary: rethrow to terminal catch | 500 + generic id | error + full stack |

- **Boundary map:** every async entry (parse handler, validate middleware, charge caller)
  bottoms out in **one** terminal `process`/framework-level catch that owns the 500 and the
  log — no layer both catches *and* continues silently.
- **Unknown outcome (the nasty class):** the charge may have landed — so the answer is
  *idempotency keys*: retry is safe because the upstream deduplicates by key; a bare
  "retry" without the key can double-charge. State the semantics, not the verb.
- **Cited executed evidence, one decision each:** `cause` preservation (exercise 3) → every
  translation keeps `{ cause }`; the `finally`-override transcript (exercise 1) → no `return`
  in cleanup paths; the unhandled-rejection crash (set 6) → every promise at the boundary has
  a handler; `instanceof` dispatch (exercise 2) → the layer's catch switches on the taxonomy.
- **Honest trade-off:** expected failures could be `Result`-style return values instead of
  exceptions (as TypeScript lessons model) — chosen *at the validate/charge boundary* if the
  caller must branch on them routinely; exceptions once they reach a layer that has no
  alternative branch.
- **Criteria check:** ☐ table with no branch-less class ☐ boundary map with every async entry ☐
  unknown-outcome retry *semantics* ☐ four correctly quoted transcripts ☐ one trade-off.

---

Next: [set-9-solutions.md](set-9-solutions.md)
