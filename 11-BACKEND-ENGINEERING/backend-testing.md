# Backend Testing

## 1. Learning Objectives

After this lesson you can:

- [ ] Place a test at the right layer of the backend pyramid — and justify the choice by
      **measured cost**: plain unit tests at 0.017 s, contract tests at 15.15 s (executed,
      surefire report below)
- [ ] Write a plain-JUnit test that constructs a service with `new` and proves an
      authorization rule, with **no Spring context on the classpath of the test**
      (executed: `OrderServiceTest`, 4 tests, 0.017 s)
- [ ] Write a contract test with `@SpringBootTest` + MockMvc that asserts the **wire**
      — status, envelope, byte-identity — instead of implementation details (executed:
      6 tests including the identical-404 and byte-identical-401 rules from lessons 11–13)
- [ ] Run the **deliberate-break drill**: inject an enumeration leak, watch the exact
      test fail with both bodies printed, revert, go green (executed: red at
      `BUILD FAILURE`, then `15/15 BUILD SUCCESS`)
- [ ] Diagnose a Spring Boot 4 test-compile failure where the annotation's package
      moved and its module is no longer in `spring-boot-starter-test`
      (executed: `AutoConfigureMockMvc` now lives in `spring-boot-webmvc-test`)
- [ ] Read a surefire summary and name what a suite did *not* cover (executed:
      context-loads, unit, and contract totals with per-class timings)

## 2. Prerequisites

- [09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) — you have seen the
  red-green drill before; this lesson port it to the server.
- `validation-and-error-handling.md` and `authorization.md` of this subject — the rules
  under test are those lessons' contracts.
- `authentication.md` — the uniform-401 rule this lesson breaks and repairs.
- The `spring-smoke` lab from this subject's earlier lessons, with its test sources:
  `src/test/java/com/example/smoke/` (three classes, one per layer).

## 3. Introduction

Every rule this subject has executed by hand — *foreign reads look like missing rows*,
*login failures are byte-identical*, *validation reports every field sorted* — was
enforced by code that a future change can silently undo. Hand-run `curl` batteries
prove the rule today; only a test proves it at the next commit. This lesson turns the
batteries into an executable suite, layer by layer, and then proves the suite has teeth
by breaking the code on purpose.

## 4. The Problem It Solves

A backend rule has a half-life. Six weeks after the API ships, someone "improves" the
401 handler to include the username for debugging, and the enumeration leak returns —
with no test failing, no review catching it, no sign until it appears in an incident
report. The batteries in lessons 11–15 ran once, by hand, in a terminal; hand-run
evidence expires the moment the code changes.

The other problem is *where* tests live. If every test needs `@SpringBootTest`, every
test boots the container, connects to PostgreSQL, scans every bean — and a 0.017-second
rule costs 15 seconds to check. Suites like that get deleted or skipped, and then there
are no tests at all. Layering is not aesthetic: it is the difference between a suite
people run and a suite people skip.

## 5. Core Concepts

**The backend pyramid, priced.** Three layers, each with a different cost measured in
this subject's own suite:

| Layer | What it exercises | Example | Measured |
|---|---|---|---|
| Unit | One class, plain `new`, no Spring, no I/O | `OrderServiceTest` | 0.017 s / 4 tests |
| Unit with a real dependency | One class + its actual collaborator (bcrypt) | `AuthServiceTest` | 0.901 s / 4 tests |
| Contract / slice | Real HTTP mapping via MockMvc, one shared context | `ApiContractTest` | 15.15 s / 6 tests |
| Context smoke | The wiring itself compiles into a running app | `SmokeApplicationTests` | 1.9 s / 1 test |

The rule of thumb follows the table: if the behavior lives in one class, the test
constructs that class. Only behavior *about the boundary* — status codes, headers,
JSON shape — earns a contract test.

**Assert the wire, not the implementation.** A contract test should survive an internal
refactor. It asserts `status`, `type`, `fieldErrors`, and byte-equality of two responses;
it never asserts that a particular method was called or a particular map was built.
Implementation assertions are the reason tests fail on harmless edits and get disabled.

**MockMvc is in-process HTTP.** `@AutoConfigureMockMvc` runs the real dispatcher
servlet, real `@ControllerAdvice`, real Jackson — inside the test JVM, with no socket.
You write `post("/auth/login")` and get back the exact bytes a `curl` would receive,
which is what makes byte-identity assertions meaningful.

**Test doubles vs real collaborators.** The unit tests use neither mocks nor a
container: `new OrderService()` is the real thing, because the service's only
dependency is its own logic. `AuthServiceTest` uses the *real* bcrypt encoder —
replacing it with a fake would test the fake. Mocks pay for themselves only at
genuine boundaries (clocks, queues, third-party clients), not as a reflex.

