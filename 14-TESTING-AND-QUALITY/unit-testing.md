# Unit Testing

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Write boundary-focused unit tests with `@ParameterizedTest` tables, one row per boundary
- [ ] Use `assertThrows` to prove a guard exists — and assert the message tells the caller why
- [ ] Separate behavior tests from implementation tests, and demonstrate a rename breaking only the latter
- [ ] Run a unit suite fast enough that running it is cheaper than thinking about whether to run it
- [ ] Decide what belongs in a unit test and what needs a wired component instead

## 2. Prerequisites

- [Testing Fundamentals](testing-fundamentals.md) — AAA, isolation, what green means
- [04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — Java syntax; JUnit 5 is introduced here

## 3. Introduction

A unit test exercises *one unit* — a method or class — with everything around it
real but tiny: no network, no database, no Spring context. The payoff is speed (16
tests in 0.216 s in the lab) and *diagnosis*: when a unit test fails you know the
logic broke, because nothing else was in the room. This lesson is about writing the
tests that deserve that speed: boundary tables, guard proofs, and the discipline of
asserting behavior rather than structure.

## 4. The Problem It Solves

Untested logic fails at the *edges* — off-by-one quantities, boundary totals, values
just below a threshold — because happy-path examples never visit them. Hand-writing
one test per boundary is tedious and skips some. The alternative executed here: one
parameterized test whose table *is* the boundary analysis, so adding a boundary is
adding a row. And since logic is often refactored freely, tests that assert internal
structure (`getDeclaredField("rate")`) break on every rename without any behavior
changing — the lab demonstrated exactly that: a rename turned 15 green tests + 1
green test into 15 green + 1 error, and nothing else.

## 5. Core Concepts

### Boundaries, not averages

For each rule, the values that can behave differently: the threshold itself, one
below, one above, the extremes, and illegal inputs. A rule `net >= 100.00 → free
shipping` has five interesting numbers: `99.99`, `100.00`, `100.01`, `0.00`, huge.

### Parameterized tables

`@ParameterizedTest` + `@CsvSource` runs one test method once per row, reporting
each row by name (`shipping(net=99.99) = 5.00`). The table doubles as documentation:
reading it tells you the rule.

### Guards are behavior

A rejected input is as much a contract as a returned value. `assertThrows` proves
the guard fires; asserting the *message* proves the guard helps (`"unitPrice must not
be negative: -1.0"` names the value). An `IllegalArgumentException` with no context
passes the throw assertion and fails the caller.

### Behavior test vs implementation test

- **Behavior**: asserts what callers observe (`lineTotal(10.00, 2) == 21.40`). Survives any internal rename.
- **Implementation**: asserts how it's stored (reflection on a private field). Breaks when structure changes, with no behavior change — a *false red* that teaches people to ignore red.

## 6. How It Works

1. Surefire compiles and discovers `*Test` classes; the JUnit platform runs each `@Test`.
2. A parameterized method expands into N invocations from the data source; each
   invocation gets its own pass/fail.
3. `assertThrows` runs the lambda, catches the expected type, and fails if nothing
   throws (or the wrong type does).
4. A failing assertion throws an exception the runner records as a *failure*; a
   reflection error is recorded as an *error* — same red, different label in the report.

## 7. Practical Examples

All executed in the batch's `testlab` (Java 25, JUnit 5.12, surefire 3.5.6, Windows 11).

**Example 1 — the boundary table** (executed: `Tests run: 16, Failures: 0 … 0.216 s`)

```java
private final TaxCalculator eu = new TaxCalculator(0.07); // 7% — the lessons' EU rate

@ParameterizedTest(name = "shipping(net={0}) = {1}")
@CsvSource({
        "0.00, 5.00",        // lower boundary of the paid band
        "99.99, 5.00",       // one cent below the threshold
        "100.00, 0.00",      // exactly at the threshold -> free
        "100.01, 0.00",      // one cent above
        "1000.00, 0.00"      // deep inside the free band
})
void shippingBoundaries(double net, double expected) {
    assertEquals(expected, eu.shipping(net), 0.0001,
            "shipping(" + net + ") should be " + expected);
}
```

Executed rows included the fixtures the subject-13 lessons used:
`lineTotal(10.00, 2) = 21.40` (EU 2-line) and the rounding row
`19.99 × 1.07 = 21.3893 → 21.39`.

**Example 2 — guards proven, with useful messages** (executed)

```java
@Test
void negativePriceRejected() {
    IllegalArgumentException ex = assertThrows(IllegalArgumentException.class,
            () -> eu.lineTotal(-1.00, 2));
    assertTrue(ex.getMessage().contains("-1.0"),
            "message should name the value, got: " + ex.getMessage());
}

@ParameterizedTest(name = "quantity {0} rejected")
@ValueSource(ints = {0, -1, Integer.MIN_VALUE})
void badQuantityRejected(int quantity) {
    assertThrows(IllegalArgumentException.class, () -> eu.lineTotal(10.00, quantity));
}
```

**Example 3 — rename drill: behavior survives, implementation dies** (executed)

The suite pairs one of each:

```java
@Test @DisplayName("BEHAVIOR test: asserts only the public output — survives any internal rename")
void behaviorTest() { assertEquals(21.40, eu.lineTotal(10.00, 2), 0.0001); }

@Test @DisplayName("IMPLEMENTATION test: reflects into the private field 'rate' — dies on rename")
void implementationTest() throws Exception {
    Field f = TaxCalculator.class.getDeclaredField("rate");
    f.setAccessible(true);
    assertEquals(0.07, (double) f.get(eu), 0.0001);
}
```

Drill: rename the private field `rate` → `taxRate`, run the class:

```
[ERROR] com.example.lab.TaxCalculatorTest.implementationTest -- Time elapsed: 0.069 s <<< ERROR!
java.lang.NoSuchFieldException: rate
[ERROR] Tests run: 16, Failures: 0, Errors: 1, Skipped: 0
[INFO] BUILD FAILURE
```

15 of 16 stayed green (including `behaviorTest`) — the *only* casualty is the test
that looked inside. Revert the rename: full suite back to `Tests run: 22, Failures: 0 / BUILD SUCCESS`.

- **How to run:** `mvn test -Dtest=TaxCalculatorTest`
- **Expected output:** as quoted, and green after revert.
- **Assumptions:** Java 25, Maven 3.9.16, Windows 11 (see [VERSIONS.md](../VERSIONS.md)).

## 8. Real-World Applications

Unit tests are the first gate in every CI pipeline and the safety net under refactoring
— the subject-13 measure→change→measure shape leans on them because 0.2 s feedback
lets you change your mind. Domain logic (pricing, validation, state machines) belongs
here; anything whose correctness lives in *wiring* belongs one level up — that boundary
is [integration-testing](integration-testing.md)'s subject.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Happy-path only | easiest to write | bug at `99.99/100.00` boundary in production | table per rule: below/at/above/illegal |
| Asserting internals | feels more precise | red on refactors that change nothing observable | rename drill: would this test survive? |
| Empty `assertThrows` | message is optional | guard throws `""` and callers get nothing | assert message contains the offending value |
| Testing through mocks | habit from integration tests | unit test constructs 3 mocks to call one pure function | if it needs a mock, it may not be a unit test |
| Giant parameterless methods | one test per case | 40 near-identical methods | data source + one method |

## 10. Best Practices

- **Write the boundary table before the test** — the table is the analysis; the method is mechanical.
- **Assert messages that name the input** — `"…: -1.0"` turns a failure line into a diagnosis.
- **Prefer output assertions; use reflection only to test reflection** — the rename drill is the filter.
- **Keep the suite under ~seconds** — the executed ratio (units 0.216 s vs integration 12.60 s) is the budget: a unit test that needs a context has moved levels.
- **Fail for one reason** — if two rows fail, fix one at a time; the report's row names make that possible.

## 11. Limitations and Trade-Offs

Unit tests can't see wiring, configuration, SQL, or serialization — a perfect unit
suite and a broken Spring configuration coexist happily (our integration class did not
even *run* until its name matched the include pattern — a unit-level view cannot catch
that). Parameterized tables also hide in reports until a row fails; name them. And
boundary analysis has a ceiling: it covers rules you can state, not emergent behavior
of the whole flow.

## 12. Practical Exercises

### Introductory

1. **Exercise 3.1** — write the boundary table for a function you own, on paper first. **Completion criteria:** every row predicted before running; executed table with your captures.
2. **Exercise 3.2** — add guard tests with messages to three throwing methods. **Completion criteria:** each `assertThrows` also asserts the message names the input.

### Intermediate

3. **Exercise 3.3** — run the rename drill on your own suite: rename one private field, run. **Completion criteria:** the red capture; the list of tests that died; a verdict on each — behavior or implementation?
4. **Exercise 3.4** — split a 60-line test into AAA structure. **Completion criteria:** one act per test; suite still green; test count increased.

### Independent problem-solving

5. **Exercise 3.5** — a colleague claims their 200 unit tests "cover the service". Audit 10 of them. **Completion criteria:** for each — what failure class can it catch? Deliver the count that are implementation-coupled or assertion-free, with quotes.

*Solutions: attempt first. They live in [`solutions/`](exercises/solutions/README.md) of this subject.*

## 13. Knowledge Check

1. Why does `99.99 / 100.00 / 100.01` need three rows when the rule looks like one number?
2. A test fails after a pure rename. What are the two possible verdicts, and how do you tell them apart?
3. When is a test with a mock still a unit test — and when has it become a integration test wearing a unit test's name?

## 14. Completion Criteria

- [ ] You can write a boundary table from a rule statement without looking at examples
- [ ] You can prove a guard fires *and* that its message helps
- [ ] You can classify any test as behavior or implementation with a one-line reason
- [ ] You can say which failure classes your unit suite cannot catch

## 15. Summary

- Boundaries are where logic breaks; tables make boundary coverage cheap and readable.
- Guards are behavior: `assertThrows` plus a message that names the input.
- Behavior tests survive refactors; implementation tests manufacture false reds (executed rename drill).
- Units are fast (0.216 s / 16 tests) — that speed is the feature, so keep contexts out.
- What units cannot see — wiring, SQL, config — is the next lesson's job.

## 16. Next Steps

- Next lesson: [Integration Testing](integration-testing.md) — proving the wiring
- Practice: [exercise set](exercises/README.md)
- Where it is applied: [Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md)