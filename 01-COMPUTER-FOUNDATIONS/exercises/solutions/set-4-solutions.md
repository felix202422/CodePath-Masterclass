# Solutions — Set 4: Binary and Number Systems

> ⚠ Attempt first; rebuild cold in a week. Every conversion here is verified by reconverting.

## Exercise 1 — Ten conversions, verified

**Decimal → binary**

```text
5   → 101          check: 4+1 = 5        ✓
17  → 10001        check: 16+1 = 17      ✓
100 → 1100100      check: 64+32+4 = 100  ✓
127 → 1111111      check: 64+32+16+8+4+2+1 = 127 ✓
128 → 10000000     check: 128            ✓
```

**Binary → decimal**

```text
1111     → 8+4+2+1 = 15         ✓
10000000 → 128                   ✓
11001100 → 128+64+8+4 = 200      ✓
```

**Hex → decimal**

```text
0x10 → 16        0xFF → 255        0xA → 10
```

**Criteria check:** ☐ all correct ☐ verification shown for at least six.

## Exercise 2 — `#1F6FEB`

```text
1F → 1×16+15 = 31     → 0001 1111
6F → 6×16+15 = 111    → 0110 1111
EB → 14×16+11 = 235   → 1110 1011
rgb(31, 111, 235)
```

**Criteria check:** ☐ three correct channels ☐ nibble groups written.

## Exercise 3 — 2 GiB vs 2 GB

```text
2 GiB = 2 × 2³⁰ = 2 147 483 648 bytes   (binary/IEC — what an OS reports)
2 GB  = 2 × 10⁹ = 2 000 000 000 bytes   (decimal/SI — what a drive box states)
Difference: ~147 MB — because the bases differ (1024 vs 1000), not because anyone is lying.
```

**Criteria check:** ☐ both figures exact ☐ one-sentence base explanation.

## Exercise 4 — Why `0.1 + 0.2 ≠ 0.3` (independent)

**Answer.**

1. Binary fractions can only sum negative powers of two: ½, ¼, ⅛, 1⁄16 …
2. `0.1 = 1/10`; 10 is not a power of two, so 0.1 has **no exact** binary representation — it is
   an infinite repeating binary fraction, rounded to the machine's precision (same for `0.2`; note
   `0.5 = ½` and `0.25 = ¼` *are* exact — the contrast proves the rule).
3. The two rounded values sum to something marginally above `0.3`, and `0.3` itself is also
   rounded — so the comparison fails at the last bit.
4. **Consequence if ignored:** `if (total == 0.3)` silently fails; repeated tiny errors accumulate
   in billing, producing cent-level discrepancies and reconciliation failures at scale.
5. **Recommendation:** store money as **integer cents** (or a fixed-point/decimal type in
   databases — see `numeric`/`decimal` in [10-DATABASE-ENGINEERING](../../../10-DATABASE-ENGINEERING/README.md)),
   and compare floats with tolerances when exactness is impossible.

**Criteria check:** ☐ explanation with a concrete non-representable fraction ☐ integer-cents
recommendation ☐ real-world consequence.

**Reviewer note:** full credit requires *why 1/10 specifically* fails (denominator has a factor of
5), not merely "floating point is imprecise".

---

Next: [set-5-solutions.md](set-5-solutions.md)
