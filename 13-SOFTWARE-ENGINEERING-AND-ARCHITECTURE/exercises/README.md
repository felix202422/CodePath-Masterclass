# Exercises — 13 Software Engineering and Architecture

**Lessons:** this subject's eighteen lessons, in order, plus the subject README.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Sets 1–12 correspond to the lessons named in their titles and mirror each lesson's exercise
ladder (introductory → intermediate → independent) with observable completion criteria.
Completing all twelve sets *is* this subject's half of the milestone gate in
[ROADMAP.md](../../ROADMAP.md) Milestone 8 (architecture, testing, and security), and they
are the analysis half of the ADR you will owe Project 07.

**The lab you need.** Everything here runs against a scratch directory you may break at
will, plus one git repo for sets 1–2 — the exact shape the lessons were executed in:

```bash
mkdir arch-lab && cd arch-lab && git init
java -version        # the lessons were executed with Java 25; Java 21+ compiles every probe
```

Each set's probe is reconstructible from the code blocks quoted in its lesson: the lesson
shows the source *and* the transcript it produced on the authoring machine (see
[VERSIONS.md](../../VERSIONS.md) for the policy — where your versions differ, the
**behaviour** is the criterion and the exact text is yours to capture). Scripts named in
the lessons (`solid-probes.sh`, `cleanarch-probes.sh`, `scale-probes.sh`, …) are the
authoring names for batteries of single-file Java programs; rebuilding them from the
lesson's quotes is part of the exercise, and sets that say "run the probe" accept your
reconstruction as long as the measurement logic matches.

