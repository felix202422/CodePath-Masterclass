# Solutions — Set 4: LIFO discipline

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Bracket validation, traced

**Trace `"([{}])"`** (top of stack rightmost):

| Char | Action | Stack |
|---|---|---|
| `(` | push | `(` |
| `[` | push | `(` `[` |
| `{` | push | `(` `[` `{` |
| `}` | matches top ✓ pop | `(` `[` |
| `]` | matches top ✓ pop | `(` |
| `)` | matches top ✓ pop | empty |

Verdict: **balanced**. Final check: stack empty *and* no early return — both conditions, or
`"((("` passes.

**Trace `")(()"`** — the string that needs two independent failure detections:

| Char | Action | Stack |
|---|---|---|
| `)` | pop on **empty** → unbalanced, stop | empty |
| `(` | push | `(` |
| `(` | push | `(` `(` |
| `)` | pop | `(` |

Two bugs in one string: the leading closer trips the empty-stack guard, and the string *would*
also end non-empty. An implementation that only checks the final emptiness misses the first;
one that only checks the pop-on-empty misses `"((("`. **You need both checks.**

**Criteria check:** ☐ both traces ☐ both verdicts ☐ empty-pop guarded.

## Exercise 2 — Drain-order battery

| Scenario | Pushes/pops | Drain order | Lesson |
|---|---|---|---|
| push 1..5, drain | 5 pushes | `5 4 3 2 1` | pure LIFO — reverse of insertion |
| push 1,2, pop, push 3, drain | pops interleaved | `3 2 1` | the pop removed 2, so 1 surfaces after 3 — 3 arrives *later* than 2 but leaves *first* |
| drain empty | — | error `stack empty` | the policy row |

The sentence tying each to LIFO: the drain order is the **reverse of the push order of the
elements still present** — interleaving changes *which* elements are present, never their
relative order of departure.

**Criteria check:** ☐ three orders predicted ☐ three printed ☐ LIFO sentence.

## Exercise 3 — MinStack, O(1) worst case

**The design.** A single `min` variable fails because it cannot answer "what was the minimum
*before* this push?" when popping the current minimum. The fix: a second stack storing the
minimum *as of each depth*:

- `push(x)`: push onto values; if `x <= min()` push x onto mins (the `<=`, not `<` — duplicates
  must be recorded or the first pop of a duplicated minimum loses the tracker).
- `pop()`: pop values; if popped == mins.top, pop mins.
- `min()`: `mins.top` — one array read, **Θ(1) worst case**, not amortized.

Executed shape (20 mixed ops): after `push 5, push 3, push 3, push 7` the min stack holds
`5 3 3`; popping one 3 still reports min 3; popping the second reports 5. **Space:** Θ(n)
worst (strictly decreasing pushes store every element).

**Criteria check:** ☐ 20-op transcript with min after each ☐ single-variable failure explained
☐ space stated.

## Exercise 4 — Queue from two stacks (independent)

**Reference shape.** FIFO from LIFO primitives — `in` stack for pushes, `out` stack for pops:

- `enqueue(x)`: push to `in`. Θ(1).
- `dequeue()`: if `out` non-empty, pop it; else **pour** all of `in` into `out` (popping `in`,
  pushing `out` — reversing order once), then pop. The pour is Θ(n) but happens at most once
  per element across a full cycle.
- `peek` mirrors `dequeue` without the pop (careful: peeking when `out` is empty must pour too).

**The amortized proof, counted.** Run n enqueues followed by n dequeues with a total-op
counter. Each element is: pushed to `in` once (1), moved `in→out` at most once (1), popped
from `out` once (1) — **≤ 3 ops per element, ≤ 3n total, i.e. Θ(1) amortized per operation**
(2n if you count pushes and pops separately as the classic 2n bound). The single worst
dequeue can be Θ(n) (the pour) — that worst case is real and worth stating; amortization
promises the *average over a sequence*, never that one call.

**Criteria check:** ☐ counted run ≤ 3n stack ops ☐ amortization written as a total-cost
inequality ☐ the Θ(n) single-op worst case named.

---

Next: [set-5-solutions.md](set-5-solutions.md)
