# 04 — Java Programming

Java is the language of this curriculum's backend track and one of the most widely used languages in
industry. It is also an excellent *teaching* language: its type system makes your mistakes
loud and early, and its object model is explicit. This subject takes you from your first class to
streams, concurrency, and an understanding of what the JVM is doing underneath you.

## What this subject covers

- Environment setup (JDK 21, Maven) and program structure: classes, methods, entry points, packages.
- Variables and types, operators and control flow, methods — the fundamentals from subject 02,
  now with a static type system arguing with you.
- Arrays and strings; classes and objects; encapsulation.
- Inheritance, polymorphism, abstraction, interfaces and abstract classes — with the *why* of each,
  not just the syntax.
- Exceptions: catching, propagating, and designing error handling that isn't a silent `catch {}`.
- The Collections Framework and generics.
- File handling, lambdas and streams, functional programming style.
- Concurrency basics, and the JVM's memory model at a working-programmer's depth.
- Build tools: Maven, dependency management, and reproducible builds.

Every example compiles with `javac --release 21` and says so; the toolchain this was verified on is
in [VERSIONS.md](../VERSIONS.md).

## Why it matters

Java is the backbone of the backend track: [Spring Boot](../11-BACKEND-ENGINEERING/README.md),
the REST API projects, and most enterprise systems you will encounter use it or resemble it.
Learning OOP seriously here pays off three times — in Java, in the architecture subject, and in
every other language you later meet, because OOP ideas transfer even when the syntax does not.

## Prerequisites

- [02-PROGRAMMING-FUNDAMENTALS](../02-PROGRAMMING-FUNDAMENTALS/README.md) — control flow,
  functions, and arrays are assumed fluent.
- [03-DEVELOPER-TOOLS](../03-DEVELOPER-TOOLS/README.md) — you will compile from the terminal and
  version everything with Git; Maven needs a shell.

## Lessons

- `java-environment-setup.md` · `java-program-structure.md` · `variables-and-types.md`
- `operators-and-control-flow.md` · `methods.md` · `arrays-and-strings.md`
- `classes-and-objects.md` · `encapsulation.md` · `inheritance.md` · `polymorphism.md`
- `abstraction.md` · `interfaces-and-abstract-classes.md`
- `exceptions.md` · `collections-framework.md` · `generics.md`
- `file-handling.md` · `lambdas-and-streams.md` · `functional-programming.md`
- `concurrency.md` · `jvm-and-memory.md` · `build-tools.md`

## Exercises and practice

`exercises/` contains, per topic: guided exercises that extend a worked example, intermediate ones
combining topics with edge cases and unit-test requirements, and one independent design problem per
section (e.g. "model a library lending system with three collaborating classes and justify your
use of inheritance"). Solutions are separated and appear only after you have attempted.

## Expected outcomes

You can design and implement a small object-oriented program with clear responsibilities; choose
between an interface and an abstract class *and defend the choice*; handle errors at the right
layer; use streams where they improve clarity; explain what happens between `main()` and bytecode
and garbage collection; and build the whole thing reproducibly with Maven.

## Common blockers

- **Everything `static`.** A variable or method that belongs to the class instead of an instance is
  usually a sign you have not found the object yet.
- **Empty catch blocks.** Swallowing exceptions converts a bug into a mystery. Handle, propagate,
  or fail loudly.
- **Inheritance as code reuse.** Inheritance models an "is-a" relationship and couples you to a
  parent class forever; when you only want shared code, use composition.
- **Generics jargon.** Generics exist so the compiler can check your types *before* the program
  runs. Everything else is syntax.

## Next

[05-DATA-STRUCTURES-AND-ALGORITHMS](../05-DATA-STRUCTURES-AND-ALGORITHMS/README.md) — the
structures you will build *on*, and how to reason about their cost.