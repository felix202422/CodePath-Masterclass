# Glossary

Every technical term the curriculum uses, defined once, in one or two sentences, grouped by the
subject that teaches it. Where a term means different things in different tools (a "thread" in Java
and a "thread" in an operating system), the entry says which sense the curriculum uses.

> **How to use this page.** Search it (Ctrl+F) rather than reading it. If the definition raises a
> question, follow the *Taught in* link — the lesson is where the concept is actually built. Terms
> are grouped, not alphabetised, because related words are easier to learn together.

**Baseline:** vocabulary follows the versions in [`VERSIONS.md`](../VERSIONS.md) — Java 21, Node 24,
PostgreSQL 18, Docker Engine 29, Flutter 3.47.

## Foundations and hardware

| Term | Meaning | Taught in |
|---|---|---|
| Bit | A single binary digit, `0` or `1` — the smallest unit of information a computer stores. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| Byte | Eight bits, addressed as one unit; a byte holds 256 distinct values, which is why character encodings fit in it. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| Hexadecimal | Base-16 notation, `0x`-prefixed, used because one hex digit maps to exactly four bits — the shortest way to write a byte. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| Two's complement | The encoding that makes subtraction the same circuit as addition and gives every signed integer a single representation of zero. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| ASCII | A 7-bit character set covering English letters, digits and control codes; the ancestor of modern encodings. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| Unicode | The standard that assigns a code point to every character in every writing system; UTF-8 is its most common byte encoding. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| UTF-8 | A variable-width encoding of Unicode, one to four bytes per code point, backwards-compatible with ASCII. | [binary-and-number-systems](../01-COMPUTER-FOUNDATIONS/binary-and-number-systems.md) |
| CPU | The processor that executes machine instructions; speed depends on cores, clock and, more than either, memory access patterns. | [computer-hardware](../01-COMPUTER-FOUNDATIONS/computer-hardware.md) |
| RAM | Volatile working memory; every running program's data must be in it to be executed. | [computer-hardware](../01-COMPUTER-FOUNDATIONS/computer-hardware.md) |
| Cache | A small, fast memory between the CPU and RAM holding recently used data; *cache miss* means a slower trip to main memory. | [computer-hardware](../01-COMPUTER-FOUNDATIONS/computer-hardware.md) |
| Kernel | The privileged core of an operating system that owns memory, devices and scheduling, exposed to programs through system calls. | [software-and-operating-systems](../01-COMPUTER-FOUNDATIONS/software-and-operating-systems.md) |
| System call | A controlled entry point from user code into the kernel — `read`, `write`, `open`, `fork` — the only way to touch hardware. | [software-and-operating-systems](../01-COMPUTER-FOUNDATIONS/software-and-operating-systems.md) |
| Process | A running program with its own memory space, file descriptors and at least one thread. | [files-and-processes](../01-COMPUTER-FOUNDATIONS/files-and-processes.md) |
| Thread | A unit of execution inside a process; threads share memory, which makes communication cheap and data races possible. | [files-and-processes](../01-COMPUTER-FOUNDATIONS/files-and-processes.md) |
| Virtual memory | The kernel's illusion that each process owns a contiguous address space, mapped page by page to physical memory or disk. | [memory-and-storage](../01-COMPUTER-FOUNDATIONS/memory-and-storage.md) |
| Page fault | The trap raised when a program touches a virtual page that is not in physical memory yet. | [memory-and-storage](../01-COMPUTER-FOUNDATIONS/memory-and-storage.md) |
| File descriptor | A small integer naming an open file, socket or pipe for a process; `0`, `1` and `2` are stdin, stdout and stderr. | [files-and-processes](../01-COMPUTER-FOUNDATIONS/files-and-processes.md) |
| Filesystem | The kernel subsystem that organises bytes into files and directories with metadata such as permissions and timestamps. | [files-and-processes](../01-COMPUTER-FOUNDATIONS/files-and-processes.md) |

## Programming fundamentals

| Term | Meaning | Taught in |
|---|---|---|
| Variable | A named storage location whose value can change; the name is the programmer's handle, the memory behind it is the machine's concern. | [variables-and-data-types](../02-PROGRAMMING-FUNDAMENTALS/variables-and-data-types.md) |
| Data type | The set of values a variable may hold plus the operations allowed on them — the contract that makes `+` unambiguous. | [variables-and-data-types](../02-PROGRAMMING-FUNDAMENTALS/variables-and-data-types.md) |
| Static typing | Checking types before the program runs, from declared or inferred annotations; errors surface at compile time. | [variables-and-data-types](../02-PROGRAMMING-FUNDAMENTALS/variables-and-data-types.md) |
| Dynamic typing | Checking types at run time against the values actually present, as JavaScript and Python do. | [variables-and-data-types](../02-PROGRAMMING-FUNDAMENTALS/variables-and-data-types.md) |
| Operator | A symbol that combines values: arithmetic, comparison, logical, assignment. Precedence decides which binds first. | [operators](../02-PROGRAMMING-FUNDAMENTALS/operators.md) |
| Expression | Code that produces a value, such as `2 * (a + 1)`; every expression can be used anywhere a value is accepted. | [operators](../02-PROGRAMMING-FUNDAMENTALS/operators.md) |
| Statement | Code that performs an action and produces no value, such as an assignment or an `if`. | [conditional-statements](../02-PROGRAMMING-FUNDAMENTALS/conditional-statements.md) |
| Control flow | The order in which statements execute: sequence, selection (`if`/`switch`) and repetition (`for`/`while`). | [conditional-statements](../02-PROGRAMMING-FUNDAMENTALS/conditional-statements.md) |
| Function | A named, reusable block that takes inputs and returns an output; the unit of decomposition in every language here. | [functions-and-methods](../02-PROGRAMMING-FUNDAMENTALS/functions-and-methods.md) |
| Parameter vs argument | A parameter is the name in the definition; an argument is the value supplied at the call site. | [functions-and-methods](../02-PROGRAMMING-FUNDAMENTALS/functions-and-methods.md) |
| Return value | The result a function hands back to its caller; `void`/`None`/`undefined` means it hands back nothing. | [functions-and-methods](../02-PROGRAMMING-FUNDAMENTALS/functions-and-methods.md) |
| Scope | The region of code where a name is visible; shadowing occurs when an inner scope reuses an outer name. | [functions-and-methods](../02-PROGRAMMING-FUNDAMENTALS/functions-and-methods.md) |
| Recursion | A function solving a problem by calling itself on a smaller input, with a base case that stops the descent. | [loops](../02-PROGRAMMING-FUNDAMENTALS/loops.md) |
| Array | A fixed-order collection of same-typed elements addressed by index, usually stored contiguously. | [arrays-and-strings](../02-PROGRAMMING-FUNDAMENTALS/arrays-and-strings.md) |
| String | An ordered sequence of characters; in Java and JavaScript it is immutable, so "changing" one creates a new value. | [arrays-and-strings](../02-PROGRAMMING-FUNDAMENTALS/arrays-and-strings.md) |
| Algorithm | A finite, unambiguous procedure that transforms an input into a desired output. | [algorithms-and-pseudocode](../02-PROGRAMMING-FUNDAMENTALS/algorithms-and-pseudocode.md) |
| Pseudocode | Structured English describing an algorithm without a language's syntax, used to design before coding. | [algorithms-and-pseudocode](../02-PROGRAMMING-FUNDAMENTALS/algorithms-and-pseudocode.md) |
| Off-by-one | The class of bug where a boundary is included or excluded by mistake, usually in a loop or slice index. | [loops](../02-PROGRAMMING-FUNDAMENTALS/loops.md) |
| Stack trace | The call chain printed when an error escapes, read bottom-up: the crash site is the top frame, the cause is usually lower. | [debugging-fundamentals](../02-PROGRAMMING-FUNDAMENTALS/debugging-fundamentals.md) |
| Breakpoint | A marker that pauses execution so state can be inspected; the difference between guessing and observing. | [debugging-fundamentals](../02-PROGRAMMING-FUNDAMENTALS/debugging-fundamentals.md) |
| Modularity | Splitting a program into units with narrow interfaces so a change stays local. | [modular-programming](../02-PROGRAMMING-FUNDAMENTALS/modular-programming.md) |

## Java

