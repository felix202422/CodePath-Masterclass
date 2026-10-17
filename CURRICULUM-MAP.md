# CURRICULUM MAP

Every major competency in this repository, mapped to the lesson that teaches it, the exercises that
practice it, and the project that applies it.

**How to read this file**

- **Lesson** links point to files that exist today. Entries shown as `code paths` are **planned but
  not yet written** — authoritative status lives in [ISSUE-REGISTER.md](ISSUE-REGISTER.md). As each
  lesson is written, its entry here becomes a live link.
- **Practice** points at the exercise set for that subject (solutions are separated into
  `solutions/` subfolders).
- **Project** points at the project in [20-PROJECT-LABORATORY](20-PROJECT-LABORATORY/README.md)
  where the competency is applied for real.
- Required-lesson columns follow prerequisite order: never take a competency from a later row
  before the earlier rows it depends on.

---

## How computers work

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Explain how a program runs on hardware | [01-COMPUTER-FOUNDATIONS/how-programs-execute.md](01-COMPUTER-FOUNDATIONS/how-programs-execute.md) | `01-COMPUTER-FOUNDATIONS/exercises/` | all later subjects |
| Reason about binary, number bases, and data representation | `01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md` | `01-COMPUTER-FOUNDATIONS/exercises/` | 05 (bit-level reasoning), 06 (IP addressing) |
| Apply Boolean logic to conditions | `01-COMPUTER-FOUNDATIONS/logic-and-boolean-algebra.md` | `01-COMPUTER-FOUNDATIONS/exercises/` | 02 (conditions), 04 (operators) |
| Explain files, processes, and memory | `01-COMPUTER-FOUNDATIONS/files-and-processes.md`, `memory-and-storage.md` | `01-COMPUTER-FOUNDATIONS/exercises/` | 03 (terminal), 04 (JVM memory), 16 (Linux ops) |
| Describe hardware roles (CPU, RAM, storage, I/O) | `01-COMPUTER-FOUNDATIONS/computer-hardware.md` | `01-COMPUTER-FOUNDATIONS/exercises/` | 17 (VMs, load balancing) |

## Programming fundamentals

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Decompose a problem and express an algorithm | `02-PROGRAMMING-FUNDAMENTALS/computational-thinking.md`, `algorithms-and-pseudocode.md`, `flowcharts.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | Project 01 |
| Use variables, types, and operators correctly | `02-PROGRAMMING-FUNDAMENTALS/variables-and-data-types.md`, `operators.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | Projects 01, 04 |
| Control flow: conditions and loops | `02-PROGRAMMING-FUNDAMENTALS/conditional-statements.md`, `loops.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | Project 01, 05 |
| Wrap logic in functions with parameters and returns | `02-PROGRAMMING-FUNDAMENTALS/functions-and-methods.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | Projects 01, 04 |
| Store collections in arrays/strings; use I/O | `02-PROGRAMMING-FUNDAMENTALS/arrays-and-strings.md`, `input-and-output.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | Project 01 |
| Find defects systematically | `02-PROGRAMMING-FUNDAMENTALS/debugging-fundamentals.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | every project, 19 (methodology) |
| Split programs into modules | `02-PROGRAMMING-FUNDAMENTALS/modular-programming.md` | `02-PROGRAMMING-FUNDAMENTALS/exercises/` | 13 (separation of concerns) |

## Developer tools and version control

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Navigate and automate via the terminal | `03-DEVELOPER-TOOLS/terminal-fundamentals.md` | `03-DEVELOPER-TOOLS/troubleshooting/` | every project |
| Set up a working dev environment (Windows/Linux) | `03-DEVELOPER-TOOLS/windows-development-environment.md`, `linux-fundamentals.md` | `03-DEVELOPER-TOOLS/troubleshooting/` | 16 (Linux administration) |
| Manage files, packages, environment variables | `03-DEVELOPER-TOOLS/package-managers.md`, `environment-variables.md`, `editors-and-ides.md` | `03-DEVELOPER-TOOLS/troubleshooting/` | all projects, 15 (secrets) |
| Track history and collaborate with Git | `03-DEVELOPER-TOOLS/git-fundamentals.md`, `branching-and-merging.md` | `03-DEVELOPER-TOOLS/troubleshooting/` | every project |
| Work on GitHub with PRs and review | `03-DEVELOPER-TOOLS/github-workflows.md`, `pull-requests-and-code-review.md` | `03-DEVELOPER-TOOLS/troubleshooting/` | 19 (workflows, review) |

