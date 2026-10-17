# Solutions — Set 9: Functions and Methods

> ⚠ Attempt the set first. One week after reading this, rebuild the answers from a blank page.

## Exercise 1 — Write and call

**Answer.**

```python
def celsius_to_f(c):
    return c * 9 / 5 + 32


for t in [0, 37, 100]:
    print(f"{t}C = {celsius_to_f(t)}F")
```

Output: `0C = 32.0F`, `37C = 98.6F`, `100C = 212.0F`. The function *returns*; the loop at the
call site *prints* — the separation the criterion checks, because it is what makes the function
testable without capturing output.

**Criteria check:** ☐ three correct values ☐ compute/return inside, print outside.

## Exercise 2 — Return, print, or wrong

**Answer.**

| Snippet | Verdict | Reason |
|---|---|---|
| `def half(x): return x / 2` | **should return** | pure computation; caller decides presentation |
| `def report(x): print(x * 2)` | **should print? wrong as written** | name promises a report but produces nothing reusable — either return the string or rename to `print_report` |
| `def area(w, h): print(w * h)` used as `y = area(2, 3); y + 1` | **wrong** | `y` is `None`; the caller needs the value |
| `def log(msg): print(f"[log] {msg}")` | **should print** | the *effect* is the point — a logging function is honest about it |
| `def total(xs): t = 0; for x in xs: t += x; print(t)` | **wrong** | computes and prints; split: `total()` returns, caller prints |

**Criteria check:** ☐ five classifications ☐ each justified by compute-vs-report.

## Exercise 3 — The trap, fixed, extended

**Answer.** Bug transcript (real, from the lesson's Example 3):

```text
first call:  ['a']
second call: ['a', 'b']  <- the default list was built once at 'def' time
```

Fix with the `None` idiom, extended to accept a starter list:

```python
def push(item, bucket=None):
    if bucket is None:
        bucket = []
    bucket.append(item)
    return bucket


print(push("a"))                  # ['a']   fresh
print(push("b"))                  # ['b']   fresh again
seed = [1, 2]
print(push(3, seed))              # [1, 2, 3]  extends the caller's list
print(push(4))                    # ['4'... no: [4] - still fresh)
```

**Criteria check:** ☐ fresh lists per call ☐ supplied list extended ☐ transcript captured.

## Exercise 4 — Stats module (independent)

**Answer.**

```python
def mean(values):
    if not values:
        return None
    return sum(values) / len(values)


def median(values):
    if not values:
        return None
    s = sorted(values)
    n = len(s)
    mid = n // 2
    if n % 2 == 1:
        return s[mid]
    return mean([s[mid - 1], s[mid]])     # composition: median calls mean


def mode_of(values):
    if not values:
        return None
    counts = {}
    for v in values:
        counts[v] = counts.get(v, 0) + 1
    best = max(counts.values())
    winners = [v for v, c in counts.items() if c == best]
    return min(winners)                    # tie rule: smallest wins
```

Evidence: `mean([2, 4, 6])` → 4.0; `median([3, 1, 2])` → 2; `median([4, 1, 3, 2])` → mean of
`[2, 3]` = 2.5 (composition visible); `mode_of([3, 1, 3, 1])` → 1 (tie, smallest); every
function returns `None` on `[]` — the stated empty behaviour, demonstrated. No printing anywhere
inside — the call site prints.

**Criteria check:** ☐ hand-checked values ☐ empty behaviour defined and demoed ☐ composition
visible ☐ zero prints inside functions.
