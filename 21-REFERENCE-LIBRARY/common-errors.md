# Common Errors

The messages learners meet most, with cause, diagnosis and fix. Entries are grouped by the tool that
prints them, and each one names the command that confirms the diagnosis — never change code on the
strength of a message alone.

> **Reading rule.** Find the *first* line that mentions your code, not the last line of the trace.
> Java prints the throw site first and the caller chain below it; JavaScript prints the offending
> frame at the top. The message is a symptom; the diagnosis column is how you find the cause.

**Baseline:** Java 21 (`javac --release 21`), Node 24, PostgreSQL 18, Docker Engine 29, Flutter
3.47. Messages are abridged — line numbers, paths and package names vary.

## Shell and operating system

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `bash: foo: command not found` | The binary is not on `PATH`, or the name is misspelled. | `type -a foo`, `echo $PATH` | Install the package, or call it by full path; add the install directory to `PATH` in your shell profile. |
| `Permission denied` | The file is not executable, or you lack read/write/execute rights on it or its directory. | `ls -l file`, `namei -l /full/path` | `chmod +x file` for an executable; fix ownership with `chown`; never `chmod 777` as a shortcut. |
| `No such file or directory` when running an existing script | The shebang line is wrong, or the file has CRLF line endings so the kernel looks for `/bin/bash\r`. | `head -1 script.sh \| od -c \| head -2` | Rewrite with LF endings (`dos2unix script.sh`) or fix the interpreter path in line 1. |
| `Address already in use` | Another process holds the port. | `ss -ltnp \| grep 8080` (Linux) or `netstat -ano \| findstr 8080` (Windows) | Stop that process or choose another port; do not kill blindly — confirm the PID owns the port. |
| `Argument list too long` | A glob expanded to more arguments than the kernel allows. | `ls \| wc -l` in the directory | Use `find . -name '*.log' -delete`, or `xargs -0`. |
| `Text file busy` | The executable is open for writing by another process, usually a running copy. | `fuser file` or `lsof file` | Stop the running process, then replace the file. |
| `Too many open files` | The process hit its file-descriptor limit. | `ulimit -n`, `lsof -p PID \| wc -l` | Close descriptors (often unclosed streams), or raise the limit deliberately. |
| `Read-only file system` | The mount is read-only, or the container's filesystem is immutable. | `mount \| grep ' / '` | Write to a writable path (`/tmp`, a mounted volume) instead of the system image. |

## Git

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `fatal: not a git repository` | You are outside the working tree, or `.git` was never created. | `pwd`, `ls -a`, `git rev-parse --show-toplevel` | `cd` into the repository root, or `git init` if this really is a new project. |
| `CONFLICT (content): Merge conflict in <file>` | Both sides changed the same lines. | `git status`, `git diff --name-only --diff-filter=U` | Edit the markers, `git add` each resolved file, then `git commit` (or `git merge --continue`). |
| `fatal: The current branch X has no upstream branch` | The branch exists only locally. | `git branch -vv`, `git remote -v` | `git push -u origin X` once; later pushes need no arguments. |
| `! [rejected] main -> main (non-fast-forward)` | The remote has commits you do not have. | `git fetch origin`, `git log --oneline HEAD..origin/main` | `git pull --rebase origin main`, resolve any conflicts, then push. Never force-push a shared branch. |
| `You are in 'detached HEAD' state` | You checked out a commit or tag rather than a branch. | `git status`, `git branch --show-current` (empty) | If you have new commits: `git switch -c keep-this-work`. If not: `git switch main`. |
| `error: Your local changes would be overwritten by checkout` | Uncommitted edits conflict with the switch. | `git status`, `git diff` | Commit them, or `git stash push -m wip`, switch, then `git stash pop`. |
| `fatal: pathspec 'x' did not match any files` | Typo, wrong directory, or the file is untracked and gitignored. | `git ls-files \| grep x`, `git status --ignored` | Correct the path; `git add -f` only if the ignore rule is genuinely wrong. |
| `fatal: remote origin already exists` | The remote is already configured. | `git remote -v` | `git remote set-url origin <url>` rather than adding a second one. |
| `Permission denied (publickey)` | The remote does not accept your key. | `ssh -T git@github.com`, `ssh-add -l` | Add the key to the agent and to the host account; HTTPS with a token is the fallback. |
| `warning: LF will be replaced by CRLF the next time Git touches it` | `core.autocrlf` is rewriting line endings on checkout. | `git config --get core.autocrlf`, `git check-attr -a -- file` | Expected on Windows; make it deliberate with `.gitattributes` (`* text=auto`) instead of toggling the setting per machine. |
| `fatal: refusing to merge unrelated histories` | Two repositories with no common ancestor are being merged. | `git log --oneline --graph --all \| head` | `git pull --allow-unrelated-histories` only when the histories really are separate projects being joined. |
| `error: cannot pull with rebase: You have unstaged changes` | Rebase needs a clean tree. | `git status` | Commit or stash first; rebase replays commits, so it cannot preserve unrelated edits. |

