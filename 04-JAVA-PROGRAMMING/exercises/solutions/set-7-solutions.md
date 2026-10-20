# Solutions — Set 7: Classes and Objects

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — BankAccount

**Reference shape:** private `balance`, constructor taking the opening amount, `deposit(double)`
/ `withdraw(double)` that *return a boolean or throw* on invalid amounts (no silent negative
balances), `toString()` printing `Account[owner=…, balance=…]`.

- Sample trace: `deposit(100)` → balance 100; `withdraw(40)` → 60; over-withdraw attempt →
  rejected with your message, balance unchanged (the rejection line is the encapsulation preview).

**Criteria check:** ☐ four states via `toString` ☐ balance consistent after each call.

## Exercise 2 — == vs equals

```text
two equal-field objects:  a == b → false   a.equals(b) → true
same object:              a == c → true    a.equals(c) → true
```

- `==` compares **references** (identity), `.equals` compares **values** — the default
  `Object.equals` *is* identity, which is why classes must override it (the JVM lesson's
  `getClass() ==` used identity deliberately).

**Criteria check:** ☐ both pairs ☐ identity-vs-value sentence.

## Exercise 3 — The NPE on the record

```console
Exception in thread "main" java.lang.NullPointerException
	at Main.main(Main.java:N)
```

- The trace's line is the **first dereference** of the null reference (`ticket.priority()` on a
  never-assigned field). Prevention options you can name: constructor validation, a sentinel
  object, or `Optional` at the API boundary.

**Criteria check:** ☐ trace captured ☐ cause line identified.

## Exercise 4 — Ticket with invariant (independent)

**Reference shape:** private `id`, `priority`, `status`; constructor validates id non-blank;
`transition(newStatus)` legal only from a documented order — e.g.
`NEW → ASSIGNED → IN_PROGRESS → DONE` (anything else prints/logs a refusal such as
`illegal transition: DONE → NEW` and changes nothing); factory `Ticket.create(id, priority)`
bumps a static sequence for ids; `equals` by id only.

- Sample: five legal transitions all accepted (audit shows the chain), one illegal attempt
  refused with state unchanged — the invariant lives *in the transition method*, never at call
  sites.

**Criteria check:** ☐ five transitions ☐ refusal without crash ☐ invariant documented in code.

---

Next: [set-8-solutions.md](set-8-solutions.md)
