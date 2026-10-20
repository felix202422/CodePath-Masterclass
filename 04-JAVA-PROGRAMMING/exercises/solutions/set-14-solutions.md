# Solutions — Set 14: Collections

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — ArrayList vs LinkedList, measured

**Reference result shape** (machine-specific numbers; the *asymmetry* is the criterion):

```text
add(0, x) × 10000:  ArrayList ~25 ms   LinkedList ~4 ms     // front insert favors nodes
add(size, x) × 10000: ArrayList ~1 ms   LinkedList ~30 ms   // end append favors the array
```

- **Mechanism, not folklore:** ArrayList's front insert *shifts every element*; LinkedList's
  end append *walks the list* (its add-by-index lands at the tail after n hops). Timings vary —
  direction must not.

**Criteria check:** ☐ both timings ☐ asymmetry explained by mechanics.

## Exercise 2 — CME, then removeIf

```console
Exception in thread "main" java.util.ConcurrentModificationException
	at java.util.ArrayList$Itr.checkForComodification(...)
```

```java
words.removeIf(w -> w.length() < 3);     // the structure-aware path — no CME
```

- for-each uses an **iterator**; a structural change behind its back trips the modCount check.
  `removeIf` (or an explicit `it.remove()`) performs removal *through* the iterator.

**Criteria check:** ☐ both transcripts ☐ rule in one sentence.

## Exercise 3 — hashCode contract, witnessed

```text
with plain class (identity equals): map.get(new Point(5,5)) → null   // equal fields, different object
with record Point:                  map.get(new Point(5,5)) → 50     // equals+hashCode by components
```

- HashMap finds by **bucket from hashCode, then equals inside it** — break either half and the
  key "disappears" while standing in front of you. Records generate both halves correctly.

**Criteria check:** ☐ broken then fixed output ☐ contract quoted.

## Exercise 4 — Word frequency (independent)

**Reference shape:** `TreeMap<String, Long>` after case-folding (`toLowerCase`) with your stated
policy (punctuation stripped; blank policy declared). Output:

```text
the: 7
and: 4
cat: 2
…                      (sorted alphabetically — TreeMap gives this for free)
```

- **HashMap comparison sentence:** same counts, *unspecified order* — sorting would cost an extra
  `TreeMap<>(map)` or stream sort; choose by whether order is part of the contract.

**Criteria check:** ☐ top-5 hand-verified ☐ policy stated ☐ HashMap comparison.

---

Next: [set-15-solutions.md](set-15-solutions.md)