## Java and the JVM

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `error: cannot find symbol` | The compiler cannot resolve a name: missing import, typo, or the class is not on the classpath. | Read the `symbol:` and `location:` lines javac prints beneath it. | Add the import, correct the spelling, or add the dependency that provides the class. |
| `error: reached end of file while parsing` | An unclosed brace, parenthesis or string. | Count braces in the reported region; format the file. | Close the block; an editor with bracket matching finds it in seconds. |
| `error: class X is public, should be declared in a file named X.java` | A public class's file name does not match. | `ls` in the package directory | Rename the file, or drop `public` if the class really is package-private. |
| `error: incompatible types: possible lossy conversion from double to int` | Widening conversions are implicit; narrowing is not. | The error names both types. | Cast with `(int)` only when you intend truncation; otherwise keep the wider type. |
| `Exception in thread "main" java.lang.NullPointerException` | A method was called on a `null` reference — usually an uninitialised field or a missing return value. | The trace's top frame names the exact line; use a debugger or `Objects.requireNonNull` at the boundary. | Initialise the reference, handle the empty case, or return `Optional` and force the caller to decide. |
| `java.lang.ArrayIndexOutOfBoundsException: Index 5 out of bounds for length 5` | An index reached `length`; valid indices stop at `length - 1`. | Print the index and the array length at the failure. | Fix the loop bound (`i < a.length`) or the offset; check the empty-array case. |
| `java.lang.ClassNotFoundException` | The class is absent from the run-time classpath, though it compiled. | `java -cp ...`, inspect the built JAR with `jar tf app.jar \| grep X` | Rebuild including the dependency; for a `java -jar`, ensure the JAR is a fat JAR or use `-cp`. |
| `java.lang.NoSuchMethodError` | A dependency version at run time differs from the one compiled against. | `mvn dependency:tree -Dincludes=group:artifact` | Align versions in `pom.xml`; do not mix the Spring Boot BOM with hand-pinned transitive versions. |
| `UnsupportedClassVersionError: ... compiled by a more recent version` | The JVM is older than the compiler target. | `java -version`, `javac -version`, `mvn -version` | Use a JDK at least as new as the bytecode target; keep `JAVA_HOME` and the Maven toolchain consistent. |
| `java.lang.OutOfMemoryError: Java heap space` | The heap filled — a leak (retained references) or a genuinely large working set. | `-Xlog:gc`, a heap dump with `jcmd <pid> GC.heap_dump` | Fix the retention (caches, listeners, unbounded collections); raise `-Xmx` only after measuring. |
| `StackOverflowError` | Unbounded recursion, or a recursive `toString`/`equals`. | The repeating frames in the trace | Add or correct the base case; convert to iteration if depth is inherently large. |
| `error: variable x might not have been initialized` | A local variable is read on a path where it was never assigned. | Follow the branch the compiler reports. | Initialise at declaration, or restructure so every path assigns it. |
| `java.lang.IllegalStateException: Failed to load ApplicationContext` (Spring) | The context could not start; the real cause is further down the trace. | `grep -i "Caused by"` and read the *last* cause. | Fix the reported cause — usually a missing bean, bad property or port clash. |
| `Port 8080 was already in use` (Spring Boot) | Another process holds the port. | `ss -ltnp \| grep 8080` | Stop it, or set `server.port=8081`. |

