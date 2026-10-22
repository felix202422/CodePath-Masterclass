# Forms and Validation

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Structure a form correctly — `form`, `label`↔control association, grouping, submit/reset — and prove each control is labeled
- [ ] Choose native constraint attributes (`type`, `required`, `min`/`max`, `minlength`, `pattern`) for a stated rule set, and state the browser behavior each one triggers
- [ ] Read `checkValidity()` output and the `ValidityState` flags to say *why* a value was rejected
- [ ] Distinguish client-side validation (guidance) from server-side validation (security) and state what each is responsible for
- [ ] Design the error experience: `novalidate` + custom messaging done accessibly, or native bubbles — with a justified choice

## 2. Prerequisites

- [Semantic HTML](semantic-html.md) — labels, grouping, and the outline rules forms inherit
- [HTML Fundamentals](html-fundamentals.md) — attributes as the constraint vocabulary
- [06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md](../06-INTERNET-AND-WEB-FOUNDATIONS/http-fundamentals.md) — what happens when the form actually submits

## 3. Introduction

Forms are where a page stops being a document and starts being software: the user hands you
data, you decide whether to accept it, and every step — labeling, constraints, error messaging —
determines whether that works for everyone. HTML ships a complete validation system natively:
types that change the mobile keyboard, constraints the browser checks before submit, and a
`ValidityState` API your scripts can read. Most teams skip it and write JavaScript from
scratch, losing free accessibility and introducing inconsistencies. This lesson's evidence is
executed against the real system: five controls, five violations, and the browser's own
rejection reasons.

## 4. The Problem It Solves

A form collects untrusted data from humans who are hurried, on phones, and sometimes using
assistive technology. Three failure modes drive every design decision:

- **Garbage arrives.** Without constraints, you receive `age = "asdf"` and empty required
  fields — then either crash, silently corrupt, or reject later with a confusing message.
  Constraint validation moves the check to where the user can still fix it: the moment of
  input.
- **The user can't tell what's wanted.** An unlabeled input (placeholder as only label —
  placeholder disappears on typing) makes forms unusable for screen-reader users and mere
  guesswork for everyone. Label association is the *minimum viable form*.
- **Validation is a security boundary being misplaced.** The most classic vulnerability class
  — "validated in the browser only" — exists because client-side checks run in code the user
  controls: they can be bypassed with a single flag. The two-layer answer (client for
  guidance, server for enforcement) is the whole security story of this lesson.

HTML's constraint API solves the first two natively and *supports* the third (it never
replaces it). The executed transcript in section 6 is that system talking.

## 5. Core Concepts

### Label association: the non-negotiable

