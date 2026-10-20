# Exercises — 04 Java Programming

**Lessons:** this subject's twenty-one lessons, in order.
**How to use these sets:** attempt first; solutions live in
[solutions/](solutions/README.md) behind a warning. The 15-minute rule from
[learning-method](../../00-START-HERE/learning-method.md) applies — record which hint you used.

Each set corresponds to the lesson named in its title and mirrors that lesson's exercise ladder
(introductory → intermediate → independent) with observable completion criteria. Completing all
twenty-one sets *is* the subject's completion gate in [ROADMAP.md](../../ROADMAP.md).

Every Java example in these sets is meant to be **compiled and run** — the subject's policy,
matching [VERSIONS.md](../../VERSIONS.md): transcripts you produce on your machine are your
evidence. Compile with `javac --release 21` unless the exercise states otherwise.

---

## Set 1 — Environment setup → `java-environment-setup.md`

1. Reproduce the tool-check block (`which`, `javac -version`, `java -version`, `$JAVA_HOME`).
   **Criteria:** four outputs captured; one sentence on which JDK the compiler vs runtime reports.
2. Compile-and-run the Hello example with `--release 21`; prove the level with `javap` major
   version. **Criteria:** `major version: 65` (or the number your release produces) captured.
3. Trigger the invalid-release error (`--release 99`) and the not-found error for a tool.
   **Criteria:** both real messages captured, each labelled with its fix layer.
4. **Independent:** write the three-layer triage for "my Java won't run" (tool missing /
   environment wrong / code wrong) with one command per layer and one real output each.
   **Criteria:** three layers, three commands, three captured outputs.

## Set 2 — Program structure → `java-program-structure.md`

1. Compile the two-class `Structure.java`; list the `.class` files javac produced.
   **Criteria:** `Structure.class` and `Helper.class` both listed from a real `ls`/`dir`.
2. Pass three arguments to `main`; print `args.length` and each argument.
   **Criteria:** `args=3` and the three values in order.
3. Reproduce two errors: public class in the wrong file name; a missing semicolon.
   **Criteria:** both compiler messages captured with file:line.
4. **Independent:** a two-class file of your own (a `Greeter` with `hi()` and a `Main` using it),
   compiled with `-d out` and run with `-cp out`. **Criteria:** output printed; `find`/`dir`
   proof that package directories were created when a `package` line was added.

## Set 3 — Variables and types → `variables-and-types.md`

1. Reproduce every primitive's default and its min/max from `Integer.MIN_VALUE`-style constants.
   **Criteria:** eight primitives, defaults and bounds printed by your program.
2. Demonstrate integer overflow deliberately (`Integer.MAX_VALUE + 1`) and the narrowing
   refusal (`int` → `byte` without a cast). **Criteria:** the wrapped value printed; the exact
   compile error captured.
3. Show `10 / 3` vs `10.0 / 3` vs `10 % 3` from one program. **Criteria:** three outputs and
   the division-vs-decimal rule in one sentence.
4. **Independent:** a unit converter reading two `String`s you hard-code, converting safely,
   with a described error for non-numeric input. **Criteria:** two conversions printed; the
   invalid-input case caught and reported without a stack trace.

## Set 4 — Operators and control flow → `operators-and-control-flow.md`

1. Recreate the short-circuit transcript (`a || (1/0 == 0)` true, then the exception line).
   **Criteria:** both lines captured including the stack-trace line number.
2. Write a `switch` expression over at least five labels used as a value.
   **Criteria:** compiles as an expression; `default` present; output shown.
3. Reproduce the truthy-refusal error (`if (1) { … }`).
   **Criteria:** `incompatible types: int cannot be converted to boolean` captured verbatim.
4. **Independent:** a day-number → billing-band program using only `switch` expressions and
   guards (no `if`-else chains), with an out-of-range message. **Criteria:** seven-day sweep
   output; the invalid input handled; zero `if/else` for band selection.

## Set 5 — Methods → `methods.md`

1. Write the `max` and `isEven` methods from memory; call each from `main`.
   **Criteria:** three call results printed; methods compute, `main` prints.
2. Overload one method two ways; call both. **Criteria:** distinct behavior per signature;
   one sentence on what the declared type picks (overload resolution).
3. Trigger a real stack overflow with unbounded recursion; catch it and print the depth.
   **Criteria:** `StackOverflowError` caught; frame count recorded.
