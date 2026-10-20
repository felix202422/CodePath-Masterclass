# Solutions — Set 13: Exceptions

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Catch by subtype

**Reference shape:** method `throws IOException` after opening a missing file; caller catches
`FileNotFoundException` **first**, then `IOException`:

```text
caught specific: missing.txt
caught wider: java.io.IOException (fallback)   // only reachable for other IO failures
```

- Order matters: a general `catch (IOException)` **before** the specific one is itself a compile
  error (unreachable) — the compiler polices the hierarchy direction you write.

**Criteria check:** ☐ two catch paths exercised ☐ hierarchy verified by output.

## Exercise 2 — A described custom exception

```java
static class NegativeTransferException extends Exception {
    final String from; final int amount;
    NegativeTransferException(String from, int amount) {
        super("transfer from " + from + " rejected: " + amount);
        this.from = from; this.amount = amount;
    }
}
```

- Caller prints `super.getMessage()` **and** `e.amount` — the payload survives the round trip,
  which is the difference between "an error happened" and "this exact value failed".

**Criteria check:** ☐ message + field survive ☐ throw/catch round trip executed.

## Exercise 3 — The two checked-exception refusals

```console
Main.java:4: error: unreported exception NegativeTransferException; must be caught or declared to be thrown
```

```console
Main.java:6: error: exception FileNotFoundException is never thrown in body of corresponding try statement
```

- First: you *threw* without declaring — add `throws` or `catch`. Second: you *caught* what the
  body promises it can't throw — the compiler saw the method's signature and refused the dead
  handler. Checked exceptions make both directions of the contract visible.

**Criteria check:** ☐ both messages ☐ each explained in one sentence.

## Exercise 4 — TransferService (independent)

**Reference shape:** three failure kinds — insufficient funds, bad amount, unknown account —
each its own exception carrying account id + amount; `finally { audit("attempt " + from + " -> " + to); }`
guarantees one audit line per path.

```text
insufficient: acct A1 has 50, tried 80
bad amount:   -10 is not a positive transfer
unknown:      acct ZZ not found
audit: attempt A1 -> B2        // printed on success AND all failures
audit: attempt A1 -> B2
audit: attempt A1 -> B2
```

**Criteria check:** ☐ three distinct reports ☐ audit on every path including success.

---

Next: [set-14-solutions.md](set-14-solutions.md)