## Java and object-oriented programming

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Write and run a Java program; structure a codebase | `04-JAVA-PROGRAMMING/java-environment-setup.md`, `java-program-structure.md` | `04-JAVA-PROGRAMMING/exercises/` | Projects 04, 05, 07 |
| Use types, control flow, methods, arrays, strings | `variables-and-types.md`, `operators-and-control-flow.md`, `methods.md`, `arrays-and-strings.md` | `04-JAVA-PROGRAMMING/exercises/` | Project 04 |
| Model with classes and objects | `classes-and-objects.md`, `encapsulation.md` | `04-JAVA-PROGRAMMING/exercises/` | Projects 04, 07 |
| Design with inheritance, polymorphism, abstraction, interfaces | `inheritance.md`, `polymorphism.md`, `abstraction.md`, `interfaces-and-abstract-classes.md` | `04-JAVA-PROGRAMMING/exercises/` | 13 (SOLID, patterns) |
| Handle errors properly | `exceptions.md` | `04-JAVA-PROGRAMMING/exercises/` | 11 (error handling), 14 (tests) |
| Use collections and generics | `collections-framework.md`, `generics.md` | `04-JAVA-PROGRAMMING/exercises/` | 05 (data structures in practice) |
| Work with files, lambdas, streams, functional style | `file-handling.md`, `lambdas-and-streams.md`, `functional-programming.md` | `04-JAVA-PROGRAMMING/exercises/` | 11 (services) |
| Reason about concurrency and the JVM | `concurrency.md`, `jvm-and-memory.md` | `04-JAVA-PROGRAMMING/exercises/` | 18 (concurrency, profiling) |
| Build with Maven | `build-tools.md` | `04-JAVA-PROGRAMMING/exercises/` | 11, 14, 16 (CI) |

## Data structures and algorithms

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Analyze cost with Big-O | `05-.../algorithm-analysis.md`, `big-o-notation.md` | `05-.../problem-solving/` | 10 (indexes), 18 (performance) |
| Choose and implement core structures | `arrays.md`, `linked-lists.md`, `stacks.md`, `queues.md`, `hash-tables.md`, `trees.md`, `heaps.md`, `graphs.md` | `05-.../problem-solving/` | Project 01, 10 (schema design) |
| Search and sort with justification | `searching.md`, `sorting.md` | `05-.../problem-solving/` | 10 (query plans) |
| Solve with recursion and backtracking | `recursion.md`, `backtracking.md` | `05-.../problem-solving/` | 18 (algorithms at scale) |
| Trade correctness for speed: greedy and DP | `greedy-algorithms.md`, `dynamic-programming.md` | `05-.../problem-solving/` | interviews (19) |
| Traversals and shortest paths | `graph-algorithms.md` | `05-.../problem-solving/` | 13, 18 (networked systems) |

## The web: from network to interface

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Trace IP, DNS, TCP, HTTP, TLS | `06-INTERNET-AND-WEB-FOUNDATIONS/` lessons | `06-.../exercises/` | 11 (REST), 15 (TLS), 16 (Nginx) |
| Explain browser rendering | `06-.../browsers-and-rendering.md` | `06-.../exercises/` | 09 (performance) |
| Write semantic, accessible HTML | `07-HTML-AND-CSS/html-fundamentals.md`, `semantic-html.md`, `accessibility.md` | `07-.../projects/` | Project 02, 09 |
| Build layouts with Box model, Flexbox, Grid | `box-model.md`, `flexbox.md`, `css-grid.md` | `07-.../projects/` | Project 02 |
| Make pages responsive and typographically sound | `responsive-design.md`, `typography-and-design-tokens.md` | `07-.../projects/` | Project 02, design systems (09) |
| Build accessible forms with validation | `forms-and-validation.md` | `07-.../projects/` | 09 (forms), 10 (validation) |
| Write modern JavaScript (scope, DOM, modules, errors) | `08-JAVASCRIPT-AND-TYPESCRIPT/` core lessons | `08-.../exercises/` | Project 02, 09 |
| Handle async: promises, await, event loop | `promises-and-async-await.md`, `event-loop.md` | `08-.../exercises/` | 09 (API calls), 11 (async jobs) |
| Model programs with types in TypeScript | `typescript-fundamentals.md`, `types-and-interfaces.md`, `generics.md`, `type-narrowing.md` | `08-.../exercises/` | Projects 05, 07 |
| Build React apps: components, state, hooks, routing, forms | `09-FRONTEND-ENGINEERING/` lessons | `09-.../projects/` | Projects 05, 07 |
| Integrate APIs and auth on the client | `api-integration.md`, `frontend-authentication.md`, `error-and-loading-states.md` | `09-.../projects/` | Project 05, security (15) |
| Design reusable, accessible systems | `reusable-components.md`, `design-systems.md`, `accessibility.md`, `performance.md` | `09-.../projects/` | capstone |
| Test and ship a frontend | `frontend-testing.md`, `build-and-deployment.md` | `09-.../projects/` | 14, 16 (CI) |