4. **Independent:** a pure `Stats` module (`mean`, `range`, `countAbove`) with no printing
   inside and a defined empty-input behavior. **Criteria:** hand-checked values for two data
   sets; empty input handled as documented.

## Set 6 — Arrays and strings → `arrays-and-strings.md`

1. Trace an enhanced-for sum and an indexed mutation on the same array; print after each.
   **Criteria:** outputs prove reads see elements, not indices; mutation visible.
2. Reproduce the out-of-bounds error and the array-covariance hole (`Object[] a = new String[1];`).
   **Criteria:** both failures captured — one runtime, one (the assignment) explained from
   the lesson if your compiler form differs.
3. Count vowels and reverse a string with `charAt` and `StringBuilder`. **Criteria:** two
   outputs for one input you chose; no `split`/streams.
4. **Independent:** a `uniqueSorted(String[] in)` helper — case-insensitive, blanks dropped,
   stable ties — with three input sets including an empty one. **Criteria:** three outputs
   hand-verified; empty-array behavior defined.

## Set 7 — Classes and objects → `classes-and-objects.md`

1. Write a `BankAccount` with a constructor, `deposit`, `withdraw`, and `toString`; exercise it.
   **Criteria:** four states printed via `toString`; balance consistent after each call.
2. Show `equals`/`hashCode` identity behavior: two equal-field objects vs the same object.
   **Criteria:** outputs demonstrating `==` vs `.equals` on both pairs.
3. Trigger `NullPointerException` from a field left null; catch it.
   **Criteria:** the trace captured; one sentence on which line caused it and why.
4. **Independent:** a small `Ticket` class (id, priority, status) with a described invariant
   (status transitions), a factory method, and `equals` by id. **Criteria:** five transitions
   executed; an illegal transition reported without crashing; invariant documented in code.

## Set 8 — Encapsulation → `encapsulation.md`

1. Make a class's field private with a validated setter; trigger the validation failure.
   **Criteria:** invalid value rejected with your message; valid values accepted.
2. Break a naive getter/setter pair (set-anything design) — show the invalid state it allows;
   then fix with validation. **Criteria:** both transcripts — broken then fixed.
3. `final` field with constructor-only assignment; try reassignment (compile error).
   **Criteria:** the exact error captured; one sentence on `final`'s guarantee.
4. **Independent:** a `Thermostat` with a 2 °C setpoint range and an audit log of changes
   (list of strings), fully encapsulated. **Criteria:** out-of-range attempt logged and
   rejected; five accepted changes visible in the audit; no public field anywhere.

## Set 9 — Inheritance → `inheritance.md`

1. Recreate the `Animal`/`Dog` construction-order transcript (constructors printing).
   **Criteria:** parent-before-child order captured; the implicit `super()` explained.
2. Add an overloaded subclass constructor; show which runs for each call form.
   **Criteria:** three constructor calls, three outputs, the delegation rule stated.
3. Attempt to override a `static` method; capture the compiler's response.
   **Criteria:** the hiding-vs-overriding error or warning captured with the lesson's wording.
4. **Independent:** a three-level hierarchy (`Shape` → `Rectangle` → …) with a shared
   invariant and a diagram (hand-drawn or Mermaid) of the constructor order. **Criteria:** the
   diagram matches your executed constructor transcript; composition chosen over inheritance
   somewhere, with two sentences justifying which.

## Set 10 — Polymorphism → `polymorphism.md`

1. Run the mixed `Animal[]` loop; predict each line before running.
   **Criteria:** five predictions, five actual lines, the dispatch rule quoted.
2. Show overload-vs-override side by side: a declared-type overload and a runtime-type
   override in one program. **Criteria:** outputs proving each half of the dispatch rule.
3. Trigger a `ClassCastException` with an explicit cast; then fix with `instanceof`.
   **Criteria:** the failure and the fix transcripts; one sentence on when the check is a
   design smell.
4. **Independent:** a `Notification` hierarchy (Email, SMS, Push) dispatched from one list with
   a `format()` override each and a shared `sendAll` loop. **Criteria:** mixed list output;
   adding a fourth type required no change to `sendAll` (state the open-closed argument).

## Set 11 — Abstraction → `abstraction.md`

