# Solutions — 13 Software Engineering and Architecture

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lessons of the same name. Transcripts marked as
*authoring machine* were executed during this batch against scratch labs plus the batteries
the lessons name — `ReqLab`, `BudgetProbe`, `ScenarioLab`, `CleanLab`, `solid-probes.sh`,
`soc-probes.sh`, `patterns-probes.sh`, `layered-probes.sh`, `modular-probes.sh`,
`cleanarch-probes.sh`, `ddd-probes.sh`, `evt-probes.sh`, `dist-probes.sh`,
`micro-probes.sh`, `scale-probes.sh`, `debt-probes.sh` — with **Java 25** on Windows and
git 2.x for the `orderdesk` mini-repo. Your versions' exact text will differ — the
**behaviour and the reasoning** are the criteria; your own captured output is your evidence.

| Set | Lesson(s) | File |
|---|---|---|
| 1 | The complete development process · Software development lifecycle | [set-1-solutions.md](set-1-solutions.md) |
| 2 | Requirements engineering | [set-2-solutions.md](set-2-solutions.md) |
| 3 | Functional and non-functional requirements | [set-3-solutions.md](set-3-solutions.md) |
| 4 | Use cases and UML | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Clean code | [set-5-solutions.md](set-5-solutions.md) |
| 6 | SOLID principles | [set-6-solutions.md](set-6-solutions.md) |
| 7 | Separation of concerns | [set-7-solutions.md](set-7-solutions.md) |
| 8 | Design patterns | [set-8-solutions.md](set-8-solutions.md) |
| 9 | Layered architecture · Modular monoliths | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Clean architecture · Domain-driven design | [set-10-solutions.md](set-10-solutions.md) |
| 11 | Event-driven architecture · Distributed systems | [set-11-solutions.md](set-11-solutions.md) |
| 12 | Microservices · Scalability and reliability · Technical debt | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring
machine's real capture — the nine-commit stage trace and its validation catch
(`18.70 → 21.40`), the false-green pair (`GREEN_EXIT=0` while two commits were made red),
`acc-eu-discount10 19.26` from `REQ-LAB`, `NFR1 FAIL: 463us exceeds budget 100us`,
`SCENARIO-LAB ALL PASS`, `before: lines=12 … shortIdentifiers=8` → `after: lines=7 … 0`,
the LSP billing split (`50.0` vs `100.0 units2`), `duplicatedTaxLadders=2 → 1`,
`rule 1 violations=1 → 0`, `error: InvoiceCalculator is not public in billing`,
`lint: inner-ring outward mentions = 0 → 2 → 0`, `accidental coupling=5`,
`naive: wrong balance by 60.0` → `final: balance=130.0`, `sequential=151ms parallel=62ms`,
`error: cannot find symbol / symbol: variable total`, `56.5%` vs `5.2%` hit ratios,
`120 → 90` retry arrivals, and the debt curve `repay-now=160.0 / repay-at-6=192.1 /
never=542.1`. Where a solution gives a *shape* (a matrix, an ADR outline, a process page,
a register entry), no single correct text exists — the criteria in each set's
[README](../README.md) define what a reviewer looks for.

**What could not be executed, and how it is labelled:** the authoring machine is Windows
without a production system, so four kinds of work appear as *labelled reference* rather
than transcripts — the CI gate against a real hosted pipeline (the local pre-commit shape
is executed; the hosted one is described), the on-call/observability sides of set 12's
retry policy, production cache sizing from real traffic, and the org-level process design
in set 1's independent exercise. Their sections say exactly what to capture in your own
environment; they never pretend a transcript exists.

**Executed corrections worth knowing** (re-verified while writing these solutions): a lint
that has only ever printed `0` is unproven — plant the violation and watch it fire, or you
are trusting a rubber stamp; hash equality alone can mean "no change was attempted," so
every structural claim in this subject pairs a hash with an import/lint count; a passing
NFR says nothing without the budget printed next to it (the *faster* run fails the tighter
budget); a shared-DTO rename breaks consumers at compile time from *their* untouched
source, which is why the consumer-owned contract variant exists; and `git commit` never
runs your tests — the false-green incident in set 1 is reproducible on any machine in
under a minute.
