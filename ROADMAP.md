# ROADMAP

The full curriculum in recommended order, grouped into **milestones**.

This roadmap is organized by **competence gates, not day counts**: you move to the next milestone
when you can demonstrate the previous one, not when a calendar says so. Any "weeks" figure below is
an honest planning aid for a learner studying ~10 hours/week — it is an estimate, never a promise.

Proficiency levels referenced below are defined in [PROGRESS-TRACKER.md](PROGRESS-TRACKER.md).
Every milestone lists the seven required elements: **required knowledge → required exercises →
required projects → demonstrable competencies → common blockers → promotion criteria → revision
activities**.

---

## Milestone 0 — Orientation

**Subjects:** [00-START-HERE](00-START-HERE/README.md)

- **Required knowledge:** what a program is, how this repository is organized, how to study from it,
  how prerequisites chain.
- **Required exercises:** build a weekly study plan; read the prerequisite map and locate yourself.
- **Required projects:** none.
- **Demonstrable competencies:** you can explain to someone else how the repository works and
  which milestone you are on and why.
- **Common blockers:** trying to read everything before doing anything; skipping orientation to
  "save time" and then bouncing off the first exercise.
- **Promotion criteria:** you have written your first entry in
  [PROGRESS-TRACKER.md](PROGRESS-TRACKER.md) and scheduled your study sessions.
- **Revision activities:** re-read [learning-method.md](00-START-HERE/learning-method.md) whenever
  you stall for more than a week.

## Milestone 1 — Foundations: how computers and programs work

**Subjects:** [01-COMPUTER-FOUNDATIONS](01-COMPUTER-FOUNDATIONS/README.md),
[02-PROGRAMMING-FUNDAMENTALS](02-PROGRAMMING-FUNDAMENTALS/README.md)

- **Required knowledge:** hardware and the OS; files and processes; binary and number bases; Boolean
  logic; memory; how a program executes. Then: computational thinking, pseudocode, variables, data
  types, operators, I/O, conditionals, loops, functions, arrays/strings, modularization, debugging.
- **Required exercises:** all exercise sets in 01 and 02, including the independent task in each.
- **Required projects:** preparation for [Project 01](20-PROJECT-LABORATORY/project-01-command-line-application/README.md).
- **Demonstrable competencies:** take a plain-language problem and produce pseudocode, then a
  running program with functions, loops, and conditionals; diagnose an off-by-one error and an
  infinite loop by reading a traceback or output.
- **Common blockers:** copying examples without predicting the output first; avoiding the debugger;
  treating errors as failure instead of information.
- **Promotion criteria:** you can write a 50–100 line program from a written spec without looking
  up how loops or functions work, and you can explain each line.
- **Revision activities:** redo one exercise per week from memory; re-attempt the independent task
  two weeks later, unaided.

## Milestone 2 — Developer workstation and version control

**Subjects:** [03-DEVELOPER-TOOLS](03-DEVELOPER-TOOLS/README.md)

- **Required knowledge:** the terminal (Windows and Linux), filesystem navigation and permissions,
  editors/IDEs, package managers, environment variables; Git fundamentals; branching and merging;
  GitHub workflows; pull requests and review.
- **Required exercises:** perform every command in the terminal lessons on your own machine; make
  at least 20 commits across at least 5 branches, including one merge conflict you resolve by hand.
- **Required projects:** start [Project 01](20-PROJECT-LABORATORY/project-01-command-line-application/README.md) in a Git repository from day one.
- **Demonstrable competencies:** recover a botched commit with `git restore`/`git revert`; explain
  `HEAD`, index, and working tree; open a pull request with a clear description and respond to review.
- **Common blockers:** committing only to `main`; fear of the command line; confusing "undo" with
  history rewriting on a shared branch.
- **Promotion criteria:** your Project 01 repository has a meaningful history (logical commits, at
  least one feature branch merged), and you can narrate every commit's purpose.
- **Revision activities:** re-run the branching exercise using only the Git documentation's reflog
  section as your guide.

## Milestone 3 — Java and object-oriented programming

**Subjects:** [04-JAVA-PROGRAMMING](04-JAVA-PROGRAMMING/README.md)

- **Required knowledge:** program structure and types; operators and control flow; methods; arrays
  and strings; classes and objects; encapsulation; inheritance; polymorphism; abstraction;
  interfaces and abstract classes; exceptions; collections; generics; file handling; lambdas and
  streams; functional style; concurrency basics; the JVM and memory; Maven build tooling.
