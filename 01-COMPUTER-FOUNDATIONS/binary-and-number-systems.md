# Binary and Number Systems

## 1. Learning Objectives

After this lesson you will be able to:

- [ ] Convert numbers between decimal, binary, and hexadecimal by hand, in both directions
- [ ] Explain *why* computers use base-2, tying it to the hardware's two physical states
- [ ] Compute storage sizes (bits, bytes, KB, MB, GB) and state what a quoted capacity really holds
- [ ] Describe how integers, fractions, and text are stored as bits — and where precision runs out

## 2. Prerequisites

- [computer-hardware.md](computer-hardware.md) — hardware is the reason binary exists.
- No programming knowledge is required; every example here is worked by hand with tables.

## 3. Introduction

Everything a computer stores — every number, letter, image, and song — is a sequence of bits, where
a **bit** (binary digit) is a single 0 or 1. This lesson teaches you to move fluently between the
binary machines speak and the decimal humans use, plus hexadecimal (base-16), the shorthand
engineers actually use for binary. It closes with how real data becomes bits.

## 4. The Problem It Solves

A computer is a vast collection of switches and voltage detectors: a switch is either on or off,
with nothing in between that is reliably readable. Encoding values in two states is therefore
overwhelmingly more reliable than encoding them in ten (imagine needing exactly 7.3 volts to mean a
digit). Binary is not an arbitrary tradition — it is the representation that hardware can store
without ambiguity, at enormous density and with built-in error tolerance.

The cost is that humans lose their native number base. The fix is fluency: binary to reason about
machines, hexadecimal to read binary without writing 64 digits.

## 5. Core Concepts

### 5.1 Place value: the one idea behind every base

Decimal (base 10) digits are multiplied by descending powers of ten: `345 = 3×100 + 4×10 + 5×1`.
Every base works identically, with its own multiplier:

| Base | Digits | Multiplier (place values) |
|---|---|---|
| 10 (decimal) | 0–9 | …, 1000, 100, 10, 1 |
| 2 (binary) | 0–1 | …, 8, 4, 2, 1 |
| 16 (hex) | 0–9, A–F | …, 4096, 256, 16, 1 |

So binary `1011` = 1×8 + 0×4 + 1×2 + 1×1 = **11** in decimal. That single calculation is the whole
conversion skill in one direction.

### 5.2 Binary → decimal, and decimal → binary

**Binary → decimal:** sum the place values where a 1 sits.

```text
  1 0 1 1 0 1
  ↓ ↓ ↓ ↓ ↓ ↓    place values: 32 16 8 4 2 1
  32 + 8 + 4 + 1  =  45
```

**Decimal → binary:** repeatedly divide by 2 and keep the remainders, then read them bottom-up:

```text
  45 ÷ 2 = 22 remainder 1   ← least significant bit (comes LAST in the answer)
  22 ÷ 2 = 11 remainder 0
  11 ÷ 2 =  5 remainder 1
   5 ÷ 2 =  2 remainder 1
   2 ÷ 2 =  1 remainder 0
   1 ÷ 2 =  0 remainder 1   ← most significant bit (comes FIRST in the answer)
  Read the remainders from the bottom up: 101101  (= 45 ✓ matches the example above)
```

**Verification is mandatory:** 32 + 8 + 4 + 1 = 45. Every conversion gets checked by converting
back — a habit that prevents the most common arithmetic errors in this lesson.

### 5.3 Hexadecimal: binary in four-bit groups

Hex (base 16) exists purely as binary shorthand. The link is exact: 16 = 2⁴, so **one hex digit =
four binary bits** (a "nibble"):

```text
  1011 0110   →  group into fours:  1011  0110
                  hex digits:        B     6     →  0xB6
  check: 1011 = 11 = B ;  0110 = 6
```

Common values worth memorizing: `0xF = 15`, `0xFF = 255`, `0x100 = 256`. You will read hex
constantly later — in colors (`#58A6FF`), memory addresses, permission bits, and hashes.

### 5.4 Storage sizes, honestly

