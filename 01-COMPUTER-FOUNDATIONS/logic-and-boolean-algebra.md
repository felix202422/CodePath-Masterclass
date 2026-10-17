# Logic and Boolean Algebra

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Build and read truth tables for AND, OR, NOT, XOR, and the common compound expressions
- [ ] Evaluate any Boolean expression step by step, including negations and parentheses
- [ ] Apply De Morgan's laws and the identity/idempotent laws to simplify conditions
- [ ] Explain short-circuit evaluation and predict when an expression's right side never runs

## 2. Prerequisites

- [binary-and-number-systems.md](binary-and-number-systems.md) — bits as values; this lesson turns
  them into decisions.
- [software-and-operating-systems.md](software-and-operating-systems.md) — where conditions get
  executed (useful context, not strictly required).

## 3. Introduction

Every decision a computer makes reduces to one question about bits: **is this true or false?**
**Boolean algebra** (named after mathematician George Boole) is the mathematics of true and false,
with three operators — AND, OR, NOT — and a small set of laws for rewriting expressions. It is the
direct ancestor of every `if`, every loop condition, every validation rule, and every access-control
check you will ever write.

## 4. The Problem It Solves

Human instructions are full of compound conditions: "send a receipt *if* the payment cleared *and*
the address is present, *unless* the order was a draft." Translating such rules into hardware
requires a system where every possible combination of inputs has a defined output — no ambiguity,
no cases forgotten. Boolean algebra provides exactly that: a finite, complete algebra where
correctness can be **checked exhaustively**, row by row, in a truth table. When a validation rule in
your code lets through a case it should not, the fix is almost always a truth table you failed to
write.

## 5. Core Concepts

### 5.1 The three operators

| Operator | Symbol (code) | Reads as | True when… |
|---|---|---|---|
| AND | `&&` (Java/JS/C) | "both" | **both** inputs are true |
| OR | `\|\|` | "either" | **at least one** input is true |
| NOT | `!` | "opposite" | input is false |

Two more that earn their place:

| XOR | `^` (in Java) | "either but not both" | inputs differ |
| NAND | NOT(AND) | "not both" | false only when both are true |

The primitive basis: **everything else is built from these.** Hardware realizes each as a tiny
circuit of transistors — AND/OR/NOT gates — which is how a decision becomes physics.

### 5.2 Truth tables: complete, checkable specifications

A truth table lists every possible input combination and its output. AND:

| A | B | A AND B |
|---|---|---|
| F | F | F |
| F | T | F |
| T | F | F |
| T | T | **T** |

OR:

| A | B | A OR B |
|---|---|---|
| F | F | F |
| F | T | **T** |
| T | F | **T** |
| T | T | **T** |

**Two inputs give four rows; three give eight; n inputs give 2ⁿ.** That growth is why you write
tables only for the tricky rules — and why exhaustive checking works when n is small.

### 5.3 Precedence: order of evaluation

From tightest to loosest in most C-family languages (Java, JavaScript, C, C++):

1. `!` (NOT)
2. `&&` (AND)
3. `||` (OR)

So `!paid && ready` means `(!paid) && ready`, **not** `!(paid && ready)`. When in doubt, **add
parentheses** — they cost nothing and make intent visible. (Assignment and comparison operators sit
elsewhere in this order; languages define them all in their specification.)

### 5.4 The laws that simplify real conditions

| Law | Form | Why it matters in code |
|---|---|---|
| Identity | `A && true = A`, `A \|\| false = A` | Strips noise from expressions |
| Idempotence | `A && A = A`, `A \|\| A = A` | Duplicated checks add nothing |
| Double negation | `!!A = A` | `if (x)` ≡ `if (!!x)` |
| Distribution | `A && (B \|\| C) = (A && B) \|\| (A && C)` | Factor conditions for readability |
| **De Morgan's 1** | `!(A && B) = !A \|\| !B` | Rewriting negations without bugs |
| **De Morgan's 2** | `!(A \|\| B) = !A && !B` | ditto |

