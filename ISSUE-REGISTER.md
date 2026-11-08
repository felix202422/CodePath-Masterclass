# Curriculum Issue Register

This file is the local project-management board for the repository. It follows the workflow:

**Backlog → To Do → In Progress → Code Review → Testing → Done**

**Why it is local:** the repository owner's GitHub CLI token was invalid at the time of writing, so
issues, milestones, and project boards cannot be created through the API yet. This register holds
the same information and is designed to be imported into GitHub later (tracked as `ROOT-15`).
No GitHub issue, milestone, branch, release, or project board has been created — only this file exists.

---

## How to read and update this register

- **Status legend:** `[ ]` Backlog · `[~]` In Progress · `[v]` Done (validated, not merely written)
- A file is marked `[v]` only when: content is substantive and complete, its lesson sections pass
  `scripts/check-curriculum.py`, its links pass `scripts/check-links.py`, its diagrams render and
  match the prose, and its exercises have completion criteria.
- **Creating a new issue:** copy the standard template below, give it the next number in its
  directory prefix, and add a row to that directory's list.
- The milestone exit criteria are the gate for moving to the next milestone.

### Standard issue template (applies to every issue unless it states a delta)

```markdown
### [ID] Title
- Status: Backlog
- Milestone: M#
- Scope: what this issue includes, and explicitly what it excludes
- Prerequisites: [IDs of issues that must be Done first]
- Expected files: exact paths
- Acceptance criteria:
  1. Follows templates/lesson-template.md with all required sections present
  2. Explains what / why / problem solved / mechanics / trade-offs / common mistakes
  3. Contains >= 2 introductory, >= 2 intermediate exercises and >= 1 independent task
  4. States measurable completion criteria
  5. Links resolve; diagrams render; alt text present
- Validation: scripts/check-curriculum.py and scripts/check-links.py pass; manual quality review
- Dependencies: [IDs this issue blocks]
```

---

## Milestones

| ID | Milestone | Scope | Exit criteria |
|---|---|---|---|
| M0 | Bootstrap | Clone, version baseline, register, auth probes | Repo cloned, `VERSIONS.md` verified, register exists |
| M1 | Repository foundations | Root docs, templates, scripts, assets system | Both scripts run and pass; README works as a textbook homepage |
| M2 | Foundations content | 00, 01, 02, 03 | Beginner can go from zero to a Git-tracked CLI program |
| M3 | Core programming | 04, 05 | Java/OOP/DSA lessons complete with runnable examples |
| M4 | Web and frontend | 06, 07, 08, 09 | Frontend path complete through React + testing |
| M5 | Data and backend | 10, 11 | SQL → PostgreSQL → Spring Boot REST API with tests |
| M6 | Mobile | 12 | Dart/Flutter path through release process |
| M7 | Engineering practices | 13, 14, 15 | Architecture, testing, security integrated |
| M8 | Operations and production | 16, 17, 18 | Docker/CI-CD/cloud/monitoring/advanced topics |
| M9 | Projects, professional, reference | 19, 20, 21, import to GitHub | 8 projects specified, reference library complete |
| M10 | Final validation | Phase K | All 16 QC checks pass; completion report discloses every gap |

**Common blockers across milestones:** version drift (re-check `VERSIONS.md`), unverified commands
runnable only on machines without the tool (label them), link rot after file renames (run
`check-links.py` before marking Done).

---

## M0 — Bootstrap

