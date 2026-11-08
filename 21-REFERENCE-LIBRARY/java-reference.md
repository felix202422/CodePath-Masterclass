# Java Reference

Syntax and standard-library lookups for the Java 21 material: types, strings, collections, streams,
records, exceptions, files, dates and concurrency. Every snippet on this page compiles and runs.

> **Baseline.** Java 21 language level, compiled with `javac --release 21` on the authoring machine's
> JDK 25.0.4.1 and executed on that JVM (2026-11-08). Output quoted below is the captured stdout.
> `--release 21` is what keeps the bytecode honest: it refuses post-21 language features and API.

## The smallest complete program

```java
public class Hello {
    public static void main(String[] args) {
        System.out.println("hello");
    }
}
```

```bash
javac --release 21 Hello.java
java Hello
```

- The file name must match the public class name.
- `main` must be `public static void main(String[])`; `String... args` also works.
- **Expected:** `hello`

## Types

| Type | Size / range | Literal | Notes |
|---|---|---|---|
| `byte` | 8-bit, −128..127 | `(byte) 1` | Rarely used outside IO. |
| `short` | 16-bit | `(short) 1` | Rarely used. |
| `int` | 32-bit | `42` | The default integer type. |
| `long` | 64-bit | `42L` | Needed above ~2.1 billion. |
| `float` | 32-bit IEEE 754 | `1.5f` | Imprecise; avoid for money. |
| `double` | 64-bit IEEE 754 | `1.5` | The default floating type. |
| `char` | 16-bit UTF-16 unit | `'a'` | A code unit, not necessarily a character. |
| `boolean` | `true`/`false` | `true` | No numeric conversion. |
| `String` | immutable reference | `"text"` | Not a primitive; compare with `equals`. |
| `var` | inferred local | `var list = new ArrayList<String>();` | Locals only, and the type must be inferable. |

`Integer`, `Long`, `Double`, `Boolean` and friends are the boxed references. Autoboxing converts
automatically, and a `null` unboxed into a primitive is a `NullPointerException`.

```java
int i = 42;              // primitive
Integer boxed = i;       // autoboxed
int unboxed = boxed;     // auto-unboxed; NPE if boxed were null
```

## Strings

```java
String s = "  Ada Lovelace  ";
s.strip();          // "Ada Lovelace"  (Unicode-aware trim)
s.toUpperCase();    // "  ADA LOVELACE  "
s.contains("Love"); // true
"ab".repeat(3);     // "ababab"
"  ".isBlank();     // true
```

**Verified output:** `strip=[Ada Lovelace] upper=ADA LOVELACE contains=true repeat=ababab isBlank=true`

| Need | Method |
|---|---|
| Compare contents | `a.equals(b)`; `a.equalsIgnoreCase(b)` |
| Compare safely with a constant | `"yes".equals(answer)` (constant first, no NPE) |
| Length / emptiness | `s.length()`, `s.isEmpty()`, `s.isBlank()` |
| Find | `s.indexOf("x")`, `s.lastIndexOf("x")`, `s.contains("x")` |
| Slice | `s.substring(2)`, `s.substring(2, 5)` — end index exclusive |
| Split | `s.split(",")`, `s.split("\\s+")` (regex), `s.split(",", -1)` keeps trailing empties |
| Join | `String.join(", ", list)` |
| Replace | `s.replace("a", "b")` (literal), `s.replaceAll("\\d+", "#")` (regex) |
| Format | `String.format("%s has %d items", name, n)` |
| Convert | `String.valueOf(42)`, `Integer.parseInt("42")`, `Integer.toString(42)` |
| Multiline | text block: `"""` on its own line, content dedented to the least-indented line |

Strings are immutable: every "modifying" method returns a new string, and building in a loop needs
`StringBuilder` (or `Collectors.joining`).

## Collections

| Interface | Ordered | Duplicates | Key implementation |
|---|---|---|---|
| `List` | Yes (by index) | Yes | `ArrayList` (array), `LinkedList` (rarely the right choice) |
| `Set` | `HashSet` no, `LinkedHashSet` insertion, `TreeSet` sorted | No | `HashSet` |
| `Map` | `HashMap` no, `LinkedHashMap` insertion, `TreeMap` sorted keys | Unique keys | `HashMap` |
| `Deque` | Yes, both ends | Yes | `ArrayDeque` (use as stack *and* queue) |
| `Queue` | FIFO | Yes | `ArrayDeque`, `PriorityQueue` for priority order |

