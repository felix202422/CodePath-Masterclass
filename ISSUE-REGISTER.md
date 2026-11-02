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
- [ ] `ROOT-04` Confirm author identity and sole-contributor policy in git config — **Done locally**, re-verify after first push
- [ ] `ROOT-15` Import this register into GitHub issues/milestones/board when `gh auth login` succeeds

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
- [ ] `SEC-09` `csrf.md`
- [ ] `SEC-10` `ssrf.md`
- [ ] `SEC-11` `secure-api-design.md`
- [ ] `SEC-12` `secrets-management.md`
- [ ] `SEC-13` `dependency-security.md`
- [ ] `SEC-14` `tls-and-certificates.md`
- [ ] `SEC-15` `secure-file-uploads.md`
- [ ] `SEC-16` `security-testing-labs/` local, authorized-only labs

## M8 — Operations and production (Phase I)

**16-DEVOPS-AND-INFRASTRUCTURE** (prereq: 03, 11)
- [ ] `OPS-01` `README.md`
- [ ] `OPS-02` `devops-fundamentals.md`
- [ ] `OPS-03` `linux-administration.md`
- [ ] `OPS-04` `networking-for-devops.md`
- [ ] `OPS-05` `shell-scripting.md`
- [ ] `OPS-06` `docker-fundamentals.md`
- [ ] `OPS-07` `docker-images-and-containers.md`
- [ ] `OPS-08` `container-networking.md`
- [ ] `OPS-09` `volumes-and-persistence.md`
- [ ] `OPS-10` `docker-compose.md`
- [ ] `OPS-11` `nginx-and-reverse-proxies.md`
- [ ] `OPS-12` `dns-and-tls-operations.md`
- [ ] `OPS-13` `infrastructure-as-code.md`
- [ ] `OPS-14` `terraform.md`
- [ ] `OPS-15` `ansible.md`
- [ ] `OPS-16` `ci-cd-fundamentals.md`
- [ ] `OPS-17` `github-actions.md`
- [ ] `OPS-18` `deployment-strategies.md`
- [ ] `OPS-19` `monitoring-and-logging.md`
- [ ] `OPS-20` `backups-and-recovery.md`
- [ ] `OPS-21` `troubleshooting/` playbooks

**17-CLOUD-AND-PRODUCTION** (prereq: 16)
- [ ] `CLD-01` `README.md`
- [ ] `CLD-02` `cloud-computing-fundamentals.md`
- [ ] `CLD-03` `virtual-machines.md`
- [ ] `CLD-04` `cloud-networking.md`
- [ ] `CLD-05` `object-storage.md`
- [ ] `CLD-06` `managed-databases.md`
- [ ] `CLD-07` `identity-and-access-management.md`
- [ ] `CLD-08` `secrets-and-configuration.md`
- [ ] `CLD-09` `load-balancing.md`
- [ ] `CLD-10` `scaling.md`
- [ ] `CLD-11` `observability.md`
- [ ] `CLD-12` `incident-management.md`
- [ ] `CLD-13` `cloud-cost-management.md`

**18-ADVANCED-ENGINEERING** (prereq: 13, 16, 17)
- [ ] `ADV-01` `README.md`
- [ ] `ADV-02` `concurrency-and-parallelism.md`
- [ ] `ADV-03` `message-queues.md`
- [ ] `ADV-04` `event-streaming.md`
- [ ] `ADV-05` `database-scaling.md`
- [ ] `ADV-06` `distributed-systems-patterns.md`
- [ ] `ADV-07` `system-design.md`
- [ ] `ADV-08` `performance-profiling.md`
- [ ] `ADV-09` `reliability-engineering.md`
- [ ] `ADV-10` `large-codebase-maintenance.md`
- [ ] `ADV-11` `architecture-decision-records.md`

## M9 — Professional, projects, reference (Phase J)

