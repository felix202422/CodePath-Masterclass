# 13 — Software Engineering and Architecture

Architecture is not diagrams — it is the set of decisions that are expensive to reverse. This
subject teaches you to make those decisions deliberately: from requirements and the full
development process, through SOLID and design patterns, to modular monoliths, clean architecture,
event-driven systems, and the honest costs of distribution and microservices.

## What this subject covers

- The complete development process: all 26 stages from problem identification to product
  improvement, with one worked example running through the whole guide
  (`the-complete-development-process.md`).
- Software development life cycle: how teams actually run it, iteratively.
- Requirements engineering: elicitation, validation, and the cost of a wrong requirement.
- Functional and non-functional requirements: making "fast, secure, scalable" testable.
- Use cases and UML: the minimum modeling notation that earns its keep.
- Clean code: naming, function design, comments that explain why.
- SOLID principles: each with a failure it prevents, not a slogan.
- Separation of concerns: the principle everything else refines.
- Design patterns: the small set worth knowing (strategy, factory, observer, decorator, repository),
  each with the smell that calls for it.
- Layered architecture: the default, and why it is a good default.
- Modular monoliths: boundaries without distribution — the right answer for most teams.
- Clean Architecture: dependency direction, and when its ceremony pays.
- Domain-driven design: ubiquitous language, entities, value objects, bounded contexts.
- Event-driven architecture: coupling, ordering, and delivery guarantees.
- Distributed systems: latency, partial failure, and the fallacies.
- Microservices: the operational bill, and the smaller architectures to try first.
- Scalability and reliability: vertical vs horizontal, SLOs, and failure budgets.
- Technical debt: recognizing, measuring, and repaying it.

## Why it matters

The difference between a junior and a senior engineer is rarely typing speed — it is the ability to
choose the *simplest* architecture that satisfies the requirements and to name its costs. This
subject is placed after you have built real things (subjects 07–12), because architecture without
implementation experience is vocabulary. It is placed before testing and security so those
practices attach to structure rather than to code dumps.

## Prerequisites

- [04-JAVA-PROGRAMMING](../04-JAVA-PROGRAMMING/README.md) — patterns are expressed in Java.
- [09-FRONTEND-ENGINEERING](../09-FRONTEND-ENGINEERING/README.md) and
  [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) — you need a real multi-layer
  application to reason about.

## Lessons

- `the-complete-development-process.md` · `software-development-life-cycle.md`
- `requirements-engineering.md` · `functional-and-nonfunctional-requirements.md`
- `use-cases-and-uml.md` · `clean-code.md` · `solid-principles.md` · `separation-of-concerns.md`
- `design-patterns.md` · `layered-architecture.md` · `modular-monoliths.md`
- `clean-architecture.md` · `domain-driven-design.md` · `event-driven-architecture.md`
- `distributed-systems.md` · `microservices.md` · `scalability-and-reliability.md`
- `technical-debt.md`

## Exercises and practice

Exercises are analysis and design work against real code: identify the SOLID violations in a given
module and refactor them with a test; write an architecture decision record for a feature you
built; take a "microservices" proposal and produce the case for a modular monolith instead; model a
bounded context for a domain you know. Each includes review criteria, since design work is judged,
not just completed.

## Expected outcomes

You can read requirements and propose an architecture with its costs written down; defend a
decision with at least one considered alternative; refactor toward SOLID with tests proving
behavior was preserved; and explain to a stakeholder why distribution is being avoided (or
embraced) in specific, economic terms.

## Common blockers

- **Patterns as goals.** A pattern is a named solution to a smell you can demonstrate. Applying
  one "because best practice" is how codebases become unreadable.
- **Premature distribution.** Microservices buy independent scaling and team autonomy at the price
  of network failure modes and operational overhead. Most products do not need that bill.
- **Diagrams without decisions.** If a diagram records no trade-off, it is decoration.

## Next

[14-TESTING-AND-QUALITY](../14-TESTING-AND-QUALITY/README.md) — how you know the architecture and
its code actually do what everyone believes.