## Data: design, SQL, operations

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Model relations, ER diagrams, normalization | `10-DATABASE-ENGINEERING/database-design.md`, `er-diagrams.md`, `normalization.md` | `10-.../postgresql/` | Projects 03, 04 |
| Write SQL: filter, aggregate, join, subquery | `sql-fundamentals.md`, `filtering-and-aggregation.md`, `joins-and-subqueries.md` | `10-.../postgresql/` sample data + expected results | Project 03 |
| Guarantee correctness: constraints, transactions | `constraints-and-relationships.md`, `transactions.md` | `10-.../postgresql/` | Project 04, 11 (JPA tx) |
| Improve performance: indexes, plans | `indexes.md`, `query-plans-and-optimization.md` | `10-.../postgresql/` (`EXPLAIN` exercises) | 18 (database scaling) |
| Operate safely: isolation, migrations, backups, security | `concurrency-and-isolation.md`, `migrations.md`, `backups-and-recovery.md`, `database-security.md` | `10-.../postgresql/` | 16, 17 |
| Know when NoSQL fits | `nosql-fundamentals.md` | `10-.../postgresql/` appendix | 13, 18 |

## Backend: REST, Spring, security, operations

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Design REST APIs and JSON contracts | `11-BACKEND-ENGINEERING/http-and-rest-apis.md`, `api-design.md` | `11-.../projects/` briefs | Project 04 |
| Structure a Spring Boot app with DI and layers | `spring-fundamentals.md`, `spring-boot.md`, `dependency-injection.md`, `controllers-services-repositories.md` | `11-.../projects/` | Projects 04, 05, 07 |
| Validate input and handle errors | `validation-and-error-handling.md` | `11-.../projects/` | 14 (API tests), 15 (injection defense) |
| Persist with JPA/Hibernate and transactions | `jpa-and-hibernate.md` | `11-.../projects/` | Project 05 |
| Authenticate and authorize; sessions, tokens, OAuth2 | `authentication.md`, `authorization.md`, `sessions-and-tokens.md`, `oauth2-and-openid-connect.md` | `11-.../projects/` | Projects 05, 07, 15 |
| Upload files, cache, run background jobs | `file-uploads.md`, `caching.md`, `background-jobs.md` | `11-.../projects/` | Project 07 |
| Document, log, and test APIs | `api-documentation.md`, `logging.md`, `backend-testing.md` | `11-.../projects/` | 14, 17 (observability) |

## Mobile

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Dart: types, null safety, async, classes | `12-MOBILE-DEVELOPMENT/dart-fundamentals.md`, `null-safety.md`, `asynchronous-dart.md` | `12-.../projects/` briefs | Project 06 |
| Flutter UI: widgets, layout, navigation | `flutter-fundamentals.md`, `widgets-and-layouts.md`, `navigation.md` | `12-.../projects/` | Project 06 |
| Manage state, forms, validation | `state-management.md`, `forms-and-validation.md` | `12-.../projects/` | Project 06 |
| Persist locally and securely; go offline | `local-storage.md`, `secure-storage.md`, `offline-functionality.md` | `12-.../projects/` | 15 (mobile security) |
| Integrate APIs with JSON and errors | `api-integration.md` | `12-.../projects/` | Project 06 |
| Device features: camera, QR, permissions, notifications | `camera-and-qr-codes.md`, `permissions-and-notifications.md` | `12-.../projects/` | Project 06 extensions |
| Test mobile: unit, widget, integration | `mobile-testing.md` | `12-.../projects/` | 14 |
| Release on Android and iOS | `android-release.md`, `ios-release.md` | `12-.../projects/` | portfolio (19) |

