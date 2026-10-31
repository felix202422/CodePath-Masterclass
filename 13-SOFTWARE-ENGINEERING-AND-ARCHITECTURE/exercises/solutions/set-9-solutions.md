# Set 9 solutions — Layered architecture · Modular monoliths → `layered-architecture.md` · `modular-monoliths.md`

*Executed in the batch's `layered-probes.sh` and `modular-probes.sh` batteries
(Java 25, Windows 11). Blocks marked *reference* are shapes to run in your lab.*

## 1. The layered lint on two designs

Executed — same rule, tangled vs layered:

```
tangled:   lint rule 1 (controller must not use persistence): violations=1
           lint rule 2 (repository must not use presentation): violations=1
layered:   lint rule 1 (controller must not use persistence): violations=0
           lint rule 2 (repository must not use presentation): violations=0
```

Both designs compiled. Why compiling proves nothing: `javac` sees a classpath, not a
layer model — a controller importing JDBC is a perfectly legal import statement. The lint
is a *separate instrument* (grep-style import rules or an architecture-test) that encodes
the structure Java doesn't. Rebuild: write your two rules as import checks, run them
against both designs, capture `violations=1/1` vs `0/0`. Then — per the lesson's warning
about unproven instruments — plant one violation and watch the lint fire before you
trust any `0` it prints.

## 2. Cross-cutting change, both designs

Executed — currency precision change (6dp → 2dp):

```
layered:   files edited: 1 (OrderController.java), service and repository hashes unchanged
tangled:   files edited: 1, but concerns disturbed = 3 markers
```

The subtle result: both worlds edited *one file* — file count alone did not separate
them. What separated them is the disturbance count: the tangled edit's file also held
service and repository logic (its `@concern` markers spanned three concerns), so the
retest scope was three; the layered file's markers were all presentation, so retest
scope was one. Takeaway you should reproduce: hash or marker the neighboring concerns
*before* the edit and compare after — "how many concerns did this touch" is the
measurement, not `git diff --stat`.

## 3. Prove the module boundary

Executed:

```
# via the public API — compiles and runs
# reaching in from outside the package:
error: InvoiceCalculator is not public in billing; cannot be accessed from outside package
internal change inside billing:
0 files outside billing modified (shop untouched)
```

Rebuild: split `billing` from `shop` into packages, call the public entry point (green),
then write a `shop` class that names an internal `billing` type and capture the
compiler's refusal — Java's access modifier is a boundary the compiler enforces, unlike
the layer lint. Then perform an internal refactor (rename the internal class) and show
`0 files outside billing modified`: the boundary's payoff is that internal change has a
*measured* blast radius of zero.

## 4. Independent — the `Common` module anti-pattern

Executed:

```
Common is in 2 feature dependency cones
```

Rebuild with real import analysis: `grep -r "import.*Common"` from each feature root,
count in how many features' transitive cones `Common` appears. The count **2** is the
statement "any change to Common potentially breaks both features" — name the second
feature explicitly (the lesson's format change broke it) because a cone count without
a named victim is a statistic.

Migration step that keeps both compiling (shape): 1) copy `Common`'s shared type into
the feature that actually owns it (ownership audit: which feature changes it more
often?), 2) leave a deprecated forwarding shim in `Common`, 3) move the second feature's
calls to the new home, 4) delete the shim. Every step keeps both features compiling —
the exercise's completion criterion — and re-run the cone count at the end: `Common`
should be in 0 feature cones, or in exactly 1 if something genuinely shared remains.