- [x] `ROOT-01` Clone repository and probe push credentials — clone done; push dry-run probe passed
- [x] `ROOT-02` `VERSIONS.md` version baseline with official sources — **Done**
- [x] `ROOT-03` `ISSUE-REGISTER.md` (this file) — **Done**
- [x] `ROOT-04` Confirm author identity and sole-contributor policy in git config —
  verified 2026-11-08: `git config user.name` → `Felix Haule` and `git config user.email` →
  `bulksms1705@gmail.com`; `git log --format='%Ae' | sort -u` returns that single address across
  all **71** commits, and `git shortlog -sne --all` lists exactly one author, which matches the
  documented policy in `CONTRIBUTING.md` ("This repository is maintained by a single author" —
  no contributor lists, bot authorship or co-author trailers without the maintainer's consent)

- [ ] `ROOT-15` Import this register into GitHub issues/milestones/board when
  `gh auth login` succeeds — **blocked, still open (2026-11-08):** `gh auth status` →
  "You are not logged into any GitHub hosts. To log in, run: gh auth login". No issue, milestone,
  label or project board has been created. This is the only open register item and it is
  infrastructure, not content: the 366 done entries below are the import payload, and `QA-09`
  records the explicit non-import. Run `gh auth login`, then import each entry as an issue (done
  ones closed, this one open)


## M1 — Repository foundations (Phase B)

**Root documents**
- [x] `ROOT-05` `README.md` — textbook-homepage README with CODEPATH MASTERCLASS banner, mission, audience, roadmap, table of contents, how to use exercises/progress/projects
- [x] `ROOT-06` `ROADMAP.md` — full curriculum in readable sequence with milestone gates
- [x] `ROOT-07` `CURRICULUM-MAP.md` — every competency → lessons, exercises, projects
- [x] `ROOT-08` `LEARNING-GUIDE.md` — study method, avoiding overwhelm, review cycles
- [x] `ROOT-09` `PROGRESS-TRACKER.md` — manual tracker with 8 dimensions and 6 proficiency levels
- [x] `ROOT-10` `CONTRIBUTING.md` — contribution workflow, issue/PR conventions, quality bar
- [x] `ROOT-11` `CODE_OF_CONDUCT.md` — Contributor Covenant 2.1 adapted, single maintainer contact
- [x] `ROOT-12` `SECURITY.md` — reporting path for vulnerabilities in examples/material
- [x] `ROOT-13` `SUPPORT.md` — how to get help, what is and is not supported
- [x] `ROOT-14` `CHANGELOG.md` — Keep-a-Changelog format, seeded with batch 1 entry
- [x] `ROOT-16` `LICENSE` (MIT, copyright Felix Haule)
- [x] `ROOT-17` `.gitignore` and `.editorconfig`

**Templates**
- [x] `TPL-01` `templates/lesson-template.md` — **Done**
- [x] `TPL-02` `templates/exercise-template.md` — **Done**
- [x] `TPL-03` `templates/project-template.md` — **Done**
- [x] `TPL-04` `templates/progress-template.md` — **Done**

**Scripts**
- [x] `SCR-01` `scripts/check-links.py` — validates relative Markdown links and image refs — **Done**
- [x] `SCR-02` `scripts/check-curriculum.py` — structure + required-sections checks — **Done**
- [x] `SCR-03` `scripts/README.md` — usage and limits (structural ≠ quality) — **Done**

**Visual system**
- [x] `ASSET-01` `assets/README.md` manifest — sourcing, licensing, naming, attribution rules
- [x] `ASSET-02` `assets/branding/` original SVG wordmark (banner to follow when first lesson art lands)
- [x] `ASSET-03` `assets/` topic subdirectories created only when first real diagram lands (policy in assets/README.md)

**Subject READMEs (navigation layer, required by ROOT-05's table of contents)**
- [x] `SUBJ-01` all 22 subject `README.md` overviews — what it covers, why it matters, prerequisites, lesson order, exercises, outcomes, next

## M2 — Foundations content (Phase C)

**00-START-HERE**
- [x] `START-01` `README.md` subject overview
- [x] `START-02` `how-to-use-this-repository.md`
- [x] `START-03` `how-programming-works.md` — from human instruction to machine execution
- [x] `START-04` `learning-method.md` — retrieval practice, spaced review, debugging as learning
- [x] `START-05` `study-planning.md` — building a realistic weekly plan
- [x] `START-06` `prerequisite-map.md` — dependency graph of the whole curriculum
- [x] `START-07` `frequently-asked-questions.md`

**01-COMPUTER-FOUNDATIONS** (prereq: 00)
- [x] `COMP-01` `README.md`
- [x] `COMP-02` `computer-hardware.md` — with `assets/computer-foundations/computer-architecture.svg` and `storage-hierarchy.svg`
- [x] `COMP-03` `software-and-operating-systems.md`
- [x] `COMP-04` `files-and-processes.md`
- [x] `COMP-05` `binary-and-number-systems.md`
- [x] `COMP-06` `logic-and-boolean-algebra.md`
- [x] `COMP-07` `memory-and-storage.md`
- [x] `COMP-08` `how-programs-execute.md`
- [x] `COMP-09` `exercises/` problem sets + `exercises/solutions/` (7 sets, separated with warning header)

**02-PROGRAMMING-FUNDAMENTALS** (prereq: 01)
- [x] `PROG-01` `README.md` — lesson list now live links; executed-transcript policy stated
- [x] `PROG-02` `computational-thinking.md` — with `assets/programming/` diagrams planned below
- [x] `PROG-03` `algorithms-and-pseudocode.md` — linear vs binary search, real traces
- [x] `PROG-04` `flowcharts.md` — Mermaid charts; grade flowchart ↔ code both directions
- [x] `PROG-05` `variables-and-data-types.md` — with `assets/programming/assignment-and-rebinding.svg`
- [x] `PROG-06` `operators.md` — precedence workups; `%`/`//` toolbox; real outputs
- [x] `PROG-07` `input-and-output.md` — retry loop and formatting, transcripts via piped stdin
- [x] `PROG-08` `conditional-statements.md` — real `SyntaxError` transcript for `=` vs `==`
- [x] `PROG-09` `loops.md` — off-by-one executed beside its fix
- [x] `PROG-10` `functions-and-methods.md` — with `assets/programming/function-call-stack.svg`; mutable-default trap executed
- [x] `PROG-11` `arrays-and-strings.md` — immutability wall shown via real `TypeError`
- [x] `PROG-12` `debugging-fundamentals.md` — with `assets/programming/debugging-cycle.svg`; real tracebacks
- [x] `PROG-13` `modular-programming.md` — three-file program executed; real `ModuleNotFoundError`
- [x] `PROG-14` `exercises/` 12 sets + `exercises/solutions/` 12 files (warning headers, executed capstone reference)
- [x] `PROG-15` Teaching language decided: **Python 3.13** — installed on the authoring machine (3.13.5), every example executed

**03-DEVELOPER-TOOLS** (prereq: 02)
- [x] `TOOL-01` `README.md` — live lesson links + executed-transcript policy stated
- [x] `TOOL-02` `terminal-fundamentals.md` — pipelines, redirection, exit codes; every transcript executed
- [x] `TOOL-03` `windows-development-environment.md` — three shells, PATH, execution policy, `wsl --status` genuinely “not installed” on the authoring machine
- [x] `TOOL-04` `linux-fundamentals.md` — FHS, permissions, processes; Git Bash transcripts labelled **[executed: Git Bash]**, ineffective `chmod` shown as the platform seam; real-distribution blocks labelled illustration
- [x] `TOOL-05` `editors-and-ides.md` — `git ls-files --eol` and `od -c` proofs, `.gitattributes`/`.editorconfig`, VS Code 1.140.0 executed
- [x] `TOOL-06` `package-managers.md` — npm 11.8.0 offline flow executed end to end (install, lockfile, `npm ci` destroy-and-reproduce); pip version executed; Maven row cited from `VERSIONS.md`
- [x] `TOOL-07` `environment-variables.md` — export/inheritance and broken-PATH experiments executed; `.env` + `git check-ignore -v` proof executed with a fake key
- [x] `TOOL-08` `git-fundamentals.md` — full sandbox history executed: three diffs, restore family, stash, amend, reflog, `reset --hard` both directions; with `assets/tools/git-three-areas.svg`
- [x] `TOOL-09` `branching-and-merging.md` — fast-forward, `--no-ff` merge, engineered conflict with markers, `merge --abort`, rebase — all executed; with `assets/tools/branch-merge-flow.svg`
- [x] `TOOL-10` `github-workflows.md` — remote/push/clone/fetch/pull executed against a local bare origin (incl. the real empty-clone failure); GitHub web UI and Actions blocks labelled illustration (`gh` unauthenticated)
- [x] `TOOL-11` `pull-requests-and-code-review.md` — `git request-pull`, three-dot diff, `--no-ff` merge executed; PR/review walkthroughs labelled illustration
- [x] `TOOL-12` `troubleshooting/` — README method + 9 diagnosis guides (command-not-found, line-endings, permission-denied, git-recovery, merge-conflict, clone-empty, no-upstream, dependency-tree, review-loop) + `exercises.md` graded drills (Tier 1–4, Milestone 2 capstone)

## M3 — Core programming (Phase D)

**04-JAVA-PROGRAMMING** (prereq: 02, 03) — baseline Java 21, see `VERSIONS.md`
- [x] `JAVA-01` `README.md`
- [x] `JAVA-02` `java-environment-setup.md`
- [x] `JAVA-03` `java-program-structure.md`
- [x] `JAVA-04` `variables-and-types.md`
- [x] `JAVA-05` `operators-and-control-flow.md`
- [x] `JAVA-06` `methods.md`
- [x] `JAVA-07` `arrays-and-strings.md`
- [x] `JAVA-08` `classes-and-objects.md`
- [x] `JAVA-09` `encapsulation.md`
- [x] `JAVA-10` `inheritance.md` — visual: `assets/java/inheritance-diagram.svg`
- [x] `JAVA-11` `polymorphism.md`
- [x] `JAVA-12` `abstraction.md`
- [x] `JAVA-13` `interfaces-and-abstract-classes.md`
- [x] `JAVA-14` `exceptions.md`
- [x] `JAVA-15` `collections-framework.md`
- [x] `JAVA-16` `generics.md`
- [x] `JAVA-17` `file-handling.md`
- [x] `JAVA-18` `lambdas-and-streams.md`
- [x] `JAVA-19` `functional-programming.md`
- [x] `JAVA-20` `concurrency.md`
- [x] `JAVA-21` `jvm-and-memory.md`
- [x] `JAVA-22` `build-tools.md`
- [x] `JAVA-23` `exercises/` + solutions (all examples compile with `javac --release 21`)

**05-DATA-STRUCTURES-AND-ALGORITHMS** (prereq: 04)
- [x] `DSA-01` `README.md`
- [x] `DSA-02` `algorithm-analysis.md`
- [x] `DSA-03` `big-o-notation.md`
- [x] `DSA-04` `arrays.md`
- [x] `DSA-05` `linked-lists.md`
- [x] `DSA-06` `stacks.md`
- [x] `DSA-07` `queues.md`
- [x] `DSA-08` `hash-tables.md`
- [x] `DSA-09` `trees.md`
- [x] `DSA-10` `heaps.md`
- [x] `DSA-11` `graphs.md`
- [x] `DSA-12` `searching.md`
- [x] `DSA-13` `sorting.md`
- [x] `DSA-14` `recursion.md`
- [x] `DSA-15` `backtracking.md`
- [x] `DSA-16` `greedy-algorithms.md`
- [x] `DSA-17` `dynamic-programming.md`
- [x] `DSA-18` `graph-algorithms.md`
- [x] `DSA-19` `problem-solving/` practice sets, hints, solutions

## M4 — Web and frontend (Phase E)

**06-INTERNET-AND-WEB-FOUNDATIONS** (prereq: 02)
- [x] `WEB-01` `README.md`
- [x] `WEB-02` `how-the-internet-works.md`
- [x] `WEB-03` `client-server-architecture.md`
- [x] `WEB-04` `ip-addressing.md`
- [x] `WEB-05` `dns.md`
- [x] `WEB-06` `tcp-and-udp.md`
- [x] `WEB-07` `http-fundamentals.md`
- [x] `WEB-08` `https-and-tls.md`
- [x] `WEB-09` `urls-and-ports.md`
- [x] `WEB-10` `browsers-and-rendering.md`
- [x] `WEB-11` `exercises/` + solutions

**07-HTML-AND-CSS** (prereq: 06)
- [x] `HTML-01` `README.md`
- [x] `HTML-02` `html-fundamentals.md`
- [x] `HTML-03` `semantic-html.md`
- [x] `HTML-04` `forms-and-validation.md`
- [x] `HTML-05` `css-fundamentals.md`
- [x] `HTML-06` `box-model.md`
- [x] `HTML-07` `flexbox.md`
- [x] `HTML-08` `css-grid.md`
- [x] `HTML-09` `responsive-design.md`
- [x] `HTML-10` `typography-and-design-tokens.md`
- [x] `HTML-11` `accessibility.md`
- [x] `HTML-12` `projects/` brief for Project 02

**08-JAVASCRIPT-AND-TYPESCRIPT** (prereq: 07)
- [x] `JS-01` `README.md`
- [x] `JS-02` `javascript-fundamentals.md`
- [x] `JS-03` `functions-and-scope.md`
- [x] `JS-04` `arrays-and-objects.md`
- [x] `JS-05` `dom-and-events.md`
- [x] `JS-06` `modules.md`
- [x] `JS-07` `promises-and-async-await.md`
- [x] `JS-08` `event-loop.md`
- [x] `JS-09` `error-handling.md`
- [x] `JS-10` `typescript-fundamentals.md`
- [x] `JS-11` `types-and-interfaces.md`
- [x] `JS-12` `generics.md`
- [x] `JS-13` `type-narrowing.md`
- [x] `JS-14` `exercises/` + solutions

**09-FRONTEND-ENGINEERING** (prereq: 08)
- [x] `FE-01` `README.md`
- [x] `FE-02` `react-fundamentals.md`
- [x] `FE-03` `components-and-props.md`
- [x] `FE-04` `state-and-hooks.md`
- [x] `FE-05` `component-composition.md`
- [x] `FE-06` `routing.md`
- [x] `FE-07` `forms.md`
- [x] `FE-08` `state-management.md`
- [x] `FE-09` `api-integration.md`
- [x] `FE-10` `frontend-authentication.md`
- [x] `FE-11` `error-and-loading-states.md`
- [x] `FE-12` `reusable-components.md`
- [x] `FE-13` `design-systems.md`
- [x] `FE-14` `performance.md`
- [x] `FE-15` `accessibility.md`
- [x] `FE-16` `frontend-testing.md`
- [x] `FE-17` `build-and-deployment.md`
- [x] `FE-18` `projects/` brief continuation (three briefs: paginated table,
  form wizard, token-authenticated dashboard → Project 05 frontend)
- [x] `FE-19` `exercises/` + solutions (12 sets, 13 solution files)

## M5 — Data and backend (Phase F)

**10-DATABASE-ENGINEERING** (prereq: 02; SQL lessons unlock 11)
- [x] `DB-01` `README.md`
- [x] `DB-02` `database-fundamentals.md` — all transcripts executed on a scratch PostgreSQL
  18.6 cluster (see the batch-12 lab note in the unfinished-work summary)
- [x] `DB-03` `relational-databases.md` — executed: one-to-one rejection, junction join,
  all three referential actions, composite-key rejection
- [x] `DB-04` `sql-fundamentals.md` — executed: projection/DISTINCT, NULL sort placement
  both directions, LIMIT/OFFSET pages, RETURNING, row-count tags (`UPDATE 3`, `DELETE 1`),
  unguarded update contained by rollback (`UPDATE 8` → 0 after)
- [x] `DB-05` `filtering-and-aggregation.md` — executed: operator ladder, three-valued
  logic traps (`= null` → 0 rows; `not (price >= 120)` → 4), `count(*)` 8 vs `count(price)`
  7, GROUP BY buckets with expression keys, WHERE-vs-HAVING population difference (2/2/2 vs
  3/2/3), the "must appear in the GROUP BY clause" refusal
- [x] `DB-06` `joins-and-subqueries.md` — executed: inner 8 rows, left-join 8 with
  coalesced 0s, right/left equivalence 10 = 10, cross 32, full-outer 5-row reconciliation
  via CTE, scalar/IN/EXISTS/derived-table subqueries (same 6 names), NOT IN NULL trap
  (2 → 0 rows), ambiguous-column error
- [x] `DB-07` `database-design.md` — executed: the five-table `shop` schema, four design
  rejections (SKU, orphan customer, duplicate line, status check), money query
- [x] `DB-08` `er-diagrams.md` — executed: catalog-derived ER (entities, 4 FKs, optionality
  from attnotnull), mermaid erDiagram validated
- [x] `DB-09` `normalization.md` — executed: all three anomalies on a flat table (truths=2,
  not-null insert refusal, customer deleted with row), lossless repair (view=3 rows),
  anomaly re-runs disappearing
- [x] `DB-10` `constraints-and-relationships.md` — executed: check/not-null/unique rejections
  with DETAILs, defaults via RETURNING, not-valid→validate sequence, exclusion constraint
  overlap rejection (btree_gist seam), FK added via ALTER
- [x] `DB-11` `transactions.md` — executed: rollback/commit pair, atomicity under a mid-block
  failure (successful update discarded), aborted-state guard, savepoint escape, autocommit
  contrast
- [x] `DB-12` `indexes.md` — executed: 13.164 ms seq scan (99980 rows removed, 637 buffers) →
  0.700 ms bitmap/index scan (22 buffers), planner decline on 12% predicate, size 776/5096 kB
- [x] `DB-13` `query-plans-and-optimization.md` — executed: filter plan with buffers/rows-removed,
  LIMIT top-N 57.862 ms vs external-merge 223.199 ms spill, hash-join plan, estimate gaps closed
  by ANALYZE
- [x] `DB-14` `concurrency-and-isolation.md` — executed two-session: uncommitted invisible,
  non-repeatable read (100→200), repeatable-read snapshot (100→100), 40001 write conflict,
  application-level lost update (150 clobbered 200)
- [x] `DB-15` `migrations.md` — executed: `schema_migrations` ledger holding exactly
  `0001_init`, `0002_email_unique`, `0003_fixed` with `applied_at` timestamps three seconds
  apart; re-run prints `skip` ×3 + `migrations up to date: 3`, exit 0; failed `0003`
  `FAILED … not recorded` exit 1 then the fixed file applies on re-run; data-fix-before-
  unique-index ordering; psql without `-1` left 1 of 2 inserts, with `-1` rolled the file whole
- [x] `DB-16` `backups-and-recovery.md` — executed: three dumps (2,969,654 B plain /
  1,039,646 B custom / 9,896 B `-n shop`), `drop schema shop cascade` → 0 tables → restore
  → products=4 customers=2 lines=3; `pg_restore -d restore_test` with the 100,000-row
  `idx.big_order` intact; `pg_restore -l` five SCHEMA entries; `setval 3 2 3 4 5` on every restore
- [x] `DB-17` `database-security.md` — executed: `analyst`/`reader` all `f` for
  `rolsuper`/`rolcreatedb`/`rolbypassrls`; `has_table_privilege` `f f` → `grant select` → `t`;
  `permission denied for table note`, `permission denied for sequence note_id_seq`,
  column-level denial; revoke re-denies; RLS `reader` sees 1 of 5 rows vs superuser's 5
- [x] `DB-18` `nosql-fundamentals.md` — executed: `->` jsonb `12` vs `->>` text `12`,
  `jsonb_typeof` explicit-null `null` vs missing-key, duplicate keys collapse to last;
  `@>` selected 12,501 of 50,004 rows at 13.549 ms seq scan (37,503 removed); explode 1 row → 3
- [x] `DB-19` `postgresql/` administration, scripts, sample data, expected results —
  `shop.sql` (one-file schema+seed), `01-schema.sql`/`02-seed.sql` (pg_dump 18.6), `q1`…`q7`
  with byte-exact `expected/` (LF), `README.md`, and `verify.sh` — **7 passed, 0 failed** end to
  end (CRLF stripped in-script so Windows captures diff clean against Linux/macOS)
- [x] `DB-20` Running sample schema: consistent `shop` database across all SQL lessons —
  `database-design.md`'s inline DDL matches `shop.sql` column-for-column; its Example 2 money
  query re-executed against the shipped seed (3 rows, `240.00/39.00/310.00`) with the output
  block corrected to exact psql padding
- [x] `DB-21` `exercises/` + solutions (12 sets, 13 files — sets 10–12 carry multiple
  lessons; every quoted capture traceable to a lesson probe, `q1`…`q7`, or `verify.sh`)

**11-BACKEND-ENGINEERING** (prereq: 04, 06, 10)
- [x] `BACK-01` `README.md` — subject overview written and committed in an earlier batch;
  verified in batch 13 (all sections, lesson list matches the BACK-02…21 names)
- [x] `BACK-02` `backend-fundamentals.md` — executed: JDK `HttpServer` probe on
  `127.0.0.1:8788` (no framework) with curl 8.22 — `curl -v` request/response lines vs the
  server's `RECV`/`SEND` log for the same event; status battery `200`+`Location`-less health,
  `201 Created`+`Location: /orders/1`, `405`+`Allow: POST` (GET and DELETE paths), `400` and
  `404` in one error envelope; bind-restart seam recorded (old listener must die before the
  new context set binds)
- [x] `BACK-03` `http-and-rest-apis.md` — executed: probe v2 method battery, eleven
  requests — `201`+`Location: /orders/1`, `200` representation, `PUT` twice with
  **B5≡B7 diff IDENTICAL** (idempotency proven as bytes), `204` on delete with `0 body
  bytes`, `404` on repeat delete (state converged), `405`+`Allow: GET, PUT, DELETE` for
  `PATCH`, `HEAD /health` advertising `Content-length: 15` with no body (JDK HEAD warning
  handled manually — recorded seam), `Accept: application/xml` answered JSON (the
  negotiation seam, labelled not hidden)
- [x] `BACK-04` `api-design.md` — executed: probe v3 pagination battery (seeded 7 —
  default page metadata, first/last page, `page=9` → **200 + `items:[]`**, `size=abc` →
  400 `invalid_parameter`), filter+sort (`qtyMin=3&sort=qty.desc` → 5 rows qty-desc with
  id tiebreak, `sort=evil` → 200 default order = allowlist fallback), unknown-param
  policy (`colour=red` → 200 + `IGNORED` log line), and the full idempotency-key table:
  STORE `201 Location /orders/8` → REPLAY identical `201` → CONFLICT `409` on body
  mismatch, with `totalItems` held at **8** (7+1, no duplicate) across all three
- [x] `BACK-05` `java-backend-development.md` — executed: `Layered.java` probe (plain JDK)
  with four requests traced layer-by-layer (`CONTROLLER/SVC/REPO` prefixes) — rule refusal
  caused in the service, `400` produced in the controller, `qty null→0` translation shown;
  Maven standard layout quoted from the smoke lab (`main/test/resources`, jar in `target/`)
- [x] `BACK-06` `spring-fundamentals.md` — executed: `ContainerLab` (no `new Greeter` in
  `main` yet ctor runs), lifecycle order ctor→afterPropertiesSet→destroy-on-close,
  singleton `a == b: true`, `lab`/`prod` → `lab-mode`/`prod-mode`, missing bean →
  `NoSuchBeanDefinitionException: interface java.lang.Runnable`
- [x] `BACK-07` `spring-boot.md` — executed: fat-jar smoke on Boot 4.1.1 — banner
  `Tomcat started on port 8790` + `Started SmokeApplication in 6.458 seconds` from a
  two-class app; `/hello`, `/config` binding, actuator `health` UP / `info {}`,
  `env` values all `******` (masking), dev profile → `1 profile is active: "dev"` and
  `spring-smoke-dev` override with `owner` layering through
- [x] `BACK-08` `dependency-injection.md` — executed: `DiLab` four-section probe —
  null repo refused at construction vs setter service NPE at use, container-wired
  singleton, hostile fake test (`fake rows [700, 800]`, service `imports Spring?
  false`), plus the cycle refusal (`BeanCurrentlyInCreationException` from `CircularLab`)
- [x] `BACK-09` `controllers-services-repositories.md` — executed: nine-request battery on
  the three-class Spring app — `201`+`Location`, service-rule `409` with domain message,
  `400` fieldErrors from `@Valid` at the edge, empty `404` (`bytes=0`) by `Optional`,
  framework `405`+`Allow: POST`
- [x] `BACK-10` `validation-and-error-handling.md` — executed: twelve-request battery incl.
  the fall-through seam — `V1/V5` sorted fieldErrors, `V2/V3/V4` returned Boot's default
  `timestamp/status/error` shape **before** two handlers added, `V2r/V3r/V4r` uniform
  envelope after; `V6` unknown `admin:true` ignored → `201`
- [x] `BACK-11` `jpa-and-hibernate.md` — executed on PostgreSQL 18: Hibernate DDL
  (`customer`/`purchase`, identity PKs, FK), seed `5×4`, N+1 = **6 selects** vs fetch
  join = **1 select** (identical payloads, unsorted order noted), `LazyInitializationException:
  Cannot lazily initialize collection ... (no session)` → 500 default shape, derived-query
  parse seam (`findAllWithPurchases` → explicit `@Query`)
- [x] `BACK-12` `authentication.md` — executed: `AuthProbe` (two bcrypt hashes of one
  password `equal? false`, `$2a$10$` format, malformed hash WARN+fail-closed, **121 ms
  vs 1.12 µs** bcrypt-vs-SHA256) + A1..A7 login battery — wrong-password vs unknown-user
  bodies diff **IDENTICAL**, matched timings 0.159/0.160 s via dummy-hash burn; A6 seam
  (short password → default 500) closed to `400 invalid-parameter` (A6r)
- [x] `BACK-13` `authorization.md` — executed: B1..B8 battery on header stand-in —
  owner 200, foreign **404 bytes=0 identical to nonexistent id (diff IDENTICAL)**, role
  USER → `403 forbidden`, ADMIN → `200`, no identity → `401 auth-required`, stock rule
  still `409`; role gate placed in the service (controller deliberately unchecked)
- [x] `BACK-14` `sessions-and-tokens.md` — executed: S1..S6 session battery (HttpOnly
  cookie set, authenticated, miss≡guess 401, **logout `revoked:true` then same cookie
  401**) + `JwtProbe` (hand-built HS256 — clean `true`, tampered `false`, wrong key
  `false`, stale `true`+`expired=true`, `alg=none` `false`, `MessageDigest.isEqual`)
- [x] `BACK-15` `oauth2-and-openid-connect.md` — executed `OidcLab`: real loopback
  provider — 302 `code`+`state` echo pass, `/token` 200 with RS256 `id_token`,
  `ACCEPT (sig, iss, aud, exp, nonce)`, attacks `REJECT: nonce/signature/not-three-parts`,
  **code replay → 400 invalid_grant**
- [x] `BACK-16` `file-uploads.md` — executed: U1..U5 — `201`+server sha256 for a good
  file, `.exe` → `400 unsupported type`, 1.5 MB → `413 payload-too-large` (container
  limit, controller never runs), `filename=../../evil.txt` stored as a UUID (store
  listing shows exactly the two UUID names), empty → `400`
- [x] `BACK-17` `caching.md` — executed: C1..C7 — miss 0.492 s `source:db`
  `computeMillis:307` → hit 0.014 s `source:cache` `0`, stats `hits:1 misses:1`,
  invalidate `evicted:true` then miss again, `ETag "d61dee47"` → `304 bytes=0`
- [x] `BACK-18` `background-jobs.md` — executed: J1..J7 — `202`+`Location` accept,
  `DONE attempts:1`, retry trace `attempts:2` → `FAILED attempts:3 gave up after 3`,
  duplicate key → `200 duplicate:true` same id (`totalJobs` stable), unknown id `404`;
  in-memory durability seam documented + restart exercise
- [x] `BACK-19` `api-documentation.md` — executed: OpenAPI document validated **4/4
  green** (structure, references, schemas, examples) + a recorded contract-vs-runtime
  diff (documented single-violation 400 vs actual sorted multi-violation; documented
  404 envelope vs actual empty body — doc fixed to match the IDOR rule)
- [x] `BACK-20` `logging.md` — executed: runs A/B/C — correlation id across all three
  request lines (`req`/`login rejected`/`res` same rid), DEBUG adds decision lines,
  WARN-only run keeps just the WARN, `grep -c 'correct horse'` and token prefix → **0**
  across all three logs; seam recorded: the WARN override also suppresses the
  `Started …` banner (its logger is in the overridden package), so readiness was
  probed with a framework logger instead
- [x] `BACK-21` `backend-testing.md` — executed: `mvn test` **15 tests, 0 failures,
  BUILD SUCCESS** across `OrderServiceTest` (0.017 s), `AuthServiceTest` (0.901 s),
  `ApiContractTest` MockMvc (15.15 s), `SmokeApplicationTests` (1.9 s); deliberate-break
  drill red-captured (enumeration leak → `AssertionFailedError` printing both 401
  bodies) then green on revert; Spring Boot 4 seam recorded: `@AutoConfigureMockMvc`
  lives in `spring-boot-webmvc-test`, **not** in `starter-test` — added as a test
  dependency; `JsonPath.read` generics make bare `assertEquals` ambiguous (cast first)
- [x] `BACK-22` `projects/` briefs for Projects 04 and 05, plus `exercises/` — 12 sets
  with observable criteria (rollback proof, privilege-escalation red drill, N+1 query
  counting named as criteria) and 12 separated solution files behind the attempt-first
  warning; subject-11 README verified against all twenty lesson files; root `LABS.md`
  gains the **Spring Boot lab** row + section; CHANGELOG gains the Subject 11 entry.

## M6 — Mobile (Phase G)

**12-MOBILE-DEVELOPMENT** (prereq: 02, 11 for API integration)
- [x] `MOB-01` `README.md`
- [x] `MOB-02` `mobile-development-fundamentals.md` — executed: `flutter create`
  scaffold (shared `lib/`+`test/` vs six platform folders, `AndroidManifest.xml` /
  `Info.plist` on each side), `flutter analyze` → `No issues found! (ran in 94.7s)`,
  `flutter test` → `+1: All tests passed!`, `Platform.isWindows=true` branch line
- [x] `MOB-03` `dart-fundamentals.md` — executed: d1 battery (`int 4.5 double`,
  spread/`if`/`for` collections, merged `{a: 2, ...}`, records, switch expr) + d2
  battery (cascade, const constructor `0:00:30.000000`, mixin+ext, shapes sum)
- [x] `MOB-04` `null-safety.md` — executed: d3 `2 issues found` (analyzer **and**
  `dart run` compile errors), d4a `Null check operator used on a null value` + `#0`
  trace, d4b `LateInitializationError: Field 'user'`, d4c flow narrowing `narrowed: 8`
- [x] `MOB-05` `asynchronous-dart.md` — executed: d5 ordering (sync→microtask→timer),
  `sequential=188ms parallel=96ms`, typed `on TimeoutException` catch, ticks+broadcast
  listeners, `one-run=97ms two-isolates=129ms checksum==`; d5b `Bad state: Stream has
  already been listened to` + `broadcast` fix
- [x] `MOB-06` `flutter-fundamentals.md` — executed: W1/W2 widget-test battery —
  mount `pageBuilds=1 constChildBuilds=1` → after tap `pageBuilds=2
  constChildBuilds=1` (const child skipped), element tree dump 77 lines with
  `Scaffold(dependencies: [...])`, `RenderParagraph size=114x20`; full battery
  `+5: All tests passed!`, `flutter analyze` → `No issues found! (ran in 64.0s)`
- [x] `MOB-07` `widgets-and-layouts.md` — executed: W3 `FlutterError: A RenderFlex
  overflowed by 740 pixels on the right.` via `takeException`; W4 responsive branch
  `layout: narrow w=390` → `layout: wide w=1280` on viewport resize; W5 stack
  coordinates `badge topLeft=(50.0, 40.0) size=(60.0, 30.0)` asserted with
  `getTopLeft`/`getSize`
- [x] `MOB-08` `navigation.md` — executed: W6 battery — `pushed: detail="detail"
  home-gone=true` → `popped: home detail-gone=true`, argument `confirm order 7`
  read at destination, awaited `result: confirmed` after mounted-check
- [x] `MOB-09` `state-management.md` — executed: W7 — InheritedNotifier rebuild
  counts `mount: dependent=1 bystander=1` → `after inc: dependent=2 bystander=1`,
  Provider split-state `theme-consumer-builds=1 (was 1)` after inc → `2` after flip
- [x] `MOB-10` `forms-and-validation.md` — executed: W8 three rounds — empty
  submit errors painted + `callback=not called` on bad values, valid submit
  `email=ada@example.com password=correct horse errors-gone=true`; battery
  `+4: All tests passed!`
- [x] `MOB-11` `api-integration.md` — executed: W9 real HTTP vs local server —
  `status=200 items=3`, 404 envelope `type=…/not-found detail="no such order"`,
  `caught=FormatException "Unexpected character"`, `caught=TimeoutException
  "0:00:00.150000"`; W9b state walk `loading → error → loading (attempt 2) →
  items=1`; `HttpOverrides.global=null` documented (test binding stubs HttpClient)
- [x] `MOB-12` `local-storage.md` — executed: W10 — prefs `theme=dark launches=7`
  → fresh handle `launches=8 missing-key=null`, file store `wrote=2 read=2`,
  corruption `recovered=[] file-repaired=true`
- [x] `MOB-13` `secure-storage.md` — executed: W11 plaintext token
  `contains-token=true bytes=27` + redacted log `{"token":"***"}`; platform
  vault paths (Keychain/Keystore) **labelled reference** — no device on this
  machine, exercises run them on-device; battery `+8: All tests passed!`
- [x] `MOB-14` `camera-and-qr-codes.md` — executed: W12 — QR matrix
  `size=25x25 dark=332/625`, typed parses `WebLink host=example.com` /
  `WifiNetwork ssid=CafeNet auth=WPA` / `UnknownPayload` (wifi-prefix bug caught
  by capture); camera HAL + on-device scan **labelled** (no device here)
- [x] `MOB-15` `permissions-and-notifications.md` — executed: W13 — permission
  walk `unknown → denied → permanentlyDenied (settings hint) → granted /
  camera unlocked`, payload routes `order → /confirm?id=7`, `message →
  /messages/c-9`, `mystery → /`; system dialogs/channels labelled reference
- [x] `MOB-16` `offline-functionality.md` — executed: W14 — reads
  `source=network stale=false` → `source=cache(stale) stale=true` → no-cache
  `SocketException` rethrow; queue `sent=[PUT 1, PUT 2] dedup-skipped=1
  kept-pending=1`; conflict versions → remote/local wins/NoOp
- [x] `MOB-17` `mobile-testing.md` — executed: full suite `+25: All tests
  passed!` (~13s) + deliberate-break drill — first round printed the bug and
  stayed green (print≠assert, captured), then with assertions
  `Found 0 widgets with text "Enter an email"` → `Some tests failed` exit 1 →
  revert → 25 green
- [x] `MOB-18` `android-release.md` — executed: `flutter build apk --debug` →
  `√ Built app-debug.apk` 154,535,224 B in 881.7 s (cold Gradle 9.3.1);
  `flutter build appbundle --release` → `√ Built app-release.aab (43.0MB)`
  689.7 s, `MaterialIcons-Regular.otf 1645184 → 1368 bytes (99.9%)`;
  keystore/Play-Console steps **labelled reference**
- [x] `MOB-19` `ios-release.md` — **labelled reference** (Windows machine, no
  Xcode): signing chain, Info.plist contracts, ATS, privacy labels, review loop —
  all steps assigned to macOS in the exercises; no transcript pretends execution
- [x] `MOB-20` `projects/` brief for Project 06 — offline-first capstone brief:
  six milestones mapped to the executed batteries W1–W14 + build pair,
  required exercises, grading rubric, release-readiness gate

## M7 — Engineering practices (Phase H)

**13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE** (prereq: 04, 11)
- [x] `ARCH-01` `README.md` — lesson index, milestone-gate wording, executed-transcript policy (ticked late: file written in installment A)
- [x] `ARCH-02` `the-complete-development-process.md` — 26-stage idea-to-maintenance guide; executed worked example: the `orderdesk` mini-repo (Java 25) — 9-commit trace `stage 1-4`…`stage 20-22`, validation catch `18.70 → 21.40`, deliberate break RED `unknown-region-no-tax: got 10.0 want 5.0` exit 1 → green exit 0, NFR1 `326us < 50000us`; mermaid validated
- [x] `ARCH-03` `software-development-life-cycle.md` — executed: iteration 2 of the same repo runs the full compressed cycle in five commits (FR3 ACC3 → RED `got 21.4 want 19.27` → stage-6 catch `19.27 → 19.26` → `GREEN_EXIT=0` → release), tags `v0.1.0`/`v0.2.0`, plus the **kept-in false-green incident** (two commits made while red — `git commit` doesn't run tests) as the CI-gate argument; mermaid validated
- [x] `ARCH-04` `requirements-engineering.md` — executed: `ReqLab` P1 — both ACs
  parsed out of `REQUIREMENTS.md` and run (`acc-eu-2lines 21.4`,
  `acc-eu-discount10 19.26`, summary `2 criteria … 2 passed`), P2 ambiguity probe
  (FR1 "tax by region" read buyer vs shop: `21.4` vs `20.0` `DELTA=1.4`),
  P3 traceability `5/5 … uncovered: []`, `REQ-LAB ALL PASS` exit 0; mermaid validated
- [x] `ARCH-05` `functional-and-nonfunctional-requirements.md` — executed:
  `BudgetProbe` both outcomes on identical code — budget 50000us `NFR1 PASS: 480us`
  exit 0, budget 100us `NFR1 FAIL: 463us exceeds budget 100us` exit 1 (the *faster*
  run fails), methodology gap `1424us` cold vs `463us` warm same workload, NFR2
  determinism `10000 reruns, distinct results = 1`, FR2 absence test
  `IllegalArgumentException: bad code`; mermaid validated
- [x] `ARCH-06` `use-cases-and-uml.md` — executed: `ScenarioLab` — UC0 lifecycle
  `DRAFT -> SUBMITTED -> PAID -> SHIPPED` + `alt-cancel-submitted` + 2 rejected
  transitions (`ship on DRAFT`, `pay on CANCELLED` both leave state), UC1 3 flows,
  UC2 main + bad-code rejection, `SCENARIO-LAB ALL PASS` exit 0; state/sequence/class
  mermaid validated, use case view kept as text (mermaid 12 has no usecase renderer —
  parse failure captured and worked around honestly)
- [x] `ARCH-07` `clean-code.md` — executed: `CleanLab` (Java 25) — behavior preservation
  across 6 fixtures (`ok fixture-EU-2lines before=21.4 after=21.4` … all six equal),
  readability metrics over the exact quoted sources (`before: lines=12 maxDepth=1
  shortIdentifiers=8` → `after: lines=7 maxDepth=0 shortIdentifiers=0`), lying-comment
  AC `got 20.0 want 19.9 -> AC RED` → `got 19.9 want 19.9 -> AC GREEN`,
  `CLEAN-LAB ALL PASS`; mermaid validated
- [x] `ARCH-08` `solid-principles.md` — executed: `solid-probes.sh` P1–P5 with sha256
  evidence — OCP `MODIFIED existing file -> Calculator.java` vs `0 existing files
  modified; new files: WholesalePricing.java FeatureWholesaleB.java` (both regression
  suites green), DIP `second-run exit=1 … out.log missing` vs `ServiceB.java hash
  unchanged`, SRP `retest scope: 4 concerns` → `1 concern`; `Sondes.java` LSP
  `Rectangle: 50.0 units2 billed, Square: 100.0 units2 billed` from identical client
  code + `BrokenShape threw UnsupportedOperationException`, ISP
  `UnsupportedOperationException: not supported` / `Console untouched`; mermaid validated
- [x] `ARCH-09` `separation-of-concerns.md` — executed: `soc-probes.sh` P1–P3 — scattering
  `copies of the validation rule: 4 files, 4 occurrences` → same change request
  `files edited: CliSignup.java NightlyImport.java SupportTool.java WebSignup.java`
  vs centralized `1 file(s)` → `files edited: EmailPolicy.java`, tangling
  `reasons to change in OrderPage.java: 4` with `java.sql. java.util. javax.mail.`
  foreign imports, plus P5 `retest scope 4 → 1`; mermaid validated
- [x] `ARCH-10` `design-patterns.md` — executed: `patterns-probes.sh` P1–P5 — strategy
  `decision points = 6` → `0` with all six behavior checks equal (`P1 both designs agree`),
  factory `channel.equals decisions = 5 across 2 files` → `0 … lives in 1 file:
  NotifierFactory.java` + new channel `callers edited … 0`, observer
  `MODIFIED existing file -> OrderServiceTight.java` vs `OrderServiceLoose hash
  unchanged`, decorator `8 classes for 3 options` vs `4 classes for 8 combinations`,
  repository `OrderService.java hash unchanged` + `sql imports 0`; mermaid validated
- [x] `ARCH-11` `layered-architecture.md` — executed: `layered-probes.sh` P1–P3 — lint
  counts tangled `rule 1 violations=1` / `rule 2 violations=1` vs layered `0`/`0`
  (both designs compile — Java does not enforce layers), currency change
  `1 file edited (OrderController.java); service and repository hash unchanged` vs
  tangled `files edited=1 but concerns disturbed=3 markers`, testability
  `service test ran with zero infrastructure imports = 42.00` vs tangled
  `NullPointerException: Cannot invoke "java.sql.Connection.prepareStatement(String)"
  because "<parameter2>" is null`; mermaid validated
- [x] `ARCH-12` `modular-monoliths.md` — executed: `modular-probes.sh` P1–P3 — public
  API call compiles (`P1a`), package-private reach-in rejected
  `error: InvoiceCalculator is not public in billing; cannot be accessed from outside
  package` (`P1b`), internal tax change leaves `shop/OrderApi.java hash unchanged` /
  `0 files outside billing modified`, shared-module anti-pattern
  `Common is in 2 feature dependency cones … count=2`; mermaid validated
- [x] `ARCH-13` `clean-architecture.md` — executed: `cleanarch-probes.sh` P1–P3 —
  dependency rule stated by the compiler (`P1a: domain entity depends on jakarta ->
  Order.java:1: error: package jakarta.validation.constraints does not exist`) vs clean
  rings (`P1b: inner rings compile`, `lint: inner-ring outward mentions = 0`), outer-ring
  swap (`http adapter: HTTP 200 {"total":90.0}` + `cli adapter: cli: order A-1 total
  90.0` from one use case → `0 inner-ring files modified (hashes unchanged)`), and a
  deliberate-break drill on the lint (`0` → planted `java.sql`/`HttpDelivery` → `2` →
  revert → `0`); mermaid validated
- [x] `ARCH-14` `domain-driven-design.md` — executed: `ddd-probes.sh` P1–P2 — vocabulary
  audit `fields both contexts must agree on = 6 -> [id, status, total, shopStatus,
  warehouseStatus, weightKg] (real overlap=1, accidental coupling=5)` vs two bounded
  contexts with an ACL (`boundary: CatalogOrder[...state=PAID...] -> FulfillmentOrder[...,
  warehouseStatus=QUEUED, weightKg=0.4]`, `boundary rule enforced: not shippable yet:
  DRAFT`), value objects `two equal amounts are equal objects: true`, `illegal state
  rejected: negative money: -1`, `cross-currency add rejected: currency mismatch: EUR vs
  USD`, `sum = Money[cents=9500, currency=EUR]`; mermaid validated
- [x] `ARCH-15` `event-driven-architecture.md` — executed: `evt-probes.sh` P1–P4 —
  fan-out `two subscribers ran: [mail sent] [audit row]` + `third subscriber added without
  touching the producer`, naive consumer drift `after duplicate: balance=200.0 (should be
  150.0)` → `naive: wrong balance by 60.0`, guarded consumer on the identical stream
  `final: balance=130.0 duplicates rejected=2 out-of-order rejected=1` + `guard check:
  e-4 wanted seq 2 after seq 3 was applied -> dropped, balance untouched`, isolation
  `handlers ran: [mailer ok, failed: mailer down, warehouse ok]`; mermaid validated
- [x] `ARCH-16` `distributed-systems.md` — executed: `dist-probes.sh` P1–P3 — stale
  replica `after commit, replica still says 100 (primary=150)` → `after replication,
  replica says 150`, partition split-brain `side-AB's acknowledged write x=1 is GONE` vs
  quorum `side AB has 2/3 votes -> write accepted` + `side C has 1/3 votes -> write
  rejected with unavailable`, timeout ambiguity `caller gave up after 100ms while the
  server was still working` → `server executed 'charge' 2 times for 1 logical request`;
  mermaid validated
- [x] `ARCH-17` `microservices.md` — executed: `micro-probes.sh` P1–P3 — saga
  `order=true payment=false stock=true -> inconsistent` vs compensation `order=false
  payment=false stock=false -> consistent, just failed`, fan-out `sequential=151ms
  parallel=62ms (3 x 50ms calls)`, and a real javac contract experiment: shared type
  renamed → untouched consumer `InvoiceService.java:1: error: cannot find symbol /
  symbol: variable total` vs consumer-owned contract `compiles clean, consumer redeploy
  count = 0`; mermaid validated
- [x] `ARCH-18` `scalability-and-reliability.md` — executed: `scale-probes.sh` P1–P3 with
  fixed seeds — cache `hit ratio = 56.5%, avg latency = 500.0ms -> 223.2ms` for hot-set
  traffic vs `5.2%` uniform on the same LRU(50), retry policy `same 120 attempts, but only
  90 land during the outage vs 120 for immediate retries` with backoff reaching past
  `recovers at t=500ms`, redundancy `96.89% -> 99.74%` (100k ticks, 2-of-3 majority);
  mermaid validated
- [x] `ARCH-19` `technical-debt.md` — executed: `debt-probes.sh` P1–P3 — metrics `messy:
  lines=17 decisionPoints=10 duplicatedTaxLadders=2` vs `clean: lines=10 decisionPoints=2
  duplicatedTaxLadders=1`, injected 0.07→0.08 bug `messy: tax(100) = 8.0 with 0 tests
  running -> bug escaped` vs `clean suite: RED tax(100) = 8.0 want 7.0 -> caught`,
  12-release curve `repay-now=160.0, repay-at-6=192.1, never=542.1` (25%/release growth
  labeled an assumption); mermaid validated
- [x] `ARCH-20` `exercises/` + solutions (12 sets, 13 files — sets 1 and 9–12 carry
  multiple lessons; every quoted capture traceable to a lesson probe, including
  `GREEN_EXIT=0` false-green pair, `DELTA=1.4`, `463us exceeds budget 100us`,
  `rule 1 violations=1 → 0`, `inner-ring outward mentions 0 → 2 → 0`,
  `balance=130.0 duplicates rejected=2`, `120 → 90`, `repay-now=160.0 / never=542.1`)

**14-TESTING-AND-QUALITY** (prereq: 04, 09, 11)
- [x] `TEST-01` `README.md` — subject index: lesson list, pyramid→security→CI positioning, "coverage never tells you what was asserted" blocker
- [x] `TEST-02` `testing-fundamentals.md` — executed: `PrintTrapTest` green-while-wrong
  (`PRINT-TRAP: expected=19.9 actual=19.8 MISMATCH` inside `Tests run: 22 … BUILD
  SUCCESS`), order-dependence probe green-together (`ISOLATION: … value=seeded-by-first-test`)
  / red-alone (`AssertionFailedError … was: <null>`, exit 1) / fix-line green-alone,
  pyramid priced from surefire (`16 tests 0.216s` vs `3 tests 12.60s`)
- [x] `TEST-03` `unit-testing.md` — executed: 16-test boundary/guard battery green
  (`shipping(net=99.99)=5.00` … `lineTotal 21.40`, message assertions), rename drill —
  `rate → taxRate` turns exactly `implementationTest` red (`NoSuchFieldException: rate`,
  15/16 others green) → revert → `Tests run: 22 … BUILD SUCCESS`
- [x] `TEST-04` `integration-testing.md` — executed: `@SpringBootTest` on real JPA+H2 —
  `CTX-LOAD: beans wired`, round-trip `PERSIST: id=2 rows 0 -> 1`, rollback probe
  `ROLLBACK: before=0 after=0 -> exception propagated AND the row is gone`, and the
  never-ran incident: `OrderServiceIT` outside surefire's `*Test` include (absent from a
  green 22-test run) → renamed → `3 tests 12.60s` present
- [x] `TEST-05` `end-to-end-testing.md` — executed: jar packaged + started on :8085, HTTP-seat
  flow (201 + `Location`, 401 no token, 400 detail) against the deployed process, browser
  seat driven live (page POST → rendered `Order #N placed for ada`, negative path →
  `400: net must not be negative`); Playwright/Cypress shape labelled reference
- [x] `TEST-06` `mocking-and-test-doubles.md` — executed: divergence pair — mock accepts
  `quote(-5.00,1)=-5.35` while real collaborator throws `IllegalArgumentException`;
  run 1 all green (`Tests run: 3, Failures: 0`) across contradictory worlds; guard
  installed → mock test dies (run 2 `Errors: 1`) → rewritten to `verify(never())` →
  run 3 green; stub/spy/fake trio (`SPY: real result 21.40 AND call verified`,
  `FAKE: … no mocking framework`)
- [x] `TEST-07` `test-driven-development.md` — executed full cycle: RED `expected: <95.0>
  but was: <100.0>` (assertion-failure red against the stub) → GREEN minimal rule (`BUILD
  SUCCESS`) → REFACTOR constant extraction → green again; wrong-red drill classified
- [x] `TEST-08` `api-testing.md` — executed: 6-cell battery over `RANDOM_PORT` real
  socket — 201 + `Location=/api/orders/1`, 400 blank customer / negative net with pinned
  `detail`, 401 no token + wrong token (identical bodies pinned against future leak),
  200 → 404 `no order with id 999999`
- [x] `TEST-09` `performance-testing.md` — executed: `PerformanceBatteryTest` — P1
  percentile budget after warmup `p50=100ns p95=100ns max=16300ns budget=50000ns`,
  P2 injected tail `avg=0.073ms PASS vs budget 5.0ms | p99=5.65ms -> tail caught`
  (and the harness bug captured honestly: pause outside the window → first run
  `p99=0.01ms -> tail missed`), P3 gate discriminates `naive=944ms (budget 50ms) ->
  OVER | indexed=0ms -> PASS` (first run's front-of-list workload captured as
  `naive=24ms -> PASS`), deliberate break `p95 100ns exceeds budget 10ns` →
  `BUILD FAILURE` → revert → 3/3 green; JMH/k6/JMeter labelled reference
- [x] `TEST-10` `security-testing.md` — executed: `SecurityBatteryTest` 5 probes —
  first run red on two real gaps (`401 must include a WWW-Authenticate challenge`,
  `X-Content-Type-Options: nosniff must be set ==> expected: <nosniff> but was:
  <<absent>>`), fixed in production code (`WWW-Authenticate: Bearer realm="lab"` +
  `SecurityHeadersFilter` at HIGHEST_PRECEDENCE), then `Tests run: 5, Failures: 0`
  with `challenge=Bearer realm="lab"` / `nosniff`+`DENY` present; P2 injection
  round-trip `get-after-insert=200 table-alive=yes`, P3 traversal `both shapes ->
  non-200`, P4 mass assignment `/api/orders/999999 -> 404`; secrets scan 0 matches
  (code-only scope stated); dependency-check/ZAP labelled reference
- [x] `TEST-11` `test-coverage.md` — executed: JaCoCo baseline over 46 green tests —
  `TOTAL instruction 93.2% (358/384)` with line drill-down naming four dead
  failure paths (`getRate()` never called, `net < 0` guards never threw,
  `quantity <= 0`, the filter's non-`/api/` false arm) → round 1 → `98.7%`
  (379/384) branch `79.4 → 100%` → round 2 (reachable-branch split: controller
  `req == null` structurally unreachable over HTTP, direct-call test) → final
  `54 tests, 0 failures`, only `LabApplication.main()` left (5 instructions);
  honesty drill inside the green run: `PRINT-TRAP: expected=19.9 actual=19.8
  MISMATCH` + `EXIT=0`; stale-class incident (`IsolationDependentTest` fails at
  52 tests, gone from sources, `clean` restores green); PIT labelled reference
- [x] `TEST-12` `quality-gates.md` — executed three-run drill of a real
  three-stage gate (`structure → references → mvn clean verify + jacoco floor
  0.90`): baseline `GATE: PASS` exit 0, `tests=54`, bundle `379/384 = 0.987`;
  planted `AuditLogger.java` (production code, no tests) → stages 1–2 green,
  stage 3 red despite `total=54 failures=0 errors=0` — `Coverage checks have
  not been met` → `GATE: FAIL at stage 3`, exit 1, bundle `379/506 = 0.749`
  (`AuditLogger 0/122`); fix = four `AuditLoggerTest` tests, never config →
  `GATE: PASS` exit 0, `tests=58`, bundle `501/506 = 0.9901`; PASS run still
  carries  `PRINT-TRAP … MISMATCH` as the gate's honest limit; hosted-CI YAML
  labelled reference
- [x] `TEST-13` `exercises/` + solutions (12 sets, 13 files — set 12 covers the
  subject README's regression/frontend/mobile promise; every quoted capture
  traceable to a lesson transcript: `PRINT-TRAP … MISMATCH` inside
  `BUILD SUCCESS`, `value=seeded-by-first-test` → `was: <null>`,
  `16 tests 0.216s` vs `3 tests 12.60s`, `NoSuchFieldException: rate` 15/16
  green, `ROLLBACK: before=0 after=0`, `quote(-5.00,1) = -5.35` vs real throw,
  `expected: <95.0> but was: <100.0>`, `p99=5.65ms -> tail caught`,
  `401 must include a WWW-Authenticate challenge`, `93.2% (358/384)` →
  `98.7%`, gate triple `0.987 PASS` / `0.749 exit 1 with 54 green tests` /
  `0.9901 PASS with 58`; Playwright grid, hosted CI, staging perf runs and
  real-storage traversal labelled reference)

**15-APPLICATION-SECURITY** (prereq: 06, 11, 14)
- [x] `SEC-01` `README.md` — subject index and prereq chain (06, 11, 14) named;
  `SECURITY.md` safe-use pointer present; next-subject pointer to
  `16-DEVOPS-AND-INFRASTRUCTURE` resolves under `check-links`
- [x] `SEC-02` `security-fundamentals.md` — 16 sections; every quoted capture
  traceable to a `seclab-A` probe: base64 recovered in one line
  (`DECOD : password=username:summer2026!`), defense-in-depth ladder
  `L1 off   : concat query returned 3 row(s)` vs `parameterised query returned
  0 row(s)` vs `L1/L2 off, L3 ON : WRITE BLOCKED: attempt to write a readonly
  database` with `rows still readable through the L3 handle: 3`; scanning/audit
  tooling not run — labelled reference
- [x] `SEC-03` `threat-modeling.md` — 16 sections; STRIDE matrix built over an
  executed 5-route walk of the `seclab-A` notes server: `GET  /notes -> 200`
  returning bob's row to an anonymous caller, `POST /notes -> 201` with
  `"owner": "anonymous"`, `GET  /debug/config -> 200` serving
  `jwt_secret`/`db_url`/`admin_api_key` (body truncated at 120 chars by the
  probe), injection probe `GET  /notes?id=1'--      -> 404`; DAST/IAM/cloud
  inventory not run — labelled reference
- [x] `SEC-04` `password-security.md` — 16 sections; four executed probes:
  unsalted `identical hashes: True` vs salted `False` (`verify alice: True`),
  crack `summer2026! in 0.0176 ms` vs PBKDF2-600k `tried 20 candidates in
  16.12 s` / `per-attempt cost: 806 ms` -> `attacker slowdown vs the unsalted
  store: 915776x` (still `CRACKED:` — dictionary hit, argued in text), timing
  ladder `1.02 / 12.61 / 128.29 / 796.54 ms`, policy-vs-strength
  `Password1! ... PASS FAIL` vs `correct horse battery staple ... FAIL PASS`;
  Argon2/bcrypt/breach-list API not run — labelled reference
- [x] `SEC-05` `session-security.md` — 16 sections; five executed `seclab-B` phases:
  fixation `same sid before and after login  : True` vs rotation `replay old sid -> 401`
  `{"error": "no such session"}`, cookie flags `{'HttpOnly': False, 'Secure': False,
  'SameSite': 'absent'}` vs `{'HttpOnly': True, 'Secure': True, 'SameSite': 'Strict'}`,
  `GET /notes with an expired sid -> 401: {"error": "session expired"}` and
  `GET /notes after  logout -> 401: {"error": "session revoked"}`; browser DevTools cookie
  inspection, real TLS deployment, session-store load tests not run — labelled reference
- [x] `SEC-06` `access-control.md` — 16 sections; four executed `seclab-B` phases: IDOR
  `bob GET /notes/1 (alice's) -> 200` vs check on `-> 403` (own note still `200`, admin
  still `200`), forced browsing `checks off: alice GET /admin/metrics -> 200` vs
  `checks on : alice ... -> 403`, mass assignment `checks off: bob POST /profile -> 200`
  `{"user": "bob", "role": "admin"}` + `checks off: bob GET /admin/metrics -> 200` vs
  fixed `checks on : bob POST /profile -> 200` `{"user": "bob", "role": "user"}`;
  SAST authorization linters, real IAM audits, gateway policy tests not run — labelled
  reference
- [x] `SEC-07` `injection-vulnerabilities.md` — 16 sections; executed `seclab-B` probes:
  SQLi tautology `payload "' OR '1'='1" -> 4 row(s)` and `UNION ... -> 1 row(s): [(99,
  'pwned', 'admin')]` vs parameterised `executed SQL: SELECT * FROM users WHERE name = ?`
  returning `0 row(s)` for both payloads, shell injection `output lines : ['greeting x',
  'PWNED-BY-ARGUMENT']` / `injected second command ran: True` vs list argv
  `['greeting x & echo PWNED-BY-ARGUMENT']` / `False`; sqlmap, DAST scanners,
  NoSQL/LDAP/template injection not run — labelled reference
- [x] `SEC-08` `cross-site-scripting.md` — 16 sections; executed `seclab-B` probes:
  reflected XSS `script elements parsed   : ['window.__pwned=1']` vs escaped `[]`,
  stored XSS same pair, `javascript:` URL surviving escaping
  `still a script-capable scheme: True` then scheme allowlist `-> #blocked`; in-browser
  script execution, CSP reporting, extension testing not run — labelled reference
- [x] `SEC-09` `csrf.md` — 16 sections; executed `seclab-C` probe: forged
  cross-site POST without defenses `-> 200: {"user": "alice", "email":
  "attacker@evil.example"}` changing alice's email (`alice's email after :
  new@example.com`) vs Origin check `-> 403: {"error": "cross-origin request
  rejected"}` and session-bound token `no token -> 403: {"error": "missing csrf
  token"}` / `attacker's own token -> 403: {"error": "csrf token mismatch"}` while
  alice's real token `-> 200`; browser-driven delivery (form/iframe/fetch),
  SameSite cookie interaction, and cross-framework header parsing not run —
  labelled reference
- [x] `SEC-10` `ssrf.md` — 16 sections; executed `seclab-C` probe: policy off
  reads the metadata stand-in `{'fetched': '{"AccessKeyId":
  "AKIA-LOOPBACK-STANDIN-0001"...` and `file://` -> `LAB-ONLY-LOCAL-FILE-SECRET`;
  strict policy `{'error': 'blocked: 127.0.0.1 resolves to private address
  127.0.0.1'}` and `blocked: scheme 'file' not allowed`; naive allowlist escapes
  through the open redirect `allowlisted CDN redirect -> {'fetched': '{"AccessKeyId":
  "AKIA-LOOPBACK-STANDIN-0001"...}` vs `strict, same redirect -> 'RuntimeError:
  redirect hop 1: blocked...'`; real cloud metadata endpoints, DNS rebinding, and
  multi-hop redirect chains not run — labelled reference
- [x] `SEC-11` `secure-api-design.md` — 16 sections; executed `seclab-C` probe:
  rate ladder `status codes: [200, 200, 200, 200, 200, 429, 429, 429]` with
  `9th request -> 429 ... Retry-After: 9` while `other client unaffected -> 200`;
  error hygiene leaky `500: {"error": "login failed against
  postgres://api_app:DevPass99@10.0.4.11:5432/prod", "debug": true}` and a
  `stack: "File app.py line 42..."` vs fixed `500: {"error": "internal error",
  "code": "AUTH_UPSTREAM", "request_id": "req_lab_0001"}` (`req_lab_0002` for the
  admin route); distributed multi-node counters, real load tests, and gateway/WAF
  layers not run — labelled reference
- [x] `SEC-12` `secrets-management.md` — 16 sections; executed `seclab-C` probes:
  pattern scan `findings: 4` over the fake repo (`app.py:3 [generic api key
  assignment] API_KEY = "sk_live_EXAMPLE_FIXTURE"`, `app.py:4 [database
  url with password] postgres://app:DevPass99@10.0.4.11`, `deploy.sh:2 [AWS access
  key id] AKIAIOSFODNN7EXAMPLE`, plus a private-key block); env-based config
  `literal in source: False` / `app_env.py scan findings: 0` / `LAB_API_KEY
  loaded, length 23`; masking `masked log : login with api_key=sk_l...RE` with
  `masked contains full key : False`; hosted secret-scanning services, KMS/HSM
  vaults, and live rotation not run — labelled reference
- [x] `SEC-13` `dependency-security.md` — 16 sections; executed `seclab-C` probes:
  pinning hygiene `flask -> UNPINNED - resolves to whatever is newest` (and
  `django>=4,<5`, `unpinned entries: 2`); offline advisory snapshot (LAB FIXTURE)
  `requests==2.31.0 vs GHSA-LAB-0001 < 2.32.0 -> VULNERABLE` vs `django>=4,<5 ->
  UNKNOWN (not pinned; cannot compare)`; after upgrading `still-flagged pinned
  entries: 0` with `flask remains UNPINNED`; hash-pin detection `version-pinned:
  True, hash-pinned: True`; live pip-audit / OSV / npm audit not run — labelled
  reference (the probe prints this itself)
- [x] `SEC-14` `tls-and-certificates.md` — 16 sections; executed `seclab-C` probe
  (Python OpenSSL 3.0.16, CLI 3.5.9): default store fails `certificate verify
  failed: unable to get local issuer certificate` vs lab CA trusted `negotiated :
  TLSv1.3 / TLS_AES_256_GCM_SHA384` returning `hello over TLS`; `openssl x509`
  inspection `subject=CN=localhost` / `issuer=CN=Lab Root CA` with SAN
  `DNS:localhost, IP Address:127.0.0.1` and `checkend 0 : exit 0 -> Certificate
  will not expire`; version floor refuses `tlsv1 alert protocol version`; public-CA
  issuance/ACME renewal, browser warning UX, HSTS/CT, and revocation not run —
  labelled reference
- [x] `SEC-15` `secure-file-uploads.md` — 16 sections; executed `seclab-C` probe:
  traversal `naive resolves outside uploads dir : True` vs `safe : stored as
  uploads-lab/2edafaa21107.png (name kept inside: True)`; sniffing rejects both
  `avatar.png` and `shell.php.png` -> `rejected: content is php but extension says
  .png`; null byte -> `rejected: extension '.php' not allowed`; streaming limit
  `reader stopped at 65537 bytes (limit 65536)` / `rejected: size 65537 > 65536
  bytes`; image re-encoding, antivirus scanning, browser serving-header behavior,
  and storage-bucket policies not run — labelled reference
- [x] `SEC-16` `security-testing-labs/` local, authorized-only labs — README index
  of all 16 labs with the four-beat loop (exploit -> failing test -> fix -> proof),
  authorization ground rules (loopback-only targets, fixture-only data, safe-use
  pointer to `SECURITY.md`), the lesson->probe table for `seclab-A|B|C` verified
  against each probe's own header comment, run instructions (stdlib + `openssl`,
  no network deps) and the loopback port table (8095, 8096/8097/8100, 8101,
  8443/8444); no third-party targets or scanners exercised — labelled reference

## M8 — Operations and production (Phase I)

**16-DEVOPS-AND-INFRASTRUCTURE** (prereq: 03, 11)
- [x] `OPS-01` `README.md` — subject index and prereq chain (03, 11, 15) named;
  next-subject pointer to `17-CLOUD-AND-PRODUCTION` resolves; `ops-lab-A` probe
  pointer added for the first four lessons; `check-links` passes
- [x] `OPS-02` `devops-fundamentals.md` — 16 sections; every quoted capture
  traceable to `ops-lab-A/pipeline_probe.py`: gate held at `gate: test failed ->
  build, deploy never runs` (test exit 1, `FAIL ten percent off 100: expected 90,
  got -900`), reproducible artifact `build 1 sha256 c14ac46096ab4a28` / `build 2
  sha256 c14ac46096ab4a28` / `identical bytes: True`, blast-radius table `big-bang
  15s 250 45s`, `rolling 15s 50 30s`, `blue-green 15s 100 15s`, `canary 30s 35
  45s`; GitHub Actions workflow shown as an illustration and marked not executed;
  hosted runners unavailable — labelled reference
- [x] `OPS-03` `linux-administration.md` — 16 sections; `admin_probe.py` capture:
  `this shell starts with umask 0022` with `0666 & ~077 = 600` arithmetic against
  `file created by this Python process: stat reports 644`; chmod matrix `requested
  600 -> stored 644` .. `requested 400 -> stored 444` .. `chmod +x on a shebang
  script -> 755`; `secret.env others-readable after chmod 600: True (644)`; triage
  `failed=5 accepted=2 sessions=1 oom=1`, `3 198.51.100.23 failed attempts`,
  `2 invalid user admin`; rotation `auth.log 1212 bytes -> auth.log.1.gz 507 bytes
  (58% smaller)` with `12 of 12` still readable; disk `95% used -> ALERT: above
  90%`; `systemctl` absent (`exit 127`), so unit files, `journalctl` and ext4
  stored modes are labelled reference
- [x] `OPS-04` `networking-for-devops.md` — 16 sections; `net_probe.py` capture:
  listener `127.0.0.1:8105` vs client `127.0.0.1:61445`, `round trip: pong:ping`;
  `ConnectionRefusedError after 2.02 s` against `TimeoutError after 1.51 s` on
  `192.0.2.1:80`; DNS `localhost -> 127.0.0.1`, `example.com -> 104.20.23.154,
  172.66.147.243`, `gaierror 11001`, resolver `OpenWrt` `192.168.0.1`; health check
  `failure 1 of 2, still in pool` then `EVICTED after 2 consecutive failures` then
  `re-admitted after a good check`; `OSError 10048 (WSAEADDRINUSE)`; operator
  commands shown as illustration; no real load balancer, firewall, or DNS zone
  configured — labelled reference
- [x] `OPS-05` `shell-scripting.md` — 16 sections; `script_probe.py` drives real bash
  runs (GNU bash 5.3.15): `cat missing | wc -l` with `set -e` prints `STILL RUNNING`
  and `exit=0`, with `pipefail` `exit=1`; `set -u` gives `DEPLOY_ENV: unbound
  variable` / `exit=127`; unquoted split yields `[my]` `[report.txt]` against
  `"$@"` `[my report.txt]`; trap fires on the failure path (`cleanup removed
  /tmp/tmp.…`, `exit=1`, no leftovers); missing `--env` value exits `1` with no
  message while an unknown flag exits `2`; idempotence proved by two identical
  tree digests `7ee1a121bff85b40…`
- [x] `OPS-06` `docker-fundamentals.md` — 16 sections; `docker_probe.py` builds real
  gzipped tar layers: `base 180 KB`, `deps 147 KB`, `app 237 B`, `cleanup 187 B`,
  `total 328 KB`, rebuild gives the same digest `True`; whiteout
  `srv/app/.wh.config.json` removes `config.json` (`True`); deleting in a layer
  keeps `328 KB`; two images share `327 KB` so `328 KB` stored instead of `655 KB`
  (`saves 49%`); copy-on-write leaves the digest `d8e4d1251ce3` unchanged while the
  writable layer holds `49` bytes; argv assembly in exec and shell form; manifest
  digest `b10021fdd6b6` -> `787f3278066e` (CMD) -> `17d2228516f5` (base). Docker
  Engine absent, so `docker build/run/inspect` and the overlay driver are labelled
  reference
- [x] `OPS-07` `docker-images-and-containers.md` — 16 sections; `image_probe.py`
  models the build cache: build 1 `0 cached, 6 new`, build 2 `6 cached, 0 new`,
  source change `4 cached, 2 new`, base retag `0 cached, 6 new`; ordering contrast
  `1 of 6` cached with `COPY` first against `4 of 6` in the conventional order;
  multi-stage `builder 1904 KB` -> `final 88 KB` (`95% smaller`) with `runs as
  root: False`; `COPY .env` puts the secret in `1` layer (`102 B`) and removing the
  line leaves `0`. No daemon on this machine, so BuildKit cache mounts, `--cache-
  from`, and registry pushes are labelled reference
- [x] `OPS-08` `container-networking.md` — 16 sections; `netlab_probe.py` over real
  sockets: direct `127.0.0.1:8110 -> HTTP/1.0 200 OK` while `192.168.0.50:8110 ->
  TimeoutError after 2.02 s`; forwarder on `8111` returns `200 OK` and the backend
  records `peer=127.0.0.1` with `X-Forwarded-For=127.0.0.1:53896`; name `api`
  resolves, `cache` gives a name error; second bind `OSError 10048`; egress to
  `192.0.2.1:80` times out after `2.00 s`; round robin `2 ok, 2 failed`, then
  `health check 8113 -> failed, evicted` and `pool now holds 1 of 2`. Bridge
  networks, iptables DNAT, and embedded DNS are labelled reference
- [x] `OPS-09` `volumes-and-persistence.md` — 16 sections; `vol_probe.py` moves real
  files through a mount table: the writable layer dies (`state file exists: False`)
  while the volume keeps `PG_VERSION=17`; the bind is the host directory (both sides
  see the write immediately); mounting over `/srv/app/data` turns `['seed.json']`
  into `['PG_VERSION']`; the drill tars the volume, destroys it, restores it and
  matches both files by SHA-256 (`identical: True`); 3 volumes on disk, 1
  referenced, 2 orphans needing an explicit prune. Docker volume drivers and the
  overlay filesystem are labelled reference
- [x] `OPS-10` `docker-compose.md` — 16 sections; `compose_probe.py` parses and
  validates the file itself: services `api/db/web`; interpolation yields `app:1.0`
  and `postgres:17-alpine`, and a missing required value stops resolution with
  `KeyError 'DB_PASSWORD: set DB_PASSWORD'`; `$$` survives as `cost=$5`; published
  ports `8000` and `8080->80`; a broken fixture produces `problems found: 2`
  (duplicate host port, unknown dependency); order `['db', 'api', 'web']`; a cycle
  raises `ValueError dependency cycle: a -> b -> a`; `TAG=2.3.1` retags the image
  to `app:2.3.1`. The `docker compose` CLI and its merge rules are labelled
  reference
- [x] `OPS-11` `nginx-and-reverse-proxies.md` — 16 sections; `proxy_probe.py` runs a
  real reverse proxy over TCP: prefix routing (`/api`, `/slow`, `/`) returns 200
  per upstream; failover returns 200 although the first upstream is a closed port;
  a 3.0 s upstream yields `504 upstream timeout after 1.02 s` and then
  `upstream finished afterwards anyway: 1 request(s)`; a 4000 B POST is refused
  `413` against a 1024 B limit while 200 B reaches the backend; the deny list
  answers `/metrics` with `404` and no backend sees it; the access log records 9
  requests, 6 successful. NGINX itself is absent, so every directive in the
  reference configuration is labelled
- [x] `OPS-12` `dns-and-tls-operations.md` — 16 sections; `tls_probe.py` issues a
  private CA and leaf with OpenSSL 3.5.9 (SANs `DNS:localhost, IP:127.0.0.1`),
  verifies `OK`, rejects the leaf as its own CA (`error 20`), matches key and
  certificate by modulus, refuses the untrusted chain (`code 20`), then negotiates
  `TLSv1.3 TLS_AES_256_GCM_SHA384` with the CA trusted; a trusted certificate for
  the wrong name still fails (`code 62`); expiry `2026-11-23` is 19 days out and
  alerts at 30 but not 14; `example.com` resolves to 2 addresses and an invalid
  name raises `gaierror 11001` before any handshake. OCSP, CRL, and public
  issuance are labelled reference
- [x] `OPS-13` `infrastructure-as-code.md` — 16 sections; `iac_probe.py` is a
  plan/apply engine over a real state file: first plan `plan: 3 to add, 0 to change,
  0 to destroy`, apply writes state serial 1, and a re-plan says `No changes.
  Infrastructure is up to date.`; a hand edit produces `update   server.web     size
  changes`; `image` forces `replace  server.web     image forces replacement`;
  removing two resources destroys `destroy order: ['server.web', 'subnet.a']`; a
  second operator is `refused, lock held by alice@laptop`; a ghost in state is
  destroyed while an unmanaged bucket is invisible (`plan destroys it only if it is
  in state: False`). Terraform/OpenTofu/Pulumi CLIs and their providers are labelled
  reference
- [x] `OPS-14` `terraform.md` — 16 sections; `tf_probe.py` models evaluation and
  planning: addresses `count instances:   ['web[0]', 'web[1]', 'web[2]']` against
  `worker["mailer"]`; `detailed exit code: 2` then `0`; removing a middle count
  element plans `replace  web[1]  (name forces replacement)` plus `destroy  web[2]`,
  while a for_each removal plans only `destroy  worker["indexer"]`;
  `prevent_destroy` blocks the plan with `Error: worker["mailer"]: Instance cannot
  be destroyed (prevent_destroy is set)`; precedence resolves `effective image:
  app:1.2`; `db_password  = (sensitive value)` while `state contains the value:
  True`. The terraform binary, providers and remote backends are labelled reference
- [x] `OPS-15` `ansible.md` — 16 sections; `ansible_probe.py` runs a play against two
  hosts: `first run: ok=2 changed=13` then `second run: ok=14 changed=0`; `when`
  skips the nginx task on the RedHat host; the handler is deduplicated (`restart app
  (4 notification(s), deduplicated to one run per host)`); drift is repaired in
  `third run: ok=13 changed=2`; check mode reports `check mode: ok=12 changed=2` with
  `file unchanged by check mode: True`; a broken module stops the play at `failed=1`
  and `ignore_errors` continues at `failed=2`; `run_once` writes the canary only on
  `web1`. The ansible CLI, roles and collections are labelled reference
- [x] `OPS-16` `ci-cd-fundamentals.md` — 16 sections; `ci_probe.py` is a pipeline
  runner executing real jobs: graph order `order: ['install', 'lint', 'unit',
  'integration', 'build', 'deploy']`; cache `cache=miss key=ea395108aba1` at 0.36s
  then `cache=hit` at 0.00s, invalidated to `key=10d5964191e7` by a lockfile edit; a
  failing unit job leaves lint green while integration, build and deploy are
  `SKIPPED`; `e2e TIMED_OUT 1.04s`; `publish` succeeds after `attempts=2`;
  `deploy_allowed=False` on a feature branch; artifact `sha256:
  c6a38316a242653c` with `digest matches the build: True`; the token logs as `***`.
  Hosted runners are labelled reference
- [x] `OPS-17` `github-actions.md` — 16 sections; `actions_probe.py` implements
  workflow semantics: a docs-only push is refused (`no changed file matches
  on.push.paths ['app/**']`), a feature branch is refused by `branches`, a pull
  request starts the run; the matrix expands `combinations: 3 of 4` with names such
  as `test (python=3.13, os=windows)`; deploy is skipped on a pull request by its
  `if:` while `notify` runs under `always()`; a failing matrix leaves deploy skipped
  and notify successful; `hashFiles` moves the key `deps-9de1b09c` to
  `deps-fc67850c`; concurrency cancels the older run (`run 41 -> cancelled`); an
  undefined context raises `KeyError`. Runner images, marketplace actions and OIDC
  are labelled reference
- [x] `OPS-18` `deployment-strategies.md` — 16 sections; `deploy_probe.py` models three
  instances at 6 requests/tick against 9 capacity and measures every strategy against the
  same traffic: recreate fails 18 requests with peak unavailable 3; rolling with one
  instance out fails 0 at peak 1; rolling with two out fails 9; blue-green fails 0 and
  finishes at tick 7 while doubling capacity, and a release failing its health check
  aborts at tick 7 with the old pool still serving; the canary records `canary saw 4
  failures of 24 requests (16.7%)` and `budget burned: canary removed, stable untouched`
  at tick 9. Kubernetes manifests and cloud load-balancer consoles are labelled reference
- [x] `OPS-19` `monitoring-and-logging.md` — 16 sections; `observe_probe.py` serves 240 real
  loopback requests and measures them: `requests: 240, statuses: {200: 235, 500: 5},
  errors: 5 (2.1%)`; p99 far above p50 with the mean between them; `30 days = 43200
  minutes, budget = 43.2 minutes` and `at 2000000 requests/month, 2000 failures exhausts
  it`; `observed 2.08% is 20.8x the 0.1% budget`; logs parse into eight fields with
  `unparsed 0`; a rule over consecutive windows concludes `1 window(s) -> no page`;
  `paths ['/fail', '/fast', '/slow'] x statuses [200, 500] = 6 series` is cardinality;
  `10% sample: 24 lines, 1 error(s) (4.2% versus 2.1% overall)` is sampling error.
  Prometheus, Grafana and hosted APM are labelled reference
- [x] `OPS-20` `backups-and-recovery.md` — 16 sections; `backup_probe.py` writes real
  `tar.gz` archives with SHA-256 manifests: a 41-file full (`archive bytes: 1101`) and a
  4-file incremental (`archive bytes: 213`); the drill applies `archives applied: 2, files
  written: 45` and reports `verified 42 of 42 files, mismatched: []` with `restore identical
  to source: True`; one flipped byte is not rejected by the archive tool (`corrupt restore
  raised: nothing`) but hashes catch it (`38 of 42` match), and falling back to the full
  loses `3 changed file(s)`; a naive copy during a write is torn while the quiesced copy
  parses; GFS keeps `17` of `720` snapshots. restic, borg, pgBackRest and object-storage
  lifecycle rules are labelled reference
- [x] `OPS-21` `troubleshooting/README.md` — 16 sections; `troubleshoot_probe.py` injects six
  real failures and narrows each by the cheapest check: `OSError 10048` from a second bind
  with a successful connect proves a port conflict; `status 500` after a connect separates
  the listener from its dependency; `gaierror 11001` proves no packet left the machine;
  `PermissionError 13` on an existing path separates permissions from space; a client
  timeout is `not a refusal`; and a lock naming an exited child is `already exited ->
  False` per the process table. `ss`, `ps` and container-runtime inspections are labelled
  reference

**17-CLOUD-AND-PRODUCTION** (prereq: 16)
- [x] `CLD-01` `README.md` — subject index; prereq chain (06, 16) named; a lab-host and
  probe-pointer paragraph added, stating that every lesson embeds one executed probe and that
  console and provider steps are labelled reference; all twelve lesson filenames match this
  register; the next-subject pointer to `18-ADVANCED-ENGINEERING` resolves; `check-links` passes
- [x] `CLD-02` `cloud-computing-fundamentals.md` — 16 sections; `fundamentals_probe.py` multiplies
  path availability (`request path lb x app x db : 99.840065%`, `downtime allowed per month :
  70.11 min`), separates redundancy from failure domains (`two instances, one zone : 99.5975%` at
  `176.4 min` versus `two instances, two zones : 99.9959%` at `1.8 min`, so `what the second zone
  buys : 174.6 min/month`), splits fourteen controls by service model (`IaaS ... customer 10
  shared 2 provider 2`, `PaaS 6 5 3`, `SaaS 3 4 7`), derives `monthly budget : 43.8 min` with `6x
  burn ... 7306 min`, finds the billing `crossover : 4.14 M requests/month`, and shows a second
  region lifting `<=50 ms` coverage from `45%` to `75%` and `<=200 ms` from `75%` to `100%`.
  Provider consoles and the shared-responsibility documents are labelled reference
- [x] `CLD-03` `virtual-machines.md` — 16 sections; `vm_probe.py` prices six instance types from
  `small ... 15.18` to `cpu-2x ... 242.94`, rightsizes three services to `total rightsized $
  123.97/month vs $427.23 default -> saves $303.26 (71%)`, shows oversubscription as steal (`1x
  ... 0.0%` through `4x ... 75.0%` with `throughput 25% of demand`), times `total cold start 55
  s` and `replacing 10 instances, 2 at a time: ... 425s (7.1 min)`, and prices preemptible
  capacity at `$0.0499/h (70% discount)` saving `$510.18` while `drain time must stay under the
  120 s notice (ok)`. Creating instances and reading a hypervisor's steal counter are labelled
  reference
- [x] `CLD-04` `cloud-networking.md` — 16 sections; `networking_probe.py` plans six subnets with
  `251 usable` and `4091 usable` addresses, validates `overlapping pairs: 0` and `addresses
  allocated: 13056 of 65536 (19.9%)`, evaluates five flows including `admin ssh 22 ALLOW
  0.0.0.0/0:22` and `internet scans the database 5432 DENY no matching rule`, audits `privileged
  ports open to the internet: 3`, resolves routes until a deleted NAT yields `8.8.8.8 ->
  blackhole (no route)`, and shows a stateless ACL rejecting the reply (`reply to port 51000
  permitted: False`) where a stateful group tracks it. Provider VPC consoles and live
  security-group evaluation are labelled reference
- [x] `CLD-05` `object-storage.md` — 16 sections; `object_storage_probe.py` deduplicates by
  content hash (`logical bytes 41900, stored bytes 26400 (63% after dedupe)`), contrasts a
  multipart ETag `19019d16dd0f439825c39a2c5b9178fd-3` with the single-part
  `ee8e104a3ce4b8f60f0e0106f20f51a4` for identical bytes and reassembles `reassembled ==
  original: True`, exercises versioning until `get after delete: None (NoSuchKey)` with `listing
  still contains the key: True`, paginates with a next-token, verifies presigned URLs (`valid`,
  `expired`, `signature mismatch` twice), and derives `3 replicas: ... (5.5 nines)` against `10+4
  erasure: ... (5.9 nines)`. Creating a bucket and configuring lifecycle rules are labelled
  reference
- [x] `CLD-06` `managed-databases.md` — 16 sections; `managed_db_probe.py` runs real SQLite: `SCAN
  orders` becomes `SEARCH orders USING INDEX idx_orders_customer (customer_id=?)`, a join costs
  `1 statement, 500 rows` against `500 statements, 1000 rows` for the N+1 loop (`round trips
  saved: 499`), pool 10 gives `mean wait 195.0 ms, utilisation 99%` against `pool 20 ... 0.0 ms,
  72%`, `12 app instances x 20 connections = 240 against a server limit of 100 -> 140 rejected
  at connect`, failover is `detection 20s + promotion 15s + DNS TTL 30s = 65s window` costing
  `~390` errors with one attempt and `~39` with three, replica lag is `1.2 s` (`696 of 14400`
  stale reads), and a restore takes `107 min against a 60 min RTO -> breach`. Provisioning a
  managed instance and performing a real failover are labelled reference
- [x] `CLD-07` `identity-and-access-management.md` — 16 sections; `iam_probe.py` evaluates
  policies over a 33-action catalogue (`app-role ... 4/33`, `legacy-admin ... 28/33`, `deployer
  ... 14/33`), applies explicit-deny precedence and boundaries (`Deny kms:Decrypt ... outside
  permissions boundary boundary`, `no allow statement (implicit deny)`), derives least privilege
  from six logged calls (`narrowing legacy-admin to app-role removes 24 of 28 allowed actions
  (86%)`), walks a six-row confused-deputy table where `scoped-trust ... denied` until the
  external ID matches, and detects escalation paths (`deployer holds 3: ['iam:AttachRolePolicy',
  'iam:CreatePolicyVersion', 'iam:PassRole']`, `app-role holds 0`). Creating roles, attaching
  policies and reading a provider's access analyzer are labelled reference
- [x] `CLD-08` `secrets-and-configuration.md` — 16 sections; `secrets_probe.py` merges three
  layers (`defaults < .env < environment, 6 keys`, `APP_ENV resolved to 'production'`), reports
  exactly one validation error (`DATABASE_URL is required but has no value in any layer`),
  compares `naive dump length 137, values exposed: 3` with `DB_PASSWORD present in naive dump:
  True; in redacted: False`, scores a scanner on a labelled corpus (`true positives 5, false
  positives 0, false negatives 0`, `precision 100%, recall 100%`), rotates an HMAC key with real
  verification (`no overlap : 400 of 400 live tokens rejected` versus `24 h overlap: 0 of 400`),
  and computes entropy (`token_urlsafe(32): 43 chars, 256 bits`, a six-digit code `2 min to
  exhaust at 10k guesses/min`, `'hunter2': 21 bits if truly random`). Creating a vault secret,
  configuring automatic rotation and reading a secret-access audit log are labelled reference
- [x] `CLD-09` `load-balancing.md` — 16 sections; `load_balancing_probe.py` runs four selectors
  against six backends with one 8x slower: `round_robin ... 51.7ms ... 160.0ms ... 16.7%`
  versus `p2c_response ... 31.6ms ... 160.0ms ... 2.6%` at `23.5%` spread, moves `1558/10000`
  keys with consistent hashing against `8608/10000 (86.1%)` for modulo, prices failure detection
  (`15s window -> 156 failed requests`, `6s window -> 62`, `20s window -> 208`, `passive ejection
  after 5 consecutive 5xx ... 5 requests`), and counts `4,000 users (16.7%)` losing sessions when
  one of six nodes dies. Creating a real balancer, registering targets and reading its access
  logs are labelled reference
- [x] `CLD-10` `scaling.md` — 16 sections; `scaling_probe.py` computes `900 / (120 x 0.60) = 12.5
  -> 13 instances`, `36` busy of `62` slots, and `Little's law at 100 ms: 90 requests in flight,
  of which 36 are being served and 54 are queued`; the ten-minute ramp separates the policies
  (`fixed 3 ... breach 432 s ... worst 6480ms`, `fixed 12 ... breach 0 ... mean util 42%`,
  `reactive 180s cooldown ... 335 s`, `reactive 60s cooldown ... 275 s`, `predictive, no lag ...
  5 s`), and the delay is decomposed as `boot 90s: capacity decided at t=180 serves traffic at
  t=270` with `the ramp adds 4.4 req/s every second`. Creating an autoscaling group and observing
  a real scale-out are labelled reference
- [x] `CLD-11` `observability.md` — 16 sections; `observability_probe.py` merges two latency
  distributions (`average of the two p99s: 90.6 ms` against `p99 of the merged fleet: 99.9 ms`,
  `error from averaging: 9%`), quantises a histogram (`p 95: true 72.1 ms, from buckets 96.3 ms
  (34% error)`), multiplies labels (`4800 series`, `240,000,000 series (457.8 GiB)` once `user_id`
  is added), samples rare errors (`1% sampling captures 10 failing traces; chance of capturing
  none is 4.3e-05`), prices logs (`57.0 GB/day, 1711 GB/month`, `30-day retention ... $855/month
  ingest`, trimming a debug line for `$272`), and derives burn-rate windows (`14.4x: 3000 min`,
  `99.87% achieved against 99.9% target uses 130% of the budget`). Running Prometheus, a tracing
  backend or a log platform is labelled reference
- [x] `CLD-12` `incident-management.md` — 16 sections; `incident_probe.py` reconstructs `16
  entries from 3 sources, ordered by corrected time` after correcting `api-2 ... +37 s`, computes
  `detected 10:02:11 +4 min`, `mitigated ... +10 min`, `recovered ... +21 min` and `MTTR (signal
  -> recovered): 21 min`, burns `19% of a 30-day 99.9% budget in one incident`, sizes `3 of 24
  checkout shards -> 22,500 of 180,000 users (12.5%)` and `$415` of exposure, groups `47 raw
  alerts from 4 rules` into `5 pages`, and proves the lead time (`pool exhaustion at 09:58:12,
  4.0 min before the checkout alert`; `p99 latency was already 240 ms ... 4 min before the
  error-rate alert`). Paging a real on-call rotation, using an incident tool and running a live
  postmortem review are labelled reference
- [x] `CLD-13` `cloud-cost-management.md` — 16 sections; `cost_probe.py` prices eight meters to
  `total 3424.51` with `egress ... 32%`, `log ingest ... 25%`, `managed database ... 20%` and
  `compute ... 11%`, derives `$2.1952 per million requests`, ranks seven optimisations to `total
  identified 2117.60 62% -> $1306.91/month`, models `spot at 70% off with 10% interruption risk:
  expected 63% saving before engineering cost`, and grows traffic (`doubling traffic doubles
  compute to $742.85 but egress scales too: $2140.16 at 24 TB`). Reading a billing console,
  setting budgets and purchasing reserved capacity are labelled reference

**18-ADVANCED-ENGINEERING** (prereq: 13, 16, 17)
- [x] `ADV-01` `README.md` — subject index for the ten lessons, each linked with the failure it
  answers; states the executed-probe policy (one standard-library probe per lesson with its capture
  quoted beneath it, counts and declared prices instead of stopwatches) and marks absent
  infrastructure (broker, streaming platform, production database, orchestration cluster) as
  labelled reference; prerequisites point at subjects 13, 16, 17 and `big-o-notation.md`
- [x] `ADV-02` `concurrency-and-parallelism.md` — 16 sections; `concurrency_probe.py` runs four
  threads against one counter (`expected increments : 800`, `lost updates observed : True`) and
  fixes it with a mutex (`actual increments : 800`), builds a circular wait (`circular wait
  observed : True` with both threads still waiting), shows process isolation (`length each child
  returned : [2, 2]` while `parent list after : [1]`), prints the cooperative order (`A0 -> B0 ->
  A1 -> B1`), and prices four mechanisms (`10k x 5 ms wait ... one thread 50.00` to `50 threads
  1.07` = `46.73x`, against `10k x 1 ms CPU ... 50 threads 10.07` = `0.993x` and `8 processes
  1.49` = `6.71x`); the timing table is labelled a cost model, not a benchmark
- [x] `ADV-03` `message-queues.md` — 16 sections; `message_queues_probe.py` drives a
  simulated-clock broker: a crash after processing produces `deliveries for one logical message
  : 2` with `acks=1`, an idempotency key makes the repeat harmless (`deliveries 4, side effects 3,
  duplicates suppressed 1`), the retry schedule is `[200, 400, 800, 1600, 3200]` ms totalling
  `6.2 s`, a poison message is dead-lettered after five attempts (`dead letters : [('bad-1', 5)]`,
  `followers waited behind it : 6.2 s`), two consumers reorder completion (`['b', 'd', 'a', 'c']`
  against publish order), and drain arithmetic shows `20 consumers: 800 msg/s, backlog never
  shrinks` versus `24 ... clears 5000 in 31.2 s`. Installing a real broker is labelled reference
- [x] `ADV-04` `event-streaming.md` — 16 sections; `event_streaming_probe.py` builds a
  three-partition log (`partition sizes : [3, 4, 4]`, `every key stayed in one partition: True`),
  replays one record after a crash before commit (`total processing runs : 12` for 11 records,
  `records processed more than once : 1`), contrasts sinks (`naive sink side effects : 12` against
  `idempotent sink side effects : 5`), compacts `12` writes to `3` records with `tombstoned keys :
  ['order-4']`, prices retention (`7-day retention, 3 replicas: 21.5 GB`), and computes lag
  (`lag after 60 s : 60,000 records`, `time to clear the backlog : 20 s`, `a 13th consumer receives
  : 0 partitions, so it idles`). Running a streaming platform is labelled reference
- [x] `ADV-05` `database-scaling.md` — 16 sections; `database_scaling_probe.py` creates a real
  20,000-row SQLite table and prints the planner's own words (`before index: SCAN orders` then
  `after index : SEARCH orders USING INDEX idx_orders_customer (customer_id=?)`), quantifies it
  (`rows customer 42 owns : 80`, `250x fewer rows read`), measures replica staleness (`stale reads
  : 16 (53%)` and `fresh reads : 14`), shows hash spread (`rows per shard : [1029, 943, 1035, 993]`,
  `1.03x`) and a hot tenant (`[0, 4000, 0, 0]`), the cache working-set cliff (`capacity 50 ... 25.0%`
  against `capacity 200 ... 96.2%`), and pool ceilings (`10 connections ... 2000 queries/s` to `40
  ... 8000`). Provisioning a managed database, replica or shard is labelled reference
- [x] `ADV-06` `distributed-systems-patterns.md` — 16 sections; `distributed_patterns_probe.py`
  compensates a failed saga (`business effect left behind : none (2 steps undone)`, `steps that
  never ran : ['send confirmation']`), prices two-phase commit (`participants holding locks : 4`),
  tabulates outbox crash moments (`crash after commit, before relay` loses one; `crash during
  relay, after publish` duplicates one), runs a breaker (`calls that reached the dependency: 11`,
  `calls rejected locally : 3`, final state `closed`), measures a bulkhead (`worst healthy latency
  : 2020 ms` with `4` over 100 ms, against `100 ms` and `0` isolated), and shows retry damage
  (`charges without a key : 3` against `charges with an idempotency key: 1`). A real transaction
  coordinator, broker and service mesh are labelled reference
- [x] `ADV-07` `system-design.md` — 16 sections; `system_design_probe.py` derives a design from four
  assumptions (`16,000,000` requests per day, `average qps : 185`, `peak qps : 926`, `833 / 93`
  reads and writes), storage (`4.49 TB` per year, `13.5 TB` at three-year retention), bandwidth
  (`37.9 MB/s (303 Mbit/s)`, `19.7 TB` monthly egress), shard counts (`9`, `5`, `3` by node
  capacity), a latency budget (`230 ms of 300 ms`, `headroom : 70 ms`), cache value (`185/s instead
  of 926/s`, `6.6 GB`), burst cost (`240,000 messages`, `240 s` to drain) and the bill
  (`$2,163.30/month`, egress dominant). Cloud pricing consoles and capacity dashboards are labelled
  reference
- [x] `ADV-08` `performance-profiling.md` — 16 sections; `performance_profiling_probe.py` counts work
  rather than time (`11,998,000` comparisons against `5,000` lookups, `2,400x`, `same answer :
  True`), applies Amdahl (`hotspot  60% of time, 10x faster: end-to-end  2.17x (ceiling  2.50x)`),
  reads a profile table (`main` 4,000 inclusive and 20 exclusive against `insert` 1,800 and 1700 at
  `43%`), shows the tail (`mean : 64.4 ms`, `p99 : 300 ms`, `max : 900 ms`, `14.0x`), and prices
  the counts (`240.0 ms` against `0.2 ms`, `959.8x`). `cProfile` and sampling profilers are
  discussed and named; the probe counts work because a millisecond is not reproducible on the shared
  lab host
- [x] `ADV-09` `reliability-engineering.md` — 16 sections; `reliability_probe.py` converts uptime to
  availability (`MTBF   720 h, MTTR    1 h: 99.8613%,   59.9 min/month` against `MTTR    4 h:
  99.4475%,  238.7 min/month`), shows the shared-dependency ceiling (`3 replicas behind a dependency
  at 99.900%: 99.8999%` against `99.9999%` independent), spends a budget (`budget : 43.2 min`,
  `88% of budget`, `burn rate so far : 0.88x`), prices a replica loss at load (`capacity 4 x 300/s =
  1200/s, offered 960/s (80% utilised)`, `rejected share : 6.2%`), decides a canary (`8.00%` against
  `0.53%`, `z : 54.54`, `roll back`), and decomposes `44 min` of incident (`diagnose 27%`, `fix
  45%`). Paging a real rotation, a chaos platform and live SLO dashboards are labelled reference
- [x] `ADV-10` `large-codebase-maintenance.md` — 16 sections; `large_codebase_probe.py` generates
  `40` modules and `76` import edges, finds one cycle (`mod05 -> mod12 -> mod05`), computes impact
  (`change mod02: 26 modules depend on it transitively (65% of the codebase)`), shows the cycle's
  downstream cost (`modules ordered : 23 of 40`, `blocked : 17`, `of which actually in a cycle : 2`,
  `the other 15 wait on the cycle forever`) and the fix (`40 of 40 orderable`), ranks reading order
  (`billing/tax.py` 42 changes x 18 complexity = `756` against `legacy/reports.py` 3 x 41 = `123`),
  and reports ownership (`modules with no owner : 21`, `share unowned : 52%`). Churn and ownership
  are declared fixed inputs standing in for `git log` and `CODEOWNERS`; running the analysis over a
  real monorepo is left to the exercises
- [x] `ADV-11` `architecture-decision-records.md` — 16 sections; `adr_probe.py` parses six real
  Markdown records (`status counts : {'superseded': 1, 'accepted': 4, 'proposed': 1}`), follows a
  healthy chain (`ADR-001 superseded by ADR-004: replacement exists=True`), catches a dangling one
  (`ADR-006 claims to supersede ADR-009: target exists=False`, `dangling supersession claims :
  ['ADR-006']`), scores completeness (`average completeness : 89%`, `ADR-006` at `33%`), measures
  coverage against changed components (`uncovered : ['events', 'auth', 'mobile']`, `57%`) and ages
  the set (`older than 18 months : ['ADR-001', 'ADR-002', 'ADR-003', 'ADR-006']`). Generating records
  from a real repository and running the audit in CI are exercises; no GitHub API or wiki
  integration is used

## M9 — Professional, projects, reference (Phase J)

**19-PROFESSIONAL-DEVELOPMENT**
- [x] `PROF-01` `README.md` — subject index for the nine lessons, each linked with the failure it
  answers; states the executed-probe policy (one standard-library probe per lesson, its capture quoted
  beneath it, counts and declared constants instead of stopwatches) and marks absent infrastructure
  (ticket tracker, CI service, code-review platform, hiring pipeline, employer ladder document) as
  labelled reference; prerequisites point at 03, 13, 14 and 18; exercises numbered `PROF-0N` -> `N.1`
  to `N.5`; blockers and next point at `20-PROJECT-LABORATORY`
- [x] `PROF-02` `engineering-workflows.md` — 16 sections; `workflows_probe.py` prices branch age
  (`branch age  7 day(s): misses 280 changes, conflict chance  94.0%`), review batching (`900 lines
  in 1 review of 900: 240.0 min each (capped), 240 min total, 45% detection` against `900 lines in 4
  reviews of 225: 48.2 min each, 193 min total, 86% detection`), pipeline shape (`sharded wall time
  : 320.0 s` with `total stage work : 710 s` and `shard capacity used : 22%`, `expected wall time
  including reruns: 347.8 s`), gate economics (`production share of the cost     : 63% for 4% of the
  defects`) and WIP (`review WIP 12, throughput 6/day: average wait 2.00 day(s)` down to `review WIP
  3, throughput 6/day: average wait 0.50 day(s) (4.0 h)`); the four-hour review cap is labelled a
  modelling assumption, not a measurement
- [x] `PROF-03` `code-review.md` — 16 sections; `code_review_probe.py` models diff size (`100 lines:
  18.8 min           detection  90%, 7/8 defects` against `2000 lines:  240.0 min (capped)
  detection  22%, 2/8 defects`), extra reviewers (`2 reviewer(s): 80% detection for 60 min of review`
  and `3 reviewer(s): 91%` with the correlated-misses caveat), comment triage (`blocking  4
  comment(s), 15 min each:  60 min`, `comments 12, work they create 88 min`) and review latency by
  Little's law (`median wait  26.0 h:  3.25 PRs open on average, a 3-PR stack takes  78.0 h to
  land`); the 240-minute session cap is declared and explained
- [x] `PROF-04` `technical-documentation.md` — 16 sections; `documentation_probe.py` scores
  completeness (`README       4/6 sections ( 67%)` against `RUNBOOK      3/6 sections ( 50%)
  missing: ['install', 'quick start', 'license']`), symbol drift (`drift rate 60%`), runbook
  actionability (`steps 8, concrete commands 5 (62%)` with rollback present), reader completion
  (`per-step clarity 99% over 12 steps: completes unaided 89%` down to `per-step clarity 90% over 12
  steps: completes unaided 28%`) and freshness against churn (`stale pages: 3/4`); no document is
  fetched, the sections and samples are inline
- [x] `PROF-05` `open-source-contributions.md` — 16 sections; `open_source_probe.py` triages eight
  issues (`issues 8, with reproduction 5 (62%), labelled 8 (100%)`, `stale (over 60 days, no
  maintainer reply): [430, 437, 452]`), ranks a first contribution (`#412 clarity score 5` down to
  `#452 clarity score -2`), walks the funnel (`end-to-end landing rate: 0.40% of readers`), compares
  merge rate by size (`1-50 lines 140 opened,  129 merged:   92%` against `>1000       19 opened,
  5 merged:   26%`, `overall: 259/340 merged (76%)`) and reports the response distribution (`median
  first response 19.0 h, p90 240.0 h, over 48 h: 2`); no network or GitHub API call is made
- [x] `PROF-06` `debugging-methodology.md` — 16 sections; `debugging_probe.py` bisects 64 commits
  (`first bad commit 41, found in 6 probes` against `linear search from the oldest would have taken
  41 probes`), eliminates hypotheses (`survivor: database index dropped after 60 min and 4
  experiments` against `expected 3.0 fix attempts at 60 min each = 180 min`), ranks components by
  Ochiai (`payments.py score 0.87, fails it covers 3, passes it covers 1`), splits reports by
  reproducibility (`reports 6, reproducible 3 (50%)`) and proves the fix (`bug reintroduced in a
  scratch branch: 1 test(s) fail again`); the bisection is written out rather than calling `git
  bisect`
- [x] `PROF-07` `technical-interviews.md` — 16 sections; `interviews_probe.py` applies a weighted
  rubric (`Ana   weighted 4.40  decision hire` down to `Dev   weighted 2.70  decision no hire`), shows
  a rank flip (`Ben: weighted 3.80, unweighted 3.60` against `Cleo: weighted 3.70, unweighted 3.80`),
  computes Cohen's kappa (`observed agreement 75%, chance agreement 50%`, `kappa 0.50`), compares
  formats (`work sample 72%: 36 good hires, 14 failures` against `puzzle      41%: 20 good hires, 30
  failures`, `difference: 16 hires, $2,400,000 of replacement cost at $150,000 per failed hire`) and
  prices the loop (`6 candidates per hire = 60 interviewer-hours per hire`); weights, validity rates
  and costs are declared inputs
- [x] `PROF-08` `portfolio-development.md` — 16 sections; `portfolio_probe.py` audits six projects
  against verifiable evidence (`expense tracker       100/100  missing: []` against `weather CLI
  35/100`), flags tutorial tells (`flagged: 2/6`, `chat app              tutorial-shaped one active
  day, no tests`), measures depth (`expense tracker        84 commits over 41 active days (  2.0/day,
  weeks)` against `chat app                9 commits over  1 active day (  9.0/day, days)`) and
  budgets the reviewer scan (`budget 360 s, spent 360 s, left 0 s`); the weights and the six-minute
  budget are declared policy
- [x] `PROF-09` `teamwork-and-communication.md` — 16 sections; `teamwork_probe.py` scores six updates
  against five fields (`investigated the timeout                        5/5 []` against `fixed the
  login redirect                        1/5 ['next', 'blocker', 'ask', 'date']`, `fields filled 21/30
  (70%)`), costs interruptions (`8 interruptions x 23 min to regain focus = 184 min` against `two
  batches, each costing one recovery     = 46 min`, `saved 138 min (75%)`), compares decision channels
  (`async: 3 rounds x 6 h = 18 h elapsed, 2.5 person-hours` against `sync : 45 min meeting + context
  = 2.00 h elapsed, 5.0 person-hours`), prices vague asks (`3 vague asks x 1.5 days x 2 people = 9.0
  person-days blocked`, `ratio of clarification to blocked time: 1:144`) and an escalation rule (`50%
  compliance: 300 min/day lost to silent struggle across 10 developers`); recovery times are declared
  constants
- [x] `PROF-10` `career-paths.md` — 16 sections; `career_probe.py` prints a five-level ladder on five
  dimensions, scores the distance between levels (`mid       -> senior    distance 6: task scope +1,
  autonomy +2, ...` and `senior    -> staff     distance 6: ... influence +2, ...`), computes readiness
  against two targets (`senior: 3/5 requirements evidenced (60%)`, `staff: 4/7 requirements evidenced
  (57%)`), separates span (`staff engineer      direct reports  0, teams influenced 3, engineers
  reached 24` against `engineering manager direct reports  6, teams influenced 1, engineers reached
  12`), shows compensation shape (`principal is 3.10x junior for the same craft`) and counts why
  promotions stall (`no evidence of scope beyond own team                 9 (36%)`); expectation
  scores and ratios are labelled a declared model, not employer data

**20-PROJECT-LABORATORY**
- [x] `PROJ-01` `README.md` overview, grading rubric, how solutions are separated —
  seven graded projects plus a capstone, a seven-dimension rubric whose weights shift
  (`Requirements 20 -> 15`, `Tests 15 -> 20`, `Security 10 -> 15`), a zero-score cap
  in correctness or security, completion at 70 and portfolio-ready at 85, and the
  five-step solutions cycle; the eight brief links resolve
- [x] `PROJ-02` Project 01 command-line application — expense-ledger brief, 18 numbered
  sections, `FR-1..10`, exit codes `0 ok / 1 usage / 2 data / 3 not found / 4 write`,
  `AC-1..12`; measured `h2=19 ac=12 fr=10`, the solutions policy as the extra H2
- [x] `PROJ-03` Project 02 responsive portfolio — 18 sections, `FR-1..10`, four-width
  matrix (360/768/1024/1440), axe and keyboard criteria, `AC-1..12`; measured
  `h2=19 ac=12 fr=10`; the prerequisite row links the JavaScript lesson in `08`
- [x] `PROJ-04` Project 03 database application — tool-library schema with a partial
  unique index on active loans (`WHERE returned_at IS NULL`), concurrency and restore
  criteria, `FR-1..11`, `AC-1..12`; measured `h2=19 ac=12 fr=11`
- [x] `PROJ-05` Project 04 REST API — workshop job tracker on Spring Boot + PostgreSQL,
  seven-state machine, `ETag`/`If-Match` with 412 and 428, idempotency keys,
  `FR-1..14`, `AC-1..12`; measured `h2=19 ac=12 fr=14`
- [x] `PROJ-06` Project 05 full-stack application — community kitchen rota, `HttpOnly`
  cookie sessions with double-submit CSRF, optimistic claim with snapshot rollback,
  server-side authorisation, `FR-1..12`, `AC-1..12`; measured `h2=19 ac=12 fr=12`
- [x] `PROJ-07` Project 06 Flutter mobile app — offline-first field survey, client
  uuids as idempotency keys, sync queue with backoff, crash recovery
  (`syncing -> pending`), conflict table, `FR-1..12`, `AC-1..12`; measured
  `h2=19 ac=12 fr=12`
- [x] `PROJ-08` Project 07 secure production application — STRIDE model with control
  references, pipeline gates, readiness-gated rollback under 5 min, SLO burn-rate
  alerts, restore drill, `FR-1..14`, `AC-1..12`; measured `h2=19 ac=12 fr=14`
- [x] `PROJ-09` `capstone-project/` — six gates `G0..G5`, fixed core `FR-1..8` plus
  6-12 chosen requirements, `NFR-1..8`, `AC-1..12`, a 15-minute walkthrough script;
  measured `h2=19 ac=12`
- [x] `PROJ-10` `reference-solution/` per project — eight guides (seven projects plus
  the capstone assessment guide), each opening with a stop-and-attempt warning header;
  measured `projects 8 with_solution 8` and `sol_lines 95..202`

**21-REFERENCE-LIBRARY**
- [x] `REF-01` `README.md` — 11 sections: what the subject covers, page-writing rules
  (four rules: one page one question, answer before context, vendored against
  `VERSIONS.md`, executed where executable), a 12-row register table, why it
  matters, prerequisites, page list, keeping-it-current habits, exercises,
  outcomes, five common blockers; `check-curriculum` accepts the subject README
  (Prerequisites/Lessons/Next present) and `check-links` resolves every link
- [x] `REF-02` `glossary.md` — 327 entries in 18 tables grouped by subject
  (foundations, programming, Java, DSA, web, HTML/CSS, JS/TS, frontend, databases,
  backend, mobile, architecture, testing, security, DevOps, cloud, advanced,
  professional); each row is term, a one-or-two-sentence definition and a link to
  the lesson that teaches it; measured `rows 327 missing 0` and 0 duplicate terms
  after disambiguating the SQL and domain meanings of "aggregate"
- [x] `REF-03` `common-errors.md` — 115 entries in 14 groups (shell, Git, Java,
  Maven, JavaScript/npm, TypeScript, Python, PostgreSQL, HTTP/browser, Docker,
  Flutter/Gradle, test failures); every row is message, cause, diagnose command,
  fix, plus a reading rule (first line mentioning your code) and a six-step
  method for messages not listed
- [x] `REF-04` `command-reference.md` — 92 rows: navigation, files, reading,
  searching and text tools, pipes and exit codes, permissions, processes,
  networking, environment, package and build tools, and three executed
  compile/run blocks (javac, node, curl health probe); no entry without the flag
  that matters most
- [x] `REF-05` `git-reference.md` — 59 rows organised by goal rather than flag:
  inspect, undo locally, branch, synchronise, combine and move, find the breaking
  commit (with a `git bisect` walkthrough), stash, conflict markers, tags and
  one-time configuration; every history-rewriting or destructive entry states the
  consequence, and pushed commits are directed to `git revert`
- [x] `REF-06` `sql-reference.md` — 16 sections and a PostgreSQL 18 schema/queries
  set **executed** on a throwaway `initdb --auth=trust` cluster (port 55432):
  `psql -v ON_ERROR_STOP=1 -f verify.sql` exit 0 across joins, `filter` aggregates,
  windows, CTEs, `distinct on`, `LATERAL`, upsert with `returning`, dates,
  `generate_series`, JSONB, transactions and `explain`; captures quoted, e.g.
  `Grace | 2 | 225.25`, `{"orders": 5, "revenue": 467.75}` and the bitmap-index
  query plan
- [x] `REF-07` `http-status-codes.md` — 48 codes from `100` to `511` grouped by
  class, with use-for and do-not-use-for columns, method semantics (safe,
  idempotent, expected success codes), the RFC 9110 §15 cacheability table,
  required headers per code (Location, Allow, WWW-Authenticate, Retry-After,
  ETag), decision tables for 401/403, 400/422, 404/410, 500/503 and eight common
  mistakes
- [x] `REF-08` `java-reference.md` — 14 sections; every snippet compiled with
  `javac --release 21` (exit 0) and run: `area(circle r=1)=3.14`, `max=9`,
  `money=375`, `byLength={5=[delta, alpha, bravo], 7=[charlie]}`, `virtual=true`,
  `fileLines=2`; covers records, sealed types, exhaustive pattern switch,
  collections, streams, `Optional`, generics/PECS, exceptions, `Files`, the time
  API and virtual threads
- [x] `REF-09` `javascript-reference.md` — 15 sections; JS snippets run on Node
  24.13.1 (`sorted: [ 'alpha', 'bravo', 'charlie', 'delta' ]`,
  `total: 22`, `clone keeps types: true true`, `json round-trip: string {}`,
  `order after tick: sync,microtask,timeout`) and TS snippets compiled with
  `tsc 5.9.3 --strict` (exit 0, `unwrap: 42`,
  `describe: string(3) array(2) null number`); covers coercion, arrays with
  mutate/copy columns, `Map`/`Set`, modules, promise combinators, error
  narrowing, discriminated unions, generics, `satisfies` and utility types
- [x] `REF-10` `linux-reference.md` — 14 sections: filesystem layout, octal
  permissions and special bits, users and groups, processes and signals, a
  complete systemd unit, timers/cron, networking, apt, disks, logs, SSH, shell
  startup files and four Windows/WSL pitfalls; systemd and package commands are
  labelled **not executed** because the authoring host is Windows, shell/file/text
  behaviour is consistent with `command-reference.md`
- [x] `REF-11` `docker-reference.md` — 13 sections: image/container/layer model,
  commands by task, `docker run` flags, Dockerfile instructions, layer-ordering
  rule, three multi-stage builds (Spring Boot, Node, Go distroless), health
  checks with `start-period`, volumes, networking, a Compose example with
  `service_healthy`, crash triage and `.dockerignore`; marked **not executed**
  because `docker info` failed (`failed to connect to the docker API at
  npipe:////./pipe/dockerDesktopLinuxEngine` — daemon not running)
- [x] `REF-12` `official-resources.md` — 44 official links in 8 groups (languages,
  frameworks, data, web/HTTP/accessibility, security, DevOps/cloud, testing,
  practice), each with what it is best for and a version note; every URL checked
  with `curl -L` and returned `200` (44/44), plus a six-point guide to reading
  documentation efficiently

## M10 — Final validation (Phase K)

- [x] `QA-01` All links resolve — `python scripts/check-links.py --strict` exit 0:
  "527 Markdown files checked, 0 broken reference(s), 0 planned-but-unwritten target(s)". The 20
  targets the progressive mode had tolerated were **real dangling links** and are fixed: 18
  `[exercise set](exercises/README.md)` links in subjects 16 and 19 (neither has a separate
  `exercises/` directory) now point at each README's `#exercises-and-practice` section;
  `09-…/exercises/solutions/set-4-solutions.md` needed `../../state-management.md` rather than
  `../`; and `13-…/exercises/README.md` needed `../../20-PROJECT-LABORATORY/…`
- [x] `QA-02` All required sections present — `python scripts/check-curriculum.py --strict` exit 0:
  "root files 15, subjects present 22/22, subject files checked 301, images checked 15, 0
  structural problem(s)". Fixed the checker's own reporting bug on the way: it counted **files
  scanned** and printed that as "images checked" (532) — it now counts image references (15)
- [x] `QA-03` Prerequisite ordering reviewed per directory README — all **22/22** subject READMEs
  carry a `## Prerequisites` section; **0** reference a subject with an equal or higher number;
  every prerequisite link resolves under the strict link check, so each chain names only material
  that precedes it. `ROADMAP.md` milestone placement agrees (see `QA-07`)
- [x] `QA-04` Code examples compiled/run where a toolchain exists; others labelled — re-ran the
  shipped lab at final state: `postgresql/verify.sh` on a fresh PostgreSQL 18.6 cluster →
  `7 passed, 0 failed`. Inventoried all **2,371** fenced blocks (console 562, unlabeled 348,
  text 320, Mermaid 267, Java 234, Python 149, SQL 104, Dart 89, Bash 66, TSX 63, JS/TS 66,
  YAML/CSS/HTML and other formats the rest). **229** explicit "not executed / not run / labelled /
  illustration" labels across 29 directories disclose what could not run here: Docker (daemon
  down — `docker info` fails at `npipe:////./pipe/dockerDesktopLinuxEngine`), Gradle (absent) and
  real Linux/systemd/apt (Windows host)
