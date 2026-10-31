# Set 7 solutions — Separation of concerns → `separation-of-concerns.md`

*Executed in the batch's `soc-probes.sh` battery (Java 25, Windows 11). Blocks marked
*reference* are shapes to run in your lab.*

## 1. Scattering — before/after file counts for one change request

Executed (change request: "the email validation rule now requires a domain suffix"):

```
copies of the validation rule: 4 files, 4 occurrences
tangled: after the single-rule change request, files edited: CliSignup.java NightlyImport.java SupportTool.java WebSignup.java
```

After centralizing into one policy file:

```
files edited: EmailPolicy.java    1 file(s)
```

Rebuild: pick your own rule, `grep -rl` its literal to count copies (the lesson got
`4 files, 4 occurrences`), perform the identical change in both worlds, list edited
files. State the rule in one sentence each time — "an email must contain `@` and a dot
after it" — because the point is that a *sentence* got typed four times, and the file
count is what typing it four times costs.

## 2. Tangling — reasons to change and foreign imports

Executed:

```
reasons to change in OrderPage.java: 4
```

with import evidence per reason: `java.sql.` (persistence), `java.util.` (formatting),
`javax.mail.` (notification), plus presentation. Rebuild: open one file, list each
distinct reason a ticket could force an edit, and under each, the import line that
betrays it. Which reason to move out first: the one with the **widest retest scope** —
in the lesson's file that was persistence (a schema change shouldn't retest rendering).
The exercise's test for honesty: every reason in your list must name a plausible ticket
("change the SMTP provider") — a reason nobody would ever file doesn't count.

## 3. The retest-scope collapse

Executed in `solid-probes.sh`'s SRP run:

```
SRP: change landed in monolith (1 file) -> that file holds 4 concerns -> retest scope: 4 concerns
SRP: change landed in split (1 file) -> that file holds 1 concern(s) -> retest scope: 1 concern
```

What you would actually run: scope 4 = the entry points of *all four* concerns (CLI,
web signup, nightly import, mail delivery) because one shared file could have been
touched in any of them; scope 1 = the policy's own tests plus its two direct callers.
The number is the argument — "4 concerns → 1" converts an architectural claim into a
CI-minutes estimate you can put in front of someone who signs off on build times.

## 4. Independent — the 3000-line module with four change reasons (reference shape)

Procedure the lessons' probes implement, applied to your module:

1. **Predict** the split: say which lines move where and the new per-file reason count
   (prediction: each output file ≤ 2 reasons).
2. **Split** along the reason boundaries your import analysis found (the lesson's was
   `java.sql.` / `javax.mail.` / presentation / business).
3. **Execute one change request in both worlds** — e.g. "add a coupon field that flows
   DB → page": count files edited and markers disturbed per shape (the tangled probe
   reported `concerns disturbed=3` for its version).

Report predicted vs actual counts side by side. If actual > predicted, your boundary
guess was wrong somewhere — locate the file that took a foreign reason and say which
prediction row it broke. That miss is the exercise's real output; a split that
accidentally reproduces the tangle deserves to be seen in the numbers.