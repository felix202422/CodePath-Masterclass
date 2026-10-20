# Solutions — Set 2: Program Structure

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Two classes, two class files

**Answer.** `javac Structure.java` produces `Structure.class` **and** `Helper.class` — a second
top-level class in the same source file becomes its own class file without its own source file.
The lesson's executed run lists `Helper.class` in the directory listing.

**Criteria check:** ☐ both class files listed from a real listing.

## Exercise 2 — Arguments arrive in `main`

**Reference output shape** (three args `one two three`):

```console
$ java Structure one two three
args=3
one
two
three
```

- The launcher passes everything after the **class name** into `args`; `args.length` is 3 and
  indices 0–2 hold the values in order (lesson 03's executed `args=2` was the same fact).

**Criteria check:** ☐ `args=3` ☐ three values in order.

## Exercise 3 — The two structural errors

```console
$ javac --release 21 Right.java      # file Right.java declares: public class Wrong {}
Right.java:1: error: class Wrong is public, should be declared in a file named Wrong.java
public class Wrong {}
       ^
1 error
```

```console
$ javac --release 21 Bad1.java       # missing semicolon
Bad1.java:3: error: ';' expected
        System.out.println("no semicolon here")
                                               ^
1 error
```

- Both exit **1** — `javac` failures are script-branchable exactly like shell failures. Read the
  `file:line:` prefix first; the caret line shows the exact token position.

**Criteria check:** ☐ both messages with file:line ☐ both exit 1 noted.

## Exercise 4 — Two-class file with packages (independent)

**Reference shape.** The lesson's executed package example:

```console
$ javac --release 21 -d out src/com/example/greet/Greeter.java src/Main.java && java -cp out Main
Hi, packages!

$ find out -name '*.class' | sort
out/Main.class
out/com/example/greet/Greeter.class
```

- `-d out` created `com/example/greet/` **because** the source said `package com.example.greet;`
  — the namespace became physical directories. `java -cp out Main` names the *classpath root*,
  and `Main` is invoked by class name, not file path.

**Criteria check:** ☐ output printed ☐ directory proof ☐ `package`-line cause stated.

---

Next: [set-3-solutions.md](set-3-solutions.md)
