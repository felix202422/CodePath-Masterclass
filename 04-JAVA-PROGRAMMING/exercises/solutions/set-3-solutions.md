# Solutions — Set 3: Variables and Types

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Defaults and bounds

**Answer.** Eight primitives: `byte, short, int, long, char, float, double, boolean`. **As
fields** they zero-initialize (`0`, `'\0'`, `0.0`, `false` — the JVM lesson executed
`defaults: inst=0 stat=0`); **locals** must be assigned before use (compile error otherwise).
Bounds come from the wrapper constants, printed by your program:

```text
Byte:   -128 .. 127
Short:  -32768 .. 32767
Int:    -2147483648 .. 2147483647
Long:   -9223372036854775808 .. 9223372036854775807
Char:   0 .. 65535
Float/Double: 3.4e38 / 1.8e308 magnitude (IEEE 754)
Boolean: true / false only
```

**Criteria check:** ☐ eight primitives ☐ defaults ☐ bounds from a real run.

## Exercise 2 — Overflow and the narrowing refusal

```console
Integer.MAX_VALUE + 1 = -2147483648      // silent wraparound — no error at all
```

```console
error: incompatible types: possible lossy conversion from int to byte
    byte b = 300;
             ^
```

- Overflow is a **runtime** result with no diagnostic (the exact reason `Math.addExact` exists);
  narrowing is a **compile-time** refusal — Java makes you say `byte b = (byte) 300;` and own
  the consequence.

**Criteria check:** ☐ wrapped value ☐ exact error captured.

## Exercise 3 — Division forms

```text
10 / 3   = 3        // integer division truncates toward zero
10.0 / 3 = 3.3333…  // one double operand promotes the whole expression
10 % 3   = 1        // remainder: 10 = 3*3 + 1
```

- **Rule:** `/` truncates only when *both* operands are integral; any `double` widens the
  operation. `a = q*b + r` with `|r| < |b|` ties `%` to the division.

**Criteria check:** ☐ three outputs ☐ promotion rule stated.

## Exercise 4 — Unit converter (independent)

**Reference shape.** Parse with `Double.parseDouble` inside `try/catch (NumberFormatException)`;
print a described message (offending value included) instead of a stack trace; two conversions
(e.g. miles→km 5.0 → 8.04672, kg→lb 70 → 154.32).

- **Reviewer note:** the described message is the lesson's policy — catch `NumberFormatException`
  *by type*, name the input, and let the program continue; an empty catch or a raw trace fails
  the criterion.

**Criteria check:** ☐ two conversions ☐ invalid input reported without a trace.

---

Next: [set-4-solutions.md](set-4-solutions.md)
