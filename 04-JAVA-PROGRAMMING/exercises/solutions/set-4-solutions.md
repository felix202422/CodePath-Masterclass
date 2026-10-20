# Solutions — Set 4: Operators and Control Flow

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Short-circuit on the record

```console
a || (1/0 == 0) = true
Exception in thread "main" java.lang.ArithmeticException: / by zero
	at Ops.main(Ops.java:9)
$ echo $?
1
```

- First line **true**: the right side never ran. `false || …` forced evaluation and the program
  died — same expression, one boolean apart. The trace names `Ops.java:9`: control-flow bugs are
  found by *reading line numbers*.

**Criteria check:** ☐ both lines ☐ trace line number included.

## Exercise 2 — Switch expression

**Reference shape** (from the lesson's executed program):

```java
String kind = switch (day) {
    case 1, 2, 3, 4, 5 -> "weekday";
    case 6, 7           -> "weekend";
    default             -> "impossible";
};
```

- It compiles as a *value* because **every** path yields one — the compiler checks
  exhaustiveness; multi-label `case 1, 2, … ->` needs no `break` (arrow cases don't fall
  through).

**Criteria check:** ☐ expression form ☐ `default` present ☐ output shown.

## Exercise 3 — The truthy refusal

```console
Truthy.java:3: error: incompatible types: int cannot be converted to boolean
        if (1) { System.out.println("no"); }
             ^
1 error
```

- Subject 02 taught truthiness tables; **Java has none**. The error names both types — the
  refusal is self-explaining, and the fix is a comparison (`if (x != 0)`).

**Criteria check:** ☐ error captured verbatim ☐ one-sentence explanation.

## Exercise 4 — Seven-day billing switch (independent)

**Reference shape.** One `switch` *expression* per concern, arrow cases only, `default` for
out-of-range:

```java
String band = switch (day) {
    case 1, 2, 3, 4, 5 -> "standard";
    case 6             -> "weekend-plus";
    case 7             -> "weekend";
    default            -> "invalid day: " + day;
};
```

- The seven-day sweep prints one band per day; the invalid input is a *value* of the same
  expression (not an exception) — the "no if/else chains" criterion is satisfied by making the
  switch produce the message itself.

**Criteria check:** ☐ seven-day sweep ☐ invalid input handled ☐ zero if/else for bands.

---

Next: [set-5-solutions.md](set-5-solutions.md)