| Term | Meaning | Taught in |
|---|---|---|
| JDK, JRE, JVM | The JDK compiles and runs Java; the JRE only runs it; the JVM executes bytecode and manages memory. | [java-environment-setup](../04-JAVA-PROGRAMMING/java-environment-setup.md) |
| Bytecode | The intermediate instruction set in `.class` files, produced by `javac` and executed by the JVM. | [jvm-and-memory](../04-JAVA-PROGRAMMING/jvm-and-memory.md) |
| Classpath | The list of directories and JARs the JVM searches to load classes at run time. | [java-program-structure](../04-JAVA-PROGRAMMING/java-program-structure.md) |
| Primitive vs reference | Primitives (`int`, `double`, `boolean`) hold values directly; reference types hold a pointer to an object, so `==` compares identity. | [variables-and-types](../04-JAVA-PROGRAMMING/variables-and-types.md) |
| Autoboxing | Automatic conversion between primitives and wrappers (`int` ↔ `Integer`); convenient, and a common source of `NullPointerException`. | [variables-and-types](../04-JAVA-PROGRAMMING/variables-and-types.md) |
| Package | A namespace for classes that also maps to a directory; `import` brings a name into scope. | [java-program-structure](../04-JAVA-PROGRAMMING/java-program-structure.md) |
| Constructor | The initialiser run when an object is created; overloadable, never inherited, and callable as `super(...)` from a subclass. | [classes-and-objects](../04-JAVA-PROGRAMMING/classes-and-objects.md) |
| Overloading vs overriding | Overloading picks a method by parameter types at compile time; overriding replaces a superclass method by dynamic dispatch at run time. | [polymorphism](../04-JAVA-PROGRAMMING/polymorphism.md) |
| Encapsulation | Hiding an object's internals behind methods so invariants cannot be broken from outside. | [encapsulation](../04-JAVA-PROGRAMMING/encapsulation.md) |
| Inheritance | Deriving a class from another to reuse and specialise behaviour; the tightest coupling Java offers. | [inheritance](../04-JAVA-PROGRAMMING/inheritance.md) |
| Abstract class | A class that cannot be instantiated and may leave methods unimplemented for subclasses to supply. | [interfaces-and-abstract-classes](../04-JAVA-PROGRAMMING/interfaces-and-abstract-classes.md) |
| Interface | A pure contract of method signatures a class promises to implement; a type, not an implementation. | [interfaces-and-abstract-classes](../04-JAVA-PROGRAMMING/interfaces-and-abstract-classes.md) |
| `static` | Belongs to the class rather than an instance — shared state, utility methods, and no access to `this`. | [classes-and-objects](../04-JAVA-PROGRAMMING/classes-and-objects.md) |
| `final` | A binding that cannot be reassigned (variable), overridden (method) or extended (class). | [encapsulation](../04-JAVA-PROGRAMMING/encapsulation.md) |
| Enum | A fixed set of named constants with type safety; in Java an enum is a real class and can carry fields and methods. | [classes-and-objects](../04-JAVA-PROGRAMMING/classes-and-objects.md) |
| Record | A compact immutable data carrier (Java 16+) that generates constructor, accessors, `equals`, `hashCode` and `toString`. | [classes-and-objects](../04-JAVA-PROGRAMMING/classes-and-objects.md) |
| Generics | Type parameters that let a class or method work over many types while keeping compile-time checking; erased at run time. | [generics](../04-JAVA-PROGRAMMING/generics.md) |
| Type erasure | The JVM's removal of generic type arguments, which is why `List<String>` and `List<Integer>` are the same class at run time. | [generics](../04-JAVA-PROGRAMMING/generics.md) |
| Lambda | A short anonymous function expression, `x -> x * 2`, usable wherever a functional interface is expected. | [lambdas-and-streams](../04-JAVA-PROGRAMMING/lambdas-and-streams.md) |
| Functional interface | An interface with exactly one abstract method, which a lambda or method reference can implement. | [functional-programming](../04-JAVA-PROGRAMMING/functional-programming.md) |
| Stream | A lazy pipeline over a data source: `filter`, `map`, `collect`; consumed once, and not a data structure. | [lambdas-and-streams](../04-JAVA-PROGRAMMING/lambdas-and-streams.md) |
| `Optional` | A container that either holds a value or is empty, used to make "may be absent" explicit in a return type. | [functional-programming](../04-JAVA-PROGRAMMING/functional-programming.md) |
| Checked exception | An exception the compiler forces you to catch or declare; `RuntimeException` and its subclasses are unchecked. | [exceptions](../04-JAVA-PROGRAMMING/exceptions.md) |
| Try-with-resources | Syntax that closes `AutoCloseable` resources automatically, even when the body throws. | [exceptions](../04-JAVA-PROGRAMMING/exceptions.md) |
| Garbage collection | Reclaiming heap memory no longer reachable from any live reference; you get fewer leaks, not none. | [jvm-and-memory](../04-JAVA-PROGRAMMING/jvm-and-memory.md) |
| Heap vs stack | Objects live on the heap and are shared; primitives and references live in per-thread stack frames and die with the call. | [jvm-and-memory](../04-JAVA-PROGRAMMING/jvm-and-memory.md) |
| Thread pool | A fixed set of worker threads reused for many tasks, avoiding the cost of creating a thread per request. | [concurrency](../04-JAVA-PROGRAMMING/concurrency.md) |
| Virtual thread | A JVM-scheduled thread (Java 21) that blocks cheaply, letting thread-per-request code scale to many thousands of tasks. | [concurrency](../04-JAVA-PROGRAMMING/concurrency.md) |
| Maven coordinate | `groupId:artifactId:version` — the triple that identifies one artifact in a repository. | [build-tools](../04-JAVA-PROGRAMMING/build-tools.md) |

## Data structures and algorithms

| Term | Meaning | Taught in |
|---|---|---|
| Big-O notation | An upper bound on growth as input size increases, ignoring constants: `O(n log n)` sorting, `O(1)` hash lookup. | [big-o-notation](../05-DATA-STRUCTURES-AND-ALGORITHMS/big-o-notation.md) |
| Amortised cost | The average cost per operation over a sequence, even when individual operations are expensive — `ArrayList` growth is amortised `O(1)`. | [algorithm-analysis](../05-DATA-STRUCTURES-AND-ALGORITHMS/algorithm-analysis.md) |
| Hash collision | Two keys mapping to the same bucket; resolved by chaining or open addressing, and the reason hash lookups degrade to `O(n)`. | [hash-tables](../05-DATA-STRUCTURES-AND-ALGORITHMS/hash-tables.md) |
| Load factor | Entries divided by buckets in a hash table; crossing the threshold triggers a resize to keep collisions rare. | [hash-tables](../05-DATA-STRUCTURES-AND-ALGORITHMS/hash-tables.md) |
| Binary search | Repeatedly halving a sorted range, `O(log n)`; requires random access and a total order. | [searching](../05-DATA-STRUCTURES-AND-ALGORITHMS/searching.md) |
| Stable sort | A sort that preserves the relative order of equal elements — necessary for multi-key sorting. | [sorting](../05-DATA-STRUCTURES-AND-ALGORITHMS/sorting.md) |
| In-place | An algorithm that rearranges its input using `O(1)` extra memory. | [sorting](../05-DATA-STRUCTURES-AND-ALGORITHMS/sorting.md) |
| Stack (data structure) | Last-in-first-out: `push` and `pop` at one end; the structure behind call frames and undo. | [stacks](../05-DATA-STRUCTURES-AND-ALGORITHMS/stacks.md) |
| Queue | First-in-first-out; the structure behind scheduling, breadth-first search and job processing. | [queues](../05-DATA-STRUCTURES-AND-ALGORITHMS/queues.md) |
| Linked list | Nodes holding a value and a pointer to the next node; `O(1)` insertion once positioned, `O(n)` lookup. | [linked-lists](../05-DATA-STRUCTURES-AND-ALGORITHMS/linked-lists.md) |
| Tree | A connected acyclic graph with a root; binary search trees keep an ordering that gives `O(log n)` search when balanced. | [trees](../05-DATA-STRUCTURES-AND-ALGORITHMS/trees.md) |
| Heap (data structure) | A complete tree where each parent orders before its children, giving `O(log n)` insert and `O(1)` peek at the extreme. | [heaps](../05-DATA-STRUCTURES-AND-ALGORITHMS/heaps.md) |
| Graph | A set of vertices and edges, directed or undirected, weighted or not; the model behind networks, maps and dependencies. | [graphs](../05-DATA-STRUCTURES-AND-ALGORITHMS/graphs.md) |
| BFS and DFS | Breadth-first explores level by level (shortest unweighted path); depth-first follows one branch to its end (cycle detection, ordering). | [graph-algorithms](../05-DATA-STRUCTURES-AND-ALGORITHMS/graph-algorithms.md) |
| Topological sort | An ordering of a directed acyclic graph where every edge points forward — build orders and dependency resolution. | [graph-algorithms](../05-DATA-STRUCTURES-AND-ALGORITHMS/graph-algorithms.md) |
| Dynamic programming | Solving a problem by combining solved subproblems, either bottom-up in a table or top-down with memoisation; requires optimal substructure. | [dynamic-programming](../05-DATA-STRUCTURES-AND-ALGORITHMS/dynamic-programming.md) |
| Memoisation | Caching a function's result per input so each subproblem is computed once. | [dynamic-programming](../05-DATA-STRUCTURES-AND-ALGORITHMS/dynamic-programming.md) |
| Greedy algorithm | Taking the locally best choice at each step; correct only when the problem has the exchange property. | [greedy-algorithms](../05-DATA-STRUCTURES-AND-ALGORITHMS/greedy-algorithms.md) |
| Backtracking | Exploring candidates incrementally and undoing a choice when it cannot lead to a solution — puzzles, permutations, constraint search. | [backtracking](../05-DATA-STRUCTURES-AND-ALGORITHMS/backtracking.md) |