## Engineering practice: architecture, testing, security

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Run the full development process | `13-.../the-complete-development-process.md`, `software-development-life-cycle.md` | walkthrough exercises in 13 | every project, capstone |
| Engineer requirements and acceptance criteria | `requirements-engineering.md`, `functional-and-nonfunctional-requirements.md`, `use-cases-and-uml.md` | `13-...` exercises | Projects 03–capstone |
| Write clean code; apply SOLID and patterns | `clean-code.md`, `solid-principles.md`, `separation-of-concerns.md`, `design-patterns.md` | `13-...` refactoring exercises | Project 07 |
| Choose and defend an architecture | `layered-architecture.md`, `modular-monoliths.md`, `clean-architecture.md`, `domain-driven-design.md`, `event-driven-architecture.md` | `13-...` ADR exercises | Project 07, capstone |
| Scale and distribute responsibly | `distributed-systems.md`, `microservices.md`, `scalability-and-reliability.md` | `13-...` case exercises | 18 |
| Manage technical debt | `technical-debt.md` | `13-...` | ongoing maintenance |
| Design tests at each level; use doubles; practice TDD | `14-TESTING-AND-QUALITY/testing-fundamentals.md` … `quality-gates.md` | `14-...` exercises in Java/React/Flutter | all projects |
| Model threats and design defenses | `15-APPLICATION-SECURITY/security-fundamentals.md`, `threat-modeling.md` | `15-.../security-testing-labs/` | Project 07 |
| Prevent injection, XSS, CSRF, SSRF | `injection-vulnerabilities.md`, `cross-site-scripting.md`, `csrf.md`, `ssrf.md` | `15-.../security-testing-labs/` | Project 07, capstone |
| Manage secrets, dependencies, TLS, uploads | `secrets-management.md`, `dependency-security.md`, `tls-and-certificates.md`, `secure-file-uploads.md` | `15-.../security-testing-labs/` | 16, 17 |

## Operations: DevOps, cloud, advanced

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Operate Linux: processes, permissions, scripting | `16-DEVOPS-AND-INFRASTRUCTURE/linux-administration.md`, `shell-scripting.md`, `networking-for-devops.md` | `16-.../troubleshooting/` | deployment projects |
| Containerize with Docker and Compose | `docker-fundamentals.md`, `docker-images-and-containers.md`, `container-networking.md`, `volumes-and-persistence.md`, `docker-compose.md` | `16-.../troubleshooting/` | Projects 05, 07 |
| Serve with Nginx, DNS, TLS | `nginx-and-reverse-proxies.md`, `dns-and-tls-operations.md` | `16-.../troubleshooting/` | Project 07, 14 (HTTPS tests) |
| Automate infrastructure | `infrastructure-as-code.md`, `terraform.md`, `ansible.md` | `16-...` exercises | Project 07 |
| Build CI/CD with GitHub Actions | `ci-cd-fundamentals.md`, `github-actions.md`, `deployment-strategies.md` | `16-...` exercises | all projects |
| Observe, back up, recover | `monitoring-and-logging.md`, `backups-and-recovery.md` | `16-.../troubleshooting/` | Project 07 |
| Deploy and operate in the cloud | `17-CLOUD-AND-PRODUCTION/` lessons (VM, networking, storage, IAM, LB, scaling, observability, incidents, cost) | `17-...` exercises | Project 07, capstone |
| Engineer advanced systems | `18-ADVANCED-ENGINEERING/` lessons | `18-...` design exercises | capstone |

## Professional practice and projects

| Competency | Lessons | Practice | Applied in |
|---|---|---|---|
| Run engineering workflows and reviews | `19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md`, `code-review.md` | review two sample PRs | every project |
| Document, debug, communicate | `technical-documentation.md`, `debugging-methodology.md`, `teamwork-and-communication.md` | write docs for a stranger | capstone |
| Contribute to open source | `open-source-contributions.md` | one real contribution | portfolio |
| Interview and build a career | `technical-interviews.md`, `portfolio-development.md`, `career-paths.md` | timed problem sets | all projects |
| Apply everything: 7 projects + capstone | — | see [20-PROJECT-LABORATORY](20-PROJECT-LABORATORY/README.md) | portfolio |
| Look things up fast | [21-REFERENCE-LIBRARY](21-REFERENCE-LIBRARY/README.md) | — | daily use |

---

**Back to:** [README.md](README.md) · [ROADMAP.md](ROADMAP.md) · [ISSUE-REGISTER.md](ISSUE-REGISTER.md)