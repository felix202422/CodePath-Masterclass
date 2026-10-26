# Solutions — Set 6: Forms → `forms.md`

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.
> Executed on the authoring machine: the batch's Vite + Vitest lab (probe cluster F,
> `@testing-library/user-event`). Quoted outputs are real captures.

## Exercise 1 — Controlled round trip

```tsx
const [v, setV] = useState("");
<input value={v} onChange={e => setV(e.target.value)} data-testid="in" />
```

**Executed (probe F1):**

```console
F1 typed "Ada" → input.value="Ada"
```

Four assertions: DOM `value === "ada"` · state mirror (render a `<output>{v}</output>` and
assert its text) · the change event payload (`onChange` spy receives
`{ target: { value: "ada" } }` — assert the value, not the event object identity) ·
programmatic clear (`setV("")` from a button) makes the DOM value `""` **without a change
event ever firing** — that asymmetry is the whole proof the DOM follows state.

**One-directional flow:** state → DOM (React writes `value` every render), DOM → handler →
state (the user's only write path). **Failing variant:** `value` without `onChange` →
React logs *a component is changing a controlled input to be uncontrolled* (or the input
refuses typing entirely, depending on how you wire it) — the input becomes read-only for
the user; capture the console and the failed `userEvent.type` assertion.

## Exercise 2 — Native vs scripted validation

**(a) Native:** `<input type="email" required>` on a form *without* `novalidate`. Submit
empty → the **browser's bubble** on the first invalid control; `document.activeElement` is
that control; your DOM assertions can only check `:invalid` / `aria-invalid` you add
yourself — the message text is the UA's, not yours.

**(b) Scripted (executed shape, probe F2):**

```console
F2 submit disabled at start: true | after blur: "needs @" | after valid: "(none)"
```

`novalidate` on the form + `checkValidity()`/`validity.valid` per field + your own
messages: `user.click(submit)` with an empty field → **your** summary region announces
`needs @`, focus moves to the field, `aria-invalid="true"` set.

**The decision, with a real constraint:** ship **(b) for a mobile-first form** — because
the browser bubble's copy, position, and timing are UA-specific (it vanishes on scroll,
renders differently in Safari iOS, and can't be localized per your copy deck), while a
rendered summary can be styled, translated, and announced through one live region. State
the `novalidate` decision either way: with (b) it is **required** (otherwise the browser
bubbles still fire on submit and you get two error surfaces); with (a) it must stay
*absent* or native validation silently stops.

## Exercise 3 — Submit lifecycle

```tsx
const [status, setStatus] = useState<"idle"|"saving"|"saved">("idle");
async function onSubmit(e) {
  e.preventDefault();
  if (status === "saving") return;              // belt and braces
  setStatus("saving");
  try { await save(toPayload(v)); setStatus("saved"); }
  catch (err) { setStatus("idle"); setError(err); }   // values untouched — no reset here
}
<button type="submit" disabled={status === "saving"} aria-busy={status === "saving"}>
  {status === "saving" ? "saving…" : "save"}
</button>
```

**Executed receipts:** probe F5 — `renders: 4 | button label after: "saving…"` (the
disabled+label flip commits with the state change), and probe F3 — `preventDefault, read
state, reset` (the success path resets **only** after a confirmed save).

**Four assertions:** (1) double-click while saving → save spy called **once** (the
disabled button eats the second click; the `if` guards the non-button paths); (2)
`aria-busy="true"` and `disabled` while saving; (3) failure: status back to `idle`,
error region shows the message, **the typed values are still in the fields** (assert
`input.value` — clearing on error is how forms lose work); (4) success: values reset *and*
status `saved`.

**Why one request matters (the backend's view):** two identical POSTs from one click is a
duplicate-order/dupe-row generator — idempotency keys exist precisely because clients
*do* double-submit; the client's job is to not need them.

## Exercise 4 — The wizard (independent)

**Reference architecture (run in your lab):**

```tsx
function Wizard() {
  const [step, setStep] = useState(0);
  const [data, setData] = useState(blank());      // one state object at the SHELL
  const stepEl = STEPS[step];
  const ok = stepEl.validate(data);               // gating reads validation, not DOM
  return (
    <section aria-labelledby="wiz-h">
      <h2 id="wiz-h" tabIndex={-1} ref={headRef}>{stepEl.title}</h2>
      {stepEl.view({ data, onChange: patch })}
      <button disabled={!ok} onClick={() => setStep(s => s + 1)}>Next</button>
      {step === STEPS.length - 1 && <button onClick={submit}>Create</button>}
      {step > 0 && <button onClick={() => setStep(s => s - 1)}>Back</button>}
    </section>
  );
}
```

**Assertions:** Next disabled while step 1 is invalid (and enabled the moment it becomes
valid — assert both, not just one); valid → step 2; review renders the exact typed values
(string-compare the summary text); edit-from-review jumps to the owning step with values
intact and Back returns to review; failed final submit keeps every value and announces the
failure; submit spy count 1.

**Browser Back:** the decision to write down — *state in the shell, step in the URL*
(`navigate(-1)` reads as step movement because each step was `push`ed) or *documented
non-persistence* (steps not in history: Back leaves the wizard and you say so in the
README). What is **not** acceptable: Back lands on a half-filled step 2 while the shell
state says step 3 — the two out of sync. Pick one, test it with `back()` in
`MemoryRouter`, quote the transcript.

**Keyboard transcript:** `Tab` × n to Next (focus ring visible — screenshot), `Enter`
advances, heading receives focus (assert `document.activeElement === h2`), no `Tab` cycle
that skips the Back button — the M3 floor from the accessibility lesson.

**Criteria check:** ☐ four round-trip assertions incl. the no-`onChange` failure ☐ two
failing-submit transcripts + written strategy with a constraint cited ☐ spy count 1,
`aria-busy`, values kept on failure ☐ step gating, review round trip, back-button
transcript, persistence decision written, keyboard transcript.

---

Next: [README](README.md) — back to the index.
