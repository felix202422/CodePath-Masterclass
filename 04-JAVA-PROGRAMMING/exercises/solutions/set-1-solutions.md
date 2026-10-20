# Solutions — Set 1: Environment Setup

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Tool-check block

**Reference transcript (authoring machine):**

```console
$ which javac java
/c/Program Files/Common Files/Oracle/Java/javapath/javac
/c/Program Files/Common Files/Oracle/Java/javapath/java

$ javac -version
javac 25.0.4.1

$ java -version
java version "25.0.4.1" 2026-08-18 LTS
```

- **Two answers, two questions:** `javac -version` reports the **compiler**, `java -version` the
  **runtime**. With several JDKs installed they may legitimately differ — compare before blaming
  code. `which` shows this machine resolves through Oracle's `javapath` shim while `JAVA_HOME`
  names the real directory.

**Criteria check:** ☐ four outputs ☐ compiler-vs-runtime sentence.

## Exercise 2 — Prove the level

```console
$ javac --release 21 Hello.java && java Hello
Java 25 via --release 21

$ javap -v Hello.class | grep -E 'major|minor|public class'
public class Hello
  minor version: 0
  major version: 65
```

- **65 = release 21's class-file format** (17 → 61, 21 → 65, 25 → 69). The running JVM printed
  25 — `--release` bound the *compiler*; the version claim is evidence, not adjective.

**Criteria check:** ☐ output captured ☐ `major version: 65` (or your pair).

## Exercise 3 — The failure messages, by layer

```console
$ javac --release 99 Bad.java
error: invalid target release: 99
```

```console
$ javap -version
/usr/bin/bash: line 7: javap: command not found
```

- **Layer map:** unknown release → *code/config* layer (the compiler lists valid levels);
  `command not found` → *tool/PATH* layer (the shell never reached a compiler). Fix the layer
  the message names — PATH before POM, POM before syntax.

**Criteria check:** ☐ two real messages ☐ layer labels.

## Exercise 4 — The triage ladder (independent)

**Reference shape.** Three layers, three commands, three proofs:

| Layer | Command | If it fails, it's… |
|---|---|---|
| Tool | `which java` / `where java` | install/PATH — nothing else can be diagnosed yet |
| Environment | `java -version; echo $JAVA_HOME` | version skew or a broken `JAVA_HOME` (Maven's `JAVA_HOME is not defined correctly` form) |
| Code | `javac --release 21 X.java` | the compiler's own message — now read it |

**Why a reviewer accepts this:** the ladder never lets a syntax error masquerade as a setup
problem — each step only runs after the previous one proves the layer beneath is healthy.

**Criteria check:** ☐ three layers ☐ three commands ☐ three real outputs.

---

Next: [set-2-solutions.md](set-2-solutions.md)
