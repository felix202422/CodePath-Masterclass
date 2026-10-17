# 18 — Advanced Engineering

The subjects here are "advanced" only in the sense that they compress experience: concurrency and
parallelism, message queues and event streaming, database scaling, distributed-system patterns,
system design method, performance profiling, reliability engineering, working in large codebases,
and recording decisions as ADRs.

## What this subject covers

- Concurrency and parallelism: threads vs processes vs async, races, locks, and lock-free
  reasoning.
- Message queues: brokers, delivery guarantees, retries, idempotency, and dead-letter queues.
- Event streaming: logs, partitioning, consumer groups, and exactly-once claims examined critically.
- Database scaling: read replicas, sharding, caching layers, and the consistency costs of each.
- Distributed-system patterns: saga, outbox, circuit breaker, bulkhead, sidecar — each with the
  failure it answers.
- System design: a repeatable method for ambiguous requirements, capacity estimates, and trade-off
  documentation.
- Performance profiling: measure, hypothesize, verify — with tools, not intuition.
- Reliability engineering: SLOs, error budgets, chaos experiments, and incident learning.
- Large-codebase maintenance: navigating, changing safely, and knowing when to stop reading.
- Architecture decision records: capturing context and consequences while they are still known.

## Why it matters

This material is what senior engineers are actually paid for: making correct decisions under
uncertainty, in systems where failure is distributed and expensive. It is placed at the end on
purpose — every pattern here solves a problem you can only recognize after building the earlier
subjects. Studying a saga before you have felt the pain of a two-phase commit across services is
memorizing ceremony.

## Prerequisites

- [13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md)
  — architecture vocabulary and trade-off thinking.
- [16-DEVOPS-AND-INFRASTRUCTURE](../16-DEVOPS-AND-INFRASTRUCTURE/README.md) — the operational
  reality these patterns live in.
- [05-DATA-STRUCTURES-AND-ALGORITHMS](../05-DATA-STRUCTURES-AND-ALGORITHMS/README.md) — complexity
  reasoning underpins every scaling decision.

## Lessons

- `concurrency-and-parallelism.md` · `message-queues.md` · `event-streaming.md`
- `database-scaling.md` · `distributed-systems-patterns.md` · `system-design.md`
- `performance-profiling.md` · `reliability-engineering.md`
- `large-codebase-maintenance.md` · `architecture-decision-records.md`

## Exercises and practice

Case-driven: find and fix a race condition in a provided concurrent program; design an order
pipeline that survives a payment-service failure (which pattern, and why that one); perform a
capacity estimate and choose a scaling path for a stated growth curve; profile a provided slow
service and document the measurement that changed your mind; write an ADR for a real decision from
your own project. Every answer is judged on its trade-off reasoning, not its conclusion.

## Expected outcomes

You can recognize a distributed failure mode and select a pattern that answers it, with its cost
named; produce a system-design document from ambiguous requirements with capacity estimates;
profile and fix a measured bottleneck rather than a suspected one; and leave decisions documented
so the next engineer does not have to rediscover them.

## Common blockers

- **Pattern collecting.** Knowing the names of ten patterns and the failure each answers are
  different things. Write the failure first.
- **Optimizing before measuring.** Profiling exists because intuition about performance is
  reliably wrong.
- **Designing for scale you do not have.** The method includes saying "not yet, and here is the
  trigger that would change that".

## Next

[19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md) — the human side of the
craft: workflows, review, documentation, interviews, and your portfolio.