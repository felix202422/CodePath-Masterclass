# assets/ — visual learning system

Every visual used in this repository lives here, organized by curriculum subject. Visuals support
the written explanations — they never replace them, and no essential information exists *only*
inside an image.

## Layout

| Directory | Holds | Used by |
|---|---|---|
| `assets/branding/` | Wordmark and banner | README, headers |
| `assets/computer-foundations/` | Hardware, memory, and execution diagrams | 01 |
| `assets/programming/` | Control-flow, function, and debugging diagrams | 02 |
| `assets/tools/` | Terminal, Git workflow, and branching diagrams | 03 |
| `assets/java/` | OOP relationships, JVM internals | 04 |
| `assets/algorithms/` | Data-structure and algorithm-trace diagrams | 05 |
| `assets/web/` | Request lifecycle, DNS, TLS, rendering | 06 |
| `assets/frontend/` | HTML/CSS layout, React component and state diagrams | 07–09 |
| `assets/databases/` | ER diagrams, join illustrations, index and query-plan diagrams | 10 |
| `assets/backend/` | Layered architecture, request flow, auth flows | 11 |
| `assets/mobile/` | Widget trees, navigation and state flows | 12 |
| `assets/architecture/` | Architecture styles, ADR diagrams | 13 |
| `assets/testing/` | Test pyramid, pipeline quality gates | 14 |
| `assets/security/` | Threat models, attack-flow diagrams (defensive context) | 15 |
| `assets/devops/` | Container, CI/CD pipeline, and infrastructure diagrams | 16 |
| `assets/cloud/` | Deployment topology, scaling and observability diagrams | 17 |
| `assets/projects/` | Project wireframes and reference screenshots | 20 |

A directory is created **when its first real diagram lands** — never in advance. Empty folders are
noise; this manifest is the map of what exists and what is planned.

## Format policy

| Prefer | For | Why |
|---|---|---|
| **Mermaid blocks in Markdown** | Structural diagrams (flows, trees, sequences) that live inside a lesson's prose | They render on GitHub, stay next to the text that explains them, and are editable by any contributor |
| **SVG files in this directory** | Flagship diagrams reused across lessons, and anything with precise geometry | Crisp at any zoom, small on disk, diffable, editable with any text editor |
| **PNG/WebP** | Screenshots and raster-only material | When detail genuinely cannot be vector (real UI captures) |

Never substitute a generated illustration for a precise technical diagram. A decorative picture of
"cybersecurity" teaches nothing; a correct request-flow diagram teaches everything.

## Sourcing, licensing, and attribution

1. **Original work first.** Diagrams in this repository are drawn for it. Original work needs no
   attribution entry, but is still listed below so the provenance of every file is auditable.
2. **Screenshots are real or labelled.** A screenshot is only included when it was actually
   captured from the documented software. Illustrations that resemble a UI are explicitly captioned
   as illustrations.
3. **Third-party assets** (icons, photographs, borrowed diagrams) are only included when their
   license permits reuse, with author, license, and source recorded in the table below. If the
   licensing status cannot be established, the asset is not included.
4. **No copyrighted textbook or paid-course material** is reproduced in any form.

## Asset manifest

| File | Topic | Type | Source / author | License | Notes |
|---|---|---|---|---|---|
| `branding/wordmark.svg` | Branding | SVG | Original, drawn for this repository | MIT (same as repository) | Wordmark used in the README header |
| `computer-foundations/computer-architecture.svg` | Computer architecture | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 01 `computer-hardware.md` |
| `computer-foundations/storage-hierarchy.svg` | Storage hierarchy | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 01 `computer-hardware.md` |
| `programming/assignment-and-rebinding.svg` | Variable binding and rebinding | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 02 `variables-and-data-types.md` |
| `programming/function-call-stack.svg` | Call stack frames on function call | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 02 `functions-and-methods.md` |
| `programming/debugging-cycle.svg` | The debugging cycle | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 02 `debugging-fundamentals.md` |
| `tools/git-three-areas.svg` | Git's three areas and the pointer chain | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 03 `git-fundamentals.md` |
| `tools/branch-merge-flow.svg` | Branch divergence, merge commit, conflict markers | SVG | Original, drawn for this repository | MIT (same as repository) | Used by 03 `branching-and-merging.md` |

## Naming and quality rules

- Descriptive kebab-case names: `inheritance-hierarchy.svg`, not `diagram1.png`.
- Consistent terminology: a diagram must use the same term the lesson uses (e.g. "component", not
  "widget" in a React lesson).
- Legible at 100% zoom, with text that survives GitHub's rendering; minimum body text ~12 px
  in the SVG coordinate space.
- Every referenced image must carry meaningful alt text, e.g.
  `![Inheritance hierarchy: Shape is the parent of Circle and Rectangle](../assets/java/inheritance-hierarchy.svg)`
- One file per concept; no duplicate copies of the same drawing in different folders.

## Referencing assets from a lesson

From a lesson inside a subject directory, the path is always `../assets/<topic>/<file>`:

```markdown
![Two clients sending requests through DNS and TLS to a server](../assets/web/request-lifecycle.svg)
```

Then explain the diagram's key elements in the surrounding prose — the image is support, not the
lesson. `scripts/check-links.py` verifies that every referenced path exists and that alt text is
present.