# Solutions — Set 16: File Handling

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The toolbox transcript

```console
lines=[alpha, beta] bytes=11
  > alpha
  > beta
  > gamma
after write-list: alpha|beta|gamma|one|two
copy exists=true
upper-copied lines=5
out.txt: ALPHA|BETA|GAMMA|ONE|TWO
copy exists after delete=false
NoSuchFile: missing.txt
$ echo $?
0
```

- **`bytes=11`** = `"alpha\nbeta\n"` counted as bytes; the typed `NoSuchFileException` catch is
  why the run still exits **0** — handled failure, not swallowed.

**Criteria check:** ☐ nine lines ☐ `bytes=` counted ☐ exit 0.

## Exercise 2 — café, byte-for-byte

**Reference:** `Files.writeString(p, "café\n")` then `Files.size(p)`:

```text
UTF-8: size = 6   (c,a,f,é=2 bytes,\n)   — non-ASCII é takes 2 bytes in UTF-8, 1 char
readAllLines → ["café"];  "café".length() = 4
```

- **Bytes ≠ chars:** `size` counts encoding bytes (6), `length()` counts UTF-16 code units (4).
  On a machine whose platform default is UTF-8 (as `mvn -version` printed here) the round trip
  also succeeds — which is exactly why cross-machine files should state the charset.

**Criteria check:** ☐ size recorded + explanation ☐ re-read equals input.

## Exercise 3 — Two failure kinds, two subtypes

```text
missing file:      NoSuchFileException getFile() = missing.txt
directory-as-file:  (Windows: AccessDeniedException / (other OS: IOException: Is a directory))
                   getFile() reports the directory path, not the file inside it
```

- Subtypes let you treat *recoverable-missing* (create it / skip) differently from
  *wrong-kind* (your path logic is broken) — `catch (IOException)` alone flattens that choice.

**Criteria check:** ☐ two transcripts ☐ paths compared ☐ subtype value stated.

## Exercise 4 — Crash-safe writer (independent)

**Reference flow:** `write(tmp, …)` → `Files.move(tmp, target, REPLACE_EXISTING, ATOMIC_MOVE)`
→ success; forced failure *before* the move leaves `target`'s old content intact.

```text
write OK, size=…
forced failure: row 3 infeasible (pre-move)
target intact: <old content identical>
```

- **Guarantee split (cited from the JDK `StandardCopyOption` docs):** `ATOMIC_MOVE` makes the
  rename all-or-nothing *if* the filesystem supports it — same-filesystem requirement — and
  says nothing about the *source* write's durability; the temp file must live in the target's
  directory.

**Criteria check:** ☐ guarantees as assertions first ☐ five predicted-then-run lines ☐ doc
citation with URL.

---

Next: [set-17-solutions.md](set-17-solutions.md)