1. Reproduce the abstract-method error (instantiating a class with an unimplemented abstract
   method). **Criteria:** the exact compiler message captured.
2. Make one method abstract and one concrete in the same class; subclass overrides only the
   abstract one and calls the concrete one. **Criteria:** executed output proving the concrete
   method was inherited.
3. Show the `private`-constructor-with-static-factory pattern from the lesson.
   **Criteria:** object created via factory; direct `new` refused by the compiler (captured).
4. **Independent:** a `PaymentProcessor` abstraction (abstract class) with one template-method
   skeleton (`final pay()` steps: validate → charge → receipt) forcing subclasses to implement
   exactly `charge`. **Criteria:** two subclasses run through the skeleton; overriding `pay`
   itself is a compile error (captured).

## Set 12 — Interfaces and abstract classes → `interfaces-and-abstract-classes.md`

1. Implement one interface, then two; call through the interface type.
   **Criteria:** output proving dispatch through each interface reference.
2. Reproduce the default-method conflict (`incompatible types` / same-signature clash) and its
   fix with an explicit override. **Criteria:** the error captured alone; the fix's output.
3. Use `instanceof` to branch on interface membership; then replace with pattern matching
   (`instanceof Printable p`). **Criteria:** both versions run; one sentence on what the
   pattern buys.
4. **Independent:** choose interface vs abstract class for a `Comparable`-style sorter and a
   `Logger` base — defend both choices in two sentences each; implement one. **Criteria:** the
   implemented one runs on three inputs; both defenses cite a criterion from the lesson
   (contract vs shared state).

## Set 13 — Exceptions → `exceptions.md`

1. Catch by subtype (`FileNotFoundException` under `IOException`); print each layer's message.
   **Criteria:** two catch paths exercised; the hierarchy statement verified by output.
2. Write a method that throws a *described custom exception*; catch it at the caller.
   **Criteria:** your message and a field (e.g. offending value) survive the throw/catch round
   trip.
3. Trigger the checked-exception-without-`throws` compile error, then the
   `catch`-unreachable error (catching only what cannot be thrown). **Criteria:** both messages
   captured; each one-sentence explained.
4. **Independent:** a `TransferService` (from/amount) whose exceptions carry the failing
   account and amount, with a `finally`-guaranteed audit line. **Criteria:** three failure
   kinds reported distinctly; the audit line prints on every path including success.

## Set 14 — Collections → `collections-framework.md`

1. Build an `ArrayList` and a `LinkedList`; time 10 000 indexed inserts at the front and at
   the end (nanoTime). **Criteria:** both timings recorded; the asymmetry explained by node vs
   array mechanics.
2. Trigger the `ConcurrentModificationException` from a for-each removal; then fix with
   `removeIf`. **Criteria:** both transcripts; the rule stated in one sentence.
3. Use a `HashMap` with your own class (no `hashCode`) and then with a record — observe lookup
   behavior. **Criteria:** the broken-lookup output and the fixed one; the contract quoted.
4. **Independent:** a word-frequency counter over a text you choose using `TreeMap` (sorted
   output) with case-folding policy you declare. **Criteria:** top-5 output hand-verified;
   policy stated; `HashMap` version compared in one sentence.

## Set 15 — Generics → `generics.md`

1. Reproduce both `GenBad` errors (`new T()`, `new T[]`) with your own file.
   **Criteria:** `unexpected type` and `generic array creation` captured; the erasure
   explanation in two sentences.
2. Write a bounded `max(<T extends Comparable<T>>)` and run it for strings and integers.
   **Criteria:** both outputs; the unbounded version's compile error captured.
3. Apply PECS four ways (read/write × `? extends`/`? super`); table the results.
   **Criteria:** 2×2 table from four compilations.
4. **Independent:** the `Result<T>` wrapper (value-or-error) with a generic `map`; executed
   ok-path, error-path, and `get`-on-error demos. **Criteria:** six predicted-then-run output
   lines; the signatures written before the code.

## Set 16 — File handling → `file-handling.md`

1. Recreate the `Files` toolbox transcript (write, append, copy, delete, missing-file catch).
   **Criteria:** all nine lines reproduced with `bytes=` counted; exit 0.
2. Prove the byte-vs-char distinction with a non-ASCII file (`café`).
   **Criteria:** `Files.size` recorded with your byte-count explanation; re-read equals input.
