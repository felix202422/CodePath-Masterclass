# 21 — Reference Library

Look things up here. This subject is not for studying in order — it is the shelf you reach for
while working, written so a single page answers a question in under a minute.

## What this subject covers

- [`glossary.md`](glossary.md) — every technical term used in the curriculum, defined in one or two
  sentences, grouped by subject, with a link to the lesson that teaches it properly.
- [`common-errors.md`](common-errors.md) — the error messages learners meet most, each with cause,
  diagnosis, and fix, grouped by the tool that prints it.
- [`command-reference.md`](command-reference.md) — the terminal, package, build, and HTTP commands
  worth memorizing, with the output you should expect.
- [`git-reference.md`](git-reference.md) — Git operations by goal ("undo my last commit", "what did
  this file look like last Tuesday"), not by flag.
- [`sql-reference.md`](sql-reference.md) — PostgreSQL syntax patterns for the queries you write
  weekly: joins, aggregates, windows, CTEs, upserts, indexes and `EXPLAIN`.
- [`http-status-codes.md`](http-status-codes.md) — status codes grouped by meaning, with
  when-to-use-which guidance and the cacheability rules that follow from each class.
- [`java-reference.md`](java-reference.md) — syntax and standard-library lookups for the Java 21
  material: types, collections, streams, records, exceptions, concurrency.
- [`javascript-reference.md`](javascript-reference.md) — the same for JavaScript and TypeScript:
  types, arrays, objects, modules, async, and the type-system features the lessons use.
- [`linux-reference.md`](linux-reference.md) — filesystem, permissions, processes, services,
  networking and text processing, written for a Debian/Ubuntu shell.
- [`docker-reference.md`](docker-reference.md) — commands, Dockerfile instructions, multi-stage
  patterns and Compose equivalents.
- [`official-resources.md`](official-resources.md) — curated links to official documentation only,
  with one line on what each is best for.

## How these pages are written

A reference page is judged by a different standard than a lesson: you arrive with a problem and
leave with an answer, usually in under a minute. Four rules follow from that.

| Rule | What it means in practice |
|---|---|
| **One page, one kind of question** | The glossary answers "what does this word mean", `common-errors.md` answers "what do I type now". A page that answers both is slower than two pages. |
| **Answer before context** | The table or command comes first; the paragraph explaining *why* comes after it, or is a link to the lesson. |
| **Vendored against `VERSIONS.md`** | Every version-sensitive claim is written against the baseline in [`VERSIONS.md`](../VERSIONS.md) — Java 21, Node 24, PostgreSQL 18, Docker Engine 29 — and says so where it matters. A reference that mixes versions is worse than no reference. |
| **Executed where executable** | Snippets and commands that can run on the authoring machine were run; the ones that cannot (Docker, systemd, cloud consoles) are labelled as unrun and follow the official documentation. |

## Register

| Register | Page | The question it answers |
|---|---|---|
| `REF-01` | this overview | How is this subject organised, and which page do I need? |
| `REF-02` | [Glossary](glossary.md) | What does this term mean, and where is it taught? |
| `REF-03` | [Common Errors](common-errors.md) | I have this message — what is wrong and what do I do? |
| `REF-04` | [Command Reference](command-reference.md) | What is the command, flag or syntax for X? |
| `REF-05` | [Git Reference](git-reference.md) | How do I undo / inspect / combine this in Git? |
| `REF-06` | [SQL Reference](sql-reference.md) | How do I write this query pattern in PostgreSQL? |
| `REF-07` | [HTTP Status Codes](http-status-codes.md) | Which status code is correct here, and what may a client assume? |
| `REF-08` | [Java Reference](java-reference.md) | Java 21 syntax and API lookup. |
| `REF-09` | [JavaScript & TypeScript Reference](javascript-reference.md) | JS/TS syntax, array methods, async, type-level features. |
| `REF-10` | [Linux Reference](linux-reference.md) | Permissions, processes, services, networking in a shell. |
| `REF-11` | [Docker Reference](docker-reference.md) | Container commands and Dockerfile patterns. |
| `REF-12` | [Official Resources](official-resources.md) | Which primary source should I read, and for what? |

## Why it matters

Professional development is mostly retrieval under time pressure: a broken build, a confusing
status code, a Git state you have never been in. Having a trusted, version-pinned, curriculum-
consistent reference beats searching a results page full of answers for other people's tool
versions — and every page here links back to the lesson that teaches the concept properly.

There is a second reason. The lessons are written to be *read*; a reference is written to be
*checked*. Writing down the answer to "which status code for a successful `POST` that created
nothing" forces a precision that reading never does, and that precision is most of what separates
an engineer who guesses from one who knows.

## Prerequisites

None to *read* these pages; they are self-contained. But you will get far more out of them after
studying the subjects they reference — this is a companion to the curriculum, not a shortcut
through it.

- [`00-START-HERE/how-to-use-this-repository.md`](../00-START-HERE/how-to-use-this-repository.md)
  — how the curriculum's four page types differ, including this one
- [`VERSIONS.md`](../VERSIONS.md) — the version baseline every page here is written against
- [`03-DEVELOPER-TOOLS/terminal-fundamentals.md`](../03-DEVELOPER-TOOLS/terminal-fundamentals.md)
  — if the command pages assume a shell you have not used yet

## Lessons

The eleven pages, in the order the README lists them:

- [`glossary.md`](glossary.md) · [`common-errors.md`](common-errors.md) ·
  [`command-reference.md`](command-reference.md) · [`git-reference.md`](git-reference.md)
- [`sql-reference.md`](sql-reference.md) · [`http-status-codes.md`](http-status-codes.md) ·
  [`java-reference.md`](java-reference.md) · [`javascript-reference.md`](javascript-reference.md)
- [`linux-reference.md`](linux-reference.md) · [`docker-reference.md`](docker-reference.md) ·
  [`official-resources.md`](official-resources.md)

## Keeping it current

A reference page rots faster than a lesson because it makes more specific claims. Three habits keep
this one honest:

1. **Update on contact.** When you find an answer here that is wrong for your installed version,
   fix the page in the same session, and note the version that changed (`Docker Engine 29 renamed
   ...`). The next reader inherits the correction.
2. **Never add an answer you have not tried.** If a command has not been run on the baseline
   version, either run it or mark it as unverified. Confident wrong references are worse than an
   empty table.
3. **Link out, do not diverge.** Where the official documentation is the better answer (flag
   details, exhaustive option lists), link it rather than paraphrasing it. `official-resources.md`
   exists for exactly this.

## Exercises and practice

Two habits beat drills here:

1. **Contribute your misses.** When an error costs you more than ten minutes and is not yet in
   `common-errors.md`, add it — writing the entry is the retrieval practice.
2. **Self-quiz the status codes and Git operations.** Cover the right-hand column and name the
   command or meaning.

## Expected outcomes

You can resolve a common error from its message alone, find the right Git operation without
searching, write the SQL shape you need without a browser tab, and know exactly which official
document to open — the practical definition of being independent as a developer.

## Common blockers

- **Reading the reference instead of the lesson.** A table gives you the syntax; only the lesson
  gives you the model that tells you *when* the syntax is the wrong tool.
- **Trusting an answer for the wrong version.** `docker compose` versus `docker-compose`, Gradle
  versus Maven snippets, Java 8 versus Java 21 idioms — check the page's baseline line before
  copying.
- **Copying a command that writes.** `git reset --hard`, `docker system prune`, `DROP TABLE` and
  `rm -rf` appear here because you need them; none of them are safe to paste without reading the
  line above them.
- **Letting the glossary become a dictionary.** A term earns an entry only if the curriculum uses
  it and a learner could misread it. Growth for its own sake makes retrieval slower.

## Next

Back to whichever subject you are working through — or, if you have finished the curriculum, to
[20-PROJECT-LABORATORY/capstone-project/](../20-PROJECT-LABORATORY/capstone-project/README.md)
and then to open source, via
[19-PROFESSIONAL-DEVELOPMENT/open-source-contributions.md](../19-PROFESSIONAL-DEVELOPMENT/open-source-contributions.md).
