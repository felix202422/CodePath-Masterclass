# Solutions — Set 2: Arrays and their costs

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Reference numbers below were executed on the authoring machine (JDK 25.0.4.1,
> `javac --release 21`).

## Exercise 1 — The growth ladder

**Derivation.** Copies happen only when size exceeds capacity, i.e. at appends 5, 9, 17, 33,
65 (capacity doubles 4→8→16→32→64→128). Each event copies the *old* capacity:

```
copies = 4 + 8 + 16 + 32 + 64 = 124   (for 100 appends)
```

**Executed:** ladder `8 16 32 64 128`, `copies=124`. Matches.

Closed form for n appends from capacity 4, doubling: copies = 2·⌈n/4⌉·4 − 4 − (final slack) —
more cleanly: copies ≈ 2n − O(log n), the classic amortized-O(1) receipt. The two big runs:
n = 100,000 → `copies=131068` (**1.31 × n** — the same ratio the arrays lesson prints);
n = 1,000,000 → `copies=1048572` (**1.05 × n** — the ratio *falls* toward 2 from below as
slack amortizes).

**Criteria check:** ☐ ladder + copies predicted ☐ matched ☐ closed form written.

## Exercise 2 — Shift arithmetic

`remove(i)` on a size-20 list shifts every element **after** i one slot left: shifted count =
`size − 1 − i`.

| i | shifted elements | count | class |
|---|---|---|---|
| 0 | indices 1…19 move to 0…18 | 19 | worst, Θ(n) |
| 10 | indices 11…19 move to 10…18 | 9 | Θ(n/2) ≈ Θ(n) |
| 19 | nothing follows | 0 | best, Θ(1) |

A counting implementation prints exactly `19, 9, 0`. The O(n − i) rule from the lesson: cost
is position-dependent, and only the tail removal is cheap.

**Criteria check:** ☐ three predicted ☐ three counted ☐ O(n − i) connected to both.

## Exercise 3 — indexOf / lastIndexOf / insertAt

Keyed facts: `indexOf` compares at most n times and **moves nothing** — its shift counter
prints 0 for every input. `insertAt(i, v)` shifts `size − i` elements: front insert of a
size-n list shifts n, middle shifts n/2, end-insert shifts 0.

Implementation traps: `lastIndexOf` scans *backward* from size−1 and must stop at −1 without
wrapping (the classic bug is `i--` past zero wrapping to a huge positive index); `insertAt`
at `i == size` is legal (append) and must share the capacity-growth path with `add`.

**Criteria check:** ☐ 0 shifts for indexOf ☐ predicted shifts matched at front/middle/end.

## Exercise 4 — Append-only, made cheap (independent)

**Reference shape.** The problem's demand is exactly what a dynamic array already provides;
the design work is defending it:

- **Class:** `add` is Θ(1) *amortized* (worst-case Θ(n) on the doubling event) — state both;
  the pre-sized `ensureCapacity` escape hatch makes it worst-case Θ(1).
- **Counted evidence:** at n = 1,000,000 your run should land near the executed
  `1048572` copies (**1.05 × n**) with doubling from 4; the closed form is
  `2·2^⌈log₂ n⌉ − 4 − n ≤ 2n − 4`.
- **Growth factor argument (counted, ×1.5 vs ×2):** at n = 1,000,000, doubling copies
  2n − 4 ≈ 2,000,000 total; ×1.5 copies ≈ **3n** (each copy sums a geometric series with
  ratio 1.5, total ≈ n·(1/(1−1/1.5))·(1.5−1)/1.5... the executed counter is the arbiter —
  expect ≈3n). Doubling wins on copies; ×1.5 wins on peak memory (final capacity ≤ 2n vs
  ≤ 3n... actually ≤ 1.5n·2 — measure it: doubling's final capacity is < 2n, ×1.5's is
  < 1.5n only if you stop growing, else 2.25n). The honest verdict: ×2 copies less *in
  total*, ×1.5 holds *less slack at rest* — pick by whether CPU or memory is the constraint,
  and let your two counters, not the folklore, print the numbers.
- **Drawback to state:** worst-case Θ(n) add remains — a latency-sensitive caller (real-time
  audio, a tick loop) cannot tolerate the doubling event inside the frame, and the escape is
  pre-sizing, not magic.

**Criteria check:** ☐ class with amortized + worst ☐ counted 1M run ☐ factor comparison from
counters ☐ one stated drawback.

---

Next: [set-3-solutions.md](set-3-solutions.md)
