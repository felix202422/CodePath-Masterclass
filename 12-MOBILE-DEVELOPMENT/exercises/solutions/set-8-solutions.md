# Set 8 solutions — Forms and validation → `forms-and-validation.md`

*Executed in the batch's `scaffold` lab as battery W8 plus the deliberate-break drill
(`flutter test`, Flutter 3.47.7). Blocks marked *reference* are shapes to run in your lab.*

## 1. The print-vs-assert trap, executed (the drill)

Round 1 — validator broken (always returns null), test only *prints* the error state:

```
email-error="<absent>"
+4: All tests passed!        ← GREEN while the bug is live
```

Round 2 — give it teeth:

```
Found 0 widgets with text "Enter an email"
Some tests failed            ← exit 1
```

Round 3 — revert the break:

```
+4: All tests passed!        ← green again, honestly
```

One sentence: `print` observes, `expect` asserts — a test can only fail if something in it
*demands* an outcome; the first round was a log line wearing a test's name.

## 2. Validation on submit, three states (executed W8)

```
empty submit   → errors painted, callback=not called
invalid email  → errors painted, callback=not called
valid submit   → errors-gone=true, email=ada@example.com password=correct horse
```

Error-text source: the **validator's returned string**, surfaced through
`Form`/`TextFormField` error plumbing — not a local `errorText` field you maintain
separately (two sources drift; the executed suite keeps one: `validator` is the single
truth, the UI reads it).

## 3. Async validation with debounce (reference shape)

Red first: with a `Clock` injected (fake async), type `ada`, `adab`, `adams` — the broken
version fires **three** requests and the stale `adab` response overwrites `adams`
(assertion: `requests == 1` fails; capture the red). Fix: debounce 300 ms on the clock and
a request-sequence guard (`if (seq != latest) return;`), then green:

```
requests=1 submitted=adams
```

— no request until typing stops, late response dropped by the sequence check.

## 4. Independent — edit form with dirty tracking (reference shape)

Three behaviors, three tests:

```dart
// prefill: TextFormField initial value equals the loaded record
// dirty:    change one field → canPop=false, guard shows dialog
// guard:    dialog "Stay" → still on form; "Discard" → pops, record unchanged
```

Exit paths both asserted (`Stay` keeps the edit, `Discard` pops with the original record
compared field-by-field). The design line that makes this short: track dirty as
`current != initial` on the parsed model — a boolean you *set* on change desyncs the
moment validation normalizes input.
