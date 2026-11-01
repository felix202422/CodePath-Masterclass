# Mocking and Test Doubles

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Name the four doubles — stub, mock, spy, fake — and choose one with a stated reason
- [ ] Execute the divergence pair: a mock accepting a world the real collaborator rejects, and read the verdict
- [ ] Diagnose a test that proves nothing because it only proves its own mock
- [ ] Decide when a double is required (slow, nondeterministic, external) and when the real object is cheaper than the mock
- [ ] Use `verify` for interactions deliberately — and say what interaction was worth asserting

## 2. Prerequisites

- [Unit Testing](unit-testing.md) — the level where doubles live
- [Integration Testing](integration-testing.md) — the level that answers when the mock lied

## 3. Introduction

A test double stands in for a collaborator you don't want in the room: the payment
gateway, the clock, the database, the slow classifier. The vocabulary matters because
each double asserts a different thing — a stub answers *questions*, a mock asserts
*interactions*, a spy observes a real object, a fake is a working lightweight
implementation. This lesson's executed core is the moment a mock and reality disagree,
and the green test beside the red one that tells you which world you were testing.

## 4. The Problem It Solves

Testing `CheckoutService` against a real payment gateway means network, money, and
nondeterminism in every unit run. So you mock it — and buy a new failure mode: the
mock's contract is written by the same person as the test, and when the two share a
wrong assumption, the test is green about a world that never exists. The lab executed
exactly this: `when(calc.lineTotal(-5.00, 1)).thenReturn(-5.35)` — a value a real
`TaxCalculator` can never return, because it throws on negative prices. The mock test
passed; its twin, running the real object, threw `IllegalArgumentException`.

## 5. Core Concepts

### The doubles

| Double | What it is | What the test proves | Executed example |
|---|---|---|---|
| **Stub** | canned answers | your code asks the right questions and handles answers | `when(...).thenReturn(21.40)` |
| **Mock** | stub + recorded expectations | interactions happened (`verify`) | `verify(calc).lineTotal(10.00, 2)` |
| **Spy** | real object, calls observed | real behavior *and* it was consulted | `spy(real)` → real 21.40 + verified |
| **Fake** | working lightweight impl | behavior against a fast real thing | zero-rate `TaxCalculator(0.0)` |

### The divergence rule

If a mock accepts input the real collaborator rejects, the test asserts an impossible
world. The only honest fixes: guard the input *before* the collaborator (then the mock
verifies `never()` called), or test that path against the real object. The battery
executes all three runs of that story below.

### When a double is justified

External (network, clock, filesystem), nondeterministic (random, concurrency), or
genuinely slow. Everything else: the real object is usually cheaper than the mock's
setup — and never lies.

## 6. How It Works

1. Mockito creates a throwaway implementation of the class/interface at test time
   (bytecode generation), records stubbings, and records every call.
2. `when(...).thenReturn(...)` registers a canned answer for an *exact* (or
   matcher-based) invocation; unmatched calls return default values (`0`, `null`) —
   which is a silent wrong world unless you asked for strict stubbing.