## Internet and the web

| Term | Meaning | Taught in |
|---|---|---|
| IP address | A numeric address identifying a host on a network; IPv4 is 32-bit, IPv6 128-bit. | [ip-addressing](../06-INTERNET-AND-WEB-FOUNDATIONS/ip-addressing.md) |
| Port | A 16-bit number selecting a service on a host; HTTP conventionally uses 80, HTTPS 443, PostgreSQL 5432. | [urls-and-ports](../06-INTERNET-AND-WEB-FOUNDATIONS/urls-and-ports.md) |
| DNS | The distributed system mapping names to addresses, resolved through a hierarchy of caches and authoritative servers. | [dns](../06-INTERNET-AND-WEB-FOUNDATIONS/dns.md) |
| TCP | A reliable, ordered, connection-oriented transport; retransmits loss and preserves byte order. | [tcp-and-udp](../06-INTERNET-AND-WEB-FOUNDATIONS/tcp-and-udp.md) |
| UDP | A connectionless transport with no delivery guarantee, used where latency beats reliability — DNS queries, video, games. | [tcp-and-udp](../06-INTERNET-AND-WEB-FOUNDATIONS/tcp-and-udp.md) |
| TLS | The protocol that encrypts and authenticates a connection, identified by the server's certificate; HTTPS is HTTP over TLS. | [https-and-tls](../06-INTERNET-AND-WEB-FOUNDATIONS/https-and-tls.md) |
| HTTP | A request/response application protocol: a method, a target, headers and an optional body, answered by a status, headers and body. | [http-fundamentals](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) |
| Header | Metadata on a request or response — `Content-Type`, `Authorization`, `Cache-Control` — interpreted by the recipient. | [http-fundamentals](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) |
| Status code | A three-digit number summarising the outcome of a request, grouped into 1xx–5xx classes; see [the reference](http-status-codes.md). | [http-fundamentals](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) |
| URL | A string locating a resource: scheme, authority (host and port), path, query and fragment. | [urls-and-ports](../06-INTERNET-AND-WEB-FOUNDATIONS/urls-and-ports.md) |
| Cookie | A small name/value pair the server asks the browser to store and resend; the substrate of sessions. | [http-fundamentals](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) |
| CDN | A geographically distributed cache that serves static content near the user and terminates TLS at the edge. | [browsers-and-rendering](../06-INTERNET-AND-WEB-FOUNDATIONS/browsers-and-rendering.md) |
| Latency vs bandwidth | Latency is the delay of one round trip; bandwidth is the volume per second. More bandwidth does not reduce latency. | [how-the-internet-works](../06-INTERNET-AND-WEB-FOUNDATIONS/how-the-internet-works.md) |
| MIME type | The `type/subtype` label in `Content-Type` telling the recipient how to interpret a body, such as `application/json`. | [http-fundamentals](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) |
| Client–server | The architecture where a client initiates requests and a server holds the state and answers them. | [client-server-architecture](../06-INTERNET-AND-WEB-FOUNDATIONS/client-server-architecture.md) |

## HTML and CSS

| Term | Meaning | Taught in |
|---|---|---|
| Element | The unit of an HTML document: a start tag, content and end tag, possibly with attributes. | [html-fundamentals](../07-HTML-AND-CSS/html-fundamentals.md) |
| Attribute | A name/value pair on a start tag that configures an element, such as `href` or `alt`. | [html-fundamentals](../07-HTML-AND-CSS/html-fundamentals.md) |
| Semantic HTML | Choosing elements by meaning (`nav`, `main`, `button`) rather than appearance, which gives assistive technology and search engines structure. | [semantic-html](../07-HTML-AND-CSS/semantic-html.md) |
| Cascade | The algorithm deciding which declaration wins: origin and importance, then specificity, then source order. | [css-fundamentals](../07-HTML-AND-CSS/css-fundamentals.md) |
| Specificity | The weight of a selector — inline style beats IDs, IDs beat classes, classes beat element names — used only as a tie-breaker inside the cascade. | [css-fundamentals](../07-HTML-AND-CSS/css-fundamentals.md) |
| Box model | Every element is content, padding, border and margin; `box-sizing: border-box` makes width include padding and border. | [box-model](../07-HTML-AND-CSS/box-model.md) |
| Flow layout | The default layout: block boxes stack, inline boxes run along a line, and normal flow is what `flex` and `grid` replace for a container. | [css-fundamentals](../07-HTML-AND-CSS/css-fundamentals.md) |
| Flexbox | One-dimensional layout distributing space along a main axis with `justify-content`, `align-items` and `gap`. | [flexbox](../07-HTML-AND-CSS/flexbox.md) |
| Grid | Two-dimensional layout defined by rows and columns, with tracks sized in fractions, `minmax()` or content. | [css-grid](../07-HTML-AND-CSS/css-grid.md) |
| Media query | A conditional block applied when the viewport or device matches, the primitive behind responsive design. | [responsive-design](../07-HTML-AND-CSS/responsive-design.md) |
| Viewport meta tag | `<meta name="viewport" content="width=device-width, initial-scale=1">`, without which mobile browsers render at desktop width. | [responsive-design](../07-HTML-AND-CSS/responsive-design.md) |
| `rem` vs `em` | `rem` is relative to the root font size; `em` to the current element's font size, which compounds when nested. | [typography-and-design-tokens](../07-HTML-AND-CSS/typography-and-design-tokens.md) |
| Custom property | A CSS variable (`--space-2: 8px`) read with `var()`, inheritable and changeable at run time. | [typography-and-design-tokens](../07-HTML-AND-CSS/typography-and-design-tokens.md) |
| ARIA | Attributes that describe roles, states and properties when native HTML cannot express them; the first rule is not to need them. | [accessibility](../07-HTML-AND-CSS/accessibility.md) |
| Contrast ratio | The luminance ratio between text and background; WCAG AA requires 4.5:1 for normal text and 3:1 for large text. | [accessibility](../07-HTML-AND-CSS/accessibility.md) |
| Focus order | The sequence in which Tab moves through interactive elements; it must follow the visual and reading order. | [accessibility](../07-HTML-AND-CSS/accessibility.md) |

## JavaScript and TypeScript

