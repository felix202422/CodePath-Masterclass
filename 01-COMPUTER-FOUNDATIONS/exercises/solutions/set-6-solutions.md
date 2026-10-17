# Solutions — Set 6: Memory and Storage

> ⚠ Attempt first; rebuild cold in a week.

## Exercise 1 — Addressing sketch

```text
address:  0   1   2   3   4   5   6   7   8   9  10  11 ...
content:  [   ][   ][   ][   ][ <--- 4-byte integer ---> ] ...

Integer at address 4 occupies bytes 4, 5, 6, 7 — four bytes because a 32-bit
integer is 32 bits = 4 bytes (bits/8 = bytes, from the binary lesson).
Reading it means fetching exactly that range; a type mismatch would reinterpret
the same four bytes as something else entirely.
```

**Criteria check:** ☐ addresses drawn correctly ☐ byte count justified by type size.

## Exercise 2 — Five messages → layers

| Message | Layer |
|---|---|
| Out of memory | Memory (RAM/swap) |
| Disk full / no space left on device | Storage |
| Swap thrashing (si/so activity) | Memory↔storage boundary — the OS paging |
| Cache miss (profiler stat) | Cache (CPU ↔ RAM) |
| Permission denied | OS protection (file permissions) |

**Criteria check:** ☐ all five correct.

## Exercise 3 — Observe your machine

**Reference format:**

```text
Tool: free -h (Linux) / Activity Monitor (macOS) / Task Manager (Windows)
Before: total 16Gi, used 9.2Gi
During (large page loaded): used 11.8Gi, available dropped to 3.1Gi
After (closed): used 9.6Gi — reclaimed ~2.2Gi; remainder held by app's allocator pools
```

**Criteria check:** ☐ four numbers ☐ tool named ☐ reclaim sentence (noting that runtimes keep pools
is a plus).

## Exercise 4 — Two-host triage (independent)

**Host A** — `Cannot allocate 512 MB`, disk at 40%.

- **Band:** memory (RAM/swap or a per-process/container cap). Disk 40% is a deliberate distractor.
- **Next measurement:** memory over time (RSS/process list + `free -h`), swap activity, container
  memory limits.
- **Remediation candidates:** fix leak (if trend grows) or raise capacity/limit (if stable and
  genuinely undersized).
- **Falsification:** if RSS is stable and far below limits while failures continue, the hypothesis
  is wrong — look for an application-level allocation quota or a failing allocator instead.

**Host B** — slowness, CPU 90%, disk light blinking.

- **Band:** primarily CPU compute, possibly competing disk I/O; the blinking light alone does not
  prove I/O-bound.
- **Next measurement:** per-process CPU breakdown (`top`/Resource Monitor) + I/O wait percentage.
- **Remediation candidates:** reduce/parallelize the hot workload; find the runaway process.
- **Falsification:** if I/O wait is high and CPU is mostly *idle* on closer inspection (90% being
  another metric), reclassify to the storage band — measurement, not the anecdote, decides.

**Criteria check (per host):** ☐ band ☐ next measurement ☐ remediation ☐ falsification test.

---

Next: [set-7-solutions.md](set-7-solutions.md)
