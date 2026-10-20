# Solutions — Set 11: Abstraction

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Instantiating the abstract

```console
Bike.java:3: error: Bike is abstract; cannot be instantiated
    Bike b = new Bike();
             ^
1 error
```

- The message names the class and the action — an abstract class promises methods it didn't
  write; the compiler will not let an incomplete object exist. (Bonus check from the lesson: an
  *unimplemented concrete* method gets `Bike.drive() in Bike cannot be applied`-style errors at
  its call sites.)

**Criteria check:** ☐ exact message captured.

## Exercise 2 — Abstract + concrete in one class

**Reference shape:** abstract `speak()` overridden by `Dog`; concrete `describe()` inherited and
*called through the subclass* (`rex.describe()` prints the parent's text). Output proves one
method was written twice-in-source but exists once, reachable through the child.

**Criteria check:** ☐ abstract overridden ☐ concrete inherited in output.

## Exercise 3 — Private constructor + factory

```console
Main.java:N: error: Account() has private access in Account
    Account a = new Account();
               ^
```

- The factory (`Account.open(String owner)`) is the *only* legal door — it can enforce
  invariants (logging, defaults) that `new` callers would bypass. This is exactly the lesson's
  "the refusal is the feature" pattern.

**Criteria check:** ☐ created via factory ☐ `new` refused, captured.

## Exercise 4 — Template method (independent)

**Reference shape:** `abstract class PaymentProcessor` with `public final void pay(int amount)`
= validate → `charge(amount)` (abstract) → receipt; two subclasses (`CardProcessor`,
`WalletProcessor`) print different `charge` lines through the identical skeleton.

```console
Main.java:N: error: pay(int) in PaymentProcessor cannot be overridden as final
```
*(or the override-of-final form — either wording proves the lock)*

**Criteria check:** ☐ two subclasses through the skeleton ☐ `final` refusal captured.

---

Next: [set-12-solutions.md](set-12-solutions.md)