3. Force two failure kinds (missing file; directory-as-file) and catch each by subtype.
   **Criteria:** two transcripts with `getFile()` paths; the difference explained.
4. **Independent:** the crash-safe report writer (temp file + `ATOMIC_MOVE`) with a
   forced-failure test proving the target file untouched. **Criteria:** success and failure
   transcripts; the guarantee split (atomicity vs same-filesystem) cited from docs with URL.

## Set 17 — Lambdas and streams → `lambdas-and-streams.md`

1. Reproduce the full pipeline menu; write five predictions first.
   **Criteria:** five predicted-then-actual pairs with mismatches explained.
2. Trigger the reused-stream `IllegalStateException`; rewrite correctly.
   **Criteria:** the error captured; the two-pipeline fix's identical output.
3. Fill a `toMap` with colliding keys with and without the merge function.
   **Criteria:** `Duplicate key` captured; the merged output line.
4. **Independent:** `topN(words, n, minLen)` — case-insensitive counts, deterministic tie
   order, truncated — with a deliberate tie and case-collision in the demo data. **Criteria:**
   six predicted-then-run lines; the policy point (where folding happens) argued from output.

## Set 18 — Functional programming → `functional-programming.md`

1. Recreate the purity probe (pure/impure twins, cache, predicates, curry factory).
   **Criteria:** all seven lines; the `calls=2` argument in three sentences.
2. Trace drill: three mixed `andThen`/`compose` chains predicted, then verified.
   **Criteria:** three predictions, three runs, traces shown.
3. Build a memoizer for `fib`; prove the second call costs zero inner calls.
   **Criteria:** the counter transcript; the lambda-mutation compile error captured and fixed.
4. **Independent:** the pure pricing core with 20-pair property harness (determinism, bounds,
   monotonicity). **Criteria:** harness transcript; property verdicts; the thesis paragraph on
   why purity made the properties checkable.

## Set 19 — Concurrency → `concurrency.md`

1. Reproduce the race lab three times; tabulate the varying vs identical lines.
   **Criteria:** three transcripts; the variance statement; any honest 40000 noted.
2. Remove `join`; run five times and capture the ordering instability.
   **Criteria:** evidence of truncation/reordering; the fix pasted.
3. Capture a deadlock with two locks; fix with consistent ordering; re-run.
   **Criteria:** the thread-dump cycle text; the clean fixed run.
4. **Independent:** `ParallelRunner` (bounded pool, ordered results, bounded close,
   described rejection). **Criteria:** order, overlap timing, post-close rejection, and a
   wrapped worker failure — four executed proofs.

## Set 20 — JVM and memory → `jvm-and-memory.md`

1. Recreate the four-facts program (defaults, one Class object, args, max memory, counted
   stack overflow). **Criteria:** five lines; each mapped to its area-rule.
2. Disassemble your own class with `javap -c`; annotate five instructions.
   **Criteria:** source-to-bytecode table; one surprise written up.
3. Run `Heap` under `-Xmx32m` and `-Xmx64m`; dissect the line-9 trace.
   **Criteria:** both traces; the no-concat handler variant's changed line number explained.
4. **Independent:** the budget harness (2 caps × 2 workloads) with the leak-vs-reclaimed
   analysis. **Criteria:** four transcripts; the analysis paragraph; one named limitation of
   the in-process view (cited).

## Set 21 — Build tools → `build-tools.md`

1. Recreate the Maven project; capture the grepped `[INFO]` lines and the run output.
   **Criteria:** compile, jar, `BUILD SUCCESS`, and timing lines; exit 0.
2. Measure cold vs warm `Total time` and explain the delta.
   **Criteria:** both numbers; the local-repository explanation in three sentences.
3. Change `maven.compiler.release` to 17; read the produced major version.
   **Criteria:** compiler line per build; `major version: 61` vs `65` (or your pair).
4. **Independent:** the two-class jar (`Greeter` + `App`) built by Maven, run, and listed with
   `jar tf` showing package directories. **Criteria:** build transcript, run output, jar
   listing, and the plugin/doc citation used for the `Main-Class` decision.

---

## Answer key

Solutions: [solutions/](solutions/README.md).

**⚠ Attempt the sets first.** Reading a solution gives recognition, not skill. If you peeked, redo
the affected exercise one week later without looking — that second attempt is the one you keep.
