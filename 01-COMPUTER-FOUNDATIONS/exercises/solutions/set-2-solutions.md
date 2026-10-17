# Solutions — Set 2: Software and Operating Systems

> ⚠ Attempt first; rebuild cold in a week.

## Exercise 1 — Application vs system software

| Program | Class | Reason |
|---|---|---|
| Browser | Application | Serves the user directly; uses OS services for network/files |
| Calculator | Application | User-facing tool built on OS interfaces |
| Device driver | System (part of OS ecosystem) | Translates OS requests into device-specific commands |
| Disk formatter | System utility | Directly manages hardware-managed structures; normally needs elevated privilege |
| Compiler | Application (development tool) | A program like any other; reads/writes files via the OS |

**Criteria check:** ☐ five classifications ☐ reasons reference "what it does for whom".

**Reviewer note:** drivers and format utilities are the debatable pair; the tell is *who they
serve* (the OS/hardware vs the user) and the privilege they require.

## Exercise 2 — Scenario → OS job

| Scenario | Job |
|---|---|
| Two apps print at once, output interleaved sensibly | **Abstraction** (one printer interface) + scheduling of the queue |
| One app crashes; others unaffected | **Memory management** (isolated address spaces) |
| Same program runs on two different laptops | **Abstraction** (hardware differences hidden) |
| Fair CPU while six apps run | **Scheduling** |
| Student account cannot read a staff file | **Protection** (permissions) |

**Criteria check:** ☐ mappings correct.

## Exercise 3 — The save path, six steps

1. Program calls "open for writing" → **system call** (crossing 1).
2. OS checks **permissions** and resolves the path (working directory if relative).
3. OS locates the file on storage; returns a connection to your program.
4. Program writes bytes — first into a **memory buffer** (not yet durable).
5. OS **flushes** buffer → storage at some point (deltas: power loss can lose recent writes).
6. Close finalizes: metadata (size, timestamps) updated.

**System calls:** steps 1–3 (and the eventual flush trigger). **Buffering:** step 4.

**Criteria check:** ☐ six steps ☐ crossings marked ☐ buffering identified.

## Exercise 4 — Two support tickets (independent)

**Ticket A** — "After installing App X my whole computer freezes; even the mouse lags."

- **Layer:** OS-level resource contention (App X monopolizing CPU/memory/swap — system-wide effect).
- **Evidence requested:** does it happen in Safe Mode/boot without App X? Task Manager/`top`
  utilization during a freeze (CPU, memory, swap activity); whether *all* apps lag or only some.
- **First test:** remove/disable App X and compare — a controlled A/B.

**Ticket B** — "The same app is slow but everything else is fine."

- **Layer:** application layer (isolated process behavior).
- **Evidence requested:** does the slowness follow the app to another machine/user account? Its own
  process CPU/memory profile vs others.
- **First test:** profile *that process* while reproducing; check whether it is compute-bound or
  waiting (the app's own I/O), before touching system settings.

**Why this is the right split:** system-wide symptoms implicate scheduling/memory-management jobs;
app-scoped symptoms implicate the process. The evidence requests distinguish them *before* any
change is made — the discipline the lesson's four jobs exist to enable.

**Criteria check:** ☐ both classified ☐ concrete evidence each ☐ first test stated per ticket.

---

Next: [set-3-solutions.md](set-3-solutions.md)