**One exception, one test.** The service throws `StockConflict`/`Forbidden`/
`InvalidCredentials`; tests assert *that exception type*, never a status code. Status
mapping is the controller's contract and belongs in contract tests. Keeping the layers
apart is what stops a refactor of the HTTP layer from rewriting authorization tests.

**Red-green is the drill, not decoration.** A green suite you have never seen fail
proves nothing — it may be asserting the wrong thing or never running. The deliberate
break (§7.3) is the only evidence that a test *detects*.

## 6. How It Works

`mvn test` compiles `src/test/java` with the same compiler settings as main code, then
the surefire plugin runs every `*Test` class in a forked JVM:

1. **Class discovery** — JUnit 5 scans for classes with `@Test` methods. Plain classes
   need no annotations beyond `@Test`.
2. **Context caching** — the first `@SpringBootTest` builds one application context;
   every later test using the same configuration *reuses* it. `ApiContractTest` and
   `SmokeApplicationTests` share a single boot (the log shows one
   `Started SmokeApplicationTests`; the cache is why 7 integration tests cost ~15 s,
   not 7 boots).
3. **Database** — the context boots against the real lab PostgreSQL
   (`jdbc:postgresql://127.0.0.1:5433/backend_lab`); `JpaSeed` sees the five existing
   rows and skips. Contract tests that touch data therefore run against the same
   schema production would.
4. **Reporting** — surefire writes per-class XML reports and prints one aggregate
   line per class plus a suite total; the build fails on the first non-green class.

A note on the Spring Boot 4 split, because the first compile here failed on it: the
Boot 4 modularization moved `@AutoConfigureMockMvc` out of
`spring-boot-test-autoconfigure` into the `spring-boot-webmvc-test` artifact
(`org.springframework.boot.webmvc.test.autoconfigure`), and `spring-boot-starter-test`
no longer pulls it in. The fix executed in this lab:

```xml
<!-- Spring Boot 4 split MockMvc support out of starter-test -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-webmvc-test</artifactId>
    <version>4.1.1</version>
    <scope>test</scope>
</dependency>
```

Diagnosis path, worth remembering: *package does not exist* → find which jar holds the
class (`unzip -l` over `~/.m2/.../*.jar`) → check what the starter's POM actually
declares (`grep artifactId spring-boot-starter-test-4.1.1.pom`) → add the missing
module. Never fix a missing-package error by changing the import to something that
compiles; the class you want exists, in a module you haven't declared.

## 7. Practical Examples

**Example 1 — the authorization rule as a 0.017-second unit test**

The service rule from lesson 13 (`foreign reader and missing row are the same
`Optional.empty()`) without Spring, without a database, without a mock:

```java
@Test
void owner_reads_foreign_and_missing_are_indistinguishable() {
    long id = svc.create("SKU-A", 1, "ade");

    assertTrue(svc.find(id, "ade", false).isPresent(), "owner sees the row");
    assertTrue(svc.find(id, "bea", false).isEmpty(), "foreign reader gets empty");
    assertTrue(svc.find(999, "bea", false).isEmpty(), "missing id gets empty");
}
```

Three asserts encode the whole IDOR contract, including the *absence* of the
existence oracle: both refusals produce the same value, so the controller — and the
wire — cannot tell them apart. Executed: 4 tests, `Time elapsed: 0.017 s`.

`AuthServiceTest` extends the same idea to the authentication rule: call
`authenticate` twice with two *different* wrong reasons and assert
`wrongPassword.getMessage().equals(unknownUser.getMessage())` and equal exception
classes — one family, one message, enforced as a test rather than as a convention.

**Example 2 — the wire contract with MockMvc**

```java
@Test
void validation_reports_every_field_sorted() throws Exception {
    mvc.perform(post("/api/orders").contentType(MediaType.APPLICATION_JSON)
                    .content("{\"sku\":\"\",\"qty\":0}"))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.type").value("https://errors.example.invalid/validation"))
            .andExpect(jsonPath("$.fieldErrors.length()").value(2))
            .andExpect(jsonPath("$.fieldErrors[0].field").value("qty"))
            .andExpect(jsonPath("$.fieldErrors[1].field").value("sku"));
}
```

The `fieldErrors[0]`/`[1]` ordering asserts the *sorted* guarantee from lesson 9 —
the one a client's generic error parser depends on. `foreign_order_404_is_identical_
to_missing_404` goes further than the hand battery: it fetches both bodies and
`assertEquals(foreign, missing)` on the raw strings with the message “byte-identical:
no existence oracle (IDOR rule)”. The upload test asserts the envelope's `type`; the
cache test asserts `source == "db"` then `source == "cache"` with equal `cents` —
provenance *and* value stability, which is the cache-correctness rule from lesson 17.

**Example 3 — the deliberate-break drill (executed)**

The break: one line in the 401 handler of `AuthController` —

```java
"status", 401, "detail", "no account for " + creds.username()));   // broken
```

The targeted run:

```
$ mvn test -Dtest='ApiContractTest#login_failures_are_byte_identical'
[ERROR] Tests run: 1, Failures: 1, Errors: 0, Skipped: 0 <<< FAILURE!
org.opentest4j.AssertionFailedError: no enumeration signal: both 401 bodies byte-equal
  ==> expected: <{"status":401,"type":"https://errors.example.invalid/credentials",
                  "detail":"no account for ade"}>
       but was: <{"status":401,"type":"https://errors.example.invalid/credentials",
                  "detail":"no account for ghost"}>
