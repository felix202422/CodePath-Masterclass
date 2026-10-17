# Solutions — Set 1: Computer Hardware

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Redrawn architecture diagram

**Answer.** Four component groups: **CPU** (control unit, ALU, registers), **main memory (RAM)**,
**secondary storage**, **input/output**, connected by buses. Critical arrow: storage → memory
("programs are *copied* into memory before execution"), and buses linking CPU ↔ memory ↔ I/O.

**Criteria check:** ☐ CPU parts ☐ memory ☐ storage ☐ I/O ☐ copy-to-load arrow.

**Reviewer note:** a common miss is drawing storage directly into the CPU — the diagram's discipline
is that the CPU reaches everything through memory/buses.

## Exercise 2 — Symptom → band

| Symptom | Band | Justification |
|---|---|---|
| Saving took 10 seconds | **Storage** | A save is a write to storage; latency is the disk band's cost |
| Work lost after power cut | **RAM vs storage** | The work sat only in volatile memory; it was never flushed to storage |
| System crawls, CPU idle | **Memory (and swap)** | Idle CPU + slowness = the machine is waiting on the memory/swap band, not computing |

**Criteria check:** ☐ three bands named ☐ one-line justification each.

## Exercise 3 — Measure your machine

**Reference format (values are machine-specific):**

```text
Tool:   Task Manager → Performance → Memory (Windows)
RAM:    16.0 GB total, 11.2 GB in use
Storage: NVMe SSD (Task Manager → Disks shows "SSD" media type)
Competitors: browser (~3.2 GB), editor (~1.1 GB), ...
```

**Criteria check:** ☐ four numbers ☐ tool named ☐ competitor sentence.

## Exercise 4 — Video export triage (independent)

**Answer.**

- (a) **Bottleneck: storage (or the device behind it).** Evidence: disk light constantly active at
  15% CPU — the cycle is *stalled on I/O*, not computing. Free RAM rules out the memory band.
- (b) **Helps:** export to a faster/different disk (move the wait); reduce concurrent disk
  activity (contention). **Does not help:** buying a faster CPU — utilization shows the CPU is not
  the limiting resource; more RAM likewise (6 GB already free).
- (c) **Confirming measurement:** an I/O monitoring tool (Windows Resource Monitor → Disk,
  Linux `iostat`) showing sustained high busy-time / throughput saturation during export, with CPU
  remaining low. A controlled test: same export targeting another disk; time it.

**Why a reviewer accepts this:** it classifies the stall band first, proposes changes *in that
band*, rejects a plausible-sounding change with hierarchy-based reasoning, and names a measurement
that could *disprove* the claim (if the disk shows low activity while CPU sits at 100%, the
diagnosis is wrong).

**Criteria check:** ☐ bottleneck + evidence ☐ two helps + one doesn't, justified ☐ confirming
measurement with disproof potential.

---

Next: [set-2-solutions.md](set-2-solutions.md)