De Morgan's laws are the highest-value items above. Negating English is error-prone: "not (paid and
shipped)" is *either not paid, or not shipped* — not "neither". Getting this wrong is how
authorization checks get holes, a theme that returns in
[15-APPLICATION-SECURITY/access-control.md](../15-APPLICATION-SECURITY/access-control.md).

### 5.5 Short-circuit evaluation

Both `&&` and `||` stop as soon as the answer is determined:

- `A && B`: if `A` is false, **B is never evaluated**.
- `A || B`: if `A` is true, **B is never evaluated**.

Two consequences, both important:

1. **Idiomatic guards:** `x != null && x.length() > 0` — the second part only runs on non-null `x`.
   Short-circuiting is what makes that safe.
2. **Side effects on the right side become bugs:** if `B` *does* something (writes a log, calls a
   method), that thing sometimes happens and sometimes does not. Code review flags this; you will
   read such a flag in [19-PROFESSIONAL-DEVELOPMENT/code-review.md](../19-PROFESSIONAL-DEVELOPMENT/code-review.md).

## 6. How It Works — an expression down to gates

Take: **"deny if the request is not authenticated OR the user is not the owner."**

```text
English rule:   deny = !authenticated || !owner        (allow = authenticated && owner)
De Morgan:      !allow = !(!authenticated && !owner) ... not needed here — but note allow's
                negation is exactly the deny rule above, a classic check pairs them.
```

In hardware: two input signals, each passed through a NOT gate, into an OR gate — the output
physically goes high when either condition holds. In software: the same structure evaluated
millions of times per second inside your validation or authorization code. The equivalence is exact,
which is why truth-table reasoning transfers to every language you will learn.

## 7. Practical Examples

### Example 1 — evaluating step by step (worked)

Expression: `!(A || B) && (A || !B)` with **A = true, B = false**.

```text
  Step 1:  (A || B)      = (T || F) = T
  Step 2:  !(A || B)     = !T       = F
  Step 3:  !B            = !F       = T
  Step 4:  (A || !B)     = (T || T) = T
  Step 5:  F && T        = F        → the whole expression is FALSE
```

**Verification habit:** substitute and re-evaluate bottom-up once more; when practicing, also build
the full 4-row table and confirm each row — an error in any row invalidates your simplification.

### Example 2 — rewriting a buggy condition (before/after)

Intent: *"reject if the user is a guest **or** has not verified their email."*

```text
  Buggy:     if (!isGuest && emailVerified) → allow   (inverted intent: allows guests!)
             Table check: guest=T, verified=T → allows. WRONG per intent.

  Corrected: allow = !isGuest && emailVerified
             reject = isGuest || !emailVerified       (exact De Morgan negation of allow)
```

**What to notice:** writing *both* forms and building the four-row table catches inverted logic —
the technique, not the intuition, found the bug. The same exercise structure appears in
[14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md), where such tables become test cases.

## 8. Real-World Applications

Boolean logic is everywhere: database query filters (`WHERE paid = true AND total > 100`),
firewall rules (allow if source is trusted OR port is 443), form validation, search-engine query
operators, spreadsheet formulas, and every `if` in every language. Interviewers use truth-table
puzzles because they test whether you can reason about all cases rather than the typical one.

## 9. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| `=` (assignment) used where `==` (comparison) is meant | Similar symbols; some languages historically allowed it | Read your language's warning settings; add parentheses around comparisons |
| Negating compound conditions mentally | English "not A and B" is genuinely ambiguous | Apply De Morgan's laws on paper; write the truth table |
| Relying on precedence without parentheses | It works until it does not | Parenthesize mixed `&&` and `\|\|` — readability is free |
| Assuming `==` on text/objects compares content | References vs values | Know your language's equality rules (covered in 04 and 08) |
| Ignoring short-circuit side effects | Expression evaluated left to right is invisible | Never put actions inside conditions |

