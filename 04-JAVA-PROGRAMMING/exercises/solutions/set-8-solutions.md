# Solutions — Set 8: Encapsulation

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Validated setter

**Reference shape:** `private double setpoint;` with `setSetpoint(double v)` that rejects
outside-range values using *your* message (`"setpoint 99.0 out of range [10.0, 30.0]"`).

- Sample: `setSetpoint(99.0)` → message printed (or described exception), field still 20.0;
  `setSetpoint(21.5)` → accepted, printed 21.5.

**Criteria check:** ☐ invalid rejected with your message ☐ valid accepted.

## Exercise 2 — Break it, then fix it

```text
broken:  setBalance(-50)  →  balance = -50.0   (state no domain could justify)
fixed:   setBalance(-50)  →  refused: balance stays 0.0
```

- The broken transcript is the criterion people skip: **capture the illegal state first** so the
  fix has something to be a fix *of*.

**Criteria check:** ☐ both transcripts ☐ broken-then-fixed named.

## Exercise 3 — final, refused

```console
Main.java:N: error: cannot assign a value to final variable tag
    obj.tag = "x";
    ^
```

- `final` + constructor assignment = **immutable-after-construction** for that reference: the
  field can never be reassigned (though a mutable object *itself* could still be mutated —
  note the distinction; `final List` can still be `add`ed to).

**Criteria check:** ☐ error captured ☐ final's guarantee stated precisely.

## Exercise 4 — Thermostat with audit (independent)

**Reference shape:** no public fields anywhere; range check at the setter; every *accepted*
change appends `"HH:mm-ish change: 20.0 -> 21.5"`-style entry to a private
`List<String> audit`; expose `audit()` as an unmodifiable view (`List.copyOf`).

- Sample: five accepted changes visible in the audit; one out-of-range attempt logged **and**
  rejected (or refused *without* an audit entry — either policy is fine **if you state it**;
  the criterion wants a stated policy, not a specific one).

**Criteria check:** ☐ attempt logged+rejected ☐ five accepted changes ☐ zero public fields.

---

Next: [set-9-solutions.md](set-9-solutions.md)
