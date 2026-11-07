# Reference solution guide — Project 01

> **Stop.** This guide assumes you have already attempted the brief and checked the acceptance
> criteria yourself. Reading it first replaces the work with recognition, which is not the skill the
> project is graded on.

This is a design walkthrough of one defensible solution. It is not a file dump: there is no complete
source here, and copying the prose will not produce a passing project. Where a decision had
alternatives, the alternative is named and its cost stated.

## Shape

Three layers, with the CLI as thin as possible:

```text
cli.py         argparse, exit-code mapping, no rules
commands.py    one function per command: load, call domain, render, return code
domain.py      parsing, validation, totals, duplicate rule — pure, no I/O
storage.py     JSONL read (streamed), append, atomic rewrite
formatting.py  table renderer and JSON renderer
```

The boundary that matters is `commands.py` → `domain.py`. Every rule that a test should be able to
check without a subprocess lives in `domain.py`, which is why `test_domain.py` is the largest test
file and also the fastest.

## Money and dates

Amounts are parsed by string surgery, never by `float`:

```python
def parse_amount(text: str) -> int:
    cleaned = text.strip().replace(" ", "")
    if cleaned.count(",") == 1 and "." not in cleaned:
        cleaned = cleaned.replace(",", ".")
    sign = -1 if cleaned.startswith("-") else 1
    whole, _, fraction = cleaned.lstrip("+-").partition(".")
    ...
```

Two decisions are embedded there. First, **one separator convention per input**: `"1,234.50"` is
ambiguous, so the parser accepts `,` only when there is exactly one comma and no dot, and rejects the
rest with a message. Second, **minor units at the boundary**: the function returns an `int`, and no
later code sees a float. A solution that stores `12.34` as a float passes the happy-path tests and
fails `AC-6` on a fixture with many small values, because `0.1 + 0.2` is not `0.3`.

Dates are parsed by trying the three formats explicitly, not by `dateutil`-style guessing:

```python
FORMATS = ("%Y-%m-%d", "%d/%m/%Y", "%Y/%m/%d")
```

`03/04/2026` is ambiguous in principle; the brief fixes the interpretation to day-first, and the
parser refuses anything that does not match exactly one format. That refusal is what makes `AC-4`
testable.

## Storage

JSONL, append-only, one object per line. Reading streams the file and yields validated records;
a malformed line raises a domain error carrying the line number, which `commands.py` turns into a
message and exit code 1.

Writes use the temp-file-and-rename pattern, even for appends that need to rewrite the file (dedup or
sorting): write `ledger.jsonl.tmp`, `flush()`, `os.fsync()`, then `os.replace()`. `os.replace` is
atomic on the same filesystem on both Windows and POSIX, which is why `NFR-3` is achievable without a
database. A naive `open(path, "w")` truncates the ledger before the first record is written, so a crash
loses everything — that is the failure the acceptance test simulates.

The duplicate rule (FR-7) needs an index, not a scan per `add`: load the file once, build a set of
`(date, amount_minor, category, note)` tuples, check membership. On 100,000 records this is one pass
and a small set, which is what makes `NFR-1` and `FR-7` compatible.

## Import

`csv.reader` over an opened file object, line by line, with a `max_line_length` guard:

```python
for line_number, row in enumerate(reader, start=2):  # header is line 1
```

Each row is validated by the same `domain.validate()` used by `add`; rejections are collected as
`(line_number, reason)` and printed after the summary. `--dry-run` runs the identical loop and skips
the write, which is why the counts are trustworthy: there is one code path, not two.

The subtle part is that import must not be a second implementation of validation. A solution that
validates CSV rows inline passes `AC-7` and then diverges from `add` on the next bug fix; a reviewer
sees it in the diff.

## Exit codes

A single mapping table in `cli.py`:

| Exception | Exit |
|---|---|
| `UsageError` | 2 |
| `DuplicateError` | 3 |
| `DataFileError` (I/O, corrupt line) | 4 for unreadable, 1 for partial import |
| anything unexpected | 1, with a traceback only under `--debug` |

The brief's codes are a contract; a solution that returns 1 for everything passes the acceptance
criteria except `AC-7` and `AC-8`, which is why they are written as separate criteria.

## Tests

The layer split makes the test pyramid straightforward:

- `test_domain.py` — table-driven parameters for both parsers, totals over a fixture, duplicate
  detection. No filesystem.
- `test_storage.py` — append, atomic rewrite, truncated line, simulated `os.replace` failure.
- `test_cli.py` — a handful of subprocess tests for the contract: exit codes, `--json` cleanliness,
  empty ledger.

The performance test (`AC-11`) generates 100k records once into a temp file and is marked so it can be
skipped in a fast loop; a test that takes seconds on every run gets deleted by the third week.

## Trade-offs and alternatives

- **SQLite instead of JSONL.** Better for concurrent writers and queries; worse for diffability and for
  teaching file-safety. Either is defensible — the ADR is where you say why.
- **Append-only versus in-place rewrite.** Append-only is simpler and safer; dedup and `--limit` become
  read-time concerns. The solution rewrites only when a record must be removed or corrected (not in
  the core requirements).
- **Table rendering.** Hand-rolled padding versus `tabulate`. The standard library constraint makes the
  choice for you here, and `formatting.py` is small enough that the dependency would not earn its place.
- **`argparse` subparsers versus a dispatch dict.** Subparsers give free help text; the dispatch dict
  gives testability. The solution uses subparsers with a thin dispatch function, because `--help`
  quality is graded.

## What is deliberately missing

The full source. Every function above is described by its contract and its hard cases; writing it is
the project. If you are stuck, read the tests you would write for it before reading anything else —
the test list is the specification in executable form.

## Acceptance self-check

Run the acceptance criteria in order and mark each one. The three that catch most submissions:

- `AC-6` — totals to the cent on a fixture with 0.10, 0.20 and 0.30.
- `AC-9` — corrupt line leaves the file unchanged, not truncated.
- `AC-10` — `--json` emits no table text, including no "no expenses recorded" line on stdout.
