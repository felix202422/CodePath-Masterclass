# Version Baseline

> **Why this file exists:** every command, code example, configuration format, and flag in this
> repository is written against the pinned versions below. Teaching material that silently mixes
> versions is a primary source of learner confusion, so all lesson authors must check this file
> first and update it deliberately.

**Verified:** 2026-10-17 against the official sources linked in each row.
Numbers marked **UNVERIFIED** are the newest the researcher could confirm from an official page —
they are a floor, not a guarantee that no newer patch exists.

## Teaching baseline (what lessons teach)

| Technology | Baseline taught | Latest stable verified (Oct 2026) | Source |
|---|---|---|---|
| Java | **21 LTS** | 25 is the newest LTS; 21 remains an LTS supported by vendors | [OpenJDK 21](https://openjdk.org/projects/jdk/21/), [OpenJDK 25](https://openjdk.org/projects/jdk/25/) |
| Spring Boot | **4.1.x** (`spring-boot-starter-parent`) | 4.1.1, supports Java 17–26 | [System requirements](https://docs.spring.io/spring-boot/system-requirements.html) |
| Jakarta Persistence (JPA) | **3.2** (version managed by Spring Boot) | 3.2; 4.0 in development only | [Jakarta Persistence 3.2](https://jakarta.ee/specifications/persistence/3.2/) |
| Hibernate ORM | Managed by Spring Boot — **never pinned by hand** | 7.4.x line | [Hibernate releases](https://hibernate.org/orm/releases/) |
| Apache Maven | **3.9+ / 3.10** | 3.10.0 (Maven 4 still preview) | [Maven downloads](https://maven.apache.org/download.cgi) |
| PostgreSQL | **18.x** | 18.6 (19 is only at RC1) | [PostgreSQL versioning](https://www.postgresql.org/support/versioning/) |
| Node.js | **24.x LTS** | 24.x Active LTS; 26.x becomes Active LTS 2026-10-28 | [Node release schedule](https://github.com/nodejs/Release) |
| npm | 11.x (ships with Node 24) | 11.x | [npm docs](https://docs.npmjs.com/) |
| TypeScript | **5.x syntax taught; verify installed major before writing a lesson** | 7.0 reported as latest on the download page (**UNVERIFIED** beyond that page) | [TypeScript download](https://www.typescriptlang.org/download/) |
| React | **19.x** | 19.3 | [React 19.3](https://react.dev/blog/2026/09/09/react-19-3) |
| Vite | **8.x** (`--template react-ts`) | 8.1 (newer minor **UNVERIFIED**) | [Vite 8.1](https://vite.dev/blog/announcing-vite8-1) |
| Testing (frontend) | **Vitest + React Testing Library** | Vitest 5.0 | [Vitest vs Jest](https://vitest.dev/guide/comparisons), [RTL intro](https://testing-library.com/docs/react-testing-library/intro/) |
| Dart | **3.13.x** | 3.13.5 (verified `dart --version`) | [Dart 3.13](https://dart.dev/blog/announcing-dart-3-13) |
| Flutter | **stable channel, 3.47.x** | 3.47.7 (verified `flutter --version`, stable channel) | [Flutter release notes](https://docs.flutter.dev/release/release-notes) |
| Docker | Engine **29.x**, Desktop **4.95.x** | Engine 29.9.1 / Desktop 4.95.0 | [Engine 29 release notes](https://docs.docker.com/engine/release-notes/29/) |
| GitHub Actions | `ubuntu-24.04` runner, `actions/checkout@v7`, `actions/setup-java@v6` | ubuntu-latest = Ubuntu 24.04 image; move to 26.04 announced for Nov 2026 | [runner-images](https://github.com/actions/runner-images/blob/main/README.md) |
| Terraform | **1.16.x** | 1.16.6 (1.17 is RC) | [HashiCorp releases](https://releases.hashicorp.com/terraform/) |
| Ansible | **community package 14.x** (ansible-core 2.21.x) | 14.x / 2.21.x | [Ansible release policy](https://docs.ansible.com/projects/ansible/latest/reference_appendices/release_and_maintenance.html) |
| NGINX | **stable 1.30.x** | 1.30.6 (mainline 1.31.x) | [nginx download](https://nginx.org/en/download.html) |

### Deliberate choices (and their reasoning)

1. **Java 21, not 25.** Java 21 is the LTS with the widest industry install base and the version
   most job postings and existing textbooks assume. Spring Boot 4.1 explicitly supports Java 17–26,
   so 21 is fully supported. Local examples are compiled with `javac --release 21` on the JDK 25
   toolchain installed on the author's machine, which validates both that the code is correct and
   that it does not accidentally use post-21 language features.
2. **Node 24, not 26 (for now).** Node 24 is Active LTS on the verification date; Node 26 only
   becomes Active LTS on 2026-10-28. Lessons say "Node 24 LTS (Active LTS until Oct 2026)" and
   this row must be revisited after that date.
3. **Hibernate is never pinned by hand** in Spring Boot lessons. Spring Boot curates the version.
   Naming a different Hibernate version than the one Boot manages is a classic source of
   "works in the tutorial, breaks in my project" bugs.
4. **Pinning policy for lessons.** Prefer minor-version ranges in prose (`Spring Boot 4.1.x`) and
   exact versions only where reproducibility demands them (`pom.xml` parent version, lockfiles).
   Never write a version into a lesson that has not been checked against this file.

## Author environment (what was actually executed when writing this repository)

| Tool | Version on the writing machine |
|---|---|
| OS | Windows 11 (Git Bash for all commands) |
| JDK | 25.0.4.1 LTS (`javac --release 21` used for lesson verification) |
| Maven | 3.9.16 |
| Gradle | **not installed** — Gradle lessons are documented but not executed locally |
| Docker | **not installed** — container lessons use verified official docs and labelled transcripts |
| PostgreSQL client | psql 18.6 |
| Dart SDK | 3.13.5 (stable) |
| Flutter | 3.47.7 (stable channel) — Android SDK 36.1.0 installed |
| Node.js | 24.13.1 |
| npm | 11.8.0 |
| Python | 3.13.5 (used for validation scripts in `scripts/`) |
| Git | see `git --version` output recorded in the completion report |

**Transparency rule:** where a lesson's transcript comes from a command actually run here, the
lesson says so. Where a transcript is an illustration of expected behaviour, the lesson labels it
as an illustration. Nothing in this repository pretends to be a screenshot it is not.