| Term | Meaning | Taught in |
|---|---|---|
| Hoisting | Declarations are processed before execution: `var` is initialised to `undefined`, `let`/`const` stay uninitialised in the temporal dead zone. | [functions-and-scope](../08-JAVASCRIPT-AND-TYPESCRIPT/functions-and-scope.md) |
| Temporal dead zone | The span before a `let`/`const` declaration executes, where reading the name throws a `ReferenceError`. | [functions-and-scope](../08-JAVASCRIPT-AND-TYPESCRIPT/functions-and-scope.md) |
| Closure | A function plus the lexical environment it captured, which is why a callback still sees variables from its defining scope. | [functions-and-scope](../08-JAVASCRIPT-AND-TYPESCRIPT/functions-and-scope.md) |
| `this` | The receiver of a call, decided at call time: method call, plain call (`undefined` in modules), `call`/`apply`, or an arrow function's lexical `this`. | [javascript-fundamentals](../08-JAVASCRIPT-AND-TYPESCRIPT/javascript-fundamentals.md) |
| Prototype chain | The lookup path for properties: an object delegates to its prototype, and to that prototype's prototype, ending at `null`. | [javascript-fundamentals](../08-JAVASCRIPT-AND-TYPESCRIPT/javascript-fundamentals.md) |
| Event loop | The scheduler that runs the call stack to completion, then drains microtasks, then takes the next macrotask. | [event-loop](../08-JAVASCRIPT-AND-TYPESCRIPT/event-loop.md) |
| Microtask | A callback queued by a promise or `queueMicrotask`, drained before the next macrotask — which is why promises resolve before `setTimeout(0)`. | [event-loop](../08-JAVASCRIPT-AND-TYPESCRIPT/event-loop.md) |
| Promise | An object representing a future value with three states — pending, fulfilled, rejected — and `then`/`catch`/`finally` handlers. | [promises-and-async-await](../08-JAVASCRIPT-AND-TYPESCRIPT/promises-and-async-await.md) |
| `async`/`await` | Syntax that turns promise chains into sequential-looking code, where `await` suspends the function without blocking the thread. | [promises-and-async-await](../08-JAVASCRIPT-AND-TYPESCRIPT/promises-and-async-await.md) |
| Module | A file with its own scope that explicitly exports and imports bindings; ES modules are the standard, `require` is CommonJS. | [modules](../08-JAVASCRIPT-AND-TYPESCRIPT/modules.md) |
| Bundler | A tool that resolves module graphs and emits a smaller number of files for the browser, often with tree-shaking and minification. | [modules](../08-JAVASCRIPT-AND-TYPESCRIPT/modules.md) |
| Type inference | A compiler deducing a type from context, so `const n = 1` needs no annotation. | [typescript-fundamentals](../08-JAVASCRIPT-AND-TYPESCRIPT/typescript-fundamentals.md) |
| Union type | A type that accepts one of several shapes, `string \| number`, narrowed with `typeof` or discriminants. | [types-and-interfaces](../08-JAVASCRIPT-AND-TYPESCRIPT/types-and-interfaces.md) |
| Narrowing | Refining a union to a member inside a branch, through `typeof`, `in`, `instanceof` or a discriminant property. | [type-narrowing](../08-JAVASCRIPT-AND-TYPESCRIPT/type-narrowing.md) |
| `interface` vs `type` | Both describe object shapes; interfaces can be reopened and extended, type aliases can express unions, tuples and mapped types. | [types-and-interfaces](../08-JAVASCRIPT-AND-TYPESCRIPT/types-and-interfaces.md) |
| Generic (TS) | A type parameter that preserves the relationship between input and output types, `function first<T>(xs: T[]): T`. | [generics](../08-JAVASCRIPT-AND-TYPESCRIPT/generics.md) |
| `unknown` vs `any` | `any` disables checking; `unknown` accepts any value but must be narrowed before use. | [type-narrowing](../08-JAVASCRIPT-AND-TYPESCRIPT/type-narrowing.md) |
| DOM | The browser's tree of nodes built from HTML, queried and mutated from JavaScript through `document`. | [dom-and-events](../08-JAVASCRIPT-AND-TYPESCRIPT/dom-and-events.md) |
| Event delegation | Attaching one listener to a common ancestor and dispatching by `event.target`, instead of one listener per child. | [dom-and-events](../08-JAVASCRIPT-AND-TYPESCRIPT/dom-and-events.md) |
| `structuredClone` | A built-in deep copy using the structured-clone algorithm; unlike `JSON.parse(JSON.stringify(x))` it keeps `Date`, `Map` and cycles. | [arrays-and-objects](../08-JAVASCRIPT-AND-TYPESCRIPT/arrays-and-objects.md) |
## Frontend engineering

| Term | Meaning | Taught in |
|---|---|---|
| Component | A reusable unit of markup, styling and behaviour with a typed input contract; the unit of composition in React and Flutter. | [react-fundamentals](../09-FRONTEND-ENGINEERING/react-fundamentals.md) |
| Props | Read-only inputs a parent passes to a child; changing them re-renders the child, mutating them is a bug. | [components-and-props](../09-FRONTEND-ENGINEERING/components-and-props.md) |
| State | Data owned by a component that changes over time and triggers a re-render. | [state-and-hooks](../09-FRONTEND-ENGINEERING/state-and-hooks.md) |
| Hook | A function (`useState`, `useEffect`) that lets a function component use state and lifecycle features; called unconditionally at the top level. | [state-and-hooks](../09-FRONTEND-ENGINEERING/state-and-hooks.md) |
| Controlled component | A form control whose value is driven by React state, with `onChange` writing back — the value has one source of truth. | [forms](../09-FRONTEND-ENGINEERING/forms.md) |
| Lifting state | Moving shared state to the closest common ancestor so two siblings read and write the same value. | [state-management](../09-FRONTEND-ENGINEERING/state-management.md) |
| Reducer | A pure `(state, action) => state` function that centralises transitions for complex state. | [state-management](../09-FRONTEND-ENGINEERING/state-management.md) |
| Context | React's mechanism for passing a value down a subtree without threading props through every level. | [state-management](../09-FRONTEND-ENGINEERING/state-management.md) |
| Reconciliation | React's process of diffing the rendered tree against the previous one and applying the minimal DOM changes. | [react-fundamentals](../09-FRONTEND-ENGINEERING/react-fundamentals.md) |
| Key | A stable identity on a list item that lets reconciliation match elements across renders; an index is a poor key when the list reorders. | [react-fundamentals](../09-FRONTEND-ENGINEERING/react-fundamentals.md) |
| Effect | A hook for synchronising with systems outside React — network, timers, subscriptions — with an explicit dependency list and cleanup. | [state-and-hooks](../09-FRONTEND-ENGINEERING/state-and-hooks.md) |
| Code splitting | Loading part of the bundle on demand so the initial page ships less JavaScript. | [performance](../09-FRONTEND-ENGINEERING/performance.md) |
| Hydration | Attaching React behaviour to server-rendered HTML; a mismatch between the two is a hydration error. | [build-and-deployment](../09-FRONTEND-ENGINEERING/build-and-deployment.md) |
| SPA, CSR, SSR | A single-page app routes client-side; client-side rendering ships an empty shell; server-side rendering sends HTML for the first paint. | [build-and-deployment](../09-FRONTEND-ENGINEERING/build-and-deployment.md) |
| HMR | Hot module replacement: swapping changed modules in a running dev server without losing page state. | [build-and-deployment](../09-FRONTEND-ENGINEERING/build-and-deployment.md) |
| Accessibility tree | The structure assistive technology reads, derived from the DOM plus ARIA; the DOM's visual appearance is irrelevant to it. | [accessibility](../09-FRONTEND-ENGINEERING/accessibility.md) |
| Design token | A named design decision (`--color-surface`, `--space-3`) referenced instead of hard-coded values, so themes change in one place. | [design-systems](../09-FRONTEND-ENGINEERING/design-systems.md) |
| Error boundary | A component that catches render errors in its subtree and shows a fallback instead of unmounting the app. | [error-and-loading-states](../09-FRONTEND-ENGINEERING/error-and-loading-states.md) |

## Databases

