# Solutions — Set 3: Pointer trade-offs

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Reversal, traced then run

**The three-pointer discipline.** Before the loop: `prev = null`, `curr = head`. Per
iteration, in order: `next = curr.next` (save the forward link), `curr.next = prev` (reverse
the link), `prev = curr` (advance prev), `curr = next` (advance curr). The assignment order
is the whole algorithm — swap the last two and the list is severed into a one-node list plus
an unreachable chain.

Five-node list `1→2→3→4→5`, one line per pointer change:

```
prev=null curr=1  : next=2, 1.next=null, prev=1, curr=2   → 1→null | 2→3→4→5
prev=1   curr=2  : next=3, 2.next=1,   prev=2, curr=3   → 2→1→null | 3→4→5
prev=2   curr=3  : next=4, 3.next=2,   prev=3, curr=4   → 3→2→1→null | 4→5
prev=3   curr=4  : next=5, 4.next=3,   prev=4, curr=5   → 4→3→2→1→null | 5
prev=4   curr=5  : next=null, 5.next=4, prev=5, curr=null → 5→4→3→2→1→null
```

Final head is `prev` (5). **Complexity:** n − 1 iterations, Θ(n) time, Θ(1) extra space —
the in-place property that arrays cannot match. The executed `after` list equals
`5 4 3 2 1`.

**Criteria check:** ☐ paper trace ☐ pointer assignments named (3 per step) ☐ run matches.

## Exercise 2 — Empty-state battery

Four policies, each a *decision* you write before the code:

| Case | Recommended policy | Why |
|---|---|---|
| `addLast` on empty | legal — becomes the one-element list | empty is a normal state, not an error |
| `remove` the only node | legal — list becomes empty (`head = null`) | the common path after "pop the last" |
| `remove` on empty | throw `IllegalStateException("remove from empty list")` | a silent `null` return forces every caller to null-check and hides bugs |
| `peek` on empty | throw, same message family | consistency: both reads/writes of a missing element refuse alike |

The message must **name the operation and the state** — `index out of bounds`-style context
is what the arrays lesson's `index 17, size 17` lesson bought you.

**Criteria check:** ☐ four cases exercised ☐ policies printed ☐ no stack trace escapes.

## Exercise 3 — Step-counter law (1,000-node list)

| Operation | Steps (visits) | Worst case | Note |
|---|---|---|---|
| `get(k)` | k + 1 | 1,000 (k = 999) | position-dependent: Θ(k), not Θ(n) |
| `removeFirst(value)` | matches position + 1 | 1,000 | scans from head; average ≈ n/2 for a random target |
| `removeLast(value)` | n (all visited), 0 removed if absent | 1,000 | must scan the *whole* list to prove absence |
| `addLast` with tail pointer | 1 | 1 | the tail-pointer fix from the lesson |

The asymmetry to state: `removeFirst` and `removeLast` differ *only* in when they stop —
first stops at the hit, last cannot stop early. A counter run confirms both saturate at 1,000
for a missing key.

**Criteria check:** ☐ three predictions ☐ three counts ☐ worst case named per operation.

## Exercise 4 — Splice structure (independent)

**Reference shape.** The demand — O(1) ends, insertion order, splice without copying elements —
describes a **doubly linked list with head/tail**, spliced by re-linking:

- `spliceBefore(dest, srcHead, srcTail)`: 4 re-links (dest.prev's next, srcHead.prev, srcTail
  next, dest.prev) — **independent of both n and the spliced length k**. That constancy is the
  structure's whole argument over arrays, where the same operation is Θ(n) shifts.
- **Measured per-node overhead:** each node holds a reference to its element plus two node
  references (next, prev) plus the object header. On a 64-bit JVM with compressed oops:
  header 12 B + 3 refs × 4 B = **24 B per node**, versus the array's ~4 B per slot. For
  1,000,000 boxed Integers that's ≈ 24 MB of pure linkage — the memory bill for O(1) splice.
  Measure it with `Runtime.totalMemory − freeMemory` across two builds, or derive it from
  `jol`/`Instrumentation.getObjectSize` if you have one; name whichever method you used.
- **Complexity summary:** ends Θ(1); random access Θ(n) (the array's O(1) given up); splice
  Θ(1) + no element copies.

**Criteria check:** ☐ splice counted at ≤ 4 re-links ☐ overhead measured with method named ☐
access trade-off stated.

---

Next: [set-4-solutions.md](set-4-solutions.md)
