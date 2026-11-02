# Set 2 solutions — Unit testing → `unit-testing.md`

*Executed in the batch's Maven lab (Java 25, JUnit 5). Blocks marked *reference* are shapes
to run in your own lab.*

## 1. Boundary table, paper first

The method the lessons enforce: the table exists **before** the run. For a shipping/tax
function the executed battery's rows looked like:

```
shipping(net=0.00)=10.00   shipping(net=99.99)=5.00   shipping(net=100.00)=0.00
lineTotal(10.00, 2)=21.40
```

Zero below the boundary, the boundary value itself, one step above — plus the guard row
(`net < 0` throws). Your capture needs the predicted column and the actual column side by
side; a table written after the run is documentation, not a prediction.

## 2. Guard tests that name the input

Shape that satisfies the criteria:

```java
IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
        () -> calc.orderTotal(-1.00));
assertTrue(ex.getMessage().contains("-1.00"), ex.getMessage());
```

Why the message assertion: the throw alone proves *a* guard fired — with three throwing
methods it could be the wrong guard. The message ties the failure to the input that caused
it, so a regression that swaps the guards' messages still fails.

## 3. The rename drill

The lessons' executed run — rename the private field `rate` to `taxRate`:

```
[ERROR] TaxCalculatorTest.implementationTest » NoSuchFieldException: rate
[ERROR] Tests run: 22, Failures: 1, Errors: 0
# 15 of 16 other tests green
```

Verdict: exactly one test died, and it is the one that reached into the field by name. It
was testing *implementation*, not behavior. Revert → `Tests run: 22 … BUILD SUCCESS`. The
drill's generalization: any rename should kill only tests you can name as implementation-
coupled *before* you run it; if a behavior test dies, your rename changed behavior.

## 4. Independent — audit of 10 claimed tests (reference shape)

For each test, one line: *what failure class can this catch?* Categories the lessons taught
you to look for:

| Smell | Evidence to quote |
|---|---|
| Assertion-free | a print, a `verify` with no value assertion, or no assert at all |
| Implementation-coupled | died in the rename drill (`NoSuchFieldException`) |
| Impossible-world mock | passes while the real collaborator throws (set 5's pair) |
| Wrong expectation | asserts the buggy value (print-trap: `expected=19.9 actual=19.8` green) |
| Never runs | outside surefire's include pattern (set 3's `OrderServiceIT` incident) |

Deliverable: the count with quotes. A "200 tests cover the service" claim that yields 6/10
in these categories is a measurable statement about the suite, not an opinion — and the
follow-up is one red run per category, not a rewrite.