## Maven

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `Could not resolve dependencies for project ...` | A dependency is missing from every configured repository, or the version does not exist. | Read the `artifact` coordinates in the message; check `mvn -X` output for the repositories tried. | Correct the coordinates; run with `-U` to force an update; check the repository is reachable. |
| `Non-resolvable parent POM` | The parent cannot be downloaded, or the relative path is wrong in a multi-module build. | `mvn help:effective-pom` | Fix `<parent>` coordinates or `<relativePath>`; ensure the parent is installed (`mvn install`) in a multi-module build. |
| `[ERROR] ... does not exist` on a test class | Test sources were not compiled, often due to a compile error earlier in the log. | Scroll to the *first* `ERROR`. | Fix the first compile error; later errors are frequently cascades. |
| `No compiler is provided in this environment. Perhaps you are running on a JRE` | Maven is using a JRE or the wrong `JAVA_HOME`. | `mvn -version` (it prints the Java home) | Point `JAVA_HOME` at a JDK 21 install. |
| `Fatal error compiling: invalid target release: 21` | The JDK in use is older than the configured release. | `mvn -version` | Install JDK 21+ and set `JAVA_HOME`; keep `maven.compiler.release` at the baseline. |
| `BUILD FAILURE ... There are test failures` | Tests ran and failed — this is a signal, not a tooling problem. | Open `target/surefire-reports/*.txt` for the assertion and stack. | Fix the code or the test; never skip tests to get a green build. |
| `Could not transfer artifact ... status code 401` | The repository requires credentials that are missing or wrong. | `cat ~/.m2/settings.xml` (do not print secrets) | Configure a server entry with the token; keep credentials out of `pom.xml`. |

