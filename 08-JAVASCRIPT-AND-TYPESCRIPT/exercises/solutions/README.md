# Solutions — 08 JavaScript and TypeScript

**⚠ Attempt the sets first.** Reading a solution produces recognition, which feels like
knowledge and is not. One week after reading any solution here, rebuild that answer from a
blank page — the second attempt is the one you keep.

One solution file per set, matching the lesson of the same name. Transcripts marked as
*authoring machine* were executed during this batch on Windows 11 / Git Bash with the tools in
[VERSIONS.md](../../../VERSIONS.md) (Node 24.13.1, tsc 7.0.2 under `--strict`, headless
Chrome 156 for the DOM set). Your versions' exact text will differ — the **behaviour and the
reasoning** are the criteria; your own captured output is your evidence.

| Set | Lesson | File |
|---|---|---|
| 1 | JavaScript fundamentals | [set-1-solutions.md](set-1-solutions.md) |
| 2 | Functions and scope | [set-2-solutions.md](set-2-solutions.md) |
| 3 | Arrays and objects | [set-3-solutions.md](set-3-solutions.md) |
| 4 | DOM and events | [set-4-solutions.md](set-4-solutions.md) |
| 5 | Modules | [set-5-solutions.md](set-5-solutions.md) |
| 6 | Promises and async/await | [set-6-solutions.md](set-6-solutions.md) |
| 7 | Event loop | [set-7-solutions.md](set-7-solutions.md) |
| 8 | Error handling | [set-8-solutions.md](set-8-solutions.md) |
| 9 | TypeScript fundamentals | [set-9-solutions.md](set-9-solutions.md) |
| 10 | Types and interfaces | [set-10-solutions.md](set-10-solutions.md) |
| 11 | Generics | [set-11-solutions.md](set-11-solutions.md) |
| 12 | Type narrowing | [set-12-solutions.md](set-12-solutions.md) |

**About reference transcripts:** where a solution quotes output, it is the authoring machine's
real capture, not a mock-up — every `tsc` exit code, diagnostic line, `node` trace, and
headless-Chrome DOM trail in these files was re-executed while writing them. Where a solution
gives a *shape* (tables, layouts, taxonomies), no single correct text exists — the criteria in
the set's [README](../README.md) define what a reviewer looks for.

**Two executed corrections worth knowing** (fixed in the lessons during this batch): `typeof`
on a TDZ binding **does** throw `ReferenceError` (only never-declared names get the free
`undefined`), and the pinned-generic misuse `first<number>(["a"])` reports `TS2322` for a fresh
literal (`TS2345` when the argument is a pre-built variable) — both re-verified against tsc
and Node on this machine.
