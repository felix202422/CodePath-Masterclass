# Solutions — Set 21: Build Tools

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — The greped transcript

```console
$ mvn clean package | grep -E "Compiling|BUILD|Building jar|Total time"
[INFO] Compiling 1 source file with javac [debug release 21] to target\classes
[INFO] Building jar: C:\…\target\demo-1.0.0.jar
[INFO] BUILD SUCCESS
[INFO] Total time:  7.325 s

$ java -cp target/classes App
built by Maven, release 21
$ echo $?
0
```

- The compile line **is** the POM's `maven.compiler.release` property arriving at the compiler
  plugin; the jar name **is** the coordinates (`artifactId-version.jar`).

**Criteria check:** ☐ four `[INFO]` lines ☐ run output ☐ exit 0.

## Exercise 2 — Cold vs warm, measured

```text
cold:  Total time: 17.500 s   (Downloading/Downloaded from central — plugin graph fetched)
warm:  Total time:  7.325 s   (no downloads — artifacts served from ~/.m2/repository)
```

- **Three sentences:** the first build resolved Maven's *own packaging-plugin dependencies*
  from `repo.maven.apache.org` and cached them in the local repository; the second run found
  every artifact locally and skipped the network; the delta (~10 s here) is transfer + handshake
  time — which is why CI caches `~/.m2`.

**Criteria check:** ☐ both numbers ☐ local-repository explanation.

## Exercise 3 — The release knob, proven twice

```text
release 21 → [INFO] Compiling … [debug release 21]   → javap -v: major version: 65
release 17 → [INFO] Compiling … [debug release 17]   → javap -v: major version: 61
```

- **Property → bytecode on disk:** the POM property configures the compiler plugin; the plugin
  passes `--release`; `javac` writes the class-file major (`10 + release − …` table: 17 → 61,
  21 → 65) — every link visible, none assumed.

**Criteria check:** ☐ both compiler lines ☐ 61 vs 65 majors ☐ chain explained.

## Exercise 4 — Two-class jar (independent)

**Reference shape:**

```console
$ mvn clean package   # (grepped lines as in Exercise 1, coordinates com.example:greet:1.0.0)
$ java -cp target/greet-1.0.0.jar com.example.greet.App
Hi, packages!
$ jar tf target/greet-1.0.0.jar | grep class
com/example/greet/Greeter.class
com/example/greet/App.class
```

- **The lesson-03 rule, survived:** `package com.example.greet;` still *is* the directory
  `com/example/greet/` — now inside the jar; the listing lines with paths are the proof. The
  `Main-Class` route (if chosen) cites `maven-jar-plugin`'s `archive/manifest` configuration
  docs — one citation, one decision stated.

**Criteria check:** ☐ build transcript ☐ run output ☐ jar listing ☐ plugin/doc citation.

---

[Back to the exercise sets](../README.md)
