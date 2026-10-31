# Set 10 solutions — Clean architecture · Domain-driven design → `clean-architecture.md` · `domain-driven-design.md`

*Executed in the batch's `cleanarch-probes.sh` and `ddd-probes.sh` batteries (Java 25,
Windows 11). Blocks marked *reference* are shapes to run in your lab.*

## 1. The dependency rule as javac states it

Executed — the inner-ring entity importing a framework, compiled alone:

```
P1a: domain entity depends on jakarta -> Order.java:1: error: package jakarta.validation.constraints does not exist
```

and the clean rings:

```
lint: inner-ring outward mentions = 0
```

Rebuild both: compile the entity with **no framework jars on the classpath** — the error
is the dependency rule stated by the compiler, not by a diagram: the entity's compilation
*depends on an outer-ring artifact*. Then compile the clean version and run the lint that
counts outward mentions from inner rings. Per the lesson's warning, print the lint's exact
watch-list with the run (the import prefixes it flags) and plant one import to watch it
fire — a lint that has only ever printed `0` is a rubber stamp.

## 2. A second adapter, hashes unchanged

Executed:

```
P2: second delivery mechanism -> 0 inner-ring files modified (hashes unchanged)
```

with both adapters — `http adapter` and `cli adapter` — driving the same use-case object;
their output lines differ only in formatting. Rebuild: hash every inner-ring file
(`sha256sum rings/**/*.java > before.sha`), add the CLI adapter, re-hash, `diff` → empty.
What the pair of measurements proves: the lint says no *source-level* coupling crept
inward, the hashes say no *edit* did either — the lesson pairs them because hash
equality alone can mean "no change was attempted."

## 3. Drill the lint

Executed — plant one outward import in a use case:

```
lint: inner-ring outward mentions = 0    ← baseline
lint: inner-ring outward mentions = 2    ← after planting java.sql + HttpDelivery mention
lint: inner-ring outward mentions = 0    ← after revert
```

The planted lines were one `java.sql` import plus one reference to `HttpDelivery` (an
outer-ring type) — count **2** because mentions include uses, not just imports. Capture
all three runs and quote the planted line. This drill is what converts the lint from
artifact to instrument: you have now seen it go red on purpose.

## 4. DDD vocabulary audit

Executed:

```
fields both contexts must agree on = 6 -> [id, status, total, shopStatus, warehouseStatus, weightKg]
real overlap=1, accidental coupling=5
```

Rebuild for two contexts you know: list each context's *used* fields (grep the actual
access sites), form the union, then classify each shared field: real overlap = both
contexts genuinely mean the same invariant by it; accidental coupling = same word, two
meanings, or a field only one context should own. The counts decide: overlap 1 vs
coupling 5 means **split** — one shared field is an anti-corruption conversation
(`total` in a shared value object), not a merged model. If the ratio reversed
(real overlap ≥ most of the union), merge would be defensible. State the decision from
the two numbers, not from team politics.

## 5. Independent — boundary crossing + shared value object

Executed shape (four lines the lesson's runner prints):

```
valid crossing:            shop model accepted by warehouse adapter -> shipped-eligible
invalid crossing:          not shippable yet: DRAFT        ← domain-language reason
Money: -5 rejected          → IllegalArgumentException: amount must not be negative
Money: 10 EUR + 10 USD      → IllegalArgumentException: mixed currency
```

Build: two context models, an ACL that translates one to the other, one valid case, one
invalid case whose message comes from the **target** context's language ("not shippable
yet: DRAFT", not "error 4"). Type classification with one-sentence justification:
`OrderId`, `Money` are **value objects** (identity is their value; interchangeable,
validated at construction — that's where the negative and mixed-currency rejections
live); `Order` is an **entity** (mutable identity with a lifecycle through DRAFT →
SUBMITTED). The justification test: could two instances with the same data be
interchangeable? Values yes, entities no.