## JavaScript, Node and npm

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `TypeError: Cannot read properties of undefined (reading 'x')` | The left-hand side is `undefined` at that point — a failed lookup or a value that has not loaded. | The top stack frame gives file and line; log the object just before it. | Guard (`obj?.x`), default the value, or fix the lookup that returned nothing. |
| `ReferenceError: x is not defined` | The name is not declared in scope, or a `let`/`const` is read before its declaration (temporal dead zone). | Check imports and the declaration order in the file. | Declare or import it; move the declaration above first use. |
| `SyntaxError: Unexpected token '<'` in the browser | The server returned HTML (usually an `index.html` fallback or a 404 page) where JavaScript was expected. | Open the failing URL directly; inspect the Network tab's response. | Fix the asset path or the dev-server fallback; in production, verify the build output is actually served. |
| `SyntaxError: Cannot use import statement outside a module` | ES module syntax in a file Node treats as CommonJS. | `cat package.json \| grep type` | Add `"type": "module"`, rename to `.mjs`, or switch to `require`. |
| `npm ERR! code ERESOLVE` / `unable to resolve dependency tree` | Two dependencies require incompatible peer versions. | Read the "Found:" and "Could not resolve" blocks npm prints. | Align versions, or use `--legacy-peer-deps` only as a temporary, documented workaround. |
| `npm ERR! code EADDRINUSE` | The dev server's port is taken. | `ss -ltnp \| grep 5173` | Stop the other process, or run with `--port 5174`. |
| `Error: Cannot find module 'x'` (Node) | The package is not installed, or the path is wrong (including a missing extension in ESM). | `npm ls x`, `node -e "console.log(require.resolve('x'))"` | `npm install x`, correct the path, or add the extension for ESM. |
| `Uncaught (in promise) ...` | A rejected promise with no `catch` or `try/await`. | The stack shows where the rejection happened, not where it was created. | Await inside `try/catch`, or attach `.catch` at the boundary. |
| `Hydration failed because the server rendered HTML didn't match the client` | Server and client produced different markup — often from `Date.now()`, `Math.random()` or browser-only state during render. | Compare the server HTML with the client tree in the error's diff. | Move non-deterministic values into effects, or render them only after mount. |
| `CORS policy: No 'Access-Control-Allow-Origin' header` | The browser blocked a cross-origin response that did not opt in. | The Network tab shows the request succeeded; only the read was blocked. | Configure the server's allowed origin; a proxy in dev is often cleaner than permissive CORS. |
| `net::ERR_CONNECTION_REFUSED` | Nothing is listening at that host and port. | `curl -v http://localhost:PORT` | Start the server, or correct the URL/port in the client config. |
## TypeScript

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `Type 'string' is not assignable to type 'number'` | The declared type and the value disagree. | Hover the symbol in the editor to see its inferred type. | Convert at the boundary, or widen the target type deliberately. |
| `Object is possibly 'undefined'` | `strictNullChecks` is on and the value may be absent. | Read the expression that produced it. | Narrow first (`if (x !== undefined)`), use `?.` with a default, or make the absence explicit in the type. |
| `Property 'x' does not exist on type 'Y'` | Wrong type, or the property genuinely is not there. | Hover `Y` to see its inferred shape. | Fix the type or add the property; do not cast with `as any` to silence it. |
| `Argument of type 'X' is not assignable to parameter of type 'Y'` | The call site's type does not satisfy the parameter's contract. | The error prints the missing or mismatched members. | Pass the expected shape, or fix the function's overly narrow parameter. |
| `Cannot find module 'x' or its corresponding type declarations` | The package is not installed, or has no bundled types. | `npm ls x`; check `node_modules/x/package.json` for `types`. | Install it, plus `@types/x` when the package ships no types. |
| `Conversion of type 'X' to type 'Y' may be a mistake` | A cast between unrelated types. | Read both sides of the cast. | Cast to `unknown` first only when you genuinely know better — and comment why. |
| `Variable 'x' implicitly has an 'any' type` | `noImplicitAny` is on and inference found nothing. | Look for an untyped parameter or an empty array declaration. | Annotate the parameter or give the array a type. |

## Python (used by the repository's own scripts)

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `ModuleNotFoundError: No module named 'x'` | The package is not installed for the interpreter running the script. | `python -c "import sys; print(sys.executable)"`, `pip list` | Install with that interpreter's `pip`, or use a virtual environment. |
| `IndentationError: unexpected indent` | Mixed tabs and spaces, or a stray indent. | `cat -A file \| head` shows tabs as `^I`. | Re-indent the block with spaces only; configure the editor to insert spaces. |
| `SyntaxError: expected ':'` | A block header without its colon. | The caret points at the offending token. | Add the colon. |
| `UnicodeDecodeError: 'utf-8' codec can't decode byte 0x..` | The file is not UTF-8 — commonly cp1252 from Windows tooling. | `file text.txt`, `python -c "print(open('text.txt','rb').read()[:20])"` | Convert the source file to UTF-8; do not patch the reader's encoding to hide it. |
| `ValueError: I/O operation on closed file` | The file was used after its `with` block ended. | The traceback names the line outside the block. | Move the reads inside the `with`, or read into memory before leaving it. |
| `TypeError: object of type 'NoneType' has no len()` | A function returned `None` where a collection was expected. | Print the value before the failing call. | Return an empty collection instead of `None`, or handle `None` at the call site. |

