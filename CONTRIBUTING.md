# Contributing

Thanks for helping improve this repository. Contributions of every size are welcome: a typo fix,
a clearer explanation, a new exercise, a bug in an example, or a full lesson.

Please read [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) first. By participating you agree to it.

---

## Ground rules

1. **Accuracy over completeness.** If you cannot verify a claim against official documentation,
   mark it as unverified rather than presenting it as fact. Version-sensitive details must match
   [VERSIONS.md](VERSIONS.md).
2. **Never commit secrets.** No API keys, tokens, passwords, or private keys — in code, screenshots,
   logs, or tests. Use placeholders like `your-token-here`. See
   [SECURITY.md](SECURITY.md).
3. **No unearned attribution.** This repository is maintained by a single author. Do not add
   contributor lists, bot authorship, or co-author trailers without the maintainer's explicit
   approval.
4. **Explain, don't just show.** A code block without explanation is not a contribution here; every
   example needs the *why*, the expected output, and how to run it.

## Ways to contribute

| Type | What to do first | Where it lands |
|---|---|---|
| Typo / clarity fix | Just open a PR; no issue needed | Any lesson |
| Bug in an example (wrong output, broken command) | Open an issue stating lesson path, what you ran, what you expected, what happened | The lesson + its exercise set |
| Unclear explanation | Open an issue: which concept, what you understood instead, and where you looked | The lesson |
| New exercise or solution | Open an issue first (scope + difficulty + completion criteria) | `exercises/` of the subject |
| New lesson | Open an issue first; the scope is agreed before writing | Subject directory |
| New diagram | Open an issue naming the lesson, the concept, and the required accuracy | `assets/<topic>/` |

## Writing a lesson

1. Copy [templates/lesson-template.md](templates/lesson-template.md). The 16 sections are not
   decoration: each answers a question a learner actually has.
2. Follow the prerequisite discipline: link to the lesson that teaches each dependency — and if
   that lesson does not exist, say so in the issue so it gets written before yours lands.
3. Define every term the first time you use it. Assume an intelligent reader who has not been
   introduced to the jargon.
4. Include at least two introductory exercises, two intermediate ones, and one independent task,
   each with observable completion criteria.
5. State expected output for every example, and say whether the transcript is from a command
   actually executed or an illustration of expected behaviour.
6. Use relative links only. Reference images as
   `![descriptive alt text](../assets/<topic>/file.svg)` and explain each diagram's key elements in
   the surrounding text — never put essential information only inside an image.

## Quality gate for every pull request

A PR is reviewable when:

- [ ] `python scripts/check-links.py` passes (no broken relative links or image paths)
- [ ] `python scripts/check-curriculum.py` passes (required sections present)
- [ ] New or changed claims about tool behaviour are sourced (official docs linked) or marked unverified
- [ ] Examples compile/run where they claim to, and the tool version used is stated
- [ ] New diagrams have alt text and match the prose they accompany
- [ ] No secrets, no personal data, no copyrighted third-party material without permission

## Commit and pull request style

- Commits: imperative mood, scoped subject — `Add worked example to 10-.../indexes.md`.
- PRs: state **what changed**, **why**, and **how it was validated**. Link the issue.
- Keep PRs to one subject area; a PR that mixes a typo sweep with a new lesson is hard to review.

## Reporting problems with the material itself

- Errors and omissions: GitHub issue.
- Security-sensitive content (an example that teaches an unsafe pattern, a real credential in
  history): follow [SECURITY.md](SECURITY.md) — do not open a public issue.

## License of contributions

Contributions are accepted under the [MIT License](LICENSE). By submitting a contribution you
confirm it is your own work or freely reusable under MIT.