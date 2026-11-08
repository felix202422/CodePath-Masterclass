# Official Resources

Primary sources only: the documentation written by the people who make the thing. Each entry says
what that page is *best* for, because a link without a purpose is a bookmark you never open.

> **Rule.** When this curriculum and an official page disagree, the official page for your installed
> version wins — and then this curriculum gets fixed. Versions named below follow
> [`VERSIONS.md`](../VERSIONS.md); check the version selector on the site before reading.

## Languages and runtimes

| Resource | Best for | Note |
|---|---|---|
| [dev.java — Learn](https://dev.java/learn/) | Modern Java tutorials from Oracle's Java team. | Language-level, current, and free. |
| [Java 21 API specification](https://docs.oracle.com/en/java/javase/21/docs/api/) | Exact signatures of every JDK class. | The baseline version for this curriculum. |
| [Java Language Specification (SE 21)](https://docs.oracle.com/javase/specs/jls/se21/html/index.html) | The normative answer to "is this legal Java". | Dense; use it to settle arguments, not to learn. |
| [MDN — JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) | Syntax, built-ins, behaviour of the language. | The best JavaScript reference that exists. |
| [Node.js API](https://nodejs.org/api/) | `fs`, `path`, `http`, `process`, ESM. | Pick your Node version in the selector; the docs are versioned. |
| [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) | The type system: narrowing, generics, utility types. | Read the handbook before the release notes. |
| [Dart — Language tour](https://dart.dev/language) | Null safety, async, classes, patterns. | Shorter and better organised than the full spec. |
| [Flutter — UI documentation](https://docs.flutter.dev/ui) | Widgets, layout, state. | The cookbook is the fastest route to a working screen. |

## Frameworks and tools

| Resource | Best for | Note |
|---|---|---|
| [Spring Boot reference](https://docs.spring.io/spring-boot/) | Configuration, starters, Actuator, testing slices. | Version-specific paths: `/spring-boot/4.1/`. |
| [Spring Guides](https://spring.io/guides) | Working examples you can run in minutes. | Guides track the latest release, not the baseline. |
| [React reference](https://react.dev/reference/react) | Hooks, rules of hooks, component APIs. | The "You Might Not Need an Effect" page prevents most bugs. |
| [Vite guide](https://vite.dev/guide/) | Dev server, build, environment variables, plugins. | `import.meta.env` semantics live here. |
| [Git documentation](https://git-scm.com/docs) | Every command, every option. | Start with `git help <command>` locally; the site is the same text. |
| [man7.org — Linux man pages](https://man7.org/linux/man-pages/) | Syscalls, libc, and Linux-specific tools. | The authoritative page when a distro's `man` differs. |

## Data

| Resource | Best for | Note |
|---|---|---|
| [PostgreSQL 18 manual](https://www.postgresql.org/docs/18/) | Everything about the database. | Bookmark the "SQL Commands" and "Functions and Operators" chapters. |
| [PostgreSQL — SQL commands](https://www.postgresql.org/docs/18/sql.html) | Exact syntax of every statement. | Includes `ON CONFLICT`, `LATERAL`, window frames. |
| [PostgreSQL — performance tips](https://www.postgresql.org/docs/18/performance-tips.html) | Indexing, planning, configuration starting points. | Read before adding an index "just in case". |

## Web, HTTP and accessibility

| Resource | Best for | Note |
|---|---|---|
| [MDN — HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP) | Headers, methods, status codes, caching in practice. | The practical companion to the RFCs. |
| [RFC 9110 — HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html) | The normative definition of methods, status codes and headers. | Section 15 is the status-code list. |
| [RFC 9111 — HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html) | Cacheability, freshness, revalidation. | Explains why a `302` is not cached by default. |
| [WCAG 2.2](https://www.w3.org/TR/WCAG22/) | The success criteria accessibility is measured against. | AA is the level most organisations target. |
| [W3C WAI tutorials](https://www.w3.org/WAI/tutorials/) | Practical patterns: forms, tables, navigation, images. | Better than the spec for "how do I actually do this". |
| [web.dev — Learn](https://web.dev/learn) | Performance, accessibility, CSS and HTML courses. | Google's material, but vendor-neutral in practice. |

## Security

| Resource | Best for | Note |
|---|---|---|
| [OWASP Top 10](https://owasp.org/www-project-top-ten/) | The risk categories reviewers and auditors use. | Start here for threat modelling prompts. |
| [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) | Concrete defences: sessions, CSRF, password storage, file uploads. | The single most useful security reference for application code. |
| [CVE Program](https://www.cve.org/) | Identifiers for published vulnerabilities. | Pair with your dependency scanner's database, not by hand. |

## DevOps, infrastructure and cloud

| Resource | Best for | Note |
|---|---|---|
| [Docker CLI reference](https://docs.docker.com/reference/cli/docker/) | Every command and flag. | Matches Engine 29. |
| [Dockerfile reference](https://docs.docker.com/reference/dockerfile/) | Instruction semantics, especially `COPY`, `ARG`, `HEALTHCHECK`. | The layer-caching explanation is worth reading once, properly. |
| [Compose file specification](https://docs.docker.com/reference/compose-file/) | Every Compose key, including `depends_on` conditions. | The `services` schema is the part you will use daily. |
| [GitHub Actions documentation](https://docs.github.com/en/actions) | Workflow syntax, contexts, caching, matrix builds. | The `workflow-syntax` page is the one to keep open. |
| [Terraform documentation](https://developer.hashicorp.com/terraform/docs) | HCL, state, providers, plan/apply. | Read the state section before your first shared workspace. |
| [Ansible documentation](https://docs.ansible.com/) | Modules, playbooks, idempotence. | Module pages are the reference; the "Learning path" is the tutorial. |
| [NGINX documentation](https://nginx.org/en/docs/) | Directives, reverse proxy, TLS. | `proxy_pass` and `try_files` cause most questions. |
| [Kubernetes documentation](https://kubernetes.io/docs/home/) | Concepts, `kubectl`, manifests. | Concepts before commands. |
| [AWS documentation](https://docs.aws.amazon.com/) | Service-level reference for anything in the cloud subject. | Use the service's own "Getting started", not third-party tutorials. |

## Testing

| Resource | Best for | Note |
|---|---|---|
| [JUnit 5 user guide](https://junit.org/junit5/docs/current/user-guide/) | Annotations, lifecycle, parameterised tests, extensions. | The `@Nested` and `@ParameterizedTest` sections change how you write tests. |
| [Vitest guide](https://vitest.dev/guide/) | Configuration, mocking, coverage, snapshots. | API-compatible with Jest for the basics. |
| [Playwright documentation](https://playwright.dev/docs/intro) | Browser automation, locators, fixtures, tracing. | Locators by role are also an accessibility check. |
| [Testing Library](https://testing-library.com/docs/) | Querying the DOM the way a user would. | "The more your tests resemble the way your software is used…" |

## Practice and process

| Resource | Best for | Note |
|---|---|---|
| [The Twelve-Factor App](https://12factor.net/) | Config, statelessness, logs, disposability. | Still the clearest statement of deployable-app hygiene. |
| [Semantic Versioning 2.0.0](https://semver.org/) | What `MAJOR.MINOR.PATCH` promises. | Read the "FAQ" before arguing about a version bump. |
| [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) | Commit message structure that tools can parse. | Optional, but consistent across a team is what matters. |
| [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) | A changelog format written for humans. | Explains why "git log" is not a changelog. |
| [Google Engineering Practices — code review](https://google.github.io/eng-practices/review/) | How to review, and how to respond to review. | Short, opinionated, widely adopted. |

## How to read documentation efficiently

1. **Find the version selector first.** A page for the wrong major version is worse than no page.
2. **Read the signature, then the example, then the prose.** Prose explains edge cases you have not hit yet.
3. **Search the page, not the site** (`Ctrl+F`), then the site's own search, then a general search engine.
4. **Prefer the reference over a tutorial** once you know the concept; tutorials teach, references answer.
5. **Check the "Deprecated" and "Changed in" notes** before copying an example into new code.
6. **When the docs and the behaviour disagree, trust the behaviour** — then check whether you are on the version the docs describe.

## Related pages

- [Glossary](glossary.md) — the vocabulary these documents assume
- [Common Errors](common-errors.md) — when the documented answer and your error disagree
- [`VERSIONS.md`](../VERSIONS.md) — the versions this curriculum is written against
- [19-PROFESSIONAL-DEVELOPMENT/technical-documentation.md](../19-PROFESSIONAL-DEVELOPMENT/technical-documentation.md) — writing documentation others can use
