# Solutions — Set 18: Functional Programming

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The purity probe

```console
pure total = 15  repeat = 15
cache = {a=3, b=10, c=2}
impure same-input: 3, 3  calls=2
username(buffy) = true
username(blanks) = false
username(long) = false
add(3).apply(4) = 7
```

- **The `calls=2` argument (three sentences):** the values matched, so no *output* was wrong;
  but each call performed an observable side effect, so the second call could **not** be
  replaced by a cache lookup without changing program behavior; purity's product is the
  guarantee (repeat/cache/parallel), and one `++` destroyed it while the printed values still
  looked innocent.

**Criteria check:** ☐ seven lines ☐ three-sentence argument.

## Exercise 2 — Composition traces

```text
inc.compose(dbl).andThen(dbl).apply(5):   5 → 10 → 20  = 20
dbl.andThen(inc.compose(dbl)).apply(5):    5 → 6 → 12  = 12
inc.andThen(dbl).apply(5) = 12             (control: 5 → 6 → 12)
```

- **Reading rule:** `andThen` flows left-to-right, `compose` flips its argument — expand every
  chain as arrows *from the input* and never reason about names mid-flight.

**Criteria check:** ☐ three predictions ☐ three runs ☐ traces shown.

## Exercise 3 — Memoized fib

**Reference:** `memoize` wrapping a `fib` whose raw body increments `calls`; then

```text
fib(10) = 55  raw-calls after 1st = 89
fib(10) = 55  raw-calls after 2nd = 89     // unchanged: second call hit the map
```

- The compile error you hit: mutating an outer local from the lambda →
  `local variables referenced from a lambda expression must be final or effectively final`;
  **fix:** keep the cache in a `final Map` reference (mutating the *object* through a final
  reference is legal — the rule freezes the variable, not the object).

**Criteria check:** ☐ zero-cost second call ☐ compile error + fix explained.

## Exercise 4 — Pure pricing core (independent)

**Reference behavior:** first matching rule wins (stated), half-up rounding to cents, empty
schedule throws `IllegalStateException("empty schedule")`-style described failure.

```text
pair  7: schedule S2, tx 990 → 10.00   (determinism: repeat identical)
bounds: every fee within [0, cents/100 + ε]     ✓ ×20
mono:   cents 990 → 120 never increases fee     ✓ ×20 (or your honest rule fix)
throws: empty schedule → caught: empty schedule
```

- **Thesis paragraph's core:** determinism made each property *a function of its inputs* — a
  run-to-run-variable function cannot be asserted against bounds or orderings at all, because
  there is no single value to compare; the pure core turned testing into tables.

**Criteria check:** ☐ spec before code ☐ harness transcript ☐ property verdicts ☐ thesis
paragraph.

---

Next: [set-19-solutions.md](set-19-solutions.md)
