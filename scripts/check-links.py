#!/usr/bin/env python3
"""check-links.py — validate relative Markdown links and image references.

Repository quality tool for CodePath-Masterclass. Structural check only: it proves that a target
path exists on disk, not that the target teaches the right thing.

Checks performed for every *.md file in the repository:
  * every relative Markdown link [text](target) resolves to an existing file or directory
  * every relative image reference ![alt](target) resolves to an existing asset file
  * every image reference has non-empty alternative text (accessibility)

Two failure classes are reported separately:
  FAIL   the reference is broken (a typo, or a file that was moved/renamed)
  PLAN   the reference points into a curriculum subject directory that is not written yet.
         While the curriculum is under construction these are warnings — every one of them is
         tracked in ISSUE-REGISTER.md. Pass --strict (Phase K) to treat them as failures.

Deliberately ignored:
  * external links (http/https/mailto/tel) — network link checking belongs in scheduled CI
  * in-page anchors (#section)
  * anything inside a fenced code block (``` or ~~~) — code fences contain illustrative examples
    by design, such as the syntax for referencing a future asset
  * templates/ — the templates contain placeholder paths by design

Usage:
    python scripts/check-links.py               # check the whole repository
    python scripts/check-links.py 04-JAVA-...   # check one subdirectory
    python scripts/check-links.py --strict      # planned curriculum files count as failures

Exit codes: 0 = no broken references, 1 = at least one broken reference (or planned, under --strict).
"""

from __future__ import annotations

import re
import sys
import urllib.parse
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

SKIP_DIRS = {".git", ".github", "node_modules", "target", "build", "dist",
             ".dart_tool", "__pycache__", "templates"}

# The 22 curriculum subject directories (mirrors check-curriculum.py).
SUBJECT_DIRS = {
    "00-START-HERE", "01-COMPUTER-FOUNDATIONS", "02-PROGRAMMING-FUNDAMENTALS",
    "03-DEVELOPER-TOOLS", "04-JAVA-PROGRAMMING", "05-DATA-STRUCTURES-AND-ALGORITHMS",
    "06-INTERNET-AND-WEB-FOUNDATIONS", "07-HTML-AND-CSS", "08-JAVASCRIPT-AND-TYPESCRIPT",
    "09-FRONTEND-ENGINEERING", "10-DATABASE-ENGINEERING", "11-BACKEND-ENGINEERING",
    "12-MOBILE-DEVELOPMENT", "13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE",
    "14-TESTING-AND-QUALITY", "15-APPLICATION-SECURITY", "16-DEVOPS-AND-INFRASTRUCTURE",
    "17-CLOUD-AND-PRODUCTION", "18-ADVANCED-ENGINEERING", "19-PROFESSIONAL-DEVELOPMENT",
    "20-PROJECT-LABORATORY", "21-REFERENCE-LIBRARY",
}

MD_REF = re.compile(r"(!?)\[([^\]]*)\]\(([^)\s]+)(?:\s+\"[^\"]*\")?\)")
FENCE = re.compile(r"^\s*(```|~~~)")


def iter_markdown_files(root: Path):
    for path in sorted(root.rglob("*.md")):
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        yield path


def is_planned_target(resolved: Path) -> bool:
    """True when the missing target lives inside a curriculum subject directory."""
    try:
        relative = resolved.relative_to(REPO_ROOT)
    except ValueError:
        return False
    return bool(relative.parts) and relative.parts[0] in SUBJECT_DIRS


def check_file(md_file: Path, strict: bool) -> tuple[list[str], list[str]]:
    errors: list[str] = []
    planned: list[str] = []
    text = md_file.read_text(encoding="utf-8", errors="replace")
    rel_file = md_file.relative_to(REPO_ROOT)

    in_fence = False
    for line_no, line in enumerate(text.splitlines(), start=1):
        if FENCE.match(line):
            in_fence = not in_fence
            continue
        if in_fence:
            continue

        # Inline code spans (`...`) contain illustrative paths by design; strip before matching.
        line = re.sub(r"`[^`]*`", "", line)

        for match in MD_REF.finditer(line):
            is_image, alt_or_text, target = match.group(1), match.group(2), match.group(3)

            if target.startswith(("http://", "https://", "mailto:", "tel:")):
                continue  # external links are not validated here (no network dependency)
            if target.startswith("#"):
                continue  # in-page anchor
            if " " in target or target.startswith("<"):
                errors.append(f"{rel_file}:{line_no} malformed Markdown target: {target!r}")
                continue

            if is_image and not alt_or_text.strip():
                errors.append(f"{rel_file}:{line_no} image with empty alt text: {target!r} "
                              "(describe the diagram for screen readers)")

            path_part = urllib.parse.unquote(target.split("#", 1)[0])
            if not path_part:
                continue

            resolved = (md_file.parent / path_part).resolve()
            if resolved.exists():
                continue

            message = f"{rel_file}:{line_no} unresolved reference: {target!r}"
            if is_planned_target(resolved):
                if strict:
                    errors.append(message + " [--strict: planned curriculum files must exist in Phase K]")
                else:
                    planned.append(message)
            else:
                errors.append(message)

    return errors, planned


def main(argv: list[str]) -> int:
    strict = "--strict" in argv
    scope_args = [a for a in argv if not a.startswith("--")]
    scope = REPO_ROOT
    if scope_args:
        scope = (REPO_ROOT / scope_args[0]).resolve()
        if not scope.exists():
            print(f"error: scope path does not exist: {scope}")
            return 1

    all_errors: list[str] = []
    all_planned: list[str] = []
    files_checked = 0

    for md_file in iter_markdown_files(scope):
        files_checked += 1
        errors, planned = check_file(md_file, strict)
        all_errors.extend(errors)
        all_planned.extend(planned)

    for message in all_planned:
        print(f"PLAN  {message}")
    for message in all_errors:
        print(f"FAIL  {message}")

    mode = "strict" if strict else "progressive"
    print(
        f"\ncheck-links ({mode}): {files_checked} Markdown files checked, "
        f"{len(all_errors)} broken reference(s), {len(all_planned)} planned-but-unwritten target(s)."
    )
    if all_errors:
        print("Broken references must be fixed before a batch is considered complete.")
        return 1
    if all_planned:
        print("All resolved references are valid; planned targets are tracked in ISSUE-REGISTER.md.")
    else:
        print("All relative links and image paths resolve.")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))