| Term | Meaning | Taught in |
|---|---|---|
| Relation | A table: a set of rows (tuples) sharing named, typed columns (attributes). | [relational-databases](../10-DATABASE-ENGINEERING/relational-databases.md) |
| Primary key | The column or columns uniquely identifying a row; implicitly `NOT NULL` and uniquely indexed. | [constraints-and-relationships](../10-DATABASE-ENGINEERING/constraints-and-relationships.md) |
| Foreign key | A column referencing another table's key, enforcing that the referenced row exists; the database's referential integrity. | [constraints-and-relationships](../10-DATABASE-ENGINEERING/constraints-and-relationships.md) |
| Candidate key | Any minimal set of columns that uniquely identifies a row; one becomes the primary key, the rest stay unique constraints. | [database-design](../10-DATABASE-ENGINEERING/database-design.md) |
| Index | A separate structure (usually a B-tree) mapping column values to row locations, trading write cost and space for read speed. | [indexes](../10-DATABASE-ENGINEERING/indexes.md) |
| Composite index | An index on several columns, usable for a left-hand prefix of them — column order is part of the design. | [indexes](../10-DATABASE-ENGINEERING/indexes.md) |
| Partial index | An index with a `WHERE` clause covering only the rows you query, such as only active loans. | [indexes](../10-DATABASE-ENGINEERING/indexes.md) |
| Transaction | A group of statements that either all take effect or none do, bounded by `BEGIN` and `COMMIT`/`ROLLBACK`. | [transactions](../10-DATABASE-ENGINEERING/transactions.md) |
| ACID | Atomicity, consistency, isolation, durability — the four guarantees a transactional database offers. | [transactions](../10-DATABASE-ENGINEERING/transactions.md) |
| Isolation level | How much concurrent transactions may see of each other: `READ COMMITTED` (PostgreSQL default), `REPEATABLE READ`, `SERIALIZABLE`. | [concurrency-and-isolation](../10-DATABASE-ENGINEERING/concurrency-and-isolation.md) |
| Dirty read | Reading another transaction's uncommitted write; prevented at every standard isolation level above `READ UNCOMMITTED`. | [concurrency-and-isolation](../10-DATABASE-ENGINEERING/concurrency-and-isolation.md) |
| Phantom read | A repeated query returning new rows inserted by another committed transaction; prevented at `SERIALIZABLE`. | [concurrency-and-isolation](../10-DATABASE-ENGINEERING/concurrency-and-isolation.md) |
| Deadlock (database) | Two transactions each holding a lock the other needs; the server detects the cycle and aborts one with a serialisation error. | [concurrency-and-isolation](../10-DATABASE-ENGINEERING/concurrency-and-isolation.md) |
| Normalisation | Organising tables to remove redundancy and update anomalies, through first, second and third normal form. | [normalization](../10-DATABASE-ENGINEERING/normalization.md) |
| Denormalisation | Deliberately duplicating data to avoid joins, at the cost of keeping copies consistent. | [normalization](../10-DATABASE-ENGINEERING/normalization.md) |
| Join | Combining rows from two relations on a condition: `INNER`, `LEFT`, `RIGHT`, `FULL`, `CROSS`, `LATERAL`. | [joins-and-subqueries](../10-DATABASE-ENGINEERING/joins-and-subqueries.md) |
| Aggregate | A function collapsing many rows to one value — `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` — with `GROUP BY` deciding the groups. | [filtering-and-aggregation](../10-DATABASE-ENGINEERING/filtering-and-aggregation.md) |
| CTE | A named subquery declared with `WITH`, which makes a multi-step query readable and can be recursive. | [joins-and-subqueries](../10-DATABASE-ENGINEERING/joins-and-subqueries.md) |
| View | A stored query presented as a table; it stores no rows (unless materialised) and always reflects current data. | [joins-and-subqueries](../10-DATABASE-ENGINEERING/joins-and-subqueries.md) |
| Migration | A versioned, ordered change to schema or data that every environment applies the same way. | [migrations](../10-DATABASE-ENGINEERING/migrations.md) |
| N+1 query | One query for a list plus one per item to fetch a relation — the classic ORM performance bug. | [query-plans-and-optimization](../10-DATABASE-ENGINEERING/query-plans-and-optimization.md) |
| Query plan | The executor's chosen strategy for a statement, read with `EXPLAIN` (and `EXPLAIN ANALYZE` to run it). | [query-plans-and-optimization](../10-DATABASE-ENGINEERING/query-plans-and-optimization.md) |
| Sequential scan | Reading every row because no index helped; correct for small tables or when most rows match. | [query-plans-and-optimization](../10-DATABASE-ENGINEERING/query-plans-and-optimization.md) |
| Connection pool | A bounded set of reused database connections; the limit is a concurrency budget, not a suggestion. | [database-fundamentals](../10-DATABASE-ENGINEERING/database-fundamentals.md) |
| ORM | Object–relational mapper: translates rows to objects and back, owning SQL generation, identity and lazy loading. | [database-fundamentals](../10-DATABASE-ENGINEERING/database-fundamentals.md) |
| Optimistic locking | Detecting conflicting writes with a version column and rejecting the stale one, instead of holding a lock. | [concurrency-and-isolation](../10-DATABASE-ENGINEERING/concurrency-and-isolation.md) |
| WAL | Write-ahead log: changes are appended durably before data pages, enabling crash recovery and replication. | [backups-and-recovery](../10-DATABASE-ENGINEERING/backups-and-recovery.md) |
| Replication | Copying a database's changes to another server for read scaling or failover; asynchronous by default. | [backups-and-recovery](../10-DATABASE-ENGINEERING/backups-and-recovery.md) |

## Backend engineering

| Term | Meaning | Taught in |
|---|---|---|
| API | The contract through which one piece of software calls another: operations, inputs, outputs and failure modes. | [backend-fundamentals](../11-BACKEND-ENGINEERING/backend-fundamentals.md) |
| REST | An architectural style using resources identified by URLs, a uniform HTTP interface, and stateless requests. | [http-and-rest-apis](../11-BACKEND-ENGINEERING/http-and-rest-apis.md) |
| Resource | A thing the API exposes (`/orders/42`) whose representation is transferred, not the operations on it. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| Idempotent | Safe to repeat with the same effect: `GET`, `PUT`, `DELETE` are idempotent by definition, `POST` is not. | [http-and-rest-apis](../11-BACKEND-ENGINEERING/http-and-rest-apis.md) |
| Stateless | Each request carries everything needed to serve it, so any instance may handle it. | [http-and-rest-apis](../11-BACKEND-ENGINEERING/http-and-rest-apis.md) |
| DTO | Data transfer object: the shape crossing the API boundary, deliberately separate from the persistence entity. | [controllers-services-repositories](../11-BACKEND-ENGINEERING/controllers-services-repositories.md) |
| Controller, service, repository | The HTTP edge, the business rules, and the data access — separated so each can change without the others. | [controllers-services-repositories](../11-BACKEND-ENGINEERING/controllers-services-repositories.md) |
| Dependency injection | Supplying a component's collaborators from outside instead of constructing them inside, which makes them replaceable in tests. | [dependency-injection](../11-BACKEND-ENGINEERING/dependency-injection.md) |
| Bean | A Spring-managed object created and wired by the container, with a scope (`singleton` by default). | [spring-fundamentals](../11-BACKEND-ENGINEERING/spring-fundamentals.md) |
| Filter / interceptor | Code that runs around a request — authentication, logging, CORS — before or after the handler. | [spring-fundamentals](../11-BACKEND-ENGINEERING/spring-fundamentals.md) |
| Validation | Rejecting input that violates declared constraints with a 400/422 response, before it reaches business logic. | [validation-and-error-handling](../11-BACKEND-ENGINEERING/validation-and-error-handling.md) |
| Serialisation | Converting an object to a transport format (`JSON`) and back, including how `null`, dates and enums appear on the wire. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| Entity | A JPA class mapped to a table, managed by a persistence context within a transaction. | [jpa-and-hibernate](../11-BACKEND-ENGINEERING/jpa-and-hibernate.md) |
| Pagination | Returning results in bounded pages, by offset or by cursor; unbounded lists are a production incident waiting to happen. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| Rate limit | A cap on requests per client per window, returning 429 with `Retry-After` when exceeded. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| Background job | Work moved off the request path and executed by a worker, with retries and a recorded outcome. | [background-jobs](../11-BACKEND-ENGINEERING/background-jobs.md) |
| Webhook | An HTTP callback a provider sends to your endpoint when something happens; verify the signature before trusting it. | [api-integration](../09-FRONTEND-ENGINEERING/api-integration.md) |
| Session | Server-side state keyed by an identifier the client sends back in a cookie. | [sessions-and-tokens](../11-BACKEND-ENGINEERING/sessions-and-tokens.md) |
| Token | A self-contained credential the client presents, such as a JWT, whose signature and expiry the server verifies. | [sessions-and-tokens](../11-BACKEND-ENGINEERING/sessions-and-tokens.md) |
| JWT | JSON Web Token: base64url-encoded header, claims and signature; readable by anyone, so it carries no secrets. | [sessions-and-tokens](../11-BACKEND-ENGINEERING/sessions-and-tokens.md) |
| OAuth 2.0 | The authorisation framework that lets a client obtain scoped access to a resource on the user's behalf. | [oauth2-and-openid-connect](../11-BACKEND-ENGINEERING/oauth2-and-openid-connect.md) |
| OpenID Connect | An identity layer on OAuth 2.0 adding an ID token and a standard user-info endpoint. | [oauth2-and-openid-connect](../11-BACKEND-ENGINEERING/oauth2-and-openid-connect.md) |
| CORS | The browser's cross-origin fetch policy, relaxed only by response headers the server sends for that origin. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| Idempotency key | A client-supplied unique value letting the server recognise a retried `POST` and replay the first result. | [api-design](../11-BACKEND-ENGINEERING/api-design.md) |
| ETag | A validator for a representation; `If-None-Match` makes reads conditional, `If-Match` makes writes optimistic. | [http-and-rest-apis](../11-BACKEND-ENGINEERING/http-and-rest-apis.md) |

