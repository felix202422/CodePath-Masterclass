# 01 — Computer Foundations

Before writing programs, you need a working mental model of the machine running them. This subject
builds that model: what a computer is made of, what an operating system does, how files and
processes work, how numbers and text are stored in binary, what Boolean logic is, where memory
ends and storage begins, and how a program turns into executed instructions.

## What this subject covers

- Hardware roles: CPU, memory, storage, input/output — and why their speeds differ so wildly.
- Software and operating systems: what an OS actually provides to programs.
- Files and processes: the two abstractions you will touch in every later subject.
- Binary and number systems: base-2, hex, two's complement, and how text and images are just numbers.
- Logic and Boolean algebra: the algebra behind every `if` you will ever write.
- Memory and storage: RAM versus disk versus cache, in bytes and in consequences.
- How programs execute: fetch–decode–execute, compilation versus interpretation, and why errors
  happen where they do.

## Why it matters

Every "mysterious" behaviour later in your career has a foundations-level explanation. Slow code is
usually memory access. File-not-found errors are process working directories. Security bugs are
often permission bits. Learners who skip this subject spend the rest of the curriculum memorizing
rules that are, for them, arbitrary.

## Prerequisites

- [00-START-HERE](../00-START-HERE/README.md) — orientation and the study method used throughout.

## Lessons

- `computer-hardware.md` — the components and the storage hierarchy
- `software-and-operating-systems.md` — what an OS does for a program
- `files-and-processes.md` — paths, permissions, and what "a running program" is
- `binary-and-number-systems.md` — base-2, base-16, and representation of numbers and text
- `logic-and-boolean-algebra.md` — truth tables, operators, and logical equivalence
- `memory-and-storage.md` — RAM, cache, disk, and the cost of moving data
- `how-programs-execute.md` — instructions, compilation, interpretation, and the execution cycle

## Exercises and practice

`exercises/` contains problem sets that are deliberately unglamorous and completely foundational:
convert numbers between bases, evaluate Boolean expressions by hand, reason about what an OS does
when you open a file, and trace a tiny program's execution step by step. Every set ends with an
independent problem and completion criteria; solutions are separated in `exercises/solutions/`.

## Expected outcomes

You can explain to a non-programmer what happens when a program runs; convert between decimal,
binary, and hex without a tool; evaluate a Boolean expression and name the law you used; state the
difference between RAM and disk in terms a programmer cares about; and predict what a program
does at the instruction level — which is exactly the skill debugging requires.

## Common blockers

- **"This is not programming, why am I here?"** Seven short lessons. The return on them compounds
  through the entire curriculum.
- **Memorizing without modeling.** If you cannot explain *why* RAM is faster than disk, you have
  memorized a fact, not learned a foundation.

## Next

[02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — turn this mental model
into your first algorithms and programs.