```java
List<String> names = new ArrayList<>(List.of("ada", "grace"));
names.add("alan");                                  // [ada, grace, alan]

Map<String, Integer> counts = new LinkedHashMap<>();
for (String n : names) counts.merge(n, 1, Integer::sum);   // {ada=1, grace=1, alan=1}
```

**Verified output:** `names=[ada, grace, alan] counts={ada=1, grace=1, alan=1}`

| Need | Method |
|---|---|
| Immutable literals | `List.of(...)`, `Set.of(...)`, `Map.of(k, v, ...)` — no `null`s, fixed size |
| Mutable copy | `new ArrayList<>(List.of(...))`, `new HashMap<>(map)` |
| Read with a default | `map.getOrDefault(key, 0)` |
| Insert if absent | `map.computeIfAbsent(key, k -> new ArrayList<>()).add(value)` |
| Merge values | `map.merge(key, 1, Integer::sum)` |
| Iterate entries | `for (var e : map.entrySet()) { e.getKey(); e.getValue(); }` |
| Sort a list | `list.sort(Comparator.naturalOrder())`, `list.sort(Comparator.comparing(Person::name))` |
| Reverse order | `Comparator.comparing(Person::name).reversed()` |
| Sort by two keys | `Comparator.comparing(Person::lastName).thenComparing(Person::firstName)` |
| Unmodifiable view | `Collections.unmodifiableList(list)` |
| Frequency | `Collections.frequency(list, x)` |

`List.of` and friends are immutable: `add` throws `UnsupportedOperationException`.

## Streams

```java
List<String> words = List.of("delta", "alpha", "charlie", "bravo");

List<String> sorted = words.stream().sorted().toList();
Map<Integer, List<String>> byLength = words.stream().collect(Collectors.groupingBy(String::length));
String joined = words.stream().sorted().collect(Collectors.joining(", "));
int total = words.stream().mapToInt(String::length).sum();
```

**Verified output:**

```text
sorted=[alpha, bravo, charlie, delta]
byLength={5=[delta, alpha, bravo], 7=[charlie]}
joined=alpha, bravo, charlie, delta totalLength=22
```

| Stage | Method |
|---|---|
| Filter | `filter(predicate)` |
| Transform | `map(function)`, `mapToInt/mapToLong/mapToDouble` for primitives |
| Flatten | `flatMap(x -> stream)` |
| Remove duplicates | `distinct()` |
| Sort | `sorted()`, `sorted(comparator)` |
| Limit / skip | `limit(n)`, `skip(n)` |
| Inspect | `peek(consumer)` — debugging only, not for side effects |
| Collect to list | `.toList()` (immutable, Java 16+) or `collect(Collectors.toList())` |
| Group | `collect(Collectors.groupingBy(fn))`, `groupingBy(fn, counting())` |
| Partition | `collect(Collectors.partitioningBy(predicate))` |
| Join strings | `collect(Collectors.joining(", ", "[", "]"))` |
| Map to map | `collect(Collectors.toMap(keyFn, valueFn))` |
| Fold | `reduce(0, Integer::sum)` |
| Match | `anyMatch`, `allMatch`, `noneMatch` |
| Find | `findFirst()`, `findAny()` — both return `Optional` |
| Aggregate | `count()`, `min(cmp)`, `max(cmp)`, `sum()`, `average()` |

A stream is consumed once. Reusing it throws `IllegalStateException: stream has already been operated
upon or closed`. Streams are for transformation, not for control flow with side effects.

## Optional

```java
Optional<String> empty = Optional.empty();
String fallback = empty.orElse("default");
Optional<Integer> parsed = Optional.of("42").map(Integer::parseInt);
```

**Verified output:** `fallback=default parsed=42`