- **Required exercises:** all 04 exercise sets; every example compiled with `javac --release 21`
  and run.
- **Required projects:** extend Project 01 into an object-oriented version, or begin
  [Project 04](20-PROJECT-LABORATORY/project-04-rest-api/README.md) scaffolding.
- **Demonstrable competencies:** design three collaborating classes with clear responsibilities;
  choose between an interface and an abstract class *and justify it*; handle an exception at the
  right layer; use streams instead of hand-written loops where it improves clarity.
- **Common blockers:** the "everything is `static`" habit; catching exceptions and doing nothing;
  confusing inheritance with code reuse; Jargon around generics.
- **Promotion criteria:** you can read an unfamiliar 300-line Java project and explain every class's
  responsibility without help.
- **Revision activities:** refactor one earlier solution to use interfaces; rewrite one loop-based
  solution as a stream and compare readability honestly.

## Milestone 4 — Data structures and algorithms

**Subjects:** [05-DATA-STRUCTURES-AND-ALGORITHMS](05-DATA-STRUCTURES-AND-ALGORITHMS/README.md)

- **Required knowledge:** algorithm analysis and Big-O; arrays, linked lists, stacks, queues, hash
  tables, trees, heaps, graphs; searching and sorting; recursion; backtracking; greedy methods;
  dynamic programming; graph algorithms.
- **Required exercises:** all 05 problem sets, including the independent problems; implement each
  structure from scratch once before using the library version.
- **Required projects:** add a performance-conscious feature to Project 01 (e.g. indexing or
  caching dataset lookups) and justify the complexity choice in writing.
- **Demonstrable competencies:** given a problem, name candidate structures and justify the choice
  by complexity and memory; read a given algorithm and state its running time; trace recursion and
  memoization by hand.
- **Common blockers:** memorizing Big-O without understanding derivation; jumping to dynamic
  programming before recognizing overlapping subproblems.
- **Promotion criteria:** pass a self-test of five mixed problems with correct complexity analysis
  written for each.
- **Revision activities:** re-derive the complexity of two algorithms you wrote earlier; explain one
  trade-off aloud as if teaching it.

## Milestone 5 — Web foundations, HTML/CSS, JavaScript, TypeScript, React

**Subjects:** [06-INTERNET-AND-WEB-FOUNDATIONS](06-INTERNET-AND-WEB-FOUNDATIONS/README.md),
[07-HTML-AND-CSS](07-HTML-AND-CSS/README.md),
[08-JAVASCRIPT-AND-TYPESCRIPT](08-JAVASCRIPT-AND-TYPESCRIPT/README.md),
[09-FRONTEND-ENGINEERING](09-FRONTEND-ENGINEERING/README.md)

- **Required knowledge:** client/server model, IP, DNS, TCP/UDP, HTTP, HTTPS/TLS, URLs/ports,
  browser rendering. Then semantic HTML, forms and validation, the CSS box model, Flexbox, Grid,
  responsive design, typography, accessibility. Then JavaScript fundamentals, scope, arrays/objects,
  the DOM, modules, promises/async-await, the event loop, error handling. Then TypeScript's type
  system, interfaces, generics, narrowing. Then React components, props, state and hooks,
  composition, routing, forms, state management, API integration, auth flows, error/loading states,
  reusable components, design systems, performance, accessibility, testing, builds.
- **Required exercises:** all exercise sets in 06–09 plus accessibility and testing exercises.
- **Required projects:** [Project 02 — Responsive Portfolio](20-PROJECT-LABORATORY/project-02-responsive-portfolio/README.md),
  then begin [Project 05 — Full-stack Application](20-PROJECT-LABORATORY/project-05-full-stack-application/README.md) frontend.
- **Demonstrable competencies:** build a responsive, keyboard-accessible page without a framework;
  explain the request/response cycle for any resource your page loads; write an async data-fetching
  component with loading, empty, and error states; type a React component's props so misuse is a
  compile error; write a component test that fails when the behavior regresses.
- **Common blockers:** learning React before being fluent in plain JS/DOM; layout-by-pixel-fiddling
  instead of understanding Flexbox/Grid rules; treating accessibility as a later phase.
- **Promotion criteria:** Project 02 passes the accessibility checklist and works from 360px to
  1440px; you can explain every line of one React component you wrote.
- **Revision activities:** rebuild a small widget without React; re-do a layout using only Grid;
  read one MDN page from the Web Foundations set again and summarize it in three sentences.

## Milestone 6 — Databases and backend APIs

