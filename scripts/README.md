# scripts/ — repository validation tooling

Lightweight Python tools that keep the curriculum structurally sound. Both run on stock
Python 3.9+ with no dependencies to install.

## Tools

| Script | What it checks | Run it with |
|---|---|---|
| `check-links.py` | Every relative Markdown link and image path resolves; every image has alt text | `python scripts/check-links.py` |
| `check-curriculum.py` | Required root files exist; every subject has a README with its overview sections; substantive lessons carry the required sections | `python scripts/check-curriculum.py` |

Useful variants:

```bash
python scripts/check-links.py 04-JAVA-PROGRAMMING   # validate one subject while drafting it
python scripts/check-curriculum.py --strict           # Phase K: require the complete 21-subject structure
```

Both exit non-zero on failure, so they slot directly into a CI job or a pre-commit habit:

```bash
python scripts/check-links.py && python scripts/check-curriculum.py
```

## What these tools do **not** do

They verify **structure**, never **educational quality**. A lesson can pass both scripts and still
be unclear, wrong, or patronizing. A script can confirm a heading exists; it cannot confirm the
section underneath it teaches anything.

Quality review is a human checklist, defined in [CONTRIBUTING.md](../CONTRIBUTING.md) and applied
before any lesson is marked Done in [ISSUE-REGISTER.md](../ISSUE-REGISTER.md):

- Does every concept get *what / why / how / when not to / trade-offs*?
- Are the examples runnable, with expected output and stated assumptions?
- Do the exercises ladder from guided to independent, with observable completion criteria?
- Are the diagrams technically accurate and explained in prose?
- Is any version-sensitive claim pinned in [VERSIONS.md](../VERSIONS.md)?

## Design notes

- No third-party packages: the tooling must never become a reason the checks do not run.
- Paths are resolved with `pathlib`, so the scripts behave the same on Windows, macOS, and Linux.
- External `https://` links are deliberately not validated: link checking over the network is
  flaky and belongs in a scheduled CI job, not in a local gate.