## Mobile

| Term | Meaning | Taught in |
|---|---|---|
| Widget | Flutter's immutable description of part of the UI tree; state lives in the element/state object, not the widget. | [flutter-fundamentals](../12-MOBILE-DEVELOPMENT/flutter-fundamentals.md) |
| Stateless vs stateful widget | A stateless widget renders from its inputs; a stateful one owns mutable state and rebuilds when `setState` is called. | [widgets-and-layouts](../12-MOBILE-DEVELOPMENT/widgets-and-layouts.md) |
| `BuildContext` | The handle locating a widget in the tree, used to read inherited data such as theme or navigation. | [widgets-and-layouts](../12-MOBILE-DEVELOPMENT/widgets-and-layouts.md) |
| Hot reload | Re-applying changed Dart code to a running app while preserving state; hot restart resets state. | [flutter-fundamentals](../12-MOBILE-DEVELOPMENT/flutter-fundamentals.md) |
| Null safety | Dart's compile-time guarantee that a non-nullable type never holds `null`, with `?`, `!` and `late` as the escape hatches. | [null-safety](../12-MOBILE-DEVELOPMENT/null-safety.md) |
| `Future` / `Stream` | A single asynchronous result / a sequence of them; both are awaited or listened to in Dart. | [asynchronous-dart](../12-MOBILE-DEVELOPMENT/asynchronous-dart.md) |
| Isolate | Dart's unit of parallelism with its own memory heap; communication is by message, so no shared-state races. | [asynchronous-dart](../12-MOBILE-DEVELOPMENT/asynchronous-dart.md) |
| Platform channel | The bridge that lets Dart call native Android or iOS code and receive results asynchronously. | [mobile-development-fundamentals](../12-MOBILE-DEVELOPMENT/mobile-development-fundamentals.md) |
| APK vs AAB | An installable Android package versus the upload format Google Play splits per device; you ship AABs to Play. | [android-release](../12-MOBILE-DEVELOPMENT/android-release.md) |
| IPA | The iOS application archive, signed with a distribution certificate and provisioning profile. | [ios-release](../12-MOBILE-DEVELOPMENT/ios-release.md) |
| Permission | A capability the OS grants only after a declared request and, usually, a runtime prompt; denial is a supported state. | [permissions-and-notifications](../12-MOBILE-DEVELOPMENT/permissions-and-notifications.md) |
| Offline-first | The app treats local storage as the source of truth and syncs opportunistically, rather than failing without a network. | [offline-functionality](../12-MOBILE-DEVELOPMENT/offline-functionality.md) |
| Sync queue | An ordered log of pending local changes replayed to the server, with retry, backoff and conflict handling. | [offline-functionality](../12-MOBILE-DEVELOPMENT/offline-functionality.md) |

## Architecture and design

| Term | Meaning | Taught in |
|---|---|---|
| Coupling and cohesion | How much modules depend on each other, and how focused each one is; good design lowers the first and raises the second. | [separation-of-concerns](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/separation-of-concerns.md) |
| SOLID | Five object-design principles: single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion. | [solid-principles](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/solid-principles.md) |
| Layered architecture | Organising code into layers (presentation, application, domain, infrastructure) with dependencies pointing inward. | [layered-architecture](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/layered-architecture.md) |
| Hexagonal / clean architecture | Isolating the domain behind ports and adapters so frameworks and databases are replaceable details. | [clean-architecture](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/clean-architecture.md) |
| Domain-driven design | Modelling software around the business domain, with a ubiquitous language, bounded contexts and aggregates. | [domain-driven-design](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/domain-driven-design.md) |
| Aggregate (domain) | A cluster of entities changed as one consistency boundary, with a single root exposed to the outside — not to be confused with the SQL aggregate function. | [domain-driven-design](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/domain-driven-design.md) |
| Bounded context | The boundary within which one model and one vocabulary are consistent. | [domain-driven-design](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/domain-driven-design.md) |
| Monolith | A single deployable unit; not a synonym for bad design, and the right default for most systems. | [modular-monoliths](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/modular-monoliths.md) |
| Microservice | An independently deployable service owning its data, with the network cost and failure modes that follow. | [microservices](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/microservices.md) |
| Event-driven architecture | Components communicating by publishing and reacting to events, decoupling producers from consumers. | [event-driven-architecture](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/event-driven-architecture.md) |
| Design pattern | A named, reusable solution shape (factory, observer, strategy) with known trade-offs. | [design-patterns](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/design-patterns.md) |
| Technical debt | The future cost of a shortcut taken now; like financial debt, it is only manageable when the interest is visible. | [technical-debt](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/technical-debt.md) |
| Functional requirement | What the system must do, stated observably. | [functional-and-nonfunctional-requirements](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/functional-and-nonfunctional-requirements.md) |
| Non-functional requirement | A quality constraint — performance, availability, security, operability — with a measurable target. | [functional-and-nonfunctional-requirements](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/functional-and-nonfunctional-requirements.md) |
| Use case | A goal-oriented interaction between an actor and the system, often drawn as a UML diagram. | [use-cases-and-uml](../13-SOFTWARE-ENGINEERING-AND-ARCHITECTURE/use-cases-and-uml.md) |
| ADR | Architecture decision record: a short, dated document stating one decision, its context, and its consequences. | [architecture-decision-records](../18-ADVANCED-ENGINEERING/architecture-decision-records.md) |

## Testing and quality

| Term | Meaning | Taught in |
|---|---|---|
| Unit test | A fast test of one unit in isolation, with collaborators replaced by test doubles. | [unit-testing](../14-TESTING-AND-QUALITY/unit-testing.md) |
| Integration test | A test exercising several real components together — often the database or HTTP layer — to verify the wiring. | [integration-testing](../14-TESTING-AND-QUALITY/integration-testing.md) |
| End-to-end test | A test driving the whole system the way a user does; highest confidence, slowest and most brittle. | [end-to-end-testing](../14-TESTING-AND-QUALITY/end-to-end-testing.md) |
| Test double | A stand-in for a collaborator: a stub returns canned answers, a mock records and verifies calls, a fake is a working lightweight implementation. | [mocking-and-test-doubles](../14-TESTING-AND-QUALITY/mocking-and-test-doubles.md) |
| Fixture | The known starting state a test arranges before acting. | [testing-fundamentals](../14-TESTING-AND-QUALITY/testing-fundamentals.md) |
| Coverage | The proportion of code executed by tests; line and branch coverage measure different things, and 100% proves nothing. | [test-coverage](../14-TESTING-AND-QUALITY/test-coverage.md) |
| TDD | Writing a failing test first, then the minimum code to pass, then refactoring — the red/green/refactor cycle. | [test-driven-development](../14-TESTING-AND-QUALITY/test-driven-development.md) |
| Flaky test | A test that passes and fails without a code change, usually from time, ordering or shared state. | [testing-fundamentals](../14-TESTING-AND-QUALITY/testing-fundamentals.md) |
| Regression | A defect in behaviour that previously worked; a regression test is the proof it stays fixed. | [testing-fundamentals](../14-TESTING-AND-QUALITY/testing-fundamentals.md) |
| Smoke test | A shallow check that the deployed system starts and answers, run before deeper verification. | [quality-gates](../14-TESTING-AND-QUALITY/quality-gates.md) |
| Load vs stress test | Load tests expected traffic; stress tests find the point where behaviour breaks. | [performance-testing](../14-TESTING-AND-QUALITY/performance-testing.md) |
| Quality gate | An automated condition a change must pass to merge or deploy, such as tests green plus coverage above a floor. | [quality-gates](../14-TESTING-AND-QUALITY/quality-gates.md) |

