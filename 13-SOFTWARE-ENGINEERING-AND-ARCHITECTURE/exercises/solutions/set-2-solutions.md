# Set 2 solutions — Requirements engineering → `requirements-engineering.md`

*Executed in the batch's `ReqLab` probe (Java 25, Windows 11). Blocks marked *reference*
are shapes to run in your lab.*

## 1. Three FRs + two ACs with concrete values

Shape (reference — pick your own feature):

```
FR1: The cart SHALL compute a line total as quantity × unit price.
FR2: The cart SHALL apply a regional tax rate to the line total.
AC1: GIVEN 2 units at 10.00 in EU WHEN the line total is computed THEN the total is 21.40
AC2: GIVEN 10 units at 10.00 in EU with a 10% discount WHEN the total is computed
     THEN the total is 19.26
```

The lesson executed exactly this pair against its engine:

```
ok   acc-eu-2lines got 21.4 want 21.4
ok   acc-eu-discount10 got 19.26 want 19.26
```

The test for "executable": can a reader build a two-column table (input → expected
output) from your sentence alone, without asking you anything? `18.70`-style numbers
where arithmetic says `21.40` are precisely the argument this exercise prevents.

## 2. The ambiguity probe — both readings executed

Take one requirement containing an ambiguous noun or preposition. The lessons' FR1 was
"apply tax by region" — region of the *buyer* or region of the *shop*? Execute both
readings on the same input:

```
ambiguous-fr1-region: reading=buyer -> 21.4, reading=shop -> 20.0 DELTA=1.4
```

Reproduce: write one function per reading, run the identical input through both, print
the delta. `DELTA=1.4` is not a rounding difference — it is the argument you would
otherwise have in production, after launch. Then rewrite so one reading survives:

> FR1 (revised): the tax rate SHALL be selected by the **shop's** region, fixed at
> shop-creation time; the buyer's region SHALL NOT affect taxation.

The revised line is falsifiable: someone can write a test that fails against the other
reading. "Uses the region" cannot fail any test, which is how to recognize an ambiguity.

## 3. Traceability matrix with honest cells

The lesson's executed result:

```
row FR1 covered-by acc-eu-2lines (FR1 total formula)
...
traceability: 5/5 requirements mapped to at least one executed check; uncovered: []
```

Reproduce for a real piece of your code: for each requirement, name the file/line that
implements it and the test file/line that proves it. A cell is a **pointer** — if you
cannot name both files, the cell is uncovered and you write it in the `uncovered` list
rather than shading it optimistically. `uncovered: []` is a goal state, not a default;
a real audit's honest first run usually has entries, and filling them (write the test or
delete the requirement) is the exercise. Keep the matrix beside the code — the lesson's
note is that it decays the moment it lives in a wiki.

## 4. Independent — "users should be able to export their data" (reference shape)

Four-plus readings, each with a written decision:

| Ambiguity | Readings | Decision |
|---|---|---|
| Format | CSV / JSON / PDF | CSV for machines, JSON as API; no PDF v1 |
| Scope | one record / current view / everything | everything owned by the account |
| Where | download / email link / SFTP | download now; email link v2 |
| How often | once / scheduled | once in v1; rate-limited to 1/hour |

Two ACs the stakeholder can sign:

```
AC1: GIVEN an account with 3 exported-eligible records WHEN export is requested
     THEN a CSV downloads within 10s containing exactly 3 rows + header.
AC2: GIVEN the same account WHEN export is requested twice within 60 seconds
     THEN the second request returns 429 and no file.
```

"Sign without translation" means every word in the AC is a word from the stakeholder's
sentence or a concrete value — no framework nouns, no "successfully".