| Unit | Bits/bytes | Decimal (SI) | Binary (IEC) |
|---|---|---|---|
| bit (b) | 1 | — | — |
| byte (B) | 8 bits | — | — |
| kilobyte KB | 1000 B or 1024 B | 10³ | KiB = 2¹⁰ = 1024 |
| megabyte MB | — | 10⁶ | MiB = 2²⁰ = 1 048 576 |
| gigabyte GB | — | 10⁹ | GiB = 2³⁰ |

**The trap:** drive manufacturers count in powers of 1000; operating systems historically count in
powers of 1024 — which is why a "500 GB" drive shows as ~465 GiB. Neither party is lying; the
bases differ. Knowing this saves an hour of distrust every time you first notice it.

### 5.5 How real data becomes bits

- **Integers:** a fixed number of bits (8/16/32/64). Half the range goes to negative numbers
  (two's complement, which you do not need yet) — which is why a signed 8-bit integer holds
  −128…127, not −127…127.
- **Text:** each character maps to a number by an encoding table. ASCII used 7 bits (128
  characters); **Unicode** now maps the world's scripts, with UTF-8 the web's standard — variable-length,
  backward-compatible with ASCII. `A` is 65 (`0x41`); the emoji you type is 4–8 bytes.
- **Fractions:** stored approximately, because binary fractions use only negative powers of two
  (½, ¼, ⅛…) and most decimal fractions fall between them. `0.1 + 0.2 = 0.30000000000000004` in
  essentially every programming language — a real, permanent consequence of representation, not a
  bug anyone will fix. Never compare floating-point money amounts for equality; store money as
  integer cents instead. This returns in [08-JAVASCRIPT-AND-TYPESCRIPT](../08-JAVASCRIPT-AND-TYPESCRIPT/README.md)
  and matters permanently in databases.

## 6. How It Works — a byte's journey from keystroke to storage

1. You press `A`.
2. The keyboard sends a scan code; the OS/encoding layer maps it to a character code: 65.
3. 65 in binary is `01000001` — one byte.
4. That byte joins your document's byte sequence and is written to storage as patterned charge
   states in cells (each cell encoding bits).
5. Reversed on read: charge → bits → 65 → `A` → glyph on screen.

Every step is mechanical. Nothing in the pipeline "understands" the letter.

## 7. Practical Examples

### Example 1 — three conversions, fully worked (by hand; verify with any calculator)

```text
(1) 27 → binary            (2) 1101 0111 → decimal      (3) 0x3F → decimal & binary
 27÷2=13 r1                  place values: 128 64 32 16 8 4 2 1
 13÷2= 6 r1                  bits:           1  1  0  1 0 1 1 1
 6÷2= 3 r0                   = 128+64+16+4+2+1 = 215
 3÷2= 1 r1
 1÷2= 0 r1                   0x3F → 3×16 + 15 = 48 + 15 = 63
→ 11011                      63 = 0011 1111
```

**Expected output of checking:** `11011` = 16+8+2+1 = 27 ✓ · `11010111` = 215 ✓ · `0x3F` = 63 =
`00111111` ✓. Rework any step you cannot reproduce — that rework *is* the exercise.

### Example 2 — reading a real color (executed on the author's machine)

The blue in this repository's wordmark is written `#58A6FF`. Decode:

```text
  58 → 0101 1000 → 5×16+8 = 88      (red)
  A6 → 1010 0110 → 10×16+6 = 166    (green)
  FF → 1111 1111 → 15×16+15 = 255   (blue)
  → rgb(88, 166, 255)
```

**What to notice:** hex colors are three bytes — twelve bits of RGB — readable directly as binary
once you group digits in fours. The same skill decodes memory dumps and permission bits later.

## 8. Real-World Applications

Base-2/16 literacy shows up constantly: interpreting file sizes and why backups "shrink"; reading
color codes in CSS; understanding why a phone with 64 GB holds ~59 GiB; encountering `0x7fff` in an
error log; grasping why 32-bit systems address ~4 GB of RAM (2³² bytes); and later, why hashing,
encryption, and checksums are all bit operations. Interviewers test conversions because they reveal
whether you think in representations or memorize them.

## 9. Common Mistakes

| Mistake | Why it happens | How to prevent it |
|---|---|---|
| Reading binary place values right-to-left | Decimals are read left-to-right, habit sticks | Write the place values above each digit *before* computing |
| Off-by-one in division chains | A single remainder slips | Verify by reconverting; every worked example here is checked |
| Assuming KB = 1024 always | Mixed SI/IEC conventions | State which base you mean; use KiB/MiB when precision matters |
| Forgetting that `0.1` is not exact in binary | Decimal intuition | Treat binary floats as approximate; store money as integers |
| Thinking Unicode = ASCII extended | Early encodings trained expectation | UTF-8 is variable-length; one character ≠ one byte in general |

## 10. Best Practices

- **Verify every conversion in the opposite direction** — it costs ten seconds and eliminates the
  entire class of arithmetic slips.
- **Group bits in fours when reading hex**; never convert hex → decimal in your head when binary
  notation says it faster.
- **Be explicit about bases in writing.** In professional documents, `2 GiB` and `2 GB` mean
  different things, and confusing them causes real disputes.
- **Never use binary floating point for exact quantities** (money, counters, IDs).

## 11. Limitations and Trade-Offs

Binary is not "better" — it is a *hardware constraint* that software then adopted everywhere. Some
computers historically used other bases (decimal machines existed), but error rates and density
ended that. Two's complement and UTF-8 are likewise compromises: clever encodings that gained
performance or compatibility at the cost of conceptual simplicity. Notably, quantum computing's
qubits do not abolish binary logic in the layer you will program against — application-level
abstractions remain discrete.

## 12. Practical Exercises

### Introductory

1. **Convert ten by hand:** 5, 17, 100, 127, 128 to binary; `1111`, `10000000`, `11001100` to
   decimal; `0x10`, `0xFF`, `0xA` to decimal. **Completion criteria:** all correct, each binary
   answer verified by converting back.
2. **Decode `#1F6FEB`** to RGB and to binary groups of four. **Completion criteria:** three correct
   decimal channels, plus binary nibbles written out.

### Intermediate

3. **Storage arithmetic.** How many bytes are in 2 GiB? In 2 GB? Explain the difference to someone
   who thinks they are the same. **Completion criteria:** 2 147 483 648 vs 2 000 000 000 with a
   one-sentence explanation of the bases.
4. **Text as bytes.** Write out the bytes for `Hi` in ASCII (one byte per character, binary and
   decimal), then explain why a naïve "one byte per character" assumption breaks for an emoji.
   **Completion criteria:** correct bytes for both characters plus a reason referencing UTF-8
   variable length.

### Independent problem-solving

5. **The rounding mystery.** In your own words, explain why `0.1 + 0.2` fails to equal `0.3` in
   binary floating point: identify which decimal fractions binary can represent exactly (denominators
   that are powers of two), show why 0.1 (1/10) is not among them, and propose the representation a
   bank should use for balances. **Completion criteria:** the explanation includes at least one
   concrete non-representable fraction, the "integer cents" recommendation, and one real-world
   consequence if a system ignores it.

## 13. Knowledge Check

1. Convert 63 to binary and back. Show the division chain.
2. Why does base-2 follow from hardware rather than convention?
3. What is the exact relationship between hex digits and bits?
4. A drive shows 465 GiB but was sold as 500 GB. Which party is wrong? Justify with numbers.
5. Which is safer for storing $19.99: a float, or an integer count of cents? Why?

## 14. Completion Criteria

- [ ] You can convert decimal ↔ binary ↔ hex in under a minute each, verified both directions
- [ ] You can decode any `#RRGGBB` color to binary nibbles
- [ ] You can explain the KB/KiB discrepancy with exact figures
- [ ] You can explain binary floating-point imprecision with a concrete fraction example

## 15. Summary

- Bits are hardware's two-state representation; place value converts any base.
- Hex is binary shorthand — one digit per four bits.
- Size units disagree because bases disagree (1000 vs 1024).
- Text uses encodings (UTF-8); fractions are approximate in binary; money should be integers.

## 16. Next Steps

- [logic-and-boolean-algebra.md](logic-and-boolean-algebra.md) — from bits as *values* to bits as
  *decisions*: the algebra behind every condition you will ever write.