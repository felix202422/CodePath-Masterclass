#!/usr/bin/env python3
"""check-curriculum.py — structural completeness checks for the curriculum.

WHAT THIS TOOL CAN DO:
  * confirm the required root files exist
  * confirm every subject directory that exists has a README.md
  * confirm substantive lessons carry the required section headings
  * confirm subject READMEs carry the overview sections learners rely on
  * confirm image references throughout the repository carry alt text

WHAT THIS TOOL CANNOT DO (and never claims to):
  * prove a lesson explains its concept adequately
  * verify that code examples are correct or runnable
  * check that prerequisites are pedagogically sensible
Those require human review; see the quality checklist in CONTRIBUTING.md.

Modes:
    python scripts/check-curriculum.py            # validate whatever currently exists (daily use)
    python scripts/check-curriculum.py --strict   # require the complete 21-subject structure (Phase K)

Exit codes: 0 = structure is consistent, 1 = at least one structural problem.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

REQUIRED_ROOT_FILES = [
    "README.md", "ROADMAP.md", "CURRICULUM-MAP.md", "LEARNING-GUIDE.md",
    "PROGRESS-TRACKER.md", "CONTRIBUTING.md", "CODE_OF_CONDUCT.md", "LICENSE",
    "CHANGELOG.md", "SECURITY.md", "SUPPORT.md", "VERSIONS.md", "ISSUE-REGISTER.md",
    ".gitignore", ".editorconfig",
]

# The complete curriculum architecture. Numbered subjects 01..21 plus orientation 00.
SUBJECT_DIRS = [
    "00-START-HERE", "01-COMPUTER-FOUNDATIONS", "02-PROGRAMMING-FUNDAMENTALS",
    "03-DEVELOPER-TOOLS", "04-JAVA-PROGRAMMING", "05-DATA-STRUCTURES-AND-ALGORITHMS",
    "06-INTERNET-AND-WEB-FOUNDATIONS", "07-HTML-AND-CSS", "08-JAVASCRIPT-AND-TYPESCRIPT",
    "09-FRONTEND-ENGINEERING", "10-DATABASE-ENGINEERING", "11-BACKEND-ENGINEERING",
    "12-MOBILE-DEVELOPMENT", "13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE",
    "14-TESTING-AND-QUALITY", "15-APPLICATION-SECURITY", "16-DEVOPS-AND-INFRASTRUCTURE",
    "17-CLOUD-AND-PRODUCTION", "18-ADVANCED-ENGINEERING", "19-PROFESSIONAL-DEVELOPMENT",
    "20-PROJECT-LABORATORY", "21-REFERENCE-LIBRARY",
]

# Directories whose pages are reference/handout material, not full lessons.
COMPACT_OK_DIRS = {"21-REFERENCE-LIBRARY", "00-START-HERE"}
SKIP_DIRS = {".git", ".github", "node_modules", "target", "build", "dist", "__pycache__"}

# Sections every substantive lesson must carry (checked case-insensitively as H2 headings).
REQUIRED_LESSON_SECTIONS = [
    "Learning Objectives", "Prerequisites", "Common Mistakes", "Completion Criteria", "Summary",
]
# Sections required in every subject README.
REQUIRED_SUBJECT_README_SECTIONS = ["Prerequisites", "Lessons", "Next"]

H1 = re.compile(r"^#\s+\S", re.MULTILINE)
H2 = re.compile(r"^##\s+(.+)$", re.MULTILINE)
IMAGE_REF = re.compile(r"!\[([^\]]*)\]\(")


def h2_titles(text: str) -> list[str]:
    return [m.group(1).strip().lower() for m in H2.finditer(text)]


def section_present(titles_lower: list[str], wanted: str) -> bool:
    wanted = wanted.lower()
    return any(wanted in title for title in titles_lower)


def check_subject(subject: Path, errors: list[str]) -> tuple[int, int]:
    """Check one subject directory. Returns (files_checked, lessons_with_problems)."""
    checked = 0
    bad = 0
    readme = subject / "README.md"
    if not readme.exists():
        errors.append(f"{subject.name}/ has no README.md (required overview: what it covers, "
                      "prerequisites, lesson order, exercises, outcomes, next)")
        return 0, 0

    text = readme.read_text(encoding="utf-8", errors="replace")
    titles = h2_titles(text)
    for wanted in REQUIRED_SUBJECT_README_SECTIONS:
        if not section_present(titles, wanted):
            errors.append(f"{subject.name}/README.md missing overview section matching '{wanted}'")
    checked += 1

    subject_top_level_lessons = [
        p for p in sorted(subject.glob("*.md"))
        if p.name not in {"README.md"} and p.name.lower() != "readme.md"
    ]
    for lesson in subject_top_level_lessons:
        checked += 1
        if subject.name in COMPACT_OK_DIRS:
            continue  # orientation and reference pages may use the compact format
        lesson_text = lesson.read_text(encoding="utf-8", errors="replace")
        lesson_titles = h2_titles(lesson_text)
        if not H1.search(lesson_text):
            errors.append(f"{lesson.relative_to(REPO_ROOT)} has no top-level heading (# Title)")
            bad += 1
        for wanted in REQUIRED_LESSON_SECTIONS:
            if not section_present(lesson_titles, wanted):
                errors.append(
                    f"{lesson.relative_to(REPO_ROOT)} missing required lesson section: '{wanted}'"
                )
                bad += 1
    return checked, bad


def check_images(errors: list[str]) -> int:
    checked = 0
    for md in sorted(REPO_ROOT.rglob("*.md")):
        if any(part in SKIP_DIRS for part in md.parts):
            continue
        checked += 1
        for line_no, line in enumerate(md.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            for match in IMAGE_REF.finditer(line):
                if not match.group(1).strip():
                    errors.append(f"{md.relative_to(REPO_ROOT)}:{line_no} image without alt text")
    return checked


def main(argv: list[str]) -> int:
    strict = "--strict" in argv
    errors: list[str] = []

    for name in REQUIRED_ROOT_FILES:
        if not (REPO_ROOT / name).exists():
            errors.append(f"missing required root file: {name}")

    existing = [d for d in SUBJECT_DIRS if (REPO_ROOT / d).is_dir()]
    missing = [d for d in SUBJECT_DIRS if not (REPO_ROOT / d).is_dir()]
    if strict and missing:
        for d in missing:
            errors.append(f"missing required subject directory: {d}/ (--strict)")

    files_checked = 0
    lesson_problems = 0
    for name in existing:
        c, bad = check_subject(REPO_ROOT / name, errors)
        files_checked += c
        lesson_problems += bad

    images_checked = check_images(errors)

    for error in errors:
        print(f"FAIL  {error}")
    mode = "strict" if strict else "progressive"
    print(
        f"\ncheck-curriculum ({mode}): root files {len(REQUIRED_ROOT_FILES)}, "
        f"subjects present {len(existing)}/{len(SUBJECT_DIRS)}, "
        f"subject files checked {files_checked}, images checked {images_checked}, "
        f"{len(errors)} structural problem(s)."
    )
    if missing and not strict:
        print(f"Note: {len(missing)} subject directories not written yet (tracked in ISSUE-REGISTER.md).")
    if errors:
        return 1
    print("Structure is consistent. (Structural checks only — educational quality needs human review.)")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))