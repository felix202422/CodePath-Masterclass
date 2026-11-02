# Set 5 solutions — Mocking and test doubles → `mocking-and-test-doubles.md`

*Executed in the batch's Maven lab with Mockito (bundled by spring-boot-starter-test 4.1.1).
Blocks marked *reference* are shapes to run in your own lab.*

## 1. Stub, spy, fake — three green tests

The lessons' executed trio:

```
MOCK: stubbed quote=21.40, verify(lineTotal) passed
SPY: real result 21.40 AND call verified
FAKE: zero-rate calculator, no mocking framework involved
```

One line each, what only that variant proves:

- **Stub** — the service's *use* of the collaborator: called with these arguments, this
  value came back. Proves nothing about the collaborator's real behavior.
- **Spy** — the real collaborator produced this result *and* the service called it. Proves
  the wiring against reality, at unit speed.
- **Fake** — a whole subsystem swapped for an in-memory one: proves multi-call behavior
  (sequences, state) that a stub's single `when` cannot express.

## 2. The divergence pair

Both worlds, one call:

```
run 1:  MOCK: quote(-5.00, 1) = -5.35 -> green, but see the twin
        REAL: quote(-5.00, 1) threw IllegalArgumentException
        Tests run: 3, Failures: 1        BUILD FAILURE
```

The impossible world: a negative unit price. The stub *invented* an order total no real
calculator can return, and the mock test's green was a claim about the test, not the code.
"One of the three tests sees reality" is the whole lesson — always run the pair.

## 3. Fix it the lesson's way (three runs)

Guard goes in the **service**, before the collaborator:

```java
if (unitPrice < 0) throw new IllegalArgumentException("unitPrice must not be negative: " + unitPrice);
```

```
run 2:  real test GREEN (guard throws as expected)
        mock test RED  — mockAcceptsImpossibleTest: Tests run: 3, Failures: 1
                         (the service throws before consulting the stub, so the stubbed
                          -5.35 can never be returned)
run 3:  rewritten: assertThrows(IllegalArgumentException.class, () -> svc.quote(-5.00, 1));
        verify(calc, never()).lineTotal(-5.00, 1);
        MOCK: guard thrown, collaborator never called (verify never passed)   → green
```

Note the shape to report: the collaborator stayed mocked — the fix was never "delete the
mock." The assertion moved to behavior true in **both** worlds, and `verify(never())`
converts the impossible stubbing into a real claim: the guard runs first.

## 4. Independent — de-mock one class (reference shape)

For each mock you remove, classify what you replaced it with — real collaborator (habit),
in-memory fake (state), or nothing (the collaborator was only ever called, never asserted
on). The report you owe: which mocks were **essential**, each with one of the three named
reasons — *external* (network/third party), *slow* (seconds per call), *nondeterministic*
(time, randomness, concurrency) — and which were habit. Expect the habit column to win; the
lessons' audit exercise (`verify` trivia: assert-worthy vs structural) shows the same thing
from the other side.