## SQL and PostgreSQL

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `ERROR: relation "orders" does not exist` | Wrong schema/search path, wrong database, or the migration never ran. | `\dt` in `psql`, `SHOW search_path` | Run the migration against the right database; qualify with `schema.table` if needed. |
| `ERROR: column "total" does not exist` | Typo, wrong table alias, or a missing `GROUP BY` for an alias used in `WHERE`. | Read the `LINE n:` snippet psql prints. | Correct the name; use `HAVING` for aggregates; aliases are not visible in `WHERE`. |
| `ERROR: syntax error at or near "..."` | The parser stopped at that token — frequently a missing comma, an unquoted string, or a keyword used as an identifier. | The caret under the snippet marks the position. | Fix the token; quote reserved words with double quotes. |
| `ERROR: duplicate key value violates unique constraint "..."` | An insert or update would create a second row with the same unique value. | `DETAIL: Key (email)=(x) already exists.` | Check first, use `ON CONFLICT DO NOTHING/UPDATE`, or return 409 from the API. |
| `ERROR: insert or update on table "x" violates foreign key constraint` | The referenced row does not exist, or a delete would orphan children. | `DETAIL:` names the missing key and the constraint. | Insert/lookup the parent first; choose `ON DELETE CASCADE`/`SET NULL` deliberately. |
| `ERROR: null value in column "x" violates not-null constraint` | A required column was omitted or explicitly `NULL`. | The `DETAIL` names the row and column. | Supply a value or a `DEFAULT`; fix the insert, not the constraint. |
| `ERROR: deadlock detected` | Two transactions hold locks the other needs; PostgreSQL aborts one. | `DETAIL: Process 1 waits for ...` | Retry the aborted transaction; order writes consistently to remove the cycle. |
| `ERROR: could not serialize access due to concurrent update` | `REPEATABLE READ`/`SERIALIZABLE` detected a conflict. | The error names the isolation level. | Retry the transaction with backoff; keep transactions short. |
| `ERROR: permission denied for table x` | The connected role lacks the privilege. | `\dp x`, `SELECT current_user` | `GRANT` the needed privilege to that role — do not connect as the superuser from the app. |
| `FATAL: too many connections` | The pool exceeded the server's `max_connections`. | `SHOW max_connections`, count clients with `pg_stat_activity`. | Shrink per-instance pool size, add a pooler, or close leaked connections. |
| `ERROR: canceling statement due to statement timeout` | A query exceeded `statement_timeout`. | `EXPLAIN (ANALYZE, BUFFERS)` the statement. | Add the missing index or fix the query shape; raising the timeout alone hides the problem. |
| Query returns 0 rows but the data exists | A `WHERE` on `NULL` (which is never equal to anything), or a transaction that has not committed. | Re-run without the filter; `SELECT x IS NULL` | Use `IS NULL`/`IS DISTINCT FROM`; commit the writing transaction. |

## HTTP, browsers and networking

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `401 Unauthorized` on a request that includes a token | The credential is missing, malformed, expired, or sent to the wrong audience. | Decode the token's `exp`, `iss`, `aud`; log whether the header arrived. | Refresh the token, fix the header format (`Bearer <token>`), align issuer/audience config. |
| `403 Forbidden` | Authenticated but not allowed — a missing role or ownership check. | Log the user's roles and the resource's owner. | Grant the permission or correct the authorisation rule; do not "fix" it by disabling the check. |
| `404` from a SPA route that works in dev | The server has no fallback to `index.html` for client-side routes. | `curl -i https://host/deep/route` | Configure the host's rewrite/fallback to `index.html` for non-asset paths. |
| `405 Method Not Allowed` | The route exists but not for that verb, or the proxy only forwards some verbs. | `curl -i -X OPTIONS` and read the `Allow` header. | Use the supported verb, or register the handler for the verb the client sends. |
| `413 Payload Too Large` | The body exceeded the server or proxy limit. | Compare `Content-Length` with the server's `client_max_body_size`/`max-http-request-size`. | Raise the limit deliberately, or stream/chunk the upload. |
| `429 Too Many Requests` | A rate limit was hit. | Read `Retry-After` and `X-RateLimit-*` headers. | Back off and retry; raise the limit only after confirming the traffic is legitimate. |
| `502 Bad Gateway` | The proxy could not get a valid response from the app — often the app is down or still starting. | Proxy log plus the upstream's own log; `curl` the app directly on its port. | Fix the upstream (crash, wrong port, slow start); add a health check so routing waits for readiness. |
| `504 Gateway Timeout` | The upstream did not answer within the proxy's timeout. | Compare proxy timeout with the endpoint's measured latency. | Fix the slow query/call, or move the work to a background job; raising the timeout only defers it. |
| `Mixed Content: The page at https://... was loaded over HTTPS, but requested an insecure resource` | An `http://` URL is referenced from an HTTPS page. | The console names the blocked URL. | Use `https://` or a protocol-relative path; serve assets from the same scheme. |
| `ERR_CERT_AUTHORITY_INVALID` | The certificate is self-signed or its CA is not trusted. | `openssl s_client -connect host:443 -servername host` | Trust the local CA in development; use a real certificate in production. |
| `ECONNREFUSED 127.0.0.1:5432` from the app | Nothing is listening — wrong host/port, or the database is bound to another interface. | `ss -ltnp \| grep 5432`, `pg_isready -h localhost` | Start the database; in containers use the service name, not `localhost`. |
| `getaddrinfo ENOTFOUND db` inside a container | The hostname does not resolve on the container's network. | `docker compose ps`, `docker exec app getent hosts db` | Put both services on the same Compose network and use the service name as the host. |

