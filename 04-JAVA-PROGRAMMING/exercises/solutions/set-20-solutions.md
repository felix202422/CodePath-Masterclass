# Solutions — Set 20: JVM and Memory

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Four areas, four proofs

```console
defaults: inst=0  stat=0          → fields zero-initialized (heap/class state)
same Class object: true           → one Class object per loaded type (class metadata)
args = [one, two]                 → the launcher built the String[] (frame argument)
maxMemory = 4018 MB               → heap ceiling from Runtime (machine-specific)
StackOverflowError after 20538 frames  → per-thread stack depth, counted (varies)
```

- Plus the local's compile refusal: `error: variable might not have been initialized` — the
  asymmetry: **fields zero, locals must be assigned**.

**Criteria check:** ☐ five lines ☐ each mapped to its area-rule.

## Exercise 2 — Disassemble your own

**Reference example** (lesson's executed `Calc.class`): source `int s = 2 + 3 * 4;
System.out.println(s);` →

```text
0: bipush 14        ← compiler folded 2+3*4 into a constant (no iadd/imul exists)
2: istore_1         ← locals are numbered slots; s is slot 1
3: getstatic #7     ← System.out via constant-pool index
6: iload_1
7: invokevirtual #13  ← println(int): the VIRTUAL dispatch opcode
10: return
```

- **The surprise worth writing up:** constant folding (the JVM never did the arithmetic), or
  the implicit constructor's `invokespecial … "<init>"` line.

**Criteria check:** ☐ 5-instruction table ☐ surprise written up.

## Exercise 3 — The line-9 OOM, dissected

```console
$ java -Xmx32m Heap
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
	at Heap.main(Heap.java:9)
$ echo $?
1
```

- **No-concat variant:** `e.printStackTrace()` (or a pre-allocated constant) shifts the trace
  to the **loop line** — because the handler no longer allocates its report string.
  **Rule:** inside an OOM handler, allocate nothing beyond constants you already have; the
  handler allocates too, and recovery code can be the second victim.

**Criteria check:** ☐ both traces ☐ changed line explained ☐ handler rule.

## Exercise 4 — Budget harness (independent)

**Reference matrix (2 caps × 2 workloads):**

```text
32 MB, keep-all:    OOM reported (pre-allocated message), chunks ≈ 25–30
32 MB, drop-every-8: completes; consumed stays ≈ 8–12 MB
64 MB, keep-all:    OOM, chunks ≈ 55–60        (≈ cap in MB — 1 MB chunks)
64 MB, drop-every-8: completes; consumed flat again
```

- **Leak-shaped vs reclaimed:** kept chunks make `(total-free)` climb to the cap and die;
  periodic clearing makes it *plateau* — GC reclaimed what references were dropped. **What this
  view hides (named, cited):** an in-process delta can't show *which objects* held memory —
  a heap dump (`jmap`/`-XX:+HeapDumpOnOutOfMemoryError`) shows per-class counts and references;
  the JDK's HotSpot diagnostics docs describe the dump tooling.

**Criteria check:** ☐ spec + predictions first ☐ four transcripts ☐ analysis paragraph with the
named limitation.

---

Next: [set-21-solutions.md](set-21-solutions.md)
