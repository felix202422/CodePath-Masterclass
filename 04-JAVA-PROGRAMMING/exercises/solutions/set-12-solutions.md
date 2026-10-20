# Solutions — Set 12: Interfaces and Abstract Classes

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — One, then two interfaces

**Reference shape:** `class Circle implements Printable, Resizable` called through each type:
`Printable p = c; p.print();` / `Resizable r = c; r.resize(2);` — two lines proving dispatch
through two interface references to one object.

**Criteria check:** ☐ output through each reference.

## Exercise 2 — The default-method conflict

```console
A1.java:N: error: class B1 inherits unrelated defaults for run() from types A1 and B1
```
*(the lesson's captured pair printed `A1/B1 incompatible` — match your JDK's wording)*

```java
class C implements A1, B1 {
    @Override public void run() { A1.super.run(); B1.super.run(); }   // or your own body
}
```

- The explicit override **must** choose; `A1.super.run()` names whose default runs. Without the
  clash rule, a class silently picking one would be a maintenance time bomb.

**Criteria check:** ☐ error alone ☐ fix output (`A2+B2` style).

## Exercise 3 — instanceof both ways

```java
if (obj instanceof Printable p) { p.print(); }   // pattern matching binds p — no second cast
```

- Both versions run identically; the pattern buys **binding + narrowed scope**: `p` exists only
  inside the `if`, so a stray use outside won't compile.

**Criteria check:** ☐ both versions ☐ pattern's benefit stated.

## Exercise 4 — Interface vs abstract class, defended

**Reference answers:**

- **`Comparable`-style sorter → interface:** it's a *contract* (`compareTo`'s sign convention)
  that any unrelated type can adopt without disturbing its own hierarchy — an abstract class
  would force single inheritance of the sort behavior. Implemented version sorts three inputs.
- **`Logger` base → abstract class (legitimately):** shared *state* (level, sink) and template
  scaffolding (`log(msg)` final, subclasses implement `emit`) — the lesson's criterion: shared
  state and code → abstract class; pure contract → interface. (If your `Logger` carries only a
  method, interface + default methods wins — defend *whichever you chose* with that criterion.)

**Criteria check:** ☐ implemented version runs on three inputs ☐ both defenses cite
contract-vs-shared-state.

---

Next: [set-13-solutions.md](set-13-solutions.md)