- [x] `QA-05` No credentials, tokens, or private keys anywhere in the repository — scanned every
  tracked file for private-key blocks, GitHub/AWS/OpenAI/Slack token shapes, assigned secrets,
  JDBC passwords and bcrypt hashes: **0 real credentials**. The 3 `-----BEGIN … PRIVATE KEY-----`
  hits are detection-lab fixtures, the 4 AWS hits are AWS's published `AKIAIOSFODNN7EXAMPLE`, and
  the remaining hits are labelled `EXAMPLE` / `demo` / `lab-only` values. `git ls-files` matches
  no `.env`, `.pem`, `.key`, `id_rsa` or `.netrc`; `.gitignore` blocks them (its missing final
  newline was also fixed)
- [x] `QA-06` Diagrams reviewed for technical accuracy and correct relative paths — all **267**
  Mermaid diagrams were extracted, parsed **and rendered to SVG** in Chromium with Mermaid 11:
  **267/267 ok, 0 failures**. Two could not parse and were fixed: an unquoted edge label
  containing parentheses in `11-BACKEND-ENGINEERING/caching.md` (`|remove(key)|` →
  `|"remove(key)"|`) and quotes inside a flowchart label in
  `12-MOBILE-DEVELOPMENT/camera-and-qr-codes.md` (`T[Tap "scan"]` → `T["Tap scan"]`). Image
  references: 15, **0** missing targets, **0** empty alt text (2 apparent misses are inline-code
  examples of the naming convention, not links). Visual taste and colour contrast were not judged
