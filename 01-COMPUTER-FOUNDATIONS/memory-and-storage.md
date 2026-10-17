# Memory and Storage

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Explain how memory is addressed by byte and why that matters for types and errors
- [ ] Distinguish RAM, cache, swap/virtual memory, and storage — including what survives what
- [ ] Describe what "out of memory" means versus "disk full", and diagnose which one you have
- [ ] Reason about locality: why data access patterns determine real-world speed

## 2. Prerequisites

- [computer-hardware.md](computer-hardware.md) — the hierarchy this lesson goes inside.
- [files-and-processes.md](files-and-processes.md) — persistence and process isolation.
- [binary-and-number-systems.md](binary-and-number-systems.md) — bits, bytes, and size units.

## 3. Introduction

The word "memory" is used sloppily in everyday speech, which is precisely why memory bugs feel
mysterious. This lesson replaces the fuzzy notion with a working model: how memory is organized and
addressed, what the OS does when it runs short, how storage differs in kind — and the single
concept (locality) that explains most performance behaviour you will meet again later.

## 4. The Problem It Solves

The CPU needs data instantly (sub-nanosecond) but enormous capacity costs physical space, power, and
money at that speed. The engineering answers are **layering** (already introduced) and **virtual
memory** — the OS's trick of making every program *believe* it owns a large, private, contiguous
memory space while the reality is shared, fragmented, and sometimes partly on disk. Programs that
believe the fiction run correctly; programs that ignore the reality (by assuming infinite memory,
or constant access speed) eventually fail in production in ways users notice.

## 5. Core Concepts

### 5.1 Bytes and addresses: memory as a long row of numbered boxes

Memory is a vast array of bytes, each with an **address** (a number). To read four bytes starting
at address 1000, hardware fetches 1000–1003. Your language then *interprets* those bytes as an
integer, a text character, or part of a pixel — the same reinterpretation idea from
[binary-and-number-systems.md](binary-and-number-systems.md), now with locations.

Two consequences that follow you through the curriculum:

- **Types choose size.** A 32-bit integer occupies 4 bytes; reading four bytes as two 2-byte
  values gives a different number. The Java/TypeScript lessons on types are built on this.
- **Alignment and stride are real.** Accessing bytes in order (sequential) is dramatically cheaper
  than jumping around (random) — see locality below.

### 5.2 RAM: volatile, shared, finite

Characteristics you must be able to state without notes:

- **Volatile** — contents vanish without power. That is why programs live in *files* for permanence
  and in *memory* only while running.
- **Shared** — every running process competes for it. The OS enforces isolation
  ([software-and-operating-systems.md](software-and-operating-systems.md)), but capacity is
  collective.
- **Finite** — and when it runs out, something must give. What gives is next.

(Physical types — DRAM vs SRAM, refresh cycles, DDR generations — are real but secondary; cache
uses the faster, costlier kind, RAM the cheaper kind.)

### 5.3 Cache: where locality pays

The CPU keeps a sliver of recently used memory in **cache** (L1/L2/L3), measured in nanoseconds
versus RAM's tens of nanoseconds. Cache works because programs exhibit **locality**:

- **Temporal locality** — recently touched data is likely touched again (a loop variable).
- **Spatial locality** — data near what you just touched is likely next (the next array element,
  the next instruction).

Hardware therefore moves data in **lines** (blocks of ~64 bytes) rather than single bytes, betting
that you want the neighbours too. **Practical rule:** code that walks memory in order is fast;
code that jumps randomly (think: a linked structure scattered over a large array, or hash lookups
without a cache hit) is fast *only* when the pattern happens to fit cache. This is the seed of the
performance analysis in
[18-ADVANCED-ENGINEERING/performance-profiling.md](../18-ADVANCED-ENGINEERING/performance-profiling.md).

### 5.4 Virtual memory: the OS's sleight of hand

The OS gives each process its own **virtual address space**, mapping its addresses onto physical
RAM as needed. Two features fall out of this:

