# 18 — Advanced Engineering

This subject covers what senior engineers are actually paid for: making correct decisions under
uncertainty, in systems where failure is distributed and expensive. Concurrency, messaging, data
scaling, distributed patterns, design method, profiling, reliability, large-codebase work and
recorded decisions — each taught with the failure it answers.

## What this subject covers

- Concurrency and parallelism: threads versus processes versus tasks, races, locks, deadlocks, and
  what the GIL does and does not prevent.
- Message queues: brokers, delivery guarantees, visibility timeouts, retries, idempotency and
  dead-letter queues.
- Event streaming: partitioned logs, offsets, consumer groups, compaction and the honest version of
  "exactly once".
- Database scaling: indexes, replicas, shards and caches, each with its consistency cost.
- Distributed systems patterns: saga, two-phase commit, outbox, circuit breaker, bulkhead — each
  with the failure it answers.
- System design: a repeatable method from ambiguous requirements to capacity, latency and cost.
- Performance profiling: measure, hypothesise, verify — with counts that reproduce.
- Reliability engineering: SLOs, error budgets, chaos experiments and canary decisions.
- Large-codebase maintenance: dependency graphs, impact sets, reading order and ownership.
- Architecture decision records: capturing context and consequences while they are still known.

## Why it matters

Every pattern here solves a problem you can only recognise after building the earlier subjects.
Studying a saga before you have felt a two-stage write fail across services is memorising ceremony;
meeting the half-written order is what makes the pattern obvious. That is why this subject sits
after architecture, testing, security, operations, and cloud.

The second reason is economic. Distributed systems fail in ways that cost money per minute, and the
differences between two designs are usually measured in nines, latency percentiles and invoices —
not in elegance. This subject holds you to numbers.

## Prerequisites

- [13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md)
  — architecture vocabulary, requirements and trade-off thinking.
- [16-DEVOPS-AND-INFRASTRUCTURE](../16-DEVOPS-AND-INFRASTRUCTURE/README.md) — the operational
  reality these patterns live in.
- [17-CLOUD-AND-PRODUCTION](../17-CLOUD-AND-PRODUCTION/README.md) — availability, scaling,
  observability and incident handling, all quantified there.
- [05-DATA-STRUCTURES-AND-ALGORITHMS/big-o-notation.md](../05-DATA-STRUCTURES-AND-ALGORITHMS/big-o-notation.md)
  — complexity reasoning underpins every scaling decision.

## Lessons

- [Concurrency and Parallelism](concurrency-and-parallelism.md) — what threads, processes and tasks
  buy, and what they cost.
- [Message Queues](message-queues.md) — at-least-once delivery, idempotency, retries and dead
  letters.
- [Event Streaming](event-streaming.md) — partitioned logs, offsets, compaction and retention.
- [Database Scaling](database-scaling.md) — plans, replicas, shards, caches and pool ceilings.
- [Distributed Systems Patterns](distributed-systems-patterns.md) — saga, outbox, breaker, bulkhead,
  and the failure behind each.
- [System Design](system-design.md) — capacity, latency budget and cost, derived from assumptions.
- [Performance Profiling](performance-profiling.md) — counted work, Amdahl and the tail.
- [Reliability Engineering](reliability-engineering.md) — SLOs, budgets, chaos and canaries.
- [Large-Codebase Maintenance](large-codebase-maintenance.md) — impact sets, cycles, reading order.
- [Architecture Decision Records](architecture-decision-records.md) — decisions that survive their
  authors.

Every lesson embeds one executable probe as its first Python block and quotes that probe's real
output beneath it. The probes use only the standard library — `threading`, `asyncio`, `zlib`,
`sqlite3`, `datetime`, `re` — and run on the lab host (Windows 11, Python 3.13.5); save a block under
the filename given in the lesson and run it. Where a lesson needs a duration, the probe counts work
and prices it with declared constants instead of quoting a stopwatch, because a shared machine
cannot reproduce a millisecond. Infrastructure that does not exist on this host — a broker, a
streaming platform, a production database, an orchestration cluster — is marked **labelled
reference**: described and reasoned about, never presented as executed output.

## Exercises and practice

Case-driven, with observable criteria: find and fix a race, then prove the fix; design an order
pipeline that survives a payment failure and name every compensation; perform a capacity estimate
for a stated growth curve; profile a slow path by counting work and predict the payoff with Amdahl;
audit a set of ADRs for dangling supersessions and missing consequences. Every answer is judged on
its trade-off reasoning and its numbers, not on its conclusion.

## Expected outcomes

You can recognise a distributed failure mode and select a pattern that answers it, with the cost
named; produce a system-design document from ambiguous requirements with capacity, latency and cost
estimates; profile and fix a measured bottleneck rather than a suspected one; compute availability,
budget and blast radius; and leave decisions documented so the next engineer does not have to
rediscover them.

## Common blockers

- **Pattern collecting.** Knowing ten pattern names and knowing the failure each answers are
  different skills. Write the failure first, then look for the pattern.
- **Optimising before measuring.** Intuition about performance is reliably wrong; the profile is the
  argument.
- **Designing for scale you do not have.** The method includes saying "not yet, and here is the
  trigger that would change that".
- **Treating "exactly once" as a product feature.** It is a property of a source and a sink together,
  and it costs a dedupe store.
- **Writing ADRs nobody rereads.** A record with no consequences and no review date is decoration.

## Next

[19-PROFESSIONAL-DEVELOPMENT](../19-PROFESSIONAL-DEVELOPMENT/README.md) — the human side of the
craft: workflows, code review, documentation, open source, interviews and your portfolio.
