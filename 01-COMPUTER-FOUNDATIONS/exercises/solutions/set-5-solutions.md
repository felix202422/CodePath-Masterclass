# Solutions — Set 5: Logic and Boolean Algebra

> ⚠ Attempt first; rebuild cold in a week.

## Exercise 1 — Three truth tables

**`A && !B`**

| A | B | !B | A && !B |
|---|---|---|---|
| F | F | T | F |
| F | T | F | F |
| T | F | T | **T** |
| T | T | F | F |

**`!A || B`**

| A | B | !A | !A \|\| B |
|---|---|---|---|
| F | F | T | **T** |
| F | T | T | **T** |
| T | F | F | F |
| T | T | F | **T** |

**`A XOR B`** (true exactly when inputs differ)

| A | B | A XOR B |
|---|---|---|
| F | F | F |
| F | T | **T** |
| T | F | **T** |
| T | T | F |

**Criteria check:** ☐ three tables ☐ 4 correct rows each.

## Exercise 2 — Full tables

**`!(A && B) || A`** — evaluating row by row gives **T in all four rows** (it is a tautology: if A
is true the right side wins; if A is false, `A && B` is false, so the left side wins).

**`A && (B || !B)`** — `B || !B` is always true (complement law), so this reduces to **`A && true`
= A** (identity law): result equals column A.

**Named law:** the complement (excluded-middle) law for the inner part; identity for the reduction.

**Criteria check:** ☐ correct tables ☐ law named.

## Exercise 3 — Negating a three-factor rule

```text
Rule:   active && balanceAboveZero && supported
Negation (De Morgan's 1):   !active || !balanceAboveZero || !supported
English: "the account is NOT active, OR the balance is NOT above zero, OR the region is NOT supported."
```

The trap: "not active **and** not above zero" would be wrong (it excludes cases where only one
fails). **Criteria check:** ☐ correct English using "or" ☐ symbolic check shown.

## Exercise 4 — The buggy allow rule (independent)

```text
Intended:  allow = isStaff || isOwner
Written:   allow = isStaff && isOwner          ← wrong: denies staff who aren't owners

Counterexample row (from a table): isStaff=T, isOwner=F
  written rule → F (denied)   ✗ per intent   intended → T (allowed) ✓

Corrected allow:  isStaff || isOwner
Deny (exact negation, De Morgan):  !isStaff && !isOwner
Consistency check: deny = !(allow) row-for-row — verified on all four rows.
```

**Criteria check:** ☐ counterexample row ☐ corrected allow ☐ De Morgan-derived deny.

**Reviewer note:** the deny rule being the *exact negation* of allow (not a second independent
guess) is what makes the pair provably consistent — the pattern behind real access-control
implementation.

---

Next: [set-6-solutions.md](set-6-solutions.md)