**Predict before you run.** Every set below that says "predict" means paper first: write
the expected lint count, hash result, balance, or compile verdict *before* you run it — a
prediction you did not write down is not a prediction. Where a set says "drill", it means
the deliberate-break shape used throughout the lessons: green → plant the violation → red
with the reason visible → revert → green (that exact drill is set 8's closing exercise).

---

## Set 1 — The complete development process · Software development lifecycle → `the-complete-development-process.md` · `software-development-life-cycle.md`

1. Rebuild the `orderdesk` mini-repo shape: initialize a repo, commit a feature in labeled
   stages (idea → requirement → acceptance criterion → code → test → validation), and
   print the trace with your stage labels in the subjects.
   **Criteria:** a `git log` trace whose subjects map to lesson stages; each commit's
   stage named before you look at the lesson's own nine-commit trace for comparison.
2. Reproduce a validation catch: compute a value, compare it against a written
   expectation, and make the comparison fail once (the lessons caught `18.70 → 21.40`).
   **Criteria:** the failing comparison output captured, the fix, and the passing output —
   plus one sentence on why the check must live in a script and not in your head.
3. Reproduce the false-green incident: commit code while a test fails, and demonstrate
   that `git commit` happily records it; then add a pre-commit or CI gate and show the
   same change refused.
   **Criteria:** the red run, the commit that succeeded anyway, the gated run refusing
   it; the lesson's counter-example (`GREEN_EXIT=0` versus two commits made while red)
   matched by your own capture.
4. **Independent:** design the minimum viable process for a two-person team shipping one
   feature a week: which stages are mandatory, which are merged, and what the single
   quality gate is.
   **Criteria:** a one-page process with stage → artifact → gate for each step; every
   omitted stage justified by the cost you measured in exercises 1–3.

## Set 2 — Requirements engineering → `requirements-engineering.md`

1. Take one feature of an app you use and write three functional requirements plus two
   GIVEN/WHEN/THEN acceptance criteria with concrete values (no "fast", no "recent").
   **Criteria:** the five statements; each AC executable by a reader as a table of input →
   expected output, the way the lessons' `acc-eu-2lines 21.4` and `acc-eu-discount10 19.26`
   were.
2. Reproduce the ambiguity probe: take one requirement containing an ambiguous noun or
   preposition ("region", "recent", "large") and execute *both* readings, measuring the
   difference (the lessons read FR1 as buyer-region vs shop-region: `21.4` vs `20.0`,
   `DELTA=1.4`).
   **Criteria:** both readings run, the delta printed, and the requirement rewritten so a
   single reading survives.
3. Build a traceability matrix for a real piece of your code: requirements → code → test,
   and report the uncovered cells (the lessons reported `5/5 … uncovered: []`).
   **Criteria:** the matrix with at least one empty cell found and honestly filled; each
   cell's evidence a file/line pointer, not a claim.
4. **Independent:** a stakeholder says "users should be able to export their data."
   Produce the ambiguity audit and the acceptance criteria that would end the argument.
   **Criteria:** at least four distinct readings (format? scope? where? how often?) each
   with a written decision, and two ACs the stakeholder could sign without translation.

## Set 3 — Functional and non-functional requirements → `functional-and-nonfunctional-requirements.md`

1. Route three lines as the lessons did: one functional, one quality-as-adjective, one
   with a number — then rewrite the adjective as a measurable budget.
   **Criteria:** the three-way routing with justification; the rewritten NFR states
   workload, metric, budget, and measurement method (the lessons' `budget 50000us` form).
2. Execute the same code against two budgets: one it passes and one it fails (the lessons
   got `NFR1 PASS: 480us` at 50000 µs and `NFR1 FAIL: 463us exceeds budget 100us` — the
   *faster* run failing).
   **Criteria:** both transcripts; one sentence stating why a passing NFR proves nothing
   without a stated budget.
3. Measure the methodology gap: run a workload cold and warm and report both (the lessons
   captured `1424us` vs `463us`), then state which one your budget applies to.
   **Criteria:** two timings, the ratio, and a written warm-up policy for your own CI.
4. **Independent:** "the dashboard must feel instant." Produce the full NFR packet:
   metric, percentile, budget, workload, and the measurement that would falsify it.
   **Criteria:** an NFR a reviewer can execute, plus the determinism check the lessons
   used (rerun and report distinct results — theirs was `10000 reruns, distinct results = 1`).

## Set 4 — Use cases and UML → `use-cases-and-uml.md`

1. Write two use cases (actor, goal, main flow, two alternates) for a feature you know,
   including a rejection path that leaves state unchanged.
   **Criteria:** both use cases with at least one alternate and one guarded transition;
   the rejection's post-state stated explicitly, as `ship on DRAFT` leaves the state in
   the lessons' `ScenarioLab`.
2. Draw the state machine for that feature and execute it: main path plus two rejected
   transitions, printing state after every step (the lessons ran `DRAFT -> SUBMITTED ->
   PAID -> SHIPPED` plus `alt-cancel-submitted` and two rejections).
   **Criteria:** the executed trace with every state visible; `SCENARIO-LAB`-style
   summary line from your own runner.
3. Draw a sequence diagram for one endpoint you built, including the error path, and
   validate the mermaid (or your tool of choice) parses it.
   **Criteria:** the diagram source plus the validation result; the lesson's honest note
   respected — if your tool cannot render a view type, say so rather than faking it.
4. **Independent:** for a feature request you recently received, produce the minimal UML
   set that answers it — and name every diagram you deliberately did *not* draw.
   **Criteria:** at most two views, each with one sentence justifying its existence; the
   omission list with reasons.

## Set 5 — Clean code → `clean-code.md`

1. Take the lesson's `before` source (the 12-line `a(l, d, r)` method) and refactor it
   yourself before reading the lesson's `after`; then compare behavior on the six
   fixtures.
   **Criteria:** all six fixture outputs equal before vs after (the lessons got
   `fixture-EU-2lines before=21.4 after=21.4` … `fixture-EU-2lines-disc 104.33`);
   your readable metrics printed the way the lesson's `before: lines=12 maxDepth=1
   shortIdentifiers=8` were.
2. Add a seventh fixture — a negative discount (surcharge) — and show both versions
   agree on it too.
   **Criteria:** the new fixture's expected value derived on paper first, then executed
   equality for both versions.
3. Reproduce the lying-comment drill: write an AC that fails on code whose comment
   promises the opposite order, then fix the code and show `RED → GREEN` (the lessons
   captured `got 20.0 want 19.9` → `got 19.9 want 19.9`).
   **Criteria:** both verdicts captured; one sentence on why renaming could never have
   caught this.
4. **Independent:** you inherit a 400-line function with no tests. Design the first three
   moves and say what evidence tells you each move was safe.
   **Criteria:** a ordered plan whose every step names its safety check (characterization
   fixtures, hash, or AC), borrowed from the lessons' measure → change → measure shape.

## Set 6 — SOLID principles → `solid-principles.md`

1. Run the OCP half of the probe (reconstruct from the lesson's code): one design where
   a new rule modifies an existing file, one where it does not (the lessons captured
   `MODIFIED existing file -> Calculator.java` vs `0 existing files modified; new files:
   WholesalePricing.java FeatureWholesaleB.java` — both suites green).
   **Criteria:** both change-request transcripts with file counts; which design you would
   ship, and what its cost is (Section 11 of the lesson).
2. Reproduce the LSP violation: identical client code over `Rectangle`/`Square`-style
   types where substitutability breaks (the lessons billed `Rectangle: 50.0 units2` vs
   `Square: 100.0 units2`, plus `BrokenShape threw UnsupportedOperationException`).
   **Criteria:** the two different outcomes from one client function; the rewrite that
   makes substitution safe, executed both ways.
3. Drill the DIP: hash the stable abstraction file, run a failure twice, and show the
   second run fails for the *right* reason (the lessons' `second-run exit=1 … out.log
   missing` against `ServiceB.java hash unchanged`).
   **Criteria:** the hash evidence plus the exit codes; one sentence on what the hash
   proves that the exit code alone cannot.
4. **Independent:** a teammate argues a 1200-line `OrderProcessor` is fine because it
   works. Using only measurements you can take (concerns, reasons to change, change
   requests), write the counter-argument or concede it.
   **Criteria:** at least two measured numbers with the change request that produced them;
   a verdict either way.

## Set 7 — Separation of concerns → `separation-of-concerns.md`

1. Run the scattering probe on a rule of your own: count the copies (the lessons got
   `copies of the validation rule: 4 files, 4 occurrences`), centralize it, and re-run the
   same change request (theirs: `files edited: EmailPolicy.java` — `1 file(s)`).
   **Criteria:** before/after file counts for the identical change request; the rule
   stated in one sentence each time.
2. Measure tangling: list a file's reasons to change and its foreign imports (the lessons
   counted `reasons to change in OrderPage.java: 4` with `java.sql. java.util. javax.mail.`).
   **Criteria:** the reason list with the import evidence for each; which reason you would
   move out first and why.
3. Reproduce the retest-scope collapse: after centralizing, the retest scope for one rule
   (the lessons went `retest scope: 4 concerns` → `1`).
   **Criteria:** both scope counts and the tests you would actually run for each.
4. **Independent:** you are handed a 3000-line module reporting four change reasons.
   Propose the split, predict the new per-file reason counts, then execute one change
   request against both shapes.
   **Criteria:** predicted vs actual counts; the change request run in both worlds.

## Set 8 — Design patterns → `design-patterns.md`

1. Run all five pattern probes and, for each, write the smell it answered and the number
   that moved (the lesson's table: `decision points 6 → 0`, `5 across 2 files → 0`,
   `8 classes for 3 options` vs `4 classes for 8`, observer/repository hashes).
   **Criteria:** a five-row table from your own runs; every row names the change request
   that produced its numbers.
2. Add a fourth pricing rule to both Strategy designs (conditional and strategy) and
   re-measure the decision points.
   **Criteria:** both designs' new counts; the behavior-equality check across all cases
   re-run green.
3. Reproduce the factory's missing case: add a channel the table lacked and confirm the
   caller count stays at zero (the lessons' `callers edited for the new channel: 0`).
   **Criteria:** the new channel's output line plus the caller hashes or file lists
   unchanged.
4. **Drill, then independent:** run the deliberate-break drill on one probe — sabotage a
   behavior check so it passes wrongly, watch the suite's equality check catch it, revert.
   Then take a real change request from your project's history and answer: which pattern,
   if any, would have reduced the measured change surface — with the number you would
   have measured.

## Set 9 — Layered architecture · Modular monoliths → `layered-architecture.md` · `modular-monoliths.md`

1. Run the layered lint on two designs of the same rule: tangled vs layered (the lessons
   got `rule 1 violations=1 / rule 2 violations=1` vs `0`/`0`, while both compiled —
   Java does not enforce layers).
   **Criteria:** both lint outputs; one sentence on why compiling proves nothing here.
2. Execute a currency (or equivalent cross-cutting) change in each design and count
   disturbed concerns: the layered run edited `1 file (OrderController.java)` with
   service and repository hashes unchanged; the tangled run edited 1 file but disturbed
   `3 markers`.
   **Criteria:** both file lists with hashes or marker counts; the retest scope implied by each.
3. Prove the module boundary: call the public API (compiles), then reach in from outside
   the package and capture the compiler's refusal (the lessons' `error: InvoiceCalculator
   is not public in billing; cannot be accessed from outside package`).
   **Criteria:** both compiles' outcomes; the internal-change run leaving `0 files outside
   billing modified`.
4. **Independent:** take the shared-module anti-pattern (the lessons' `Common is in 2
   feature dependency cones … count=2`) and apply it to a module you own: count the cones,
   name the second feature that will be broken by a `Common` change, and propose the move.
   **Criteria:** the cone count from real import analysis and a migration step that keeps
   both features compiling.

## Set 10 — Clean architecture · Domain-driven design → `clean-architecture.md` · `domain-driven-design.md`

1. Reproduce the dependency rule as the compiler states it: an inner-ring entity importing
   a framework fails alone (`error: package jakarta.validation.constraints does not
   exist`), then compile the clean rings with `lint: inner-ring outward mentions = 0`.
   **Criteria:** both compile outputs; the lint's exact watch-list printed with the run.
2. Add a second adapter around one use case and hash the inner rings before and after
   (the lessons got `0 inner-ring files modified (hashes unchanged)` with `http adapter`
   and `cli adapter` both driving the same object).
   **Criteria:** the hash files compared, and both adapters' output lines showing
   formatting-only differences.
3. Drill the lint: plant one outward import in a use case, watch the count go `0 → 2`,
   revert, confirm `0` (the lessons' planted `java.sql` + `HttpDelivery`).
   **Criteria:** all three lint outputs; the planted line quoted.
4. Run the DDD vocabulary audit on two contexts you know: list each context's used
   fields, form the union, and report real overlap vs accidental coupling (the lessons:
   `6 fields … real overlap=1, accidental coupling=5`).
   **Criteria:** both field lists, the union, and the two counts; the decision they imply
   (merge or split) stated from the numbers.
5. **Independent:** build the boundary crossing for your two contexts — two models plus an
   ACL that accepts one valid case and rejects one invalid case with a domain-language
   reason (the lessons' `not shippable yet: DRAFT`) — and make the value object for the
   amount they share reject a negative and a mixed-currency construction.
   **Criteria:** four executed lines — valid crossing, invalid crossing, negative-money
   rejection, currency-mismatch rejection; every type classified entity or value with a
   one-sentence justification.

## Set 11 — Event-driven architecture · Distributed systems → `event-driven-architecture.md` · `distributed-systems.md`

1. Prove the fan-out: publish one event to two subscribers, add a third, hash the
   producer across the addition (the lessons: `third subscriber added without touching
   the producer`).
   **Criteria:** both hashes and the third subscriber's output line.
2. Break a naive consumer: run the five-event stream (two duplicates) through a consumer
   without dedup, then through the guarded one, on the identical stream (the lessons got
   `naive: wrong balance by 60.0` vs `final: balance=130.0 duplicates rejected=2
   out-of-order rejected=1`).
   **Criteria:** both final balances; which guard fixed which error, attributed line by line.
3. Reproduce the timeout ambiguity: abandon a slow handler at 100 ms, retry, and count
   executions (the lessons: `caller gave up after 100ms while the server was still
   working` → `server executed 'charge' 2 times for 1 logical request`); then add the
   idempotency key and show one applied effect.
   **Criteria:** the count before and after; the key's storage stated (what survives a restart).
4. Run the partition pair: last-writer-wins losing an acknowledged write vs quorum
   refusing the minority side (`side AB has 2/3 votes -> write accepted` / `side C has
   1/3 votes -> write rejected with unavailable`).
   **Criteria:** both stories' outcomes; which side of CAP each sacrifices, named.
5. **Independent:** design the idempotency + sequence contract for a real flow you own:
   key format, dedup window, out-of-order policy, and what a reconciliation run would
   re-check. Execute a simulation with one duplicate, one reordered event, and one
   handler crash between apply and ack.
   **Criteria:** the four-line contract, the executed transcript, and the reconciliation
   query's inputs.

## Set 12 — Microservices · Scalability and reliability · Technical debt → `microservices.md` · `scalability-and-reliability.md` · `technical-debt.md`

1. Execute the saga both ways: the no-compensation state (`order=true payment=false
   stock=true -> inconsistent`) and the compensated end state (`order=false payment=false
   stock=false -> consistent, just failed`).
   **Criteria:** both state tuples; the compensation's own failure mode named with the
   mechanism you would give it (retry, dead letter, alert).
2. Measure the hop tax: three independent calls sequentially vs overlapped (the lessons
   got `sequential=151ms parallel=62ms`) and state what stays serial no matter what.
   **Criteria:** both timings from your machine; the budget arithmetic for a page that
   needs five hops under a 300 ms budget.
3. Run the contract experiment: a shared type renamed so an untouched consumer fails to
   compile (`error: cannot find symbol` / `symbol: variable total`), then the
   consumer-owned variant compiling clean (`consumer redeploy count = 0`).
   **Criteria:** all three compile outcomes (P3a–P3c); the migration policy you would
   adopt for the versioned copy.
4. Size a cache honestly: measure hit ratio on a hot-set workload and a uniform one (the
   lessons: `56.5%` with `500.0ms → 223.2ms` modeled latency, `5.2%` uniform on the same
   LRU(50)).
   **Criteria:** both ratios with the workload statement that makes them meaningful; the
   cache size you would actually provision and the evidence for it.
5. Retry with backoff: replay the 30-client outage with immediate retries and with
   jittered exponential backoff (the lessons: `120` attempts landing in the outage vs
   `90`, backoff reaching past `t=500ms`).
   **Criteria:** both arrival counts; your policy written as attempts, delays, jitter, and
   deadline cap.
6. **Independent:** produce a debt register for code you own: measured counts (the
   lessons' form: `lines=17 decisionPoints=10 duplicatedTaxLadders=2` vs `lines=10
   decisionPoints=2 duplicatedTaxLadders=1`), one injected-bug demonstration showing
   whether your suite would catch it (`bug escaped` vs `RED`), and a repayment curve run
   with *your* growth assumption — labeled as an assumption.
   **Criteria:** the three captures; the register entry with trigger change, estimate in
   feature-cost units, and the honest statement of which numbers you measured versus
   assumed.

---

**After all twelve sets:** Milestone 8's exercise requirement is satisfied for this
subject. The next thing it buys you is the ADR for
[Project 07](../20-PROJECT-LABORATORY/project-07-secure-production-application/README.md) —
set 9's boundary evidence and set 12's trade-off numbers are the raw material.
