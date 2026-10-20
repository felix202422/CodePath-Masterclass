# Solutions — Set 10: Polymorphism

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Mixed loop, predicted first

**Reference shape** (lesson's executed family):

```console
Animal speaks
Dog barks
Cat meows
Animal speaks
Dog barks
```

- Every line comes from the **runtime type of each element** — the declared `Animal[]` chose the
  *slot type*, never the method. Quote the rule while reading: *the runtime type picks the
  override; the declared type picks the overload.*

**Criteria check:** ☐ five predictions ☐ five actuals ☐ rule quoted.

## Exercise 2 — Both halves in one program

**Reference shape:** override (`Soundable`-typed reference to a `Dog` calling `speak()` → the
Dog's version) beside overload (`Parent p = new Child(); p.narrow(new Parent())` vs
`p.narrow(new Child())` → different overloads chosen by **declared** parameter type).

- Outputs: the override line depends on the *object*, the overload line on the *signature at
  the call* — one transcript, two rules.

**Criteria check:** ☐ each half demonstrated ☐ rule-to-output mapping.

## Exercise 3 — CCE and its fix

```console
Exception in thread "main" java.lang.ClassCastException: class Dog cannot be cast to class Cat
```

```java
if (a instanceof Dog d) { d.fetch(); }     // pattern: binds d, no second cast
```

- The CCE is thrown at the **cast line** — the point where declared and runtime types disagreed.
  The design-smell sentence: if you `instanceof` a whole hierarchy apart, you wanted subtypes
  doing the work (double dispatch / overriding) instead.

**Criteria check:** ☐ failure ☐ fix ☐ smell sentence.

## Exercise 4 — Notification hierarchy (independent)

**Reference shape:**

```text
[Email → ada@example.com] Your order shipped
[SMS → +2547…]            Your order shipped
[Push → device-9]         Your order shipped
```

- `sendAll(List<Notification> ns)` loops once, calling `format()` — **adding `Slack` required
  zero edits to `sendAll`** (the open-closed argument: the dispatch table is the hierarchy, not
  a chain of `instanceof`s).

**Criteria check:** ☐ mixed-list output ☐ add-a-type-without-editing claim demonstrated.

---

Next: [set-11-solutions.md](set-11-solutions.md)
