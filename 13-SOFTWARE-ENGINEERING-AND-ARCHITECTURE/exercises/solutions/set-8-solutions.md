# Set 8 solutions — Design patterns → `design-patterns.md`

*Executed in the batch's `patterns-probes.sh` battery (Java 25, Windows 11). Blocks marked
*reference* are shapes to run in your lab.*

## 1. Five probes, five rows from your own runs

| # | Pattern | Smell answered | Number that moved (executed) | Change request that produced it |
|---|---|---|---|---|
| 1 | Strategy | algorithm selection as growing `if/else` | `conditional decision points = 6` → `0` | add wholesale pricing rule |
| 2 | Factory | type selection scattered in callers | `channel.equals decisions 5 across 2 files` → table in 1 file, `callers edited … 0` | add SMS signup channel |
| 3 | Template method | duplicated pipeline skeleton | duplication across the two flows → one skeleton | add a validation step to both flows |
| 4 | Observer | producer naming its consumers | fan-out added without editing the publisher (hash-identical) | add audit subscriber |
| 5 | Repository | persistence details leaking into domain | domain compiles with no storage imports | swap in-memory → JDBC store |

Key executed lines:

```
P1: conditional decision points = 6; strategy decision points = 0
scattered: 'channel.equals' decisions in callers = 5 across 2 files
callers edited for the new channel: 0 (SignupFlow2/ImportFlow2 untouched)
subclass approach needs 8 classes for 3 independent options (2^3 combinations)
classes available: FileSource, GzipSrc, EncSrc, LogSrc = 4 classes for 8 combinations
```

## 2. A fourth pricing rule in both designs

Conditional design: six decision points were already there — adding a rule makes seven
(`if`, `else if`, … grows by one per rule). Strategy design: still `0` — a new
`WholesalePricing` class joins the registry; the decision count cannot move because
there is no decision left in the caller. Re-run the behavior-equality check across all
cases (the lesson's `ok` lines comparing both designs' outputs per input): both designs
must produce identical prices for every case *after* the addition. The pattern's proof
is two numbers at once: decision points stay `0` **and** outputs stay equal — either
one alone could be faked by a broken implementation.

## 3. The factory's missing case

Executed: add a channel the table lacked, then count caller edits —

```
callers edited for the new channel: 0 (SignupFlow2/ImportFlow2 untouched)
```

Your capture: the new channel's output line (its factory row returns the new handler)
plus the caller file list or hashes unchanged. What makes this the exercise's best probe:
in the scattered design the identical request edited **5 decisions across 2 files** —
the same feature, two shapes, and the delta is measured in files, not opinions.

## 4. Drill, then independent

**Drill (executed shape):** green suite → sabotage a behavior check so it passes wrongly
(e.g. make the equality assertion compare the refactored output to *itself*) → plant the
behavior bug → watch the suite still pass under the sabotaged check → notice the
independent cross-design equality check catch it → revert sabotage, revert bug, green.
The lesson's principle: an equality check you wrote is only as good as its independence
from the thing it checks — pair every internal assertion with one external oracle.

**Independent (reference):** take a real change request from your project's history and
compute the number you *would* have measured: files edited × concerns disturbed (the
SRP probe's `retest scope` unit). Then answer which pattern, if any, would have moved it
— Strategy moves decision points, Observer moves producer-file edits, Repository moves
domain-file edits. If your measured change surface was 1 file / 1 concern, the honest
answer is "no pattern; the design was already fine", and writing *that* down is the
exercise.