- [x] `QA-07` Roadmap matches prerequisite structure — `ROADMAP.md` lists **11** milestones
  covering subjects 00–21 **exactly once** in ascending order, and **0** prerequisites appear in a
  later milestone than the subject that depends on them
- [x] `QA-08` `CHANGELOG.md` updated; `COMPLETION-REPORT.md` written with every gap disclosed —
  the changelog gained entries for subjects 12–21, the final validation pass, and a `Fixed`
  section (two diagrams, the validator counter, 20 dangling links, `.gitignore`); the new
  `COMPLETION-REPORT.md` records 531 files / 139,546 lines / 1,121,467 words, the executed-vs-
  labelled toolchain table, **15 disclosed gaps** (no human editorial review, no CI, Docker/Gradle/
  real-Linux unverified, TypeScript unpinned, 9 SVG assets, and the rest) and the commands that
  reproduce every claim; it is linked from `README.md`
- [x] `QA-09` Register imported to GitHub or explicitly reported as not done — **explicitly
  reported as not done**: `gh auth status` → "You are not logged into any GitHub hosts." No issue,
  milestone or board exists; `ISSUE-REGISTER.md` is the board and is import-ready
  (see `COMPLETION-REPORT.md` §4 and `ROOT-15`, the one open entry)

---

## Unfinished work summary (auto-maintained view)

