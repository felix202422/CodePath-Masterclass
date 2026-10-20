# Changelog

All notable changes to this repository are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows a simple
`MAJOR.MINOR.PATCH` for curriculum releases (MAJOR = restructured curriculum, MINOR = new subject or
milestone completed, PATCH = corrections and clarity fixes).

## [Unreleased]

### Added

- **Subject 04 — Java Programming** — twenty-one lessons (environment setup through build tools)
  with every transcript **executed** on the authoring machine (JDK 25.0.4.1 with
  `javac --release 21`, Maven 3.9.16): the compile/run cycle with `javap` major-version proof,
  verbatim compiler and runtime error transcripts (truthy refusal, `private access`, `new T()`
  erasure refusals, CME, deadlock dumps, OOM-inside-the-catch at `-Xmx32m`/`-Xmx64m`), a
  two-run lost-update race (39251 / 39633) beside executed `synchronized`/`AtomicInteger` fixes,
  a full Maven build end-to-end (cold 17.5 s vs warm 7.3 s, `BUILD SUCCESS`, jar run output),
  one original SVG diagram (`assets/java/inheritance-diagram.svg`), twenty-one exercise sets
  and twenty-one separated solution files. Gradle is absent from the writing machine and is
  labelled as such rather than simulated. — ten lessons (terminal fundamentals, Windows environment,
  Linux fundamentals, editors and IDEs, package managers, environment variables, Git fundamentals,
  branching and merging, GitHub workflows, pull requests and code review) with transcripts
  executed on the authoring machine (Git Bash, Git 2.55.0; PowerShell, cmd, and `wsl --status`
  probes actually run; sandbox repositories using a placeholder identity); two original SVG
  diagrams (`assets/tools/`); and `troubleshooting/` — nine diagnosis guides plus the graded
  drills in `exercises.md` that carry this subject's practice per `CURRICULUM-MAP.md`. GitHub web
  UI, Actions, and real-Linux blocks are labelled illustrations where they could not be executed.
- **Subject 02 — Programming Fundamentals** — twelve lessons (computational thinking through
  modular programming) with every Python transcript **executed** on the authoring machine
  (Python 3.13.5), three original SVG diagrams (`assets/programming/`: assignment/rebinding,
  call stack, debugging cycle), twelve exercise sets and twelve separated solution files, plus a
  modular-programming capstone whose reference implementation was run and hand-verified.
- **Version baseline** — `VERSIONS.md` pinning every tool version lessons are written against,
  verified 2026-10-17 against official sources, with deliberate-choice rationales.
- **Issue register** — `ISSUE-REGISTER.md`: the full curriculum backlog with milestones, a standard
  issue template, status tracking, and an always-current unfinished-work summary.
- **Textbook homepage** — `README.md` with mission, audience table, learning path, full table of
  contents, exercise rules, and the six-level proficiency system.
- **Navigation system** — `ROADMAP.md` (11 competence-gated milestones with promotion criteria),
  `CURRICULUM-MAP.md` (competency → lesson → exercise → project), `LEARNING-GUIDE.md` (evidence-
  based study method), `PROGRESS-TRACKER.md` (eight tracked dimensions, six levels).
- **Project policies** — `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1),
  `SECURITY.md`, `SUPPORT.md`.
- **Templates** — lesson, exercise, project, and progress templates in `templates/`.
- **Validation tooling** — `scripts/check-links.py` (relative link and image resolution) and
  `scripts/check-curriculum.py` (structure and required-section checks).
- **Visual learning system** — `assets/` with per-topic subdirectories, an original SVG branding
  mark, and a manifest documenting source, license, and attribution rules for every asset.

### Notes

- All curriculum lesson content ships in later batches, tracked per-file in
  [ISSUE-REGISTER.md](ISSUE-REGISTER.md). Nothing in this repository is claimed as complete before
  it passes the quality gate described in [CONTRIBUTING.md](CONTRIBUTING.md).

[Unreleased]: https://github.com/felix202422/CodePath-Masterclass/compare/main...HEAD