# Solutions — Set 9: Inheritance

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Construction order

```console
Animal()  kind=basic
Dog()     name=Rex  kind=basic-dog
```

- **Parent constructor runs first** — `Dog()` implicitly begins with `super()` (the free no-arg
  call), which is why the `Animal` line always precedes the `Dog` line. Every object is a full
  parent before it is a child.

**Criteria check:** ☐ parent-before-child captured ☐ implicit `super()` explained.

## Exercise 2 — Overloaded constructors

**Reference shape:** `Dog(String name)` delegating with `this(name, "dog")` to
`Dog(String name, String kind)` — three call forms (`new Dog()`, `new Dog("Rex")`,
`new Dog("Rex", "collie")`) produce three outputs; **delegation runs at most one `this(…)`/
`super(…)` chain**, so `super` still executes exactly once, at the chain's root.

**Criteria check:** ☐ three calls ☐ three outputs ☐ delegation rule stated.

## Exercise 3 — Hiding, not overriding

```console
Main.java:N: error: static method cannot be overridden but is hidden by static method in …
```
*(wording varies by javac; the lesson's captured form is the one to match)*

- Static methods are **hidden**: resolution happens through the **declared** type at compile
  time. `@Override` on a static method is itself an error — the annotation is the contract check.

**Criteria check:** ☐ message captured ☐ hiding-vs-overriding stated.

## Exercise 4 — Three-level hierarchy (independent)

**Reference shape:** `Shape` (abstract, shared `id` + `area()`) → `Rectangle` → `SquareRect`
(or `Shape → Quadrilateral → Rectangle`) with the executed constructor transcript:
`Shape(…)` prints before `Quadrilateral(…)` before `Rectangle(…)`, matching your drawn order
(Mermaid or hand-drawn).

- **Composition pick:** e.g. `Car *has-a* Engine` rather than `Car extends Engine` — two
  sentences citing the is-a test and the coupling cost from the lesson. A valid alternative:
  borrowing behavior via a `Drivable` interface instead of a base class.

**Criteria check:** ☐ diagram matches transcript ☐ composition choice justified in two sentences.

---

Next: [set-10-solutions.md](set-10-solutions.md)
