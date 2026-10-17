# 02 — Programming Fundamentals

This subject teaches programming itself, in a language-agnostic way: how to take a plain-language
problem and turn it into a running program made of variables, conditions, loops, functions, and
arrays — and how to find the bugs when it inevitably misbehaves.

## What this subject covers

- Computational thinking: decomposition, pattern recognition, abstraction.
- Algorithms and pseudocode: describing a solution precisely before writing syntax.
- Flowcharts: the same ideas, drawn.
- Variables and data types: what a variable really is, and why types exist.
- Operators, input, and output: the arithmetic and comparison of programs.
- Conditional statements: making decisions, and the classic comparison and precedence traps.
- Loops: `for` and `while`, termination, off-by-one errors, and loop invariants (informally).
- Functions and methods: parameters, return values, scope, side effects, decomposition.
- Arrays and strings: storing sequences, iterating, common transformations.
- Debugging fundamentals: forming hypotheses, using the debugger, reading errors.
- Modular programming: splitting a program into files with clear responsibilities.

## Why it matters

This is the subject that separates people who *use* tools from people who *write* solutions. Every
later technology — Java, React, SQL, Flutter — is a vehicle for these same ideas. Debugging and
modularization are treated as first-class skills here because in real work you will spend more time
reading and fixing code than writing new lines.

## Prerequisites

- [01-COMPUTER-FOUNDATIONS](../01-COMPUTER-FOUNDATIONS/README.md) — variables and loops are
  meaningless without a model of memory and execution.

## Lessons

Examples in this subject use Python 3.13 — chosen because its syntax is close to pseudocode, so you
learn programming ideas rather than language ceremony. (The first *typed* language is Java, in
[04](../04-JAVA-PROGRAMMING/README.md).) Teaching-language versions are pinned in
[VERSIONS.md](../VERSIONS.md).

- [computational-thinking.md](computational-thinking.md) · [algorithms-and-pseudocode.md](algorithms-and-pseudocode.md) · [flowcharts.md](flowcharts.md)
- [variables-and-data-types.md](variables-and-data-types.md) · [operators.md](operators.md) · [input-and-output.md](input-and-output.md)
- [conditional-statements.md](conditional-statements.md) · [loops.md](loops.md) · [functions-and-methods.md](functions-and-methods.md)
- [arrays-and-strings.md](arrays-and-strings.md) · [debugging-fundamentals.md](debugging-fundamentals.md) · [modular-programming.md](modular-programming.md)

All twelve lessons are written. Every Python transcript in them was executed on the authoring
machine (Python 3.13.5 — see [VERSIONS.md](../VERSIONS.md)); nothing is claimed as "actual output"
without a run behind it.

## Exercises and practice

`exercises/` ladders from guided modifications, to edge-case handling, to independent problems
stated without steps (e.g. "build a small text-report generator that reads a file and prints
summary statistics"). Each exercise has observable completion criteria, and at least one exercise
per set is a deliberately broken program you must diagnose.

## Expected outcomes

You can decompose a written problem into steps, express them as pseudocode, implement them with
functions and loops, handle empty and invalid input deliberately, and diagnose an off-by-one error
or an infinite loop by reading output — the exact competencies the ROADMAP's first promotion gate
tests.

## Common blockers

- **Copy-paste drift.** Typing code instead of copying it is not pedantry; muscle memory and
  typo-fixing are part of learning.
- **Skipping pseudocode.** Writing the algorithm in English first feels slow and is the fastest
  thing you can do.
- **Avoiding the debugger.** Printing statements are fine; the debugger is a career-long skill.

## Next

[03-DEVELOPER-TOOLS](../03-DEVELOPER-TOOLS/README.md) — a real development environment, the
terminal, and Git, so your work starts looking like professional practice.