## Docker

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `Cannot connect to the Docker daemon at unix:///var/run/docker.sock` | The daemon is not running, or your user cannot access the socket. | `docker info`, `systemctl status docker` | Start Docker Desktop/daemon; add your user to the `docker` group (Linux) and re-login. |
| `Bind for 0.0.0.0:8080 failed: port is already allocated` | A host port is taken by another container or process. | `docker ps --format '{{.Names}} {{.Ports}}'` | Stop the other container, or publish on a different host port (`-p 8081:8080`). |
| `exec /app/start.sh: no such file or directory` | The file is missing, not executable, or has CRLF line endings or a bad shebang. | `docker run --rm -it image ls -l /app`, then `head -1 /app/start.sh` | `COPY` it with `--chmod=755`, save with LF, and check the interpreter exists in the image. |
| `exec format error` | The image architecture differs from the host — an `amd64` image on `arm64`, typically. | `docker image inspect image --format '{{.Architecture}}'` | Build with `--platform linux/amd64` (or the matching platform); use multi-arch base images. |
| `COPY failed: file not found in build context` | The path is outside the context, or excluded by `.dockerignore`. | `cat .dockerignore`, `docker build` from the correct directory. | Fix the path relative to the context; never build from the filesystem root. |
| `no space left on device` | The Docker disk image or host disk is full. | `docker system df`, `df -h` | Prune stopped containers, unused images and build cache: `docker system prune` (review first). |
| `manifest unknown` / `pull access denied` | The tag does not exist, or the registry needs authentication. | `docker manifest inspect repo:tag`; `docker login` | Correct the tag; authenticate for private registries. |
| `permission denied while trying to connect` on Linux | Your user is not in the `docker` group. | `id -nG` | `sudo usermod -aG docker $USER`, then log out and back in. |
| Container exits immediately with code 0 | The main process finished — often a `CMD` that starts a shell or a daemonised process. | `docker logs <container>`, `docker inspect -f '{{.State.ExitCode}}'` | Run a foreground process as PID 1 (`ENTRYPOINT ["java","-jar","app.jar"]`). |
| Container is `unhealthy` | The `HEALTHCHECK` command fails inside the container. | `docker inspect -f '{{json .State.Health}}'` | Fix the probe: correct URL/port, install `curl`, allow startup time with `start_period`. |

