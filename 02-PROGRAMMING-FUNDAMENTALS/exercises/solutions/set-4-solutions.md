# Solutions — Set 4: Variables and Data Types

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Trace the rebindings

**Answer.**

| After | Value | Type | Why |
|---|---|---|---|
| `x = 10` | `10` | `int` | literal binds |
| `x = x * 2` | `20` | `int` | reads old value, computes, rebinds (arrow moves) |
| `x = "ten"` | `"ten"` | `str` | names are not typed containers; the binding moves to a new type |

`type()` output on your machine confirms: `<class 'int'>`, `<class 'int'>`, `<class 'str'>`.

**Criteria check:** ☐ three states ☐ types correct ☐ verified by run.

## Exercise 2 — Six types

**Answer.** `10` → int; `10.0` → float; `"10"` → str; `True` → bool; `None` → NoneType;
`10 + 0.0` → **float**. The last one: any arithmetic mixing an int and a float produces a float —
the int is converted, not the reverse — which is why `10 + 0.0 = 10.0`, not `10`.

**Criteria check:** ☐ six types recorded ☐ `10 + 0.0` explained (int promotes to float).

## Exercise 3 — The two errors, made on purpose

**Answer.** Reproduced from the lesson's Example 3 (real messages):

```text
TypeError: can only concatenate str (not "int") to str
ValueError: invalid literal for int() with base 10: 'three'
```

Labels: the first is **wrong kind** — `+` cannot join a `str` and an `int`, and the message
names both types. The second is **wrong content** — `int()` accepts strings as input (right
kind) but `'three'` has no digits (bad content), and the message quotes the offender.

**Criteria check:** ☐ two real messages ☐ labels correct ☐ one-line rule stated for each.

## Exercise 4 — Convert safely

**Answer.** `reading = "42.7"`:

- `float(reading)` → `42.7` (the natural reading of the data).
- `int(float(reading))` → `42` (truncate toward zero; `int(reading)` directly fails).
- `int(reading)` raises (real): `ValueError: invalid literal for int() with base 10: '42.7'` —
  the content has a dot that `int` will not accept, and the message quotes the whole string.

**Criteria check:** ☐ float value ☐ int value with two-step conversion ☐ direct-int error
captured.

**Reviewer note:** `int` on a float *truncates* (`int(42.9)` → `42`); if you need rounding, use
`round()` deliberately — that is a requirement question, not a conversion detail.