## 10. Best Practices

- **Write the truth table before coding any security- or money-related condition.** Four rows cost
  a minute and find the hole that costs a week.
- **Prefer positive, single-meaning conditions:** `if (isEligible)` over nested negations — extract
  a well-named boolean instead of piling operators.
- **Parenthesize mixed operators** and keep conditions under about three operands; longer
  conditions want a named helper.
- **State invariants in code comments** where they hold: "`paid && shipped` never both true" tells
  a reviewer what to check.

## 11. Limitations and Trade-Offs

Boolean algebra models binary decisions — but real rules often need three-valued logic (true,
false, **unknown**) or degrees. Databases use `NULL` semantics where `unknown ≠ true` (a genuine
source of SQL bugs covered in [10-DATABASE-ENGINEERING](../10-DATABASE-ENGINEERING/README.md));
fuzzy rules use weights. Also, readability has a ceiling: exhaustive case analysis stops scaling at
about three variables, beyond which you need decomposition and tests instead. Know when the tool
stops fitting — that judgment is part of engineering.

## 12. Practical Exercises

### Introductory

1. **Build three truth tables** for `A && !B`, `!A || B`, and `A XOR B`. **Completion criteria:**
   all rows correct for two inputs (4 rows each).
2. **Evaluate two expressions** by hand for every input combination (write tables): `!(A && B) || A`
   and `A && (B || !B)`. **Completion criteria:** complete tables plus one sentence naming the law
   that explains the second one's result.

### Intermediate

3. **Negate in English.** Write the exact negation of: "the account is active AND the balance is
   above zero AND the region is supported." Then verify with De Morgan's law. **Completion criteria:**
   a correct English negation using "or", plus the symbolic form.
4. **Find the bug.** Intended: allow staff *or* a verified owner. Written: `if (isStaff &&
   isOwner)`. Diagnose with a truth table, correct it, and write the deny rule as the exact negation.
   **Completion criteria:** table showing a counterexample row, corrected allow rule, and the
   negation derived by De Morgan.

### Independent problem-solving

5. **Design a three-factor policy.** A file-sharing rule: a user may read a file when it is public,
   OR when they are the owner, OR (they are a team member AND the file is not confidential AND the
   team has the share link). Write: the allow expression, the deny expression as its exact negation
   simplified with De Morgan's laws, and the truth table for the cases where it matters (at least
   the six rows involving the owner/team branches). Then identify one real-world case the policy
   *fails* to cover. **Completion criteria:** expression pair proven consistent with each other, a
   table with correct rows, and one honest limitation stated.

## 13. Knowledge Check

1. In your own words, why does AND map to a "both must be true" gate and OR to "at least one"?
2. Without looking: what does `!(A && B)` equal? `!(A || B)`?
3. Why is `x != null && x.length() > 0` safe, and what would happen if the order were reversed?
4. An expression with 4 inputs — how many truth-table rows? Why?
5. Give one reason to prefer `allow`/`deny` written as a pair over one long condition.

## 14. Completion Criteria

- [ ] You can produce correct truth tables for the core and compound operators, unaided
- [ ] You can negate any compound English rule correctly using De Morgan's laws
- [ ] You can evaluate nested expressions step by step and verify the result
- [ ] You can explain short-circuit evaluation and name one bug it prevents and one it can cause

## 15. Summary

- Boolean algebra = true/false values with AND, OR, NOT (plus XOR) — the algebra of all decisions.
- Truth tables make rules exhaustive and checkable; n inputs need 2ⁿ rows.
- De Morgan's laws translate negations correctly — the key to sound deny rules.
- Short-circuit evaluation makes guards safe and side effects dangerous.
- Parenthesize, name, and table-check any condition that guards money, access, or correctness.

## 16. Next Steps

- [memory-and-storage.md](memory-and-storage.md) — back to the machine: where values live, how
  bytes are addressed, and what actually happens when memory runs out.