This section is updated at the end of every batch so the next session can resume without guessing.

- **Final state (2026-11-08):** all 22 subjects are written and the curriculum is complete.
  **366 of 367** register entries are done; the one open entry is `ROOT-15` (import this register
  into GitHub), blocked because `gh` is unauthenticated. Final validation, strict:
  `check-links.py --strict` → 527 files, **0 broken, 0 planned**; `check-curriculum.py --strict` →
  22/22 subjects, 301 subject files, 15 image references, **0 structural problems**; 267/267 Mermaid
  diagrams parsed *and rendered* in Chromium; the shipped PostgreSQL lab re-ran `7 passed, 0 failed`
  on a fresh 18.6 cluster; 0 real credentials in 531 files. `COMPLETION-REPORT.md` records the
  inventory, the executed-vs-labelled toolchain table and 15 disclosed gaps; `CHANGELOG.md` covers
  subjects 12–21 plus the fixes. Nothing is queued: the only remaining action needs a GitHub login.
- **Build history below is historical.** Each of the following bullets is the snapshot written at the
  end of one batch, including the toolchain seams found while writing it; their file/validation
  counts are that batch's, not the repository's final numbers. Kept because the seams (Docker and
  Gradle absent, `pg_ctl` pipe hang, jsdom 26 pin, tsc bare-CLI `noImplicitAny`, headless minimum
  width) are the reasons specific lessons are labelled instead of executed.
