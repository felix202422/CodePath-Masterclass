# Solutions — Set 5: FIFO discipline

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — Ring-buffer state, predicted then run

Using `(head, size)` with capacity 5 (front = `head`, count = `size`):

| Step | Action | head | size | slots |
|---|---|---|---|---|
| 1 | enq 1 | 0 | 1 | `[1, -, -, -, -]` |
| 2 | enq 2 | 0 | 2 | `[1, 2, -, -, -]` |
| 3 | enq 3 | 0 | 3 | `[1, 2, 3, -, -]` |
| 4 | deq | 1 | 2 | `[-, 2, 3, -, -]` |
| 5 | enq 4 | 1 | 3 | `[-, 2, 3, 4, -]` |
| 6 | enq 5 | 1 | 4 | `[-, 2, 3, 4, 5]` |
| 7 | enq 6 | 1 | 5 | FULL — policy row |

The wrap-around line is step 6: index `(1 + 4) % 5 = 0` — slot 0 is written *after* slot 4,
which is what "circular" buys over the shift queue.

**Criteria check:** ☐ five predicted lines ☐ matched ☐ wrap line identified.

## Exercise 2 — Boundary battery

| Case | Expected (throwing policy) |
|---|---|
| fill to capacity | enq 1..5 succeeds, `size == 5` |
| enqueue on full | `IllegalStateException("queue full: capacity 5")` |
| drain fully | 5 deqs in FIFO order, `size == 0` |
| dequeue on empty | `IllegalStateException("queue empty")` |
| reuse after wrap | head back near capacity, enq/deq still correct — the row that catches `(head+1)%cap` written as `head+1` anywhere |

The wrap-reuse row is the one that fails in buggy implementations: capacity math done right on
every path *except* the one that crosses the array end.

**Criteria check:** ☐ five rows ☐ declared policies ☐ wrap reuse clean.

## Exercise 3 — Ring vs shift, counted

At n = 10,000 enqueue+dequeue cycles:

- **Shift queue:** each dequeue moves the remaining elements — total moves =
  n + (n−1) + … + 1 = **n(n−1)/2 = 49,995,000 ≈ 5×10⁷** element moves. Θ(n²) total, Θ(n) per
  dequeue.
- **Ring:** each enqueue writes one slot, each dequeue moves **0** elements (only `head`
  advances). Total element moves = **n** (the enqueues). Θ(1) per operation.

The counter makes the class gap a number, not an adjective: ~5×10⁷ vs ~10⁴ — a factor of
~5,000 at this n alone, growing as n.

**Criteria check:** ☐ shift ≈ n²/2 counted ☐ ring O(n) counted ☐ class per implementation.

## Exercise 4 — Overwrite-on-full ring log (independent)

**Reference shape.** Keeping the newest d entries:

- `enqueue(x)` on full **overwrites** the oldest slot (`head`'s slot), advances `head`, keeps
  `size` saturated at capacity. No exception — the policy flips from refuse to overwrite.
- Read direction is unchanged: front = oldest *surviving*, back = newest. A `newestFirst()`
  iterator walks `(head + size − 1 − i) % cap`.
- **Classes:** enqueue Θ(1) worst (one write, no branches on fullness beyond the check); read
  Θ(1) at index k from front; full log read Θ(d).
- **The wrap-past-start test** (the one that breaks implementations): fill the capacity, then
  enqueue d more — `head` has advanced past its start; a snapshot reader must still see exactly
  d entries **in the right order**. Print the log after both halves of that run.
- **Why not a plain list:** a list capped by `remove(0)` is Θ(d) per eviction (the shift
  queue's bug again) and an uncapped one grows without bound — the ring is Θ(1) per entry and
  Θ(d) memory, provably.

**Criteria check:** ☐ wrap-past-start transcript ☐ both classes derived ☐ list alternative
 disqualified with its class.

---

Next: [set-6-solutions.md](set-6-solutions.md)
