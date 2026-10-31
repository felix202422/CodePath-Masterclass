# Set 4 solutions — Use cases and UML → `use-cases-and-uml.md`

*Executed in the batch's `ScenarioLab` (Java 25, Windows 11) plus the mermaid validation
harness (`mtest`, mermaid 12.x under jsdom). Blocks marked *reference* are shapes to run
in your lab.*

## 1. Two use cases with a guarded rejection

Shape (reference — your feature, your actor):

**UC1 — Submit order (actor: Customer)**
Main flow: 1. Customer reviews cart → 2. system validates stock → 3. system marks order
SUBMITTED → 4. confirmation shown.
Alternate A1 (empty cart): step 2 fails → error shown, **order stays DRAFT**.
Alternate A2 (insufficient stock): step 2 fails → message shown, state unchanged.

**UC2 — Cancel order (actor: Customer)**
Main flow: 1. Customer requests cancel → 2. guard: state is SUBMITTED → 3. state becomes
CANCELLED → 4. stock released.
Alternate A1 (already shipped): guard fails → refusal shown, **state stays SHIPPED**.

The exercise's key line is the *post-state of the rejection*: every alternate states
what state the system is in afterward. That is what makes the UC executable — the
lesson's `ship on DRAFT` rejection leaves the state untouched, and a runner can assert it.

## 2. The executed state machine

The lesson ran the machine and printed state after every step:

```
ok   main-lifecycle DRAFT -> SUBMITTED -> PAID -> SHIPPED
ok   alt-cancel-submitted DRAFT -> SUBMITTED -> CANCELLED = CANCELLED
...
SCENARIO-LAB ALL PASS
```

Plus two rejection transitions (`ship on DRAFT`, and the cancel-after-ship guard), each
asserted to leave state unchanged. Rebuild: a `state` variable, an explicit transition
table (`from, event, guard → to`), a `step()` that refuses illegal transitions and prints
state after each. Your summary line (`SCENARIO-LAB ALL PASS` style) should only print
after every scenario's expected post-state matched — including the *unchanged* ones,
because "state stayed" is a result like any other.

## 3. Sequence diagram + parse validation

Shape: one endpoint you built, participants (client → controller → service → store), one
happy path, one error path returning a 4xx. Validate the source parses:

```bash
node validate.mjs diagram.mmd     # mermaid 12.x under jsdom: parse or throw
```

Executed in the batch: the harness parses lesson diagrams and exits non-zero on the first
syntax error — that exit code is the exercise's "validation result". The lesson's honest
note to respect: if your tool cannot render a particular view type (or your environment
can't run the renderer), **say so in the lesson/solution** rather than pasting a picture
you cannot vouch for. A diagram nobody parsed is clip art.

## 4. Independent — minimal UML set (reference shape)

For "add a retry to the payment call": draw **exactly two views** —

1. A sequence diagram, because the request spans four components and the retry loop's
   position (client-side vs server-side) is the actual argument.
2. A state machine for the payment attempt (INITIAL → PENDING → SUCCEEDED / FAILED →
   RETRYING), because retry count × backoff is stateful.

Deliberately **not** drawn: a class diagram (no new types are proposed), a deployment
diagram (nothing moves hosts), an activity diagram (the sequence already shows the flow).
Every omission gets a sentence — the discipline is that a diagram costs reader attention,
so each one must answer a question the request actually asks.