- **Batch 12 complete:** `10-DATABASE-ENGINEERING` — `DB-01`…`DB-21` all written and
  checked: 17 lessons + `README.md`, the shipped `postgresql/` lab (schema/seed/queries/
  expected/`verify.sh`), a consistent `shop` sample schema, and `exercises/` — 12 sets with
  13 separated solution files. Root `LABS.md` now maps every lab environment (PostgreSQL,
  Java, browser, JS/TS, React, validation tooling) to the lessons it served; subject-10's
  README lesson list and coverage bullets extended to all 17 lessons. Pushed at `f7245ed`.
- **Batch 13 started:** `11-BACKEND-ENGINEERING` — `BACK-01` verified; `BACK-02` and
  `BACK-03` written with executed probes (lab: `%TEMP%/b13/`, `Probe.java` v2, port 8788,
  transcripts `transcript.txt` A1–A7, `transcript2.txt` B1–B13, `transcript3.txt` C1–C12 —
  all batteries logged, no warnings; Maven/Spring Boot smoke verdict recorded above).
  Next: `BACK-05` `java-backend-development.md`, then `BACK-06` `spring-fundamentals.md`…
  **Lab smoke — executed 2026-10-27 (verdict: Spring Boot transcripts ARE possible):**
  `%TEMP%/b13/spring-smoke` (Spring Boot **4.1.1** parent, `starter-web`, `java.version=21`)
  — `mvn -B -DskipTests package` → **BUILD SUCCESS, 12.420 s, zero downloads** (the local
  repo was already populated with 4.1.1 artifacts); `java -jar target/…jar` → `Tomcat
  started on port 8790`, `Started SmokeApplication in 5.886 seconds`, and `GET /hello` →
  `200` with `{"message":"spring boot is alive"}` (19,904,500 B jar); `mvn -B test` →
  `@SpringBootTest` context load `Tests run: 1, Failures: 0, Errors: 0` (8.209 s) — the
  test path BACK-21 depends on works too. Maven Central reachable (`200` in 0.98 s), so
  not-yet-cached deps (JPA, Flyway, Testcontainers jars) can resolve; captured seam: a
  method-level `@SpringBootTest` fails compilation with `annotation interface not
  applicable to this kind of declaration` — class-level only. Still true: no Docker
  (BACK-21 Testcontainers needs labelled illustrations or a local alternative), Gradle
  absent. **Lab (working):**
  the machine's system-wide PostgreSQL 18 service requires a scram password nobody had, so
  batch 12 runs its own scratch cluster — `initdb -D %TEMP%/b12/pgdata -U lab -A trust`,
  `pg_ctl start -o "-p 5433 -c listen_addresses=127.0.0.1"` (localhost only, system
  service untouched), database `codepath_lab`, probes as `psql -f dbNN-probes.sql` with
  transcripts kept beside them in `%TEMP%/b12/`. Two seams recorded for later lessons:
  `pg_ctl start` **hangs a terminal tool call** if its pipes are inherited (postgres keeps
  them open; the tool times out and kills the tree — the 0xC0000142 autovacuum crash), so
  start it detached (`nohup … </dev/null >/dev/null 2>&1 &`); and Python's `jsdom` in the
  mermaid-validation harness is pinned to **jsdom@26** (29.1.1 is missing
  `xhr-sync-worker.js` and crashes on import).
