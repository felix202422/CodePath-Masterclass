# Set 11 solutions — Quality gates → `quality-gates.md`

*Executed in the batch: the three-stage `gate.sh` (structure → references → `mvn clean
verify` + JaCoCo floor 0.90) run three times — baseline, planted violation, fix. Windows,
Git Bash, Java 25.*

## 1. Stage table + breaking stage 2

Executed stage behaviour:

```
== 1/3 curriculum structure ==   seconds, exit 0   "Structure is consistent."
== 2/3 references ==             seconds, exit 0   "418 Markdown files checked, 0 broken"
== 3/3 tests + coverage floor == ~90 s,  exit 0   (one API test class alone: 36.6 s)
```

Break stage 2 (rename a file a link points at) and the transcript shows:

```
GATE: FAIL at stage 2 (references)
LINK_EXIT=1          ← and no Maven output — stage 3 never started
```

The sentence: cheap stages first means the common breakage costs seconds, not a full build.
If your 30-second gate must shed a stage, shed *tests* (run them later, nightly) — never
the static checks, which are where the seconds are won.

## 2. The planted-violation drill — three runs

All three executed for this batch:

```
run A (baseline, clean lab):
  GATE: PASS        BASE_EXIT=0     tests=54 failures=0
  bundle 379/384 = 0.987            floor 0.90

run B (AuditLogger.java added — production code, no tests):
  stages 1–2 green; stage 3:
  [ERROR] Failed to execute goal org.jacoco:jacoco-maven-plugin:0.8.13:check
          on project testlab: Coverage checks have not been met.
  GATE: FAIL at stage 3 (tests/coverage)   BLOCKED_EXIT=1
  surefire: total=54 failures=0 errors=0   ← every test green
  report:   covered 379 missed 127 ratio 0.749
            AuditLogger covered 0 missed 110 / Entry covered 0 missed 12

run C (four AuditLoggerTest tests added — no config touched):
  GATE: PASS        FINAL_EXIT=0    tests=58 failures=0 errors=0
  bundle 501/506 = 0.9901
```

The deliverable is the *contrast*: run B's 54 green tests versus its exit 1. "All tests
pass" claims the existing suite still works; the floor is the only rule that checked whether
the new code ever ran. The fix was tests, never the floor — `0.749 → 0.9901` with the same
`minimum 0.90` in the pom.

## 3. The fourth stage (close Example 4's hole)

Shape: append a stage that greps the test output and fails on `MISMATCH`:

```bash
(cd "$LAB" && mvn -q clean verify 2>&1 | tee build.log) || fail_stage3
grep -q "MISMATCH" build.log && { echo "GATE: FAIL at stage 4 (vacuous test)"; exit 1; }
```

Executed expectation: exit 1 while the print-trap is present (the lessons' PASS run carried
`PRINT-TRAP: expected=19.9 actual=19.8 MISMATCH` through every stage), exit 0 once the
printed comparison becomes a real `assertEquals` — and no other stage changed. The lesson to
report: the gate only ever blocks what it was told about; you extend the gate, you do not
extend your optimism.

## 4. Independent — the weekly-ship gate policy (reference shape)

Per push: structure + references + unit tests (seconds–a minute). Per merge: full suite +
coverage floor (the ~90 s stage 3). Per release: package build, E2E, security battery,
secrets scan (minutes–nightly). Each row carries: runtime budget, the failure message a
developer sees (`GATE: FAIL at stage N (…)`, plus the reproduce command), floor numbers with
the measurement behind them, and a named owner for false positives — because a gate whose
red can legitimately be ignored is a report wearing a gate's clothes.