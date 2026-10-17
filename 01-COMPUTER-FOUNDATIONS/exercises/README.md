# Exercises — 01 Computer Foundations

**Lessons:** this subject's seven lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Each set corresponds to the lesson named in its title and mirrors that lesson's exercise ladder
(introductory → intermediate → independent) with observable completion criteria. Completing all
seven sets *is* the subject's completion gate in [ROADMAP.md](../../ROADMAP.md).

---

## Set 1 — Computer hardware → `computer-hardware.md`

1. Redraw the architecture diagram from memory with all four component types and the copy-to-load
   arrow. **Criteria:** CPU's three parts, memory, storage, I/O present; storage→memory arrow drawn.
2. Give the responsible storage band for each symptom: "saving took 10 seconds", "work lost after
   power cut", "system crawls with CPU idle". **Criteria:** correct band + one-line justification each.
3. Record your machine's RAM and storage type from a named tool. **Criteria:** four numbers + tool name.
4. **Independent:** triage the export-slowdown report (lesson exercise 5) — bottleneck, two helpful
   changes, one unhelpful change, and the confirming measurement. **Criteria:** all five parts with
   hierarchy-based reasoning.

## Set 2 — Software and operating systems → `software-and-operating-systems.md`

1. Classify five programs as application or system software with reasons. **Criteria:** correct
   classification; reasons reference what it does for whom.
2. Map scenarios to the OS's four jobs (shared printing → abstraction; crash isolation → memory
   management; etc.). **Criteria:** all mappings correct.
3. Write the six-step save path marking system calls and buffering. **Criteria:** all six steps,
   crossings marked.
4. **Independent:** diagnose the two support tickets (lesson exercise 5) — layer, evidence request,
   first test for each. **Criteria:** both classified with concrete evidence and a stated test.

## Set 3 — Files and processes → `files-and-processes.md`

1. Record path/size/modified/permissions for five files. **Criteria:** all four fields for each.
2. Predict a program's outcome when launched from three different directories with a relative path.
   **Criteria:** correct success/failure with working-directory reasoning.
3. Start, find (PID), terminate, and confirm removal of a disposable process.
   **Criteria:** PID recorded, method named, confirmed absent afterwards.
4. **Independent:** the portability bug — two fixes (path construction; launch directory), a
   justified preference, and a test run from an unrelated directory. **Criteria:** two distinct
   fixes + preference + test.

## Set 4 — Binary and number systems → `binary-and-number-systems.md`

1. Convert ten values across decimal↔binary and three across hex→decimal, each verified by
   reconversion. **Criteria:** all correct; verification shown for at least six.
2. Decode `#1F6FEB` to RGB and nibble groups. **Criteria:** correct channels + binary groups.
3. 2 GiB vs 2 GB in exact figures, explained for a mixed-up colleague. **Criteria:** both numbers
   correct + one-sentence base explanation.
4. **Independent:** the `0.1 + 0.2` mystery — why binary fractions miss, one concrete
   non-representable fraction, integer-cents recommendation, and a real consequence.
   **Criteria:** all four elements present.

## Set 5 — Logic and boolean algebra → `logic-and-boolean-algebra.md`

1. Truth tables for `A && !B`, `!A || B`, `A XOR B`. **Criteria:** 4 correct rows each.
2. Full tables for `!(A && B) || A` and `A && (B || !B)` + the law explaining the second.
   **Criteria:** correct tables + named law (e.g. complement/annulment).
3. Negate a three-factor English rule in "or" form, verified by De Morgan.
   **Criteria:** correct negation + symbolic check.
4. **Independent:** three-factor file-sharing policy — allow/deny pair, De Morgan consistency, table
   rows, and one real-world gap. **Criteria:** all four, tables correct.

## Set 6 — Memory and storage → `memory-and-storage.md`

1. Sketch 16 addressed bytes; place a 4-byte integer at address 4; name its bytes.
   **Criteria:** addresses correct; byte count justified by type size.
2. Match five failure messages to layers. **Criteria:** all correct.
3. Observe memory under load before/during/after with a named tool. **Criteria:** four numbers +
   one sentence on reclaim.
4. **Independent:** triage two hosts (allocation failure vs CPU/disk thrash) — band, next
   measurement, remediation, and a falsification test for each. **Criteria:** two complete triages.

## Set 7 — How programs execute → `how-programs-execute.md`

1. Redraw the cycle with the program counter's path. **Criteria:** four stages + PC path.
2. Classify five failures into syntax/runtime/logic with reporting stage. **Criteria:** all five.
3. Re-trace the instruction program with a taken jump; state final A and memory[9].
   **Criteria:** complete PC-by-PC trace; correct final state.
4. **Independent:** the diagnosis protocol for "build passed, wrong totals" — classification, three
   actions, and what the passing build does/does not prove. **Criteria:** all three sections.

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked, redo
the affected exercise one week later without looking — that second attempt is the one you keep.