1. **Isolation** — a process physically cannot address another's memory (security and stability).
2. **Swap** — when RAM fills, the OS moves *inactive* pages of memory to a reserved storage area
   and marks them "not in RAM". When touched again, they are read back.

Swap is a pressure valve, not free memory: swapping makes a machine crawl, because each swapped
page read is a **storage-speed** operation (the hierarchy gap from
[computer-hardware.md](computer-hardware.md) — microseconds to milliseconds against nanoseconds).

### 5.5 Storage: persistence, and the two "full" errors

Storage (SSD/HDD) persists across power cycles and is addressed through the **file system**, which
turns raw blocks into named files with metadata. Two failure modes are distinct and must never be
confused:

| Symptom | Real cause | Typical message |
|---|---|---|
| Program cannot allocate more memory | RAM *and* swap exhausted (or a per-process limit) | `OutOfMemoryError` (Java), allocation failure, app crash |
| Cannot save a file | No space left on the device | `no space left on device`, disk-full dialog |

SSD versus HDD matters here: SSDs have no moving parts (fast random access, limited write
endurance), HDDs seek mechanically (slow random, cheap bulk). Database indexing lessons
([10](../10-DATABASE-ENGINEERING/README.md)) and backups
([16](../16-DEVOPS-AND-INFRASTRUCTURE/README.md)) both lean on this difference.

## 6. How It Works — the life of a value you assign

1. Your program declares a value → the OS/process allocates bytes at some virtual address.
2. First access: not in cache → fetched from RAM (~50–100 ns), a cache **line** of neighbours comes
   too.
3. Repeated accesses (loop): served from cache (~1–10 ns) — locality doing its job.
4. RAM pressure grows: OS may page an inactive region to swap on storage.
5. Program exits: the OS reclaims the address space; the value is gone — unless your program
   **wrote it to a file** (storage), which is the only way it survives.

## 7. Practical Examples

### Example 1 — "memory" in a real process (executed on the author's machine)

```bash
ps -o pid,rss,vsz,comm -p $$     # RSS = physical RAM in use; VSZ = virtual size (Linux)
```

```text
  PID   RSS    VSZ COMMAND
 4821  3540  11920 bash
```

*(Actual transcript; values differ per machine. Units are KiB.)*

**What to notice:** virtual size (`VSZ`) is much larger than physical (`RSS`) — the process "has"
far more address space than RAM it occupies. That is virtual memory visible in one line.

### Example 2 — diagnosing which "full" it is (worked reasoning)

```text
Scenario: a web app runs fine for days, then every request fails with
          "Could not allocate enough memory", while the disk has 200 GB free.

  Step 1: Which resource does the message name?        → memory, not storage.
  Step 2: Is the machine's RAM exhausted, or a per-process cap?
          Check: free -h (system) + container limits (if any).
  Step 3: Is swap thrashing? Look at si/so in vmstat / memory pressure on macOS.
  Step 4: Candidates: leak (memory grows over time) or undersized capacity.

Verdict: a memory problem — disk space is irrelevant. The fix path (leak vs resize) starts
with observing RSS over time, not touching the disk.
```

**Expected reasoning pattern:** match the symptom to the band, then measure that band only.

## 8. Real-World Applications

Capacity planning is mostly this lesson: "how much RAM does the database need?" Outages from memory
leaks are among the most common in industry — the signature is *slow growth then collapse*, which
you can watch once you know RSS exists. Caching strategies (Redis, in-memory indexes, browser
caches) are deliberate deployments of locality thinking. Even garbage collection
([04-JAVA-PROGRAMMING/jvm-and-memory.md](../04-JAVA-PROGRAMMING/jvm-and-memory.md)) is this lesson's
discipline applied to automatic reclamation.

## 9. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| Confusing RAM shortage with disk shortage | Both called "memory/storage" in casual speech | Read the error: allocation failed = memory; no space left = storage |
| Ignoring swap as "just slow" | Slow feels tolerable until it is not | Treat any swapping as an incident signal; capacity or leak, decide by measurement |
| Believing bigger cache access is "instant" uniformly | The hierarchy feels flat | Cache lines and locality explain *patterns*, not magic; measure before/after |
| Assuming memory freed to the OS immediately | Language runtimes hold pools | Java/Python keep allocated arenas — see the JVM lesson before judging "leaks" |
| Storing huge structures "just in memory" without a plan | Convenient until growth | State your ceiling and the behaviour at it *before* building |