- **Known risks:** Docker and Gradle are absent from the writing machine, so those lessons rely on
  official docs and labelled illustrations rather than executed transcripts (04's `build-tools.md`
  shows the `gradle: command not found` probe as honest absence). `gh` is installed but
  unauthenticated (401), so 03's GitHub web-UI and Actions blocks are labelled illustrations and
  GitHub issues stay in this register (QA-09 pending). Real-Linux commands in 03 are labelled
  where Git Bash could not execute them honestly — the ineffective `chmod` is shown as the seam,
  not hidden. `dig` and `nc` are absent from the writing machine, so 06 used `nslookup`
  throughout and a Python raw-socket client in place of netcat; Windows-only tools (`tracert`,
  `ipconfig`) are labelled with their Linux counterparts named; the headless screenshot refused
  writes to the Temp directory (`Access is denied`) and was captured to a workspace path instead.
  07 executed in Chrome 156 headless only — cross-engine (Gecko/WebKit) behavior claims stay
  labelled illustrations, and headless enforces a ~504px minimum window content width (requests
  below clamp silently), so true-360px acceptance criteria name devtools device emulation;
  axe-core was fetched once and served locally (`axe.min.js` beside the pages), so lessons claim
  only the 4.10.2 rules that ran. Batch 10 executed TypeScript against tsc 7.0.2 (the native
  port) installed in a temporary lab directory, and found two toolchain seams now recorded in
  the lessons: a *bare* CLI run with no tsconfig enforces `noImplicitAny` on this tsc, so loose-
  mode comparisons must use a tsconfig with `"strict": false`; and two prose claims written from
  commented-out expectations (`typeof` being TDZ-exempt; `first<number>(["a"])` reporting
  `TS2345`) were corrected against re-executed runs (`ReferenceError`; `TS2322` for fresh
  literals, `TS2345` for variable arguments). Later batches should treat a *commented* expected
  diagnostic as unexecuted until a run says otherwise.