**Subjects:** [10-DATABASE-ENGINEERING](10-DATABASE-ENGINEERING/README.md),
[11-BACKEND-ENGINEERING](11-BACKEND-ENGINEERING/README.md)

- **Required knowledge:** relational modeling, keys, constraints, relationships, ER diagrams,
  normalization; SQL through joins, aggregation, and subqueries; transactions and ACID; indexes and
  query plans; isolation levels; migrations, backups, security; intro NoSQL. Then client/server
  and HTTP/JSON/REST, Java backend structure, Spring and Spring Boot, dependency injection,
  controllers/services/repositories, validation, error handling, JPA/Hibernate, transactions,
  authentication, authorization, sessions and tokens, OAuth2/OIDC, uploads, caching, background
  jobs, API docs, logging, backend testing.
- **Required exercises:** all SQL sets against a real PostgreSQL instance (see
  [10-DATABASE-ENGINEERING/postgresql/](10-DATABASE-ENGINEERING/postgresql/README.md)); all backend
  exercise sets including integration tests.
- **Required projects:** [Project 03 — Database Application](20-PROJECT-LABORATORY/project-03-database-application/README.md),
  [Project 04 — REST API](20-PROJECT-LABORATORY/project-04-rest-api/README.md).
- **Demonstrable competencies:** derive a schema from requirements and justify its normalization
  level; write a query with three joins and an aggregate and predict its result; explain what
  happens from `curl` to database row and back; secure an endpoint with authentication *and*
  authorization; prove correctness with tests at two levels.
- **Common blockers:** business logic leaking into controllers; storing passwords without hashing;
  N+1 queries that only show up under data volume; confusing authentication with authorization.
- **Promotion criteria:** Project 04 meets its acceptance criteria with integration tests passing,
  and you can explain one index decision using an actual query plan.
- **Revision activities:** normalize a deliberately denormalized schema and write down the cost you
  introduced; re-read the transaction lesson and re-explain isolation levels with a concrete
  conflict example.

## Milestone 7 — Mobile development

**Subjects:** [12-MOBILE-DEVELOPMENT](12-MOBILE-DEVELOPMENT/README.md)

- **Required knowledge:** mobile architecture; Dart syntax, types, null safety, classes, async;
  Flutter widgets and layout; navigation; state management; forms and validation; API integration and
  JSON; local and secure storage; camera/QR; permissions and notifications; offline behavior;
  unit/widget/integration tests; Android and iOS release processes.
- **Required exercises:** all 12 exercise sets, including the platform-difference notes exercises.
- **Required projects:** [Project 06 — Flutter Mobile App](20-PROJECT-LABORATORY/project-06-flutter-mobile-app/README.md).
- **Demonstrable competencies:** build a navigated app with forms, remote data, and offline cache;
  handle a failed network request gracefully; explain exactly where Android and iOS differ in
  permissions and release signing; write widget tests that assert on visible behavior.
- **Common blockers:** treating Flutter as "web in an app"; putting business logic in widgets;
  ignoring platform-specific permission flows.
- **Promotion criteria:** a signed debug build runs on a real device or emulator, tests pass, and you
  can narrate the app's state flow.
- **Revision activities:** remove a state-management dependency and justify the rewrite; add an
  offline path and test it with the network disabled.

## Milestone 8 — Architecture, testing, and security (integrated)

**Subjects:** [13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE](13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/README.md),
[14-TESTING-AND-QUALITY](14-TESTING-AND-QUALITY/README.md),
[15-APPLICATION-SECURITY](15-APPLICATION-SECURITY/README.md)

- **Required knowledge:** SDLC and requirements; the complete development process guide; clean code,
  SOLID, separation of concerns, patterns; layered, modular-monolith, clean, event-driven,
  distributed and microservice architectures with their operational costs; scalability, reliability,
  technical debt. Testing pyramid, unit/integration/E2E, doubles and mocking, TDD, API/frontend/
  mobile testing, performance and security testing, coverage interpretation, quality gates. Threat
  modeling; password, session, token, and access-control security; injection, XSS, CSRF, SSRF; secure
  API design; secrets, dependencies, TLS, secure uploads; testing labs.
- **Required exercises:** all exercise sets, including writing a threat model and a test plan for
  your own Project 04/05 code.
- **Required projects:** begin [Project 07 — Secure Production Application](20-PROJECT-LABORATORY/project-07-secure-production-application/README.md).
- **Demonstrable competencies:** choose an architecture style and defend it with costs; write tests
  that catch a real regression and deliberately *not* test what shouldn't be tested; demonstrate each
  OWASP-style vulnerability class in a local lab and then demonstrate the fix passing a test; add a
  quality gate to CI.