## Flutter, Dart and Gradle

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `Waiting for another flutter command to release the startup lock` | A previous Flutter process crashed or is still running. | `ps aux \| grep flutter` (or check the lock file path printed) | Close that process, then delete `bin/cache/lockfile` only if nothing is running. |
| `Target of URI doesn't exist: 'package:x/...'` | The dependency is not in `pubspec.yaml`, or `pub get` has not run. | `flutter pub deps \| grep x` | Add the dependency and run `flutter pub get`. |
| `A value of type 'X?' can't be assigned to a variable of type 'X'` | Null safety: the value may be `null`. | Find where it could be null. | Provide a fallback (`??`), narrow with a null check, or use `!` only where you can prove non-null. |
| `setState() called after dispose()` | An async callback finished after the widget was removed. | The trace shows the future that completed. | Guard with `if (!mounted) return;` before touching state. |
| `Vertical viewport was given unbounded height` | A scrollable widget inside a column/other unbounded parent. | The trace names the widget. | Wrap in `Expanded`/`SizedBox`, or use `shrinkWrap` deliberately. |
| `Gradle task assembleDebug failed with exit code 1` | The real error is above this line in the Gradle output. | Search the log upward for `FAILURE` / `Caused by`. | Fix the reported cause — usually a missing SDK, plugin or JDK version. |
| `Unsupported class file major version` (Gradle) | Gradle's JVM and the required Java version disagree. | `flutter doctor -v`, `java -version` | Point Flutter at a supported JDK (17/21) in `flutter config --jdk-dir`. |
| `MissingPluginException` | A platform plugin is not registered — often after a hot restart or an incomplete rebuild. | `flutter clean && flutter pub get` | Do a full rebuild; ensure the plugin supports the target platform. |
| `Code signing is required for product type 'Application'` (iOS) | No development team or signing certificate is configured. | Xcode → Signing & Capabilities | Select a team and let Xcode manage signing; only on macOS. |

## Test failures

| Message (abridged) | Cause | Diagnose | Fix |
|---|---|---|---|
| `expected: <2> but was: <3>` (JUnit) | The assertion's expectation does not match behaviour. | Read the failing line and the actual value; reproduce with a debugger. | Decide which is wrong — the code or the expectation — and fix that one. |
| `org.opentest4j.AssertionFailedError` (Java) | Same as above, newer JUnit. | The report includes expected/actual. | Same as above. |
| `Tests run: 5, Failures: 1, Errors: 1` | Failures are assertion mismatches; errors are exceptions escaping the test. | `target/surefire-reports/*.txt` | Fix the exception first; assertion failures next. |
| `Test timed out after 5000ms` | Genuine slowness, a deadlock, or a missing `await` on a future. | Re-run the single test with more logging. | Fix the wait condition; never raise the timeout to hide a hang. |
| `AssertionError: expected [Function] to throw` (Vitest) | The code did not throw where the test expected it to. | Check the input actually reaches the throwing branch. | Fix the code or the test; do not weaken the assertion silently. |
| Test passes alone, fails in the suite | Shared mutable state or order dependence. | Run with `-Dtest=...` and with the full suite. | Reset shared state in `@BeforeEach`; make each test independent. |
| `Address already in use` in an integration test | A previous run left the server or container up. | `docker ps`, `ss -ltnp` | Tear down in `@AfterAll`; use a random port (`server.port=0`). |

## Method when the message is not here

1. **Read the whole message, not the first line.** The cause is usually below "Caused by:" or after "DETAIL:".
2. **Copy the distinctive phrase, not the whole trace.** Paths and line numbers differ between machines; the message text is the searchable part.
3. **Reproduce in the smallest possible setting.** A one-file reproduction either fails the same way — and is now debuggable — or reveals that your environment, not the code, is the problem.
4. **Check the version before the advice.** Most search results answer for a different major version; compare with [`VERSIONS.md`](../VERSIONS.md).
5. **Change one thing at a time.** If two changes fix it, you have learned nothing and broken something invisibly.
6. **Write the entry.** If the fix took more than ten minutes and is missing here, add it — the next reader is you in three months.

## Related pages

- [Glossary](glossary.md) — the terms in these messages
- [Command Reference](command-reference.md) — the diagnostic commands used above
- [Git Reference](git-reference.md) — recovery procedures for the Git entries
- [Official Resources](official-resources.md) — error-code documentation straight from the vendors
