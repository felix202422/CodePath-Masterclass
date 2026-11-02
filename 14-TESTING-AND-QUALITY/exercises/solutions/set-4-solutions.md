# Set 4 solutions — End-to-end testing → `end-to-end-testing.md`

*Executed in the batch's Maven lab: jar packaged, started on :8085, driven over HTTP with
`java.net.http`, plus one browser-driven journey (single browser). Playwright/Cypress
cross-browser runs are *labelled reference*.*

## 1. The HTTP-seat E2E against a jar you built

The lessons' capture, in order:

```
201 Created, Location=/api/orders/1
401 (no token)          → identical body whether token absent or wrong
400 net must not be negative
Order #3 placed for ada          ← rendered in the browser
400: net must not be negative     ← rendered error on the negative path
```

How to get there: `mvn package`, `java -jar target/*.jar`, then run the test **outside** the
application JVM — a plain HTTP client against `http://localhost:8085`. If your test lives in
the same process it is an integration test wearing an E2E label; the criterion is literally
that a separate process answers.

## 2. The "wrong target" check

Start a second instance on another port (e.g. :8086 with different data), point the test at
it deliberately, and capture the failed assertion — then the sentence:

> The response came from the process listening on :8086 (it has no `Order #1`), which
> proves the test's base URL, not its expectations, decided what it measured.

Why the exercise exists: E2E tests fail for environmental reasons constantly, and "which
process answered" is the first question. A test that cannot say which target it hit cannot
distinguish app bugs from config bugs — the main operational cost of this level.

## 3. Browser journey + condition wait

Journey: page → fill form → submit → API call → persisted row → rendered success. Capture
the rendered text (the lessons captured `Order #3 placed for ada`) and the negative path's
rendered error. For the sleep replacement:

```js
// before: await page.waitForTimeout(3000)   → flaky under load
// after:  await page.waitFor(() => !!document.querySelector('[data-status="saved"]'))
```

Run 10 repetitions both ways and count flakes (`0/10` vs whatever your fixed sleep gave).
The condition is an observable predicate of the UI state — a duration is a guess about the
machine. If you cannot state the condition, you do not yet know what the test waits *for*.

## 4. Independent — the E2E budget (reference shape)

A journey list of ≤ 10, each row: user goal → why only E2E can catch its failures →
measured wall clock. Everything else gets an explicit home ("checkout validation errors:
API battery, set 7"). The sentence per *excluded* path is the deliverable — an E2E suite
whose excluded paths are undocumented is a suite nobody will maintain, because every
exclusion looks like an oversight. Budget rule of thumb from the lessons' pyramid pricing:
if the full E2E run exceeds a few minutes, cut journeys whose failure classes are covered
below, never the assertions inside the ones you keep.