- **Common blockers:** adopting microservices to look senior; mocking so much that tests prove
  nothing; coverage-as-target culture; security as a final audit.
- **Promotion criteria:** your project has an architecture decision record, a test suite with a
  justified mix of levels, and at least four verified security controls with tests.
- **Revision activities:** write the trade-offs of one architecture decision you reverse; delete one
  useless test and explain why it was useless.

## Milestone 9 — DevOps, cloud, and production operations

**Subjects:** [16-DEVOPS-AND-INFRASTRUCTURE](16-DEVOPS-AND-INFRASTRUCTURE/README.md),
[17-CLOUD-AND-PRODUCTION](17-CLOUD-AND-PRODUCTION/README.md)

- **Required knowledge:** DevOps culture; Linux administration, permissions, processes/services;
  networking for operations; shell scripting; Docker images, containers, registries, networking,
  volumes, Compose; Nginx and reverse proxies; DNS and TLS operations; IaC with Terraform and
  Ansible; CI/CD principles; GitHub Actions pipelines; deployment strategies; monitoring and
  logging; backups and recovery; cloud fundamentals, VMs, cloud networking, object storage, managed
  databases, IAM, configuration secrets, load balancing, scaling, observability, incident
  management, cost management.
- **Required exercises:** build and run containers; write a Compose stack; write a CI pipeline that
  runs your test suite; write an IaC plan for a small environment; run a restore drill from backup.
- **Required projects:** deploy Project 05 or 07 end-to-end with a pipeline, health checks, and
  monitoring.
- **Demonstrable competencies:** a containerized app with a reverse proxy and TLS; a CI pipeline
  that fails on a failing test; a deployment you can roll back; dashboards and alerts that would
  tell you the system is unhealthy; a cost estimate for your architecture.
- **Common blockers:** "works on my machine" without containers; putting secrets in Git; alerts
  nobody acts on; skipping backups until an incident.
- **Promotion criteria:** you have performed one restore drill and one rollback rehearsed, not
  theoretical.
- **Revision activities:** re-run your pipeline after breaking a dependency; audit your own
  repository for committed secrets with the checklist from [15-APPLICATION-SECURITY](15-APPLICATION-SECURITY/README.md).

## Milestone 10 — Advanced engineering and professional practice

**Subjects:** [18-ADVANCED-ENGINEERING](18-ADVANCED-ENGINEERING/README.md),
[19-PROFESSIONAL-DEVELOPMENT](19-PROFESSIONAL-DEVELOPMENT/README.md),
[20-PROJECT-LABORATORY](20-PROJECT-LABORATORY/README.md),
[21-REFERENCE-LIBRARY](21-REFERENCE-LIBRARY/README.md)

- **Required knowledge:** concurrency vs parallelism; message queues and event streaming; database
  scaling; distributed-system patterns and their failure modes; system design method; profiling;
  reliability engineering; maintaining large codebases; architecture decision records. Professional
  workflows, review skill, technical writing, open source etiquette, debugging methodology,
  interviews, portfolio, teamwork, career paths.
- **Required exercises:** complete a design review of your own system; do code reviews on two sample
  PRs using the checklist; solve a mixed interview set under time limits; write documentation for a
  stranger.
- **Required projects:** [Capstone Project](20-PROJECT-LABORATORY/capstone-project/README.md).
- **Demonstrable competencies:** design a system for a target scale and state its failure modes;
  profile and fix a measured bottleneck; participate credibly in an open-source contribution cycle;
  present your capstone's architecture, trade-offs, testing, security, and operations story.
- **Common blockers:** preparing for interviews instead of preparing for engineering; capstone scope
  creep; writing documentation only for yourself.
- **Promotion criteria:** capstone acceptance criteria are met and you can defend its trade-offs in
  a 15-minute walkthrough.
- **Revision activities:** revisit every milestone's "revision activities" once; maintain one project
  for a month with real change requests (level 6 of the tracker).

---

## After the roadmap

Finishing the milestones makes you competent, not finished. The remaining ingredient cannot be
supplied by any repository: **time spent maintaining real systems with real users and real
constraints**. Contribute to open source, run something people depend on, and keep the
[PROGRESS-TRACKER.md](PROGRESS-TRACKER.md) honest.

Next: [00-START-HERE](00-START-HERE/README.md) → [CURRICULUM-MAP.md](CURRICULUM-MAP.md)