**19-PROFESSIONAL-DEVELOPMENT**
- [ ] `PROF-01` `README.md`
- [ ] `PROF-02` `engineering-workflows.md`
- [ ] `PROF-03` `code-review.md`
- [ ] `PROF-04` `technical-documentation.md`
- [ ] `PROF-05` `open-source-contributions.md`
- [ ] `PROF-06` `debugging-methodology.md`
- [ ] `PROF-07` `technical-interviews.md`
- [ ] `PROF-08` `portfolio-development.md`
- [ ] `PROF-09` `teamwork-and-communication.md`
- [ ] `PROF-10` `career-paths.md`

**20-PROJECT-LABORATORY**
- [ ] `PROJ-01` `README.md` overview, grading rubric, how solutions are separated
- [ ] `PROJ-02` Project 01 command-line application (spec, milestones, tasks, criteria, hints)
- [ ] `PROJ-03` Project 02 responsive portfolio
- [ ] `PROJ-04` Project 03 database application
- [ ] `PROJ-05` Project 04 REST API
- [ ] `PROJ-06` Project 05 full-stack application
- [ ] `PROJ-07` Project 06 Flutter mobile app
- [ ] `PROJ-08` Project 07 secure production application
- [ ] `PROJ-09` `capstone-project/`
- [ ] `PROJ-10` `reference-solution/` per project, written only after the spec exists

**21-REFERENCE-LIBRARY**
- [ ] `REF-01` `README.md`
- [ ] `REF-02` `glossary.md`
- [ ] `REF-03` `common-errors.md`
- [ ] `REF-04` `command-reference.md`
- [ ] `REF-05` `git-reference.md`
- [ ] `REF-06` `sql-reference.md`
- [ ] `REF-07` `http-status-codes.md`
- [ ] `REF-08` `java-reference.md`
- [ ] `REF-09` `javascript-reference.md`
- [ ] `REF-10` `linux-reference.md`
- [ ] `REF-11` `docker-reference.md`
- [ ] `REF-12` `official-resources.md`

## M10 — Final validation (Phase K)

- [ ] `QA-01` All links resolve (`scripts/check-links.py` clean)
- [ ] `QA-02` All required sections present (`scripts/check-curriculum.py` clean)
- [ ] `QA-03` Prerequisite ordering manually reviewed per directory README
- [ ] `QA-04` Code examples compiled/run where a toolchain exists; others labelled
- [ ] `QA-05` No credentials, tokens, or private keys anywhere in the repository
- [ ] `QA-06` Diagrams reviewed for technical accuracy and correct relative paths
- [ ] `QA-07` Roadmap matches prerequisite structure (no advanced topic before its prerequisite)
- [ ] `QA-08` `CHANGELOG.md` updated; `COMPLETION-REPORT.md` written with every gap disclosed
- [ ] `QA-09` Register imported to GitHub or explicitly reported as not done

---

## Unfinished work summary (auto-maintained view)

This section is updated at the end of every batch so the next session can resume without guessing.

- **Last updated:** 2026-10-27 (M0, M1, 00-START-HERE, 01-COMPUTER-FOUNDATIONS,
  02-PROGRAMMING-FUNDAMENTALS, 03-DEVELOPER-TOOLS, 04-JAVA-PROGRAMMING,
  05-DATA-STRUCTURES-AND-ALGORITHMS, 06-INTERNET-AND-WEB-FOUNDATIONS,
  07-HTML-AND-CSS, 08-JAVASCRIPT-AND-TYPESCRIPT, 09-FRONTEND-ENGINEERING, and
  10-DATABASE-ENGINEERING complete — TOOL-01…12, JAVA-01…23, DSA-01…19, WEB-01…11,
  HTML-01…12, JS-01…14, FE-01…19, and DB-01…21 all done; milestone M4's subject track is
  finished and pushed at `79e4da1`; batch 12 (subject 10) closes Milestone 6's database
  half — 11-BACKEND-ENGINEERING is the next batch)
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