## 10. Best Practices

- **Always know which band you are reasoning about** — cache, RAM, swap, disk, network. Name it
  explicitly when diagnosing; the wrong band wastes hours.
- **Design for the ceiling:** know what your program does at 2× its expected load — crash, degrade,
  or shed? State it before users discover it.
- **Prefer sequential access patterns** in hot code (arrays walked in order beat pointer-chasing
  through scattered objects); you will see this concretely in
  [05-DATA-STRUCTURES-AND-ALGORITHMS](../05-DATA-STRUCTURES-AND-ALGORITHMS/README.md).
- **Measure memory over time, not at one instant** — growth trend is the fact; a snapshot is an
  anecdote.

## 11. Limitations and Trade-Offs

This lesson simplifies modern complexity: NUMA architectures, huge pages, memory-mapped files,
compressed swap, and zram all add nuance. Virtual memory itself is a *trade*: isolation and
oversubscription bought with occasional slow page faults. SSD endurance limits and HDD bit-rot are
real constraints behind the storage boxes. The layered model accommodates all of them — each
newcomer optimizes or extends a band rather than overturning the picture.

## 12. Practical Exercises

### Introductory

1. **Draw the address picture.** Sketch 16 bytes with addresses, mark a 4-byte integer at address
   4, and state which bytes it occupies. **Completion criteria:** correct addresses named and the
   byte count justified by the type's size.
2. **Sort the failure messages.** Given five messages (out of memory, disk full, swap thrash,
   cache miss, permission denied), match each to its layer from the diagrams.
   **Completion criteria:** correct layer for all five.

### Intermediate

3. **Observe your machine under load.** Open a heavy page or large file and watch free memory
   (`free -h`, Activity Monitor, Task Manager) before and during; record numbers and what reclaimed
   memory after closing. **Completion criteria:** four numbers with tool names, plus one sentence
   on which band did the work.
4. **Explain swap to a non-programmer** using the hierarchy diagram, including why enabling swap
   does not make a machine "have more RAM" in any useful sense. **Completion criteria:** explanation
   includes a speed comparison and a concrete symptom.

### Independent problem-solving

5. **Triage an unknown report.** Server logs show: application error `Cannot allocate 512 MB`;
   monitoring shows disk at 40%; another host reports slowness with CPU at 90% and disk light
   blinking constantly. For each host, identify the implicated band, the measurement you would
   request next, and one likely remediation — then state what measurement would *disprove* your
   first hypothesis for each. **Completion criteria:** two separate triages, each with band,
   next measurement, remediation, and a falsification test.

## 13. Knowledge Check

1. What does "volatile" mean, and which two storage types differ on it?
2. Explain temporal and spatial locality, and why hardware fetches cache *lines*.
3. What is swap, at what speed does it operate, and what does heavy swapping tell you?
4. How do you distinguish "out of memory" from "disk full" in an error message?
5. Why can a process have a virtual size far larger than the machine's RAM?

## 14. Completion Criteria

- [ ] You can diagram byte addressing and name the bytes a typed value occupies
- [ ] You can explain locality and predict which access pattern is fast
- [ ] You diagnosed (from written symptoms) memory vs storage vs CPU in at least one triage case
- [ ] You observed real memory figures on your machine with a named tool

## 15. Summary

- Memory is bytes at numbered addresses; types decide interpretation and size.
- Cache exploits locality; random access patterns pay the full hierarchy price.
- Virtual memory gives isolation and swap — a pressure valve priced in latency.
- RAM exhaustion and disk exhaustion are different failures with different messages.
- Memory problems are found by *trends over time*, not snapshots.

## 16. Next Steps

- [how-programs-execute.md](how-programs-execute.md) — the final piece: how the CPU turns these
  bytes into action, instruction by instruction.