- **Validation state (batch 11):** `check-curriculum.py` exit 0 (22/22 subjects, 142 subject
  files, 279 image refs); `check-links.py` exit 0 (275 files, **0 broken**, 37 planned targets;
  09 scope: 2 broken refs found and fixed in this batch — `build-and-deployment.md` linked
  `../../20-PROJECT-LABORATORY/README.md` and `../../10-DATABASE-ENGINEERING/README.md` from a
  subject root, one `..` too many, both retargeted to `../…`); 16/16 Mermaid blocks in 09 parse
  VALID via the JSDOM harness (2 fixed in this batch: `component-composition.md` had `\"0\"`
  escaped quotes inside a quoted node label and `performance.md` had a stray quote splitting a
  label — `bug<br/">few hundred` — mermaid wants plain text or `&quot;` there); fence parity
  clean across all 09 files (16 lessons + README + projects/README + exercises/README + 12
  solution files + solutions/README). The mtest harness's jsdom was repaired mid-batch (an
  unlocked `npm install` pulled jsdom 29.1.1, whose package is missing `xhr-sync-worker.js` and
  crashes on import; pinned back to jsdom@26). Prior batches' state: 08 scope — 12 lessons,
  12 Mermaid VALID, fence parity clean across 26 files.  `--strict` turns planned targets into failures in Phase K.
- **Validation state (batch 12):** `check-curriculum.py` exit 0 (22/22 subjects, 159 subject
  files, 312 image refs, 0 structural problems); `check-links.py` exit 0 (308 files, **0
  broken**, 36 planned targets); fence parity clean across all new files (LABS.md,
  postgresql/README, exercises README + solutions README + 12 set files, the four new
  lessons); the one new Mermaid block (`set-7-solutions.md` erDiagram) parses VALID via the
  JSDOM/mermaid harness (its `node_modules` had lost `symbol-tree` to a temp cleanup —
  repaired with `npm install`, jsdom still pinned at 26); and the lab's own gate
  `bash verify.sh` → **7 passed, 0 failed** (first run failed 7/7 purely on Windows psql's
  CRLF vs the LF `expected/` files — fixed by stripping `\r` in-script, not by re-capturing).