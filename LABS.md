# Labs — where the transcripts come from

Lessons in this repository claim "executed" next to their outputs. This page is the map
behind those claims: the lab each subject's transcripts were produced in, how to stand up
the same one, and which labs ship with the repository. The policy itself is pinned in
[VERSIONS.md](VERSIONS.md) — where your versions differ, the *behaviour* is the criterion
and the exact text is yours to capture.

## The labs at a glance

| Lab | Subjects it serves | You need | Ships with the repo? |
|---|---|---|---|
| PostgreSQL lab | 10 | Any PostgreSQL server, psql 16.4+ | **Yes** — [`10-DATABASE-ENGINEERING/postgresql/`](10-DATABASE-ENGINEERING/postgresql/README.md) |
| Java lab | 04, 05 | JDK 21+ (`javac`, `java`, `javap`) | Bootstrap below |
| Browser lab | 06, 07 | Chrome (or any DevTools-capable browser) | Bootstrap below |
| JavaScript/TypeScript lab | 08 | Node 24, `tsc` | Bootstrap below |
| React lab | 09 | Vite + React + Vitest | Setup block in [09 exercises](09-FRONTEND-ENGINEERING/exercises/README.md) |
| Validation tooling | all | Python 3.9+, no packages | **Yes** — [`scripts/`](scripts/README.md) |

## PostgreSQL lab (subject 10)

The only lab shipped as files: [`10-DATABASE-ENGINEERING/postgresql/`](10-DATABASE-ENGINEERING/postgresql/README.md)
contains the `shop` schema and seed, seven check queries, their captured outputs, and
`verify.sh`, which rebuilds a scratch database and diffs everything:

```bash
cd 10-DATABASE-ENGINEERING/postgresql
PGHOST=127.0.0.1 PGPORT=5432 PGUSER=you bash verify.sh   # 7 passed, 0 failed
```

The server can be anything local (a system install, a VM, a container); only the client
version matters, because the dumps use psql's `\restrict` meta-command (psql 16.4+).
Databases in this lab are disposable — every lesson tells you when it destroys and
rebuilds its schema.

## Java lab (subjects 04 and 05)

One scratch directory per rung; compile and run with the toolchain the lessons pin
(`--release 21`, verified with `javap`):

```bash
mkdir -p lab && cd lab
cat > Hello.java <<'EOF'
public class Hello {
    public static void main(String[] args) {
        System.out.println("java " + System.getProperty("java.version"));
    }
}
EOF
javac --release 21 Hello.java && java Hello
javap -v Hello | grep 'major version'     # major version: 65
```

Discipline the lessons assume: one idea per file, the transcript you paste is the file you
ran, and errors are captured verbatim (the message *is* the lesson). Authoring machine:
JDK 25 compiling with `--release 21` — see [VERSIONS.md](VERSIONS.md).

## Browser lab (subjects 06 and 07)

No build step: an `.html` file opened in a browser, DevTools open beside it. What the
transcripts rely on:

- **DevTools** for the network waterfall (subject 06 request/response traces), the
  computed box model, and element inspection (subject 07 layout debugging).
- **A responsive mode** at the widths the responsive-design lesson names (360, 768,
  1440) — completion criteria in the exercises are stated at those widths.
- **Accessibility pane + keyboard-only navigation** for the accessibility lessons.

Capture screenshots only where a lesson's criteria ask for visual evidence; a criterion
that says "assert" wants a transcript, not a picture.

## JavaScript/TypeScript lab (subject 08)

Sets 1–8 run in plain Node; sets 9–12 add `tsc`:

```bash
node -e 'console.log(typeof [])'          # quick probes, one per line of the lesson
npx tsc --noEmit                          # the type gate every TS set ends with
```

The lab the sets describe — tsconfig strictness flags, the `--strict` on/off comparison,
the diagnostics you are asked to capture — is specified in
[08 exercises](08-JAVASCRIPT-AND-TYPESCRIPT/exercises/README.md). Authoring machine:
Node 24.13.1, tsc 7.0.2.

## React lab (subject 09)

The full bootstrap (Vite `react-ts` template, Vitest, React Testing Library, jsdom, and
the two `package.json` scripts) is a ready-to-paste block in
[09 exercises](09-FRONTEND-ENGINEERING/exercises/README.md) under *The lab you need* —
it is the exact shape every lesson's probes ran in. Two rules from that page carry into
every set: predictions on paper before running, and an assertion wherever the criterion
says "assert" (a `console.log` proves it ran; an assertion proves it holds).

## Validation tooling (all subjects)

Structure and links are checked by the repository's own Python tools — no lab required:

```bash
python scripts/check-links.py        # every relative link/image resolves, alt text present
python scripts/check-curriculum.py   # required files, README sections, lesson sections
```

They validate structure, never educational quality; the quality checklist lives in
[CONTRIBUTING.md](CONTRIBUTING.md). Run both before every commit — CI does.

## Reproducing any transcript yourself

1. **Predict first.** Write the output you expect before you run the command; a
   prediction you did not write down is not a prediction.
2. **Run it in the matching lab** above, with the versions [VERSIONS.md](VERSIONS.md)
   pins where you can.
3. **Keep the failure outputs.** The error transcripts are as important as the passing
   ones — every lesson quotes both.
4. **Diff against `expected/`** where the lab ships captures (the PostgreSQL lab), and
   against the lesson's blocks elsewhere. Behaviour must match exactly; column widths and
   version banners may differ with your machine, and you say so in your notes.

## Where lab work graduates

Labs are for drills. When an exercise asks you to build something with a shape — a
responsive landing page, a component system — the brief lives with the other guided
work: [07-HTML-AND-CSS/projects/](07-HTML-AND-CSS/projects/README.md),
[09-FRONTEND-ENGINEERING/projects/](09-FRONTEND-ENGINEERING/projects/README.md), and
the full builds in [20-PROJECT-LABORATORY](20-PROJECT-LABORATORY/README.md).
