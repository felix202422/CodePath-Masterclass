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
- [ ] `BACK-12` `authentication.md`
- [ ] `BACK-13` `authorization.md`
- [ ] `BACK-14` `sessions-and-tokens.md`
- [ ] `BACK-15` `oauth2-and-openid-connect.md`
- [ ] `BACK-16` `file-uploads.md`
- [ ] `BACK-17` `caching.md`
- [ ] `BACK-18` `background-jobs.md`
- [ ] `BACK-19` `api-documentation.md`
- [ ] `BACK-20` `logging.md`
- [ ] `BACK-21` `backend-testing.md`
- [ ] `BACK-22` `projects/` brief for Projects 04 and 05

## M6 — Mobile (Phase G)

**12-MOBILE-DEVELOPMENT** (prereq: 02, 11 for API integration)
- [ ] `MOB-01` `README.md`
- [ ] `MOB-02` `mobile-development-fundamentals.md`
- [ ] `MOB-03` `dart-fundamentals.md`
- [ ] `MOB-04` `null-safety.md`
- [ ] `MOB-05` `asynchronous-dart.md`
- [ ] `MOB-06` `flutter-fundamentals.md`
- [ ] `MOB-07` `widgets-and-layouts.md`
- [ ] `MOB-08` `navigation.md`
- [ ] `MOB-09` `state-management.md`
- [ ] `MOB-10` `forms-and-validation.md`
- [ ] `MOB-11` `api-integration.md`
- [ ] `MOB-12` `local-storage.md`
- [ ] `MOB-13` `secure-storage.md`
- [ ] `MOB-14` `camera-and-qr-codes.md`
- [ ] `MOB-15` `permissions-and-notifications.md`
- [ ] `MOB-16` `offline-functionality.md`
- [ ] `MOB-17` `mobile-testing.md`
- [ ] `MOB-18` `android-release.md`
- [ ] `MOB-19` `ios-release.md`
- [ ] `MOB-20` `projects/` brief for Project 06

## M7 — Engineering practices (Phase H)

**13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE** (prereq: 04, 11)
- [ ] `ARCH-01` `README.md`
- [ ] `ARCH-02` `the-complete-development-process.md` — 26-stage idea-to-maintenance guide with worked example
- [ ] `ARCH-03` `software-development-life-cycle.md`
- [ ] `ARCH-04` `requirements-engineering.md`
- [ ] `ARCH-05` `functional-and-nonfunctional-requirements.md`
- [ ] `ARCH-06` `use-cases-and-uml.md`
- [ ] `ARCH-07` `clean-code.md`
- [ ] `ARCH-08` `solid-principles.md`
- [ ] `ARCH-09` `separation-of-concerns.md`
- [ ] `ARCH-10` `design-patterns.md`
- [ ] `ARCH-11` `layered-architecture.md`
- [ ] `ARCH-12` `modular-monoliths.md`
- [ ] `ARCH-13` `clean-architecture.md`
- [ ] `ARCH-14` `domain-driven-design.md`
- [ ] `ARCH-15` `event-driven-architecture.md`
- [ ] `ARCH-16` `distributed-systems.md`
- [ ] `ARCH-17` `microservices.md`
- [ ] `ARCH-18` `scalability-and-reliability.md`
- [ ] `ARCH-19` `technical-debt.md`

**14-TESTING-AND-QUALITY** (prereq: 04, 09, 11)
- [ ] `TEST-01` `README.md`
- [ ] `TEST-02` `testing-fundamentals.md`
- [ ] `TEST-03` `unit-testing.md`
- [ ] `TEST-04` `integration-testing.md`
- [ ] `TEST-05` `end-to-end-testing.md`
- [ ] `TEST-06` `mocking-and-test-doubles.md`
- [ ] `TEST-07` `test-driven-development.md`
- [ ] `TEST-08` `api-testing.md`
- [ ] `TEST-09` `performance-testing.md`
- [ ] `TEST-10` `security-testing.md`
- [ ] `TEST-11` `test-coverage.md`
- [ ] `TEST-12` `quality-gates.md`

**15-APPLICATION-SECURITY** (prereq: 06, 11, 14)
- [ ] `SEC-01` `README.md`
- [ ] `SEC-02` `security-fundamentals.md`
- [ ] `SEC-03` `threat-modeling.md`
- [ ] `SEC-04` `password-security.md`
- [ ] `SEC-05` `session-security.md`
- [ ] `SEC-06` `access-control.md`
- [ ] `SEC-07` `injection-vulnerabilities.md`
- [ ] `SEC-08` `cross-site-scripting.md`
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