## Security

| Term | Meaning | Taught in |
|---|---|---|
| Authentication vs authorisation | Authentication proves who you are; authorisation decides what you may do. Confusing them produces 403s that should be 401s. | [security-fundamentals](../15-APPLICATION-SECURITY/security-fundamentals.md) |
| Least privilege | Granting the minimum access needed for a task, for users, services and database roles alike. | [access-control](../15-APPLICATION-SECURITY/access-control.md) |
| RBAC | Role-based access control: permissions attached to roles, users assigned roles. | [access-control](../15-APPLICATION-SECURITY/access-control.md) |
| IDOR | Insecure direct object reference: an endpoint trusting a client-supplied identifier instead of checking ownership. | [access-control](../15-APPLICATION-SECURITY/access-control.md) |
| Hashing vs encryption | Hashing is one-way and used for passwords; encryption is reversible with a key and used for data you must read back. | [password-security](../15-APPLICATION-SECURITY/password-security.md) |
| Salt | A unique random value hashed with each password so identical passwords produce different hashes. | [password-security](../15-APPLICATION-SECURITY/password-security.md) |
| Argon2 / bcrypt | Deliberately slow password-hashing functions with a tunable work factor; never use a fast hash such as SHA-256 for passwords. | [password-security](../15-APPLICATION-SECURITY/password-security.md) |
| XSS | Cross-site scripting: attacker JavaScript running in your origin; stored, reflected or DOM-based. Prevent with output encoding and CSP. | [cross-site-scripting](../15-APPLICATION-SECURITY/cross-site-scripting.md) |
| CSRF | Cross-site request forgery: another site making an authenticated request with the victim's cookies; prevented with tokens and `SameSite`. | [csrf](../15-APPLICATION-SECURITY/csrf.md) |
| SQL injection | Untrusted input concatenated into SQL; prevented by parameterised queries, never by escaping. | [injection-vulnerabilities](../15-APPLICATION-SECURITY/injection-vulnerabilities.md) |
| SSRF | Server-side request forgery: making the server fetch an attacker-chosen URL, reaching internal services; prevented with an allowlist. | [ssrf](../15-APPLICATION-SECURITY/ssrf.md) |
| Session fixation | Forcing a victim to use an attacker-known session ID; prevented by issuing a new ID at login. | [session-security](../15-APPLICATION-SECURITY/session-security.md) |
| Secure cookie flags | `HttpOnly` blocks script access, `Secure` requires HTTPS, `SameSite` limits cross-site sending. | [session-security](../15-APPLICATION-SECURITY/session-security.md) |
| Threat model | A structured list of what you are building, what can go wrong, and what you will do — STRIDE is one prompt set. | [threat-modeling](../15-APPLICATION-SECURITY/threat-modeling.md) |
| STRIDE | Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege. | [threat-modeling](../15-APPLICATION-SECURITY/threat-modeling.md) |
| Certificate authority | An entity that signs certificates, letting clients verify that a public key belongs to a hostname. | [tls-and-certificates](../15-APPLICATION-SECURITY/tls-and-certificates.md) |
| CVE | A published identifier for a known vulnerability; dependency scanning maps your versions to them. | [dependency-security](../15-APPLICATION-SECURITY/dependency-security.md) |
| Secret | A credential that must never enter version control, logs or client code; supplied by the environment or a secret store. | [secrets-management](../15-APPLICATION-SECURITY/secrets-management.md) |

## DevOps and infrastructure

| Term | Meaning | Taught in |
|---|---|---|
| CI | Continuous integration: every change is built and tested automatically, ideally on every push. | [ci-cd-fundamentals](../16-DEVOPS-AND-INFRASTRUCTURE/ci-cd-fundamentals.md) |
| CD | Continuous delivery keeps every build releasable; continuous deployment releases it automatically. | [ci-cd-fundamentals](../16-DEVOPS-AND-INFRASTRUCTURE/ci-cd-fundamentals.md) |
| Pipeline | The ordered stages a change passes through: build, test, package, deploy, verify. | [github-actions](../16-DEVOPS-AND-INFRASTRUCTURE/github-actions.md) |
| Artifact | The immutable output of a build — a JAR, image or bundle — identified by version or digest. | [ci-cd-fundamentals](../16-DEVOPS-AND-INFRASTRUCTURE/ci-cd-fundamentals.md) |
| Container | An isolated process tree sharing the host kernel, packaged with its filesystem and configuration. | [docker-fundamentals](../16-DEVOPS-AND-INFRASTRUCTURE/docker-fundamentals.md) |
| Image | The immutable, layered template a container starts from, addressed by repository and tag or digest. | [docker-images-and-containers](../16-DEVOPS-AND-INFRASTRUCTURE/docker-images-and-containers.md) |
| Layer | A cached filesystem diff produced by one Dockerfile instruction; order instructions so expensive layers change least often. | [docker-images-and-containers](../16-DEVOPS-AND-INFRASTRUCTURE/docker-images-and-containers.md) |
| Registry | The service storing and distributing images, such as Docker Hub or GHCR. | [docker-images-and-containers](../16-DEVOPS-AND-INFRASTRUCTURE/docker-images-and-containers.md) |
| Volume vs bind mount | A volume is Docker-managed storage; a bind mount maps a host path into the container. | [volumes-and-persistence](../16-DEVOPS-AND-INFRASTRUCTURE/volumes-and-persistence.md) |
| Multi-stage build | A Dockerfile with several `FROM` stages, copying only build output into the final image to keep it small. | [docker-images-and-containers](../16-DEVOPS-AND-INFRASTRUCTURE/docker-images-and-containers.md) |
| Compose | A YAML file declaring several services, networks and volumes, started together with `docker compose up`. | [docker-compose](../16-DEVOPS-AND-INFRASTRUCTURE/docker-compose.md) |
| IaC | Infrastructure as code: declaring infrastructure in files that a tool applies, so environments are reproducible and reviewable. | [infrastructure-as-code](../16-DEVOPS-AND-INFRASTRUCTURE/infrastructure-as-code.md) |
| Provisioning vs configuration | Provisioning creates resources; configuration sets up software inside them. Terraform provisions, Ansible configures. | [terraform](../16-DEVOPS-AND-INFRASTRUCTURE/terraform.md) |
| Idempotence (operations) | Applying the same change twice leaves the same state — the property that makes automation safe to rerun. | [ansible](../16-DEVOPS-AND-INFRASTRUCTURE/ansible.md) |
| Reverse proxy | A server in front of your app that terminates TLS, routes by host or path and buffers slow clients. | [nginx-and-reverse-proxies](../16-DEVOPS-AND-INFRASTRUCTURE/nginx-and-reverse-proxies.md) |
| Load balancer | Distributes requests across instances and removes unhealthy ones from rotation. | [deployment-strategies](../16-DEVOPS-AND-INFRASTRUCTURE/deployment-strategies.md) |
| Blue-green deployment | Running two identical environments and switching traffic between them, making rollback a routing change. | [deployment-strategies](../16-DEVOPS-AND-INFRASTRUCTURE/deployment-strategies.md) |
| Canary release | Sending a small share of traffic to the new version and widening it as metrics stay healthy. | [deployment-strategies](../16-DEVOPS-AND-INFRASTRUCTURE/deployment-strategies.md) |
| Observability | Being able to answer new questions about a running system from its telemetry — logs, metrics and traces together. | [monitoring-and-logging](../16-DEVOPS-AND-INFRASTRUCTURE/monitoring-and-logging.md) |
| Health check | An endpoint or probe reporting whether an instance can serve traffic, used to gate routing and restarts. | [deployment-strategies](../16-DEVOPS-AND-INFRASTRUCTURE/deployment-strategies.md) |
| RTO and RPO | Recovery time objective: how long you may be down. Recovery point objective: how much data you may lose. | [backups-and-recovery](../16-DEVOPS-AND-INFRASTRUCTURE/backups-and-recovery.md) |

