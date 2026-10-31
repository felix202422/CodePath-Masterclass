# Set 5 solutions — Clean code → `clean-code.md`

*Executed in the batch's `CleanLab` (Java 25, Windows 11). Blocks marked *reference* are
shapes to run in your lab.*

## 1. Refactor `a(l, d, r)` yourself, then compare on six fixtures

The lesson's executed behavior-preservation run — every fixture identical before vs
after:

```
ok   fixture-EU-2lines before=21.4 after=21.4
ok   fixture-EU-2lines-disc before=19.9 after=19.9
ok   fixture-US-1lines before=5.0 after=5.0
ok   fixture-XX-1lines before=5.0 after=5.0
ok   fixture-EU-0lines before=0.0 after=0.0
ok   fixture-EU-2lines-disc before=104.33 after=104.33
```

Readability metrics on the exact two source texts:

```
before: lines=12 maxDepth=1 shortIdentifiers=8
after:  lines=7 maxDepth=0 shortIdentifiers=0
```

Method that makes this an exercise and not a copy: write your `after` first, build the
six-fixture harness, and only then read the lesson's. If all six are equal *and* your
metrics moved (`shortIdentifiers 8 → 0`, `maxDepth 1 → 0`), you refactored. End state:
`CLEAN-LAB ALL PASS`.

## 2. The seventh fixture — negative discount (surcharge)

Predict on paper first: EU 2 lines × 10.00 = 20.00, surcharge −(−10%) → 20.00 × 1.10
= 22.00. Execute both versions against it. The fixture that matters is the one that
could have exposed a `Math.max(discount, 0)` clamp or a sign flip — if both versions
return `22.00`, your refactor didn't change edge-case behavior either. If they disagree,
you found a latent bug *during* a refactor, which is exactly why the harness runs the
old code, not just the new.

## 3. The lying-comment drill

The code applied the discount *before* tax while the comment promised tax-then-discount.
Executed:

```
ok   ac-catches-lying-comment BEFORE fix: got 20.0 want 19.9 -> AC RED (comment and code disagree)
ok   ac-passes-fixed-code AFTER fix: got 19.9 want 19.9 -> AC GREEN
```

Reproduce: write the AC from the *comment's* promise, run it against the code, capture
red; fix the code (or the comment — decide which is the requirement), capture green.
Why renaming could never have caught this: both identifiers were already descriptive —
the defect is a **value disagreement** between prose and behavior, and only an executed
comparison of `got` against `want` can see a number. Summary line from the lesson:
"renaming can never fix this — only the executed AC exposed the 20.00 vs 19.90 gap."

## 4. Independent — you inherit a 400-line function (reference shape)

Ordered plan, each step with its safety check:

1. **Characterize, don't refactor.** Wrap the function; run 10–20 real inputs through
   old and new copies. Safety check: six-fixture-style equality output — all `ok`.
2. **Read-only metrics.** `lines`, `maxDepth`, `shortIdentifiers`, decision points.
   Safety check: numbers recorded *before* any edit, so improvement is measurable.
3. **Extract one behavior at a time.** Safety check after each extract: the fixture run
   again, green; plus the lesson's added belt — an AC for any behavior no fixture covers
   (the lying-comment case shows fixtures alone can enshrine a bug if they were written
   from buggy output).

This is the lessons' `measure → change → measure` shape: every move is only "safe"
because a number existed before it and the same number is checked after.