Every control needs a `<label>` whose `for` matches the control's `id` (or which *contains*
the control). Association buys three things at once: click target (clicking the label focuses
the input — bigger touch area), the accessible name (what a screen reader announces: "Email,
edit text"), and programmatic identity that audit tools check. `aria-label`/`aria-labelledby`
work for controls where visible text is impossible (icon buttons), but a *visible* label is
still required for sighted users — placeholder-only fields fail both axe (`label`) and common
sense (placeholder vanishes on focus; low-contrast by default).

**Grouping** is the other half of naming: related radio/checkbox sets wrap in `<fieldset>` +
`<legend>` so the group itself is announced ("Gender, radio group, 3 options") instead of three
orphan radios each reading only their own text.

### Input types are behavior, not decoration

`<input type=…>` changes parsing, keyboard, and validation at once:

| Type | Native rule it enforces | Keyboard/UX effect |
|---|---|---|
| `email` | value must parse as an email (contains `@`, valid domain) | `@`-optimized mobile keyboard, `typeMismatch` if wrong |
| `url` | must be an absolute URL (scheme required) | URL keyboard layout |
| `number` | numeric (plus spinner UI) | numeric keys; pairs with `min`/`max`/`step` |
| `tel` | *no* validation (pattern only) | telephone keypad — types are not all validators |
| `date` | must parse as a date | native date picker |
| `password`, `search`, `text` | free text (plus any attributes below) | standard |

The executed transcript shows `type="email"` rejecting `not-an-email` with `typeMismatch` —
the parser and validator are the same mechanism: **the type defines what a valid value *is*.**

### Constraint attributes: the rule vocabulary

- `required` — value must be present (`valueMissing` when empty)
- `minlength` / `maxlength` — text length bounds (`tooShort` / `tooLong`)
- `min` / `max` / `step` — numeric/date bounds (`rangeUnderflow` / `rangeOverflow` / `stepMismatch`)
- `pattern` — full-string regular expression (`patternMismatch`); the value must match the
  *whole* pattern (anchors are implicit) — a common source of subtle bugs when written as in
  JavaScript's `test()`
- `multiple` (on email/file), `title` (hint for pattern failures — announce-able, so keep it real)

### ValidityState: why, not just whether

`el.checkValidity()` returns a boolean; `el.validity` returns *which* rule failed — an object
of flags: `valueMissing`, `typeMismatch`, `patternMismatch`, `tooShort`, `tooLong`,
`rangeUnderflow`, `rangeOverflow`, `stepMismatch`, `badInput`, `customError`. Plus
`el.validationMessage` — the browser's human-readable reason. Scripts use the flags to attach
*specific* messages ("Must be 18 or over" instead of "Invalid value"), and
`el.matches(':invalid')` / `:valid` CSS states style fields live (red border as they type —
debounced, because styling on every keystroke before blur is hostile; see section 9).

### The two-layer contract

| Layer | Runs where | Can be bypassed? | Responsible for |
|---|---|---|---|
| Client-side (HTML/JS) | User's machine | **Always yes** | Immediate guidance, UX, catching honest mistakes |
| Server-side | Your machine | No (it *is* the boundary) | Security, data integrity, business rules — **every** rule the client checks, plus all the ones a client never could |

The rule in one line: **client-side validation is a courtesy; server-side validation is the
truth.** The same `min="18"` must be re-checked in your backend — and any auth, price, or
ownership rule was never client-side at all.

## 6. How It Works

### Five controls, five native rejections — executed

The lab form set `novalidate` (so no bubbles interfere with capture), then filled each control
with a deliberately wrong value and read the system's verdict. Headless Chrome 156, authoring
machine — full executed output:

```console
email: value="not-an-email"
  checkValidity() = false
  failing flags = typeMismatch
  matches(:invalid) = true
  validationMessage = "Please include an '@' in the email address. 'not-an-email' is missing an '@'."
age: value="15"
  checkValidity() = false
  failing flags = rangeUnderflow
  matches(:invalid) = true
  validationMessage = "Value must be greater than or equal to 18."
user: value="ab_1"
  checkValidity() = false
  failing flags = patternMismatch
  matches(:invalid) = true
  validationMessage = "Please match the requested format."
site: value="example.com"
  checkValidity() = false
  failing flags = typeMismatch
  matches(:invalid) = true
  validationMessage = "Please enter a URL."
bio: value=""
  checkValidity() = true
  failing flags = none
  matches(:invalid) = false
  validationMessage = ""
```

Read it as a system working, line group by line group:

1. **`email`: `typeMismatch`** — `type="email"`'s own parser rejected the value; the message
   even echoes the bad value. This is *type* validation, not `pattern` — no regex was written.
2. **`age`: `rangeUnderflow`** — `min="18"` with `15`: the bound itself is the rule and the
   flag names the direction (underflow below `min`, overflow above `max`, `stepMismatch` for
   off-grid values like `19.5` with `step=1`).
3. **`user`: `patternMismatch`** — `pattern="[A-Za-z]+"` with `ab_1`: the underscore failed the
   whole-string match. Note the message is generic ("Please match the requested format") —
   native messages for `pattern` are weak, which is exactly why `title` or a custom message
   matters (section 9).
4. **`site`: `typeMismatch` again** — a *different* type, the same flag: `type="url"` requires
   `https://…`-shaped input, so `example.com` fails. The flag name says "mismatch" — the type
   defines what matched.
5. **`bio` empty with no `required`: valid** — absence of a constraint is permission. And the
   control the *bad* page in lesson 11 left label-less still validates *values* — validity and
   accessibility are different systems (outline probe: `inputs without associated label: 1`).

The flags are the API contract your custom messaging codes against:

```javascript
form.addEventListener('submit', (e) => {            // runs only when native checks passed
  /* ...but the SERVER re-validates everything (section 5) ... */
});
```

```javascript
// progressive enhancement: precise messages without giving up native gating
noValidateThe(form);
form.addEventListener('invalid', (e) => {
  const flag = firstTrueFlag(e.target.validity);     // valueMissing? rangeUnderflow? ...
  e.target.setCustomValidity(MESSAGES[flag]);        // specific text, per flag
}, true);
form.addEventListener('input', (e) => e.target.setCustomValidity(''));  // clear as they fix it
```

### The whole form, correctly built

```html
<form action="/register" method="post">
  <fieldset>
    <legend>Account</legend>

    <label for="email">Email address</label>
    <input id="email" name="email" type="email" required autocomplete="email"
           aria-describedby="email-hint">
    <p id="email-hint">We never share your address.</p>

    <label for="age">Age</label>
    <input id="age" name="age" type="number" min="18" max="99" inputmode="numeric">

    <label for="user">Username</label>
    <input id="user" name="user" type="text" required minlength="8" pattern="[A-Za-z]+"
           title="8+ letters, no other characters">
  </fieldset>

  <label for="bio">Bio <span aria-hidden="true">(optional)</span></label>
  <textarea id="bio" name="bio" rows="4"></textarea>

  <button type="submit">Create account</button>
</form>
```

- **`aria-describedby="email-hint"`** attaches the hint as extra accessible description
  (announced after the label) — the pattern the executed good page in lesson 11 used (axe: 0
  violations with this exact structure).
- **`title` on the pattern field** gives pattern failures a describable rule (and surfaces as
  tooltip); still better: a visible hint via `aria-describedby` like the email one.
- **`autocomplete`** is accessibility *and* conversion: password managers and address autofill
  need it, and it reduces typo-driven invalid states before validation even runs.
- **`required` + `aria-hidden`-marked "(optional)"** — marking what's *absent* is friendlier
  than marking what's present once most fields are required.
- Submit/reset semantics: `<button type="submit">` inside the form submits (implicit
  `form` attribute allows buttons outside the `<form>` element); `type="button"` does nothing
  until scripted — the default is `submit`, which catches everyone once.

## 7. Practical Examples

**Example 1 — audit every control's labels and validity in one pass**

```console
$ chrome --headless --dump-dom --virtual-time-budget=2000 file:///path/form.html > dom.html
```

with this probe in the page (the executed outline probe from lesson 2, form-focused):

```javascript
const unlabeled = [...document.querySelectorAll('input, textarea, select')].filter(
  i => !i.labels?.length && !i.getAttribute('aria-label') && !i.getAttribute('aria-labelledby')
).length;
console.log('controls without a label:', unlabeled);
console.log('required controls:', document.querySelectorAll('[required]').length);
```

- **Expected output:** `controls without a label: 0` on a healthy form; any count > 0 is an
  axe-failing field (lesson 11's bad page reported `inputs without associated label: 1` the
  same way).
- **How to run it:** in-page script + `--dump-dom`, or paste into the devtools console.
- **Assumptions:** Chrome 156 (authoring machine).

**Example 2 — server-side validation that mirrors the form (what the client cannot enforce)**

```python
# register.py — the same rules, as the actual boundary (Flask-shaped, stdlib-clean logic)
import re
from flask import request, abort

EMAIL = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")      # mirrors type=email, roughly
USER  = re.compile(r"^[A-Za-z]+$")                      # mirrors pattern="[A-Za-z]+"

def validate_register(form: dict) -> dict:
    errors = {}
    email, user, age = form.get("email", ""), form.get("user", ""), form.get("age", "")
    if not email or not EMAIL.match(email):
        errors["email"] = "Enter a valid email address."          # typeMismatch
    if not user or len(user) < 8 or not USER.match(user):
        errors["user"] = "8+ letters, a-z only."                  # patternMismatch/tooShort
    if not age or not age.isdigit() or not (18 <= int(age) <= 99):
        errors["age"] = "Age must be between 18 and 99."          # rangeUnderflow/Overflow
    if errors:
        abort(400, description=errors)      # never trust the browser's checks having run
    return {"email": email, "user": user, "age": int(age)}
```

- **What the important lines do:** every native rule from the executed transcript appears again
  server-side — `typeMismatch`, `patternMismatch`, `rangeUnderflow` — because a request with
  `age=5` arrives here just fine when validation was only client-side (curl posts anything).
- **Expected output:** a valid POST returns 200; `curl -d 'email=bad&user=x&age=5'` returns 400
  with per-field messages — capture it with `curl -i`.
- **How to run it:** your own backend, or the pattern applied to whatever stack subject 11
  introduces; the *structure* (mirror each client rule + add business rules) is the lesson.
- **Assumptions:** run it wherever your backend runs; the executed client side of this contract
  is the transcript in section 6.

## 8. Real-World Applications

- **Every checkout, signup, and settings screen** is this lesson: native types for phone
  keyboards (`inputmode`/`type` determine the mobile keyboard — a real conversion metric),
  `autocomplete` for autofill speed, constraint attributes for instant feedback, and the server
  mirroring it all (subject 11's request validation is the same rules in framework form).
- **Accessible forms are the most-tested surface in audits.** Label association, error
  association (`aria-describedby` / `aria-invalid` + live regions — lesson 11), fieldset
  grouping for radios: the checklist *is* this lesson's section 7 structure, and axe checks
  most of it automatically (executed: 7 violations → 0 for the paired pages).
- **Multi-step wizards and dynamic forms** (subjects 08/09) still run on the same primitives —
  `novalidate` + custom messaging is where libraries (Formik, React Hook Form, HTMX patterns)
  live; they wrap `ValidityState`, they don't replace it.
- **Progressive enhancement**: a form with `action`/`method` and constraints *works without
  JavaScript* — the browser validates and the server receives. That resilience is why the
  native system still matters in a framework world.

## 9. Common Mistakes

| Mistake | Why it happens | How to recognize it | How to prevent it |
|---|---|---|---|
| Placeholder instead of `<label>` | Looks cleaner in the mock | Screen reader announces nothing; label disappears on focus | Real `<label for>` always; `aria-describedby` for extra hints |
| Client-side only validation | Faster to ship | `curl -X POST -d 'age=5'` sails through | Mirror every rule server-side (Example 2); treat client checks as UX |
| Styling `:invalid` on every keystroke | Eager red borders feel helpful | Field turns red while typing the first character of a valid value | Style on `:user-invalid` (modern) or after blur/submit; reserve `:invalid` for post-interaction |
| `pattern` written JS-style (`^…$` ok, but unanchored mentally) | Regex habits | Matches substrings unexpectedly | Patterns match the *entire* value by spec — test edge values; document via `title`/hint |
| Custom messages that replace native gating (`novalidate` with weak JS) | Wanting styled messages | Bypassable form, inconsistent coverage | Keep native `invalid` event gating; set messages *per ValidityState flag* |

## 10. Best Practices

- **Label first, style second.** Write the `label`→`id` pair before the input exists in your
  head; then style. The `for`/`id` association is one typo away from broken (`for="emial"`),
  so run the Example 1 audit after any rename.
- **Use the strictest type that is honest.** `type="email"` over `type="text"` + a regex buys
  keyboard, autofill, parsing, and validation for free; `inputmode`/`type` are also your
  mobile-keyboard UX. Never invent a type's job with a generic field.
- **Write one message per flag.** Map `valueMissing → "required"`, `rangeUnderflow → "must be
  ≥ 18"`, `patternMismatch → the actual rule` — the executed `validationMessage` strings are
  decent defaults but generic for `pattern`; specific text cuts support load.
- **Debounce, don't nag:** live validation on `input` after first blur (or `:user-invalid`),
  clear on correction — the executed `matches(:invalid) = true` lines are a *state*, and
  turning that state red mid-typing is a design choice, not a requirement.
- **Autocomplete everywhere it applies** (`email`, `name`, `street-address`, `current-password`)
  — an accessibility requirement (cognitive and motor users rely on it) that also converts.

## 11. Limitations and Trade-Offs

- **Native bubbles are unstyleable.** The default error bubble's appearance is the browser's —
  teams often choose `novalidate` + custom inline messages for design control. That trade
  *removes* native gating, so your script must now cover every flag (the executed five) or
  lose checks silently. Do it deliberately, with the `invalid` event, not by omission.
- **Client rules are a UI contract, not a security contract.** Everything in section 5's
  client row can be deleted in devtools. Additionally, clients validate *format*, never
  *context* — uniqueness, ownership, current-state rules only exist server-side.
- **`pattern` is not enough for real formats.** Phone numbers, postal codes, and locales vary
  by country; regexes that look complete are usually wrong somewhere (and `pattern` can't
  normalize — `+44…` may be valid input your backend must canonicalize, not reject).
- **Native validation timing differs by browser.** Submit-time behavior is standard; *live*
  behaviors (`:user-invalid`, bubble timing) vary — which is another argument for owning the
  message layer explicitly if your users span browsers.

## 12. Practical Exercises

### Introductory

1. **Exercise 7.1** — Recreate the executed five-control form in your own file; run the probe
   (or the console equivalent) and reproduce all five flag groups with the browser's own
   messages.
   **Completion criteria:** five transcripts captured matching the lesson's flags
   (`typeMismatch` ×2, `rangeUnderflow`, `patternMismatch`, valid-none); one sentence on why
   `bio` was valid when empty.
2. **Exercise 7.2** — Build a form where every control has a `label for` and one has
   `aria-describedby`; run the lesson 2 outline probe's label count.
   **Completion criteria:** `inputs without associated label: 0` captured; the describedby
   control named with what a screen reader would announce (label + description).

### Intermediate

3. **Exercise 7.3** — Take a "working" form that validates only in JavaScript. Capture: (a) the
   JS check passing valid input, (b) the same check bypassed with `curl -X POST` containing an
   invalid value reaching your server unchanged. Then add the server-side mirror and capture
   the 400.
   **Failure to diagnose:** three captures (client accept, server receive-without-check, server
   400-after-fix); one sentence naming why the browser's `min="18"` was never a guarantee.
4. **Exercise 7.4** — Implement the per-flag custom messaging pattern from section 6 (the
   `invalid` listener + `setCustomValidity`), and trigger three different flags to show three
   different messages, then clear one with an `input` event.
   **Failure to diagnose:** three flags → three distinct messages captured; the clear-on-input
   behavior shown; one sentence on why messages must be reset on `input` (stale validity
   blocks submit).

### Independent problem-solving

5. **Exercise 7.5** — *Problem:* design the validation contract for a signup form collecting
   email, password (with strength rules), date of birth (18+), and a country select, for a
   product that must work offline-first in a PWA. Specify: every field's native type and
   constraint attributes; what the *client* checks when offline (and how your JS mirrors
   native flags); what the server must re-check on sync — including the rules that could
   *never* live client-side (age-from-DOB, email uniqueness, password breach checks); the
   error-message strategy (native vs custom, justified); and how the offline queue prevents
   invalid data from being silently accepted.
   **Completion criteria:** a per-field table (type, attributes, flag it produces, server
   mirror); at least three rules correctly assigned server-only with reasons; error strategy
   justified against section 11's trade; offline handling stated as a mechanism (queue
   validates on reconnect or stores invalid-until-confirmed — one chosen, with consequence).

*Solutions: attempt first. This subject's applied work is in [projects/](projects/README.md)
brief 3 (form-heavy settings screen).*

## 13. Knowledge Check

1. Your form shows `checkValidity() === false` with `flag = rangeUnderflow` on a field with
   `min="18" max="99" step="1"`. What value was entered, and what two *other* flags could the
   same field produce?
2. Why does `type="tel"` appear in a validation lesson when it validates nothing?
3. A teammate ships `required` on all inputs and says "server validation is redundant."
   Rewrite their claim correctly, naming the mechanism that makes client checks bypassable.

## 14. Completion Criteria

Observable evidence that you have understood this lesson:

- [ ] You reproduced the five-control validity transcript with real browser messages (exercise 7.1)
- [ ] Your form audits `inputs without associated label: 0` (exercise 7.2)
- [ ] You captured the bypass: invalid data reaching a server, then the mirror rejecting it (exercise 7.3)
- [ ] You implemented per-flag custom messaging and showed clear-on-input (exercise 7.4)
- [ ] You can diagnose all five mistakes in section 9

## 15. Summary

- A form's floor: every control labeled (`for`/`id`), groups in fieldsets, one honest `type` per field.
- Native constraints (`required`, bounds, `pattern`) produce `ValidityState` flags — the executed transcript showed five distinct rejection reasons with the browser's messages.
- Client-side validation is guidance that can be bypassed with a single request; the server mirrors every rule and adds the ones only it can enforce (uniqueness, current state, business logic).
- `novalidate` + per-flag custom messages is a legitimate design choice — and it transfers full coverage responsibility to your script.
- Autocomplete, input types, and described-by hints are accessibility features that also convert.

## 16. Next Steps

- Next lesson: [CSS Fundamentals](css-fundamentals.md) — making the document you just validated look like the design
- Applied work: [projects/](projects/README.md) brief 3 (form-heavy settings screen)
- Where it is applied: [11-BACKEND-ENGINEERING](../11-BACKEND-ENGINEERING/README.md) (request validation) and [15-APPLICATION-SECURITY](../15-APPLICATION-SECURITY/README.md) (injection and auth through forms)