3. `verify(mock).method(...)` asserts the recorded call happened (and `never()`
   that it didn't); it cannot assert anything about *values the mock invented*.
4. `spy(real)` wraps a real instance: the real method runs, the call is recorded.

## 7. Practical Examples

All executed (Java 25, Mockito 5.x via spring-boot-starter-test, Windows 11).

**Example 1 — the legitimate stub** (executed: green)

```java
TaxCalculator calc = mock(TaxCalculator.class);
when(calc.lineTotal(10.00, 2)).thenReturn(21.40);
CheckoutService svc = new CheckoutService(calc);
assertEquals(21.40, svc.quote(10.00, 2), 0.0001);
verify(calc).lineTotal(10.00, 2);
```

```
MOCK: stubbed quote=21.40, verify(lineTotal) passed
```

**Example 2 — the divergence, executed both ways** (run 1: both green, in contradictory worlds)

```java
// mock side — impossible world accepted
when(calc.lineTotal(-5.00, 1)).thenReturn(-5.35);
assertEquals(-5.35, svc.quote(-5.00, 1), 0.0001);     // GREEN
// real side — same call, real collaborator
assertThrows(IllegalArgumentException.class, () -> svc.quote(-5.00, 1));  // GREEN too: reality rejects
```

Run 1 output: `MOCK: quote(-5.00, 1) = -5.35 -> green, but see the twin`,
`REAL: quote(-5.00, 1) threw IllegalArgumentException`, and surefire reported
`Tests run: 3, Failures: 0` / `BUILD SUCCESS` — **every test passed while the two
worlds contradict each other**. Nothing in a green run compares them.

**Example 3 — the fix, and the mock test's honest rewrite** (runs 2 and 3)

The service gets the guard *before* the collaborator:

```java
if (unitPrice < 0) throw new IllegalArgumentException("unitPrice must not be negative: " + unitPrice);
```

Run 2: the real test stays green, and the *mock* test dies with an **error** — the
service throws before consulting the stub, so its impossible assertion never runs
(`Tests run: 3, Failures: 0, Errors: 1`, error in `mockAcceptsImpossibleWorld`). The
rewritten test asserts the guard and that the collaborator was never consulted:

```java
assertThrows(IllegalArgumentException.class, () -> svc.quote(-5.00, 1));
verify(calc, never()).lineTotal(-5.00, 1);
```

Run 3 (executed): `MOCK: guard thrown, collaborator never called (verify never passed)`
— battery green. Note the shape: the *collaborator stayed mocked*, but the assertion
moved to behavior that is true in **both** worlds.

**Example 4 — spy and fake, side by side** (executed)

```
SPY: real result 21.40 AND call verified
FAKE: zero-rate calculator, no mocking framework involved
```

- **How to run:** `mvn test -Dtest=MockingBatteryTest`, `-Dtest=MockingGuardedTest`, `-Dtest=DoublesVocabularyTest`.
- **Assumptions:** Mockito bundled by spring-boot-starter-test 4.1.1.

## 8. Real-World Applications

Doubles are unit tests' connective tissue: hexagonal architectures exist so that
ports (interfaces) can be stubbed at the boundary, CI doubles replace payment/sms/map
providers, and fakes (in-memory repositories) are how integration-speed tests get
unit-speed reruns. Teams that test-and-double well keep a rule of thumb visible: the
mock's stubbings are *claims about production behavior* — every `when` should be
traceable to the real collaborator's documented contract.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Asserting the mock's invented world | stub written from the test's wish | mock green while real twin red (executed above) | divergence pairs; guard before the collaborator |
| Over-mocking | habit | test constructs 4 mocks to call 1 method | "what's external/slow/nondeterministic?" — if nothing, real object |
| `verify` on trivia | coverage-of-calls reflex | test breaks when an equivalent path is taken | verify only interactions with observable consequences |
| Silent default returns | unmatched stubbing returns `null`/`0` | NPE far from the cause | strict stubbing / `verifyNoMoreInteractions` |
| Mocking concrete final classes poorly | framework limits | unexpected `Cannot mock final class` | mock the interface your code depends on (design feedback!) |

## 10. Best Practices

- **Stub answers; verify only what matters** — the executed `verify(calc).lineTotal(10.00, 2)` earns its place because the *arguments* are the contract.
- **Guard invalid input before the collaborator** — then both worlds agree, and `verify(never())` documents it.
- **Prefer fakes when you'd mock a framework** — an in-memory repository beats mocking JPA.
- **Run the divergence pair when you add a stub** — one twin against the real object answers "is this world possible?"
- **Treat stubbings as documentation of the collaborator's contract** — if you can't cite where the answer comes from, you invented it.

## 11. Limitations and Trade-oubles

Mocks couple tests to call structure: refactors that preserve behavior can still break
`verify` — that's the implementation-coupling of [unit-testing.md](unit-testing.md)
returning at interaction granularity. Strict stubbing adds its own brittleness. And a
mocked suite can be perfectly green while the integration contract (payload shapes,
timeouts, retries) is wrong — which is why [integration-testing](integration-testing.md)
and [end-to-end-testing](end-to-end-testing.md) keep the mocks honest.

## 12. Practical Exercises

### Introductory

1. **Exercise 6.1** — stub, spy, and fake one collaborator three ways. **Completion criteria:** three green tests plus one line each: what does this variant prove that the others don't?
2. **Exercise 6.2** — run the divergence pair from Example 2 on a collaborator you own. **Completion criteria:** mock-green + real-red captures, and the world that's impossible named.

### Intermediate

3. **Exercise 6.3** — fix the divergence the lesson's way: guard before the collaborator, capture run 2 (mock test dies), rewrite, capture run 3 (green with `verify(never())`).
4. **Exercise 6.4** — audit a colleague's test class for `verify` trivia: list every `verify` and classify assert-worthy vs structural. **Completion criteria:** the table and one test you would delete.

### Independent problem-solving

5. **Exercise 6.5** — remove all mocks from one of your test classes. **Completion criteria:** the class runs against real collaborators; report which mocks were essential (named reason: external/slow/nondeterministic) and which were habit.

*Solutions: attempt first. They live in [`solutions/`](exercises/solutions/README.md) of this subject.*

## 13. Knowledge Check

1. Why can a `verify(mock).method(x)` never tell you your code is *correct*?
2. Your mock test is green and the integration test red. Name the two possible verdicts and how you'd decide between them.
3. When is a fake better than a mock — and what does the fake cost that the mock doesn't?

## 14. Completion Criteria

- [ ] You can name each of the four doubles with its assertion type, from memory
- [ ] You can execute a divergence pair and state which world the failing test lived in
- [ ] You can justify every double in one of your own test classes — or delete it
- [ ] You can rewrite a mock test that died from a new guard without weakening it

## 15. Summary

- Four doubles, four assertion types: stub answers, mock verifies, spy observes real, fake implements light.
- Executed divergence: mock accepted `-5.35` for a negative price; the real collaborator threw — one of three tests saw reality.
- The fix moves the guard before the collaborator and asserts `never()` — same double, true-in-both-worlds assertion.
- Double only what is external, slow, or nondeterministic; everything else is a world you invented.

## 16. Next Steps

- Next lesson: [Test-Driven Development](test-driven-development.md) — designing with the red first
- Practice: [exercise set](exercises/README.md)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)