[INFO] BUILD FAILURE
```

Note what the failure message gives you: both actual bodies, so the diff *is* the
security report — the unknown user and the wrong password now answer differently.
Revert the line, rerun the whole suite:

```
[INFO] Tests run: 6 ... -- in com.example.smoke.ApiContractTest
[INFO] Tests run: 4 ... -- in com.example.smoke.AuthServiceTest
[INFO] Tests run: 4 ... -- in com.example.smoke.OrderServiceTest
[INFO] Tests run: 1 ... -- in com.example.smoke.SmokeApplicationTests
[INFO] Tests run: 15, Failures: 0, Errors: 0, Skipped: 0
[INFO] BUILD SUCCESS
```

Red, then green — the only order that means anything.

## 8. Real-World Applications

- **Regression gates in CI.** `mvn test` is the whole quality gate for most teams:
  a pull request that changes the 401 body, the validation order, or the ownership
  check cannot merge while these tests exist.
- **Refactor confidence.** Byte-identity and envelope tests let you rewrite the
  controller/service split (lesson 5) without re-deriving the contracts by hand —
  the suite tells you whether the wire survived.
- **Onboarding by test.** A new engineer reads `OrderServiceTest` and knows the
  authorization contract in 20 seconds; the test is the spec that cannot drift from
  the code.
- **Contract suites against staging.** The same MockMvc assertions port to tests
  hitting a deployed server (RestTest/WebTestClient), giving black-box verification
  of the same rules.
- **Mutation confidence.** Deliberate-break drills are a lightweight mutation test:
  if removing a check leaves the suite green, the suite is decoration.

## 9. Common Mistakes

- **Every test annotated `@SpringBootTest`.** The whole suite inherits a 15-second
  floor and a database dependency; developers start running one test instead of all.
  Ask first: does this rule need HTTP at all?
- **Asserting internals.** `verify(orderService, times(1)).find(...)` passes while
  the endpoint returns 500. Assert observable behavior; verify mocks only at true
  boundaries.
- **Sleeping to test async.** `Thread.sleep(500)` before asserting the background job
  is flaky on slow machines. Await a condition with a timeout (Awaitility) or assert
  at the synchronous boundary you control.
- **Shared mutable state between tests.** `ApiContractTest` uses a unique SKU
  (`TEST-CONTRACT`) and registers its own user precisely because the context — and
  its singletons — is cached across classes. Test order must never matter.
- **Asserting on message text only.** `assertTrue(msg.contains("invalid"))` breaks on
  copy edits and misses type changes; assert the exception *type* and the envelope
  `type` URI, which are the contract.
- **Ignoring the compile error instead of diagnosing it.** The Boot 4 module move was
  a `package does not exist` failure; the wrong response is swapping imports until
  green, the right one is finding which jar declares the class.
- **Never seeing red.** A suite whose every run has been green has not been tested
  itself. Run the drill once per rule you care about.

## 10. Best Practices

- **Match the layer to the rule.** One class → construct it. Boundary behavior →
  MockMvc. Wiring → one context-loads test. This is the cost table from §5.
- **One rule per test, named after the rule.**
  `owner_reads_foreign_and_missing_are_indistinguishable` documents the contract in
  the failure log itself.
- **Assert status + envelope + content together.** The error contract has three
  parts (lesson 9); asserting only the status lets the shape rot.
- **Byte-compare security responses.** For uniformity rules (401, 404), compare raw
  response strings — JSON key order and whitespace differences are leaks too.
- **Fix the environment, not the test.** A flaky test usually means shared state or
  an unawaited condition; disabling it hides a real race.
- **Keep suite runtime boring.** Unit tests in milliseconds, the contract layer in
  seconds, and — when the suite grows — split slow integration tests into a separate
  Maven profile so the fast feedback stays fast.
- **Run the suite in CI on every commit.** The lesson's evidence only keeps paying if
  `mvn test` is a required check.

## 11. Limitations and Trade-Offs

- **MockMvc is not the network.** It skips sockets, TLS, proxies, and real timeouts.
  What it proves is the servlet-stack mapping; a handful of tests against a real
  started server (or Testcontainers with the actual HTTP client) cover the gap.
- **One shared database means ordering risk.** Tests here run against the lab schema
  with `JpaSeed` present; parallel execution or data-writing tests would need
  per-test isolation (transactions rolled back, or one container per test class).
- **The suite is not exhaustive.** 15 tests sample the contract; they do not prove
  absence of bugs, cover concurrency (lesson 22's races are timing-dependent), or
  touch the browser. Green means “the rules we named still hold.”
- **Contract tests are slow relative to unit tests** (0.017 s vs 15.15 s) — the price
  of a real context and a real database; layering is what keeps the total bearable.
- **No performance or load evidence here.** Passing tests say nothing about behavior
  under concurrency or volume; that is the later architecture work.

## 12. Practical Exercises

**Exercise 1 — Three drills, three reds.** Run the deliberate-break drill once for
each rule, capturing the failing assertion each time: (a) remove the ownership check
in `OrderService.find` (returns `Optional.of` unconditionally) — which test fails and
what does it prove? (b) sort `fieldErrors` in reverse in `ApiExceptionHandler` —
does anything fail? (c) make the cache always report `source=db` — which assertion
catches it? Revert each; the suite must return to 15/15. (Drill (b) is the one most
likely to pass — decide whether the ordering assertion is worth keeping and say why.)

**Exercise 2 — Promote a hand-run check to a test.** Pick one assertion from your
lesson-17 caching battery (a curl you ran) and encode it as a MockMvc test. Name it
after the rule, run it green, then break the code to see it fail once.

**Exercise 3 — The missing test.** The suite has no test for refresh-token rotation
(lesson 14) and none for pagination cursors (lesson 4). Write one contract test for
either, using the existing endpoints, and show its first run — then break the feature
and show it red.

**Exercise 4 — Cost audit.** Add `@SpringBootTest` to one of the unit tests and
measure the time delta (`Time elapsed` in surefire output). Write one sentence on why
the pyramid is shaped the way it is, with your two numbers.

## 13. Knowledge Check

1. Why does `OrderServiceTest` construct the service with `new` instead of `@Autowired`?
2. What three properties of a response does a good contract test assert?
3. You see `package org.springframework.boot.test.autoconfigure.web.servlet does not
   exist` on Boot 4 — what is your diagnostic sequence, and which fix is forbidden?
4. Why byte-compare the two 401 bodies instead of comparing parsed JSON?
5. What does the shared Spring context cache buy you, and what hazard does it create?
6. Name one bug class this suite provably cannot catch.

## 14. Completion Criteria

- [ ] `mvn test` runs `15 tests, 0 failures, 0 errors` and `BUILD SUCCESS` on the lab
      (executed: this lesson's captures).
- [ ] At least one deliberate-break drill executed with the red output preserved and
      the suite green again after revert (executed: §7.3).
- [ ] You can state which of the 15 tests would fail if the ownership check, the
      uniform-401 rule, or the validation sort were removed — and which would not.
- [ ] A new rule you add to the API arrives with a test at the layer its contract
      lives on, named after the rule.
- [ ] You can explain the Boot 4 module split and why `spring-boot-webmvc-test` is in
      the POM.

## 15. Summary

Testing a backend is layering evidence: the authorization contract in a 0.017-second
unit test, the wire contract in an in-process HTTP test, and one smoke test that the
wiring boots. The suite in this lesson executed 15 green tests, was proven to have
teeth by an injected enumeration leak (red, with both bodies printed), and returned
to green on revert. The rules lessons 9–17 executed by hand are now rules the build
enforces — hand evidence expires at the next commit, this evidence expires only if
you delete the tests.

## 16. Next Steps

This subject's `projects/` briefs (Project 04 REST API, Project 05 full-stack) require
these tests as acceptance criteria: an authorization test that would catch privilege
escalation, a rollback-integration test, and an N+1 fix verified by query counting.
Start with [projects/README.md](projects/README.md), then the exercises in
[exercises/README.md](exercises/README.md).

For the wider path: [12-MOBILE-DEVELOPMENT](../12-MOBILE-DEVELOPMENT/README.md) builds
the second client against this API, and the testing discipline continues in the
architecture and DevOps subjects, where this suite becomes CI's gate.
