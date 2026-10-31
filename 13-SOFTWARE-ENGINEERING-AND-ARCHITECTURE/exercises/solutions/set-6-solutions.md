# Set 6 solutions — SOLID principles → `solid-principles.md`

*Executed in the batch's `solid-probes.sh` battery (five single-file Java programs,
Java 25, Windows 11). Blocks marked *reference* are shapes to run in your lab.*

## 1. The OCP half — one change request, two designs

Executed transcripts (identical change request: "add wholesale pricing"):

```
OCP-A: MODIFIED existing file -> Calculator.java
OCP-B: 0 existing files modified; new files: WholesalePricing.java FeatureWholesaleB.java
```

Both suites green after the change. Rebuild from the lesson's quoted sources: design A
is the `if/else` ladder in one calculator; design B is a rule interface + registry. Which
would you ship, and its cost: design B, because the measured retest scope of the change
was "one file you had to open anyway" vs "the file every rule lives in" — but the cost
is three extra types for a rule set that may never grow. Section 11 of the lesson prices
this honestly: the strategy's indirection is a *loan against expected change*, and if
the rule count never moves, you paid interest for nothing.

## 2. LSP — same client, two outcomes

Executed:

```
ok   lsp-subtype-breaks-supertype-client same client code -> Rectangle: 50.0 units2 billed, Square: 100.0 units2 billed
ok   lsp-nonfunctional-subtype-fails-superclient bill() over 12.0 / 16.0 / BrokenShape threw java.lang.UnsupportedOperationException: not implemented
```

One `bill(Shape r)` client produced `50.0` for a rectangle and `100.0` for the same-shape
square after a `setSide` call — substitutability broken with no compile error anywhere.
And a `BrokenShape` that throws from `area()` passes any test written *about BrokenShape*
while failing every test written about `Shape`.

Reproduce both, then apply the rewrite that makes substitution safe (size object carries
width *and* height; `Square` no longer widens via a rectangle-only setter), executed both
ways: same input → same billed amount for both subtypes, and the thrower deleted or
constrained out of the `Shape` set. The criterion: **one client function, one expected
output per input, regardless of which subtype it holds.**

## 3. DIP drill — hash the stable abstraction

Executed:

```
DIP-A: MODIFIED existing file -> ServiceA.java (the high-level rule was edited to swap a low-level detail)
DIP-A second-run exit=1 (existing client broke: backend swapped in place)
DIP-B: 0 existing files modified; new files: ConsoleLogger.java TestB2.java (ServiceB.java hash unchanged)
```

Drill sequence: hash the abstraction file (`ServiceB.java`), run the failure twice in
design A (exit 1 both times — the break is in *your* edit, so rerunning changes nothing),
then run design B's swap and confirm `ServiceB.java hash unchanged`. What the hash
proves that the exit code cannot: exit 1 says "something is broken"; the unchanged hash
says **"the high-level rule was never even a candidate for editing"** — the coupling is
absent by construction, not merely surviving one test. That is the difference between
"still works" and "cannot be affected".

## 4. Independent — the 1200-line `OrderProcessor` argument (reference shape)

Measurements you can actually take, with the change request that produced them:

1. **Concerns:** grep the `@concern`-style markers (or count by import family) — the
   lesson's SRP probe reported `retest scope: 4 concerns` for the monolith vs `1` split.
2. **Change requests:** take your last five real tickets; for each, count files edited
   inside `OrderProcessor.java`. If five different tickets all landed in it, you have
   five reasons to change one file — that is the number to report.

Verdict rule from the exercise: concede "it works" if the measured change surface is
~1 concern and one file per change; argue for splitting if the same change request
touches markers/imports from 3+ concerns — because *that* is the retest scope you pay
on every future change. The teammate's "it works" is not refuted; it is answered with
a different measurement.