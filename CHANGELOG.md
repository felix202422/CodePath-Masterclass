# Changelog

All notable changes to this repository are documented here.
Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning follows a simple
`MAJOR.MINOR.PATCH` for curriculum releases (MAJOR = restructured curriculum, MINOR = new subject or
milestone completed, PATCH = corrections and clarity fixes).

## [Unreleased]

### Added

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