| Need | Method |
|---|---|
| Wrap a possibly-null value | `Optional.ofNullable(x)` |
| Wrap a definitely non-null value | `Optional.of(x)` — throws on `null` |
| Default | `orElse(default)` (eager), `orElseGet(supplier)` (lazy) |
| Throw if empty | `orElseThrow()`, `orElseThrow(() -> new IllegalStateException(...))` |
| Transform | `map(fn)`, `flatMap(fn -> Optional)` |
| Filter | `filter(predicate)` |
| Act if present | `ifPresent(consumer)`, `ifPresentOrElse(consumer, runnable)` |

Do not use `Optional` for fields or parameters; it is designed for return types where "absent" is a
normal outcome. `optional.get()` without a check is just a `NullPointerException` in disguise.

## Records, sealed types and pattern matching

```java
record Money(long cents) {
    Money {                                   // compact constructor
        if (cents < 0) throw new IllegalArgumentException("negative");
    }
    Money plus(Money other) { return new Money(cents + other.cents); }
}

sealed interface Shape permits Circle, Square {}
record Circle(double radius) implements Shape {}
record Square(double side) implements Shape {}

static double area(Shape shape) {
    return switch (shape) {                   // exhaustive, no default needed
        case Circle c -> Math.PI * c.radius() * c.radius();
        case Square s -> s.side() * s.side();
    };
}
```

**Verified output:** `area(circle r=1)=3.14`, `money=375`

- A record generates the canonical constructor, accessors named after the components (`cents()`), `equals`, `hashCode` and `toString`.
- Records are shallowly immutable: a component holding a `List` can still be mutated through it.
- `sealed` restricts implementations to the named subtypes, which is what lets a `switch` be exhaustive without a `default`.
- Pattern `switch` on a sealed hierarchy is checked at compile time; adding a subtype breaks the build until every switch handles it.

## Generics

```java
static <T extends Comparable<T>> T max(List<T> values) {
    return values.stream().max(Comparator.naturalOrder()).orElseThrow();
}
```

**Verified output:** `max=9`

| Need | Syntax |
|---|---|
| Generic method | `<T> T first(List<T> xs)` |
| Bounded type parameter | `<T extends Number>` |
| Multiple bounds | `<T extends Comparable<T> & Serializable>` |
| Accept a subtype collection | `void addAll(List<? extends Number> src)` (producer) |
| Accept a supertype collection | `void drain(List<? super Integer> dst)` (consumer) |
| Unbounded wildcard | `List<?>` — read as `Object`, cannot add |

PECS: **P**roducer **E**xtends, **C**onsumer **S**uper. Type arguments are erased at run time, so
`new T[]`, `instanceof List<String>` and overloads differing only in type arguments are impossible.

## Exceptions

```java
try (var reader = Files.newBufferedReader(path)) {
    return reader.readLine();
} catch (NoSuchFileException e) {
    return null;                              // expected absence
} catch (IOException e) {
    throw new UncheckedIOException(e);        // unexpected: wrap and rethrow
}
```

| Kind | Declared | Examples |
|---|---|---|
| Checked | `throws` required | `IOException`, `SQLException`, `InterruptedException` |
| Unchecked (runtime) | optional | `NullPointerException`, `IllegalArgumentException`, `IllegalStateException` |
| Error | never catch | `OutOfMemoryError`, `StackOverflowError` |

| Need | Pattern |
|---|---|
| Custom exception | `class NotFound extends RuntimeException { NotFound(String m) { super(m); } }` |
| Preserve the cause | `throw new IllegalStateException("loading config", e)` |
| Multi-catch | `catch (IOException \| SQLException e)` |
| Clean up | try-with-resources (any `AutoCloseable`) |
| Recover | catch the specific exception, not `Exception` |
| Do not | swallow (`catch (Exception e) {}`) or log-and-throw at every level |

`InterruptedException` deserves its own line: restore the flag with `Thread.currentThread().interrupt()`
before returning, or the cancellation is lost.

## Files and paths

```java
Path tmp = Files.createTempFile("refcheck", ".txt");
Files.writeString(tmp, "first\nsecond\n");
long lines = Files.readAllLines(tmp).size();      // 2
Files.delete(tmp);
```

**Verified output:** `fileLines=2`

| Need | Method |
|---|---|
| Read a whole file | `Files.readString(path)`, `Files.readAllLines(path)` |
| Write a whole file | `Files.writeString(path, text)` |
| Stream lines | `Files.lines(path)` — inside try-with-resources |
| Exists / is directory | `Files.exists(path)`, `Files.isDirectory(path)` |
| Create directories | `Files.createDirectories(path)` (idempotent) |
| List a directory | `Files.list(dir)` (a `Stream<Path>`, must be closed) |
| Walk a tree | `Files.walk(dir)` |
| Copy / move / delete | `Files.copy(src, dst, REPLACE_EXISTING)`, `Files.move`, `Files.deleteIfExists` |
| Attributes | `Files.size(path)`, `Files.getLastModifiedTime(path)` |
| Build a path | `Path.of("data", "input.txt")` — never concatenate with `"/"` |

Use `Path` and `Files` rather than `java.io.File`; the older API loses error detail and does not
compose.

## Dates and times

```java
LocalDate date = LocalDate.of(2026, 1, 5);
LocalDateTime dt = date.atTime(10, 30);
DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");
dt.format(fmt);                     // 05 Jan 2026 10:30
date.plusDays(7);                   // 2026-01-12
Duration.ofMinutes(90).toMinutes(); // 90
```

**Verified output:** `formatted=05 Jan 2026 10:30 plusDays=2026-01-12 duration=90min`

| Type | Use |
|---|---|
| `LocalDate` | A date with no time or zone. |
| `LocalTime` | A time of day. |
| `LocalDateTime` | Date and time, no zone — a wall clock. |
| `Instant` | A point on the timeline (UTC). |
| `ZonedDateTime` | Date and time with a zone and DST rules. |
| `Duration` | Time-based amount, such as 90 minutes. |
| `Period` | Date-based amount, such as 2 months. |
| `YearMonth`, `MonthDay` | Partial dates. |

`LocalDateTime` has no zone: converting it to `Instant` needs one, and that is exactly where "an hour
off" bugs live. Store instants (`timestamptz` in PostgreSQL), format for display.

## Concurrency

```java
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    var future = executor.submit(() -> Thread.currentThread().isVirtual());
    future.get();                          // true
}
```

**Verified output:** `virtual=true`

| Need | Tool |
|---|---|
| One-off task, no result | `Thread.ofVirtual().start(runnable)` |
| Many blocking tasks | `Executors.newVirtualThreadPerTaskExecutor()` |
| Bounded CPU work | `Executors.newFixedThreadPool(n)` |
| Result later | `CompletableFuture.supplyAsync(...)`, `thenApply`, `thenCompose` |
| Wait for many | `CompletableFuture.allOf(f1, f2)` |
| Shared mutable state | `AtomicInteger`, `ConcurrentHashMap`, `synchronized`, `ReentrantLock` |
| Producer/consumer | `BlockingQueue`, `ArrayBlockingQueue` |

Virtual threads make blocking code scale, not faster: they remove the thread-per-request cost, not the
CPU limit. The `ExecutorService` above is `AutoCloseable` in Java 19+, so try-with-resources waits for
tasks to finish.

## Formatting and parsing

| Need | Code |
|---|---|
| Formatted string | `String.format("%s=%d (%.2f)", name, count, ratio)` |
| Print formatted | `System.out.printf("%-10s %5d%n", name, count)` |
| Parse int / double | `Integer.parseInt(s)`, `Double.parseDouble(s)` |
| Parse with a default | `Integer.parseInt(s)` inside `try`, or `Optional` + `map` |
| Format a number with grouping | `String.format("%,d", 1234567)` |
| Pad | `String.format("%05d", 42)` → `00042` |

`%n` is the platform newline; `\n` is always LF. For files and tests, prefer `\n`.

## Related pages

- [Common Errors](common-errors.md) — the exceptions and compiler messages these APIs produce
- [Glossary](glossary.md) — records, erasure, virtual threads and the rest of the vocabulary
- [04-JAVA-PROGRAMMING/collections-framework.md](../04-JAVA-PROGRAMMING/collections-framework.md) — the lesson behind the collection table
- [04-JAVA-PROGRAMMING/concurrency.md](../04-JAVA-PROGRAMMING/concurrency.md) — threads, pools and virtual threads
- [11-BACKEND-ENGINEERING/spring-boot.md](../11-BACKEND-ENGINEERING/spring-boot.md) — where these APIs meet a framework