## Cloud and production

| Term | Meaning | Taught in |
|---|---|---|
| Region and availability zone | A geographic area, and an isolated datacentre group within it; spanning zones survives a datacentre failure. | [cloud-computing-fundamentals](../17-CLOUD-AND-PRODUCTION/cloud-computing-fundamentals.md) |
| Virtual machine | A full guest operating system on emulated hardware, isolated by a hypervisor. | [virtual-machines](../17-CLOUD-AND-PRODUCTION/virtual-machines.md) |
| Object storage | A flat store of immutable blobs addressed by key, with no filesystem and no partial writes. | [object-storage](../17-CLOUD-AND-PRODUCTION/object-storage.md) |
| Managed database | A database service where the provider handles patching, backups and failover, at a price premium. | [managed-databases](../17-CLOUD-AND-PRODUCTION/managed-databases.md) |
| Autoscaling | Adding or removing capacity from a signal such as CPU, queue depth or request rate — with a cooldown to avoid thrash. | [scaling](../17-CLOUD-AND-PRODUCTION/scaling.md) |
| IAM role | A cloud identity with attached policies that a service assumes, avoiding long-lived keys. | [identity-and-access-management](../17-CLOUD-AND-PRODUCTION/identity-and-access-management.md) |
| VPC and subnet | A private network and its address ranges, with route tables and security groups deciding what may talk to what. | [cloud-networking](../17-CLOUD-AND-PRODUCTION/cloud-networking.md) |
| Serverless | Running code on demand with no server to manage, billed per invocation, with cold starts as the trade-off. | [cloud-computing-fundamentals](../17-CLOUD-AND-PRODUCTION/cloud-computing-fundamentals.md) |
| Tagging | Labelling cloud resources by owner, environment and cost centre, without which bills are unassignable. | [cloud-cost-management](../17-CLOUD-AND-PRODUCTION/cloud-cost-management.md) |
| Incident | An unplanned degradation requiring coordinated response; the postmortem records cause and prevention, blamelessly. | [incident-management](../17-CLOUD-AND-PRODUCTION/incident-management.md) |
| SLO, SLI, SLA | An objective for reliability, the indicator measuring it, and the contractual promise with consequences. | [observability](../17-CLOUD-AND-PRODUCTION/observability.md) |

## Advanced engineering

| Term | Meaning | Taught in |
|---|---|---|
| Concurrency vs parallelism | Concurrency is dealing with many tasks at once; parallelism is executing them simultaneously. | [concurrency-and-parallelism](../18-ADVANCED-ENGINEERING/concurrency-and-parallelism.md) |
| Race condition | Behaviour depending on the unpredictable interleaving of concurrent operations. | [concurrency-and-parallelism](../18-ADVANCED-ENGINEERING/concurrency-and-parallelism.md) |
| Mutex | A lock ensuring only one thread enters a critical section at a time. | [concurrency-and-parallelism](../18-ADVANCED-ENGINEERING/concurrency-and-parallelism.md) |
| Backpressure | Making a producer slow down when a consumer cannot keep up, instead of buffering without bound. | [message-queues](../18-ADVANCED-ENGINEERING/message-queues.md) |
| Delivery guarantee | At-most-once may lose messages, at-least-once may duplicate them, exactly-once is achievable only within a bounded system. | [message-queues](../18-ADVANCED-ENGINEERING/message-queues.md) |
| Idempotent consumer | A consumer that can safely process the same message twice, usually via a deduplication key. | [message-queues](../18-ADVANCED-ENGINEERING/message-queues.md) |
| Queue vs event stream | A queue delivers each message to one consumer and discards it; a stream retains an ordered log many consumers may replay. | [event-streaming](../18-ADVANCED-ENGINEERING/event-streaming.md) |
| Partition and offset | A stream's ordered shard and a consumer's position within it; ordering holds per partition, not globally. | [event-streaming](../18-ADVANCED-ENGINEERING/event-streaming.md) |
| Circuit breaker | Failing fast for a period once a dependency is failing, giving it room to recover. | [reliability-engineering](../18-ADVANCED-ENGINEERING/reliability-engineering.md) |
| Bulkhead | Isolating resources per workload so one saturated dependency cannot exhaust everything. | [reliability-engineering](../18-ADVANCED-ENGINEERING/reliability-engineering.md) |
| Retry with backoff and jitter | Retrying with growing, randomised delays so a recovering service is not stampeded. | [reliability-engineering](../18-ADVANCED-ENGINEERING/reliability-engineering.md) |
| Cache stampede | Many requests recomputing an expired cache entry at once; mitigated with locking or early refresh. | [database-scaling](../18-ADVANCED-ENGINEERING/database-scaling.md) |
| Profiling | Measuring where a program spends time or memory, then fixing the measured hotspot rather than the suspected one. | [performance-profiling](../18-ADVANCED-ENGINEERING/performance-profiling.md) |
| Flame graph | A stacked visualisation of sampled call stacks where width is time; the widest plateaus are the hot paths. | [performance-profiling](../18-ADVANCED-ENGINEERING/performance-profiling.md) |
| System design | Choosing components, boundaries and data flow to meet stated requirements, and naming the trade-offs. | [system-design](../18-ADVANCED-ENGINEERING/system-design.md) |

## Professional practice

| Term | Meaning | Taught in |
|---|---|---|
| Trunk-based development | Short-lived branches merged frequently into one trunk, keeping integration cost small. | [engineering-workflows](../19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md) |
| WIP limit | A cap on work in progress, so work finishes instead of queueing half-done. | [engineering-workflows](../19-PROFESSIONAL-DEVELOPMENT/engineering-workflows.md) |
| Code review | Reading another's change for correctness, clarity and risk, with comments separated by severity. | [code-review](../19-PROFESSIONAL-DEVELOPMENT/code-review.md) |
| Pull request size | The number of changed lines; detection falls sharply as size grows, so small changes are reviewed better. | [code-review](../19-PROFESSIONAL-DEVELOPMENT/code-review.md) |
| Documentation drift | Documentation becoming wrong as code changes; prevented by checks, not by writing more prose. | [technical-documentation](../19-PROFESSIONAL-DEVELOPMENT/technical-documentation.md) |
| Runbook | Step-by-step operational instructions for a task or incident, written for someone tired who has never seen the system. | [technical-documentation](../19-PROFESSIONAL-DEVELOPMENT/technical-documentation.md) |
| Reproduction case | The smallest reliable set of steps that makes a bug appear — the first deliverable of any debugging session. | [debugging-methodology](../19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md) |
| Bisection | Finding the change that introduced a defect by repeatedly halving a known-good/known-bad range, often with `git bisect`. | [debugging-methodology](../19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md) |
| Rubber-duck debugging | Explaining the problem aloud step by step, which exposes the assumption you have not checked. | [debugging-methodology](../19-PROFESSIONAL-DEVELOPMENT/debugging-methodology.md) |
| Portfolio evidence | Artefacts a reviewer can verify — a running deployment, a commit history, tests — rather than claims. | [portfolio-development](../19-PROFESSIONAL-DEVELOPMENT/portfolio-development.md) |
| Scope (promotion) | The size of the problem you are trusted to own; the axis on which levels are actually distinguished. | [career-paths](../19-PROFESSIONAL-DEVELOPMENT/career-paths.md) |
| Blameless postmortem | An incident review focused on systems and decisions rather than individuals, so people report accurately. | [incident-management](../17-CLOUD-AND-PRODUCTION/incident-management.md) |

## Related pages

- [Common Errors](common-errors.md) — the messages these concepts produce
- [Official Resources](official-resources.md) — where to read further
- [CURRICULUM-MAP.md](../CURRICULUM-MAP.md) — which subject teaches what, in order
