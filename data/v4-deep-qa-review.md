# V4 Deep QA Review — Analytical Logic Check
**Reviewer:** HuMT  
**Date:** March 3, 2026 10:42 UTC  
**Standard:** "You've trained me on what 'done properly' looks like"

---

## Critical Logic Checks

### 1. The T0 Attribution Math

**Claim:** "T0 collapse ALONE can explain a 26pp drop in blended watcher%"

**Math shown:**
- Nov 2025: (65% × 43%) + (35% × 60%) = 49% watcher%
- Feb 2026: (65% × 8%) + (35% × 50%) = 22.7% watcher%
- Gap: 26pp

**CHECK 1: Do these assumptions make sense?**
- Assumes T0 = 65% of M0 base (reasonable estimate, but unverified)
- Assumes non-T0 tiers averaged 60% watcher% in Nov (Table shows T1-T6 range 27-74%, weighted avg likely ~50-55%)
- Assumes non-T0 dropped to 50% in Feb (Table shows T1-T6 range 20-65%, weighted avg likely ~45-50%)

**FINDING:** ✅ Math is directionally sound, but the "60% → 50%" non-T0 assumption is soft. Should say "estimated" more clearly.

**CHECK 2: Does the conclusion follow?**
"T0 explains 81% of the crisis" — calculated as 26pp / 32pp total drop = 81%

**FINDING:** ✅ Math checks out IF the 65% base assumption is correct. But this is presented as definitive when it's really an estimate.

**ISSUE 🟡:** The analysis presents this with high confidence ("T0 collapse ALONE can explain") but it's built on unverified assumptions (T0 base %, non-T0 weighted averages). Should be hedged more.

---

### 2. The "Direct Subscriber Base Collapsed" Hypothesis

**Claim:** T0 watcher% drop (43% → 8%) is explained by direct subs shrinking from 50% → 10% of T0

**Logic:**
- Direct subs have 95% watcher%
- Low-intent trials have 10% watcher%
- If Nov T0 = 50% direct + 50% low-intent: (0.5 × 95%) + (0.5 × 10%) = 52.5% ✅ close to observed 43%
- If Feb T0 = 10% direct + 90% low-intent: (0.1 × 95%) + (0.9 × 10%) = 18.5% ✅ close to observed 8%

**CHECK:** Does this math hold?
- Nov actual: 43% (model predicts 52.5%) → 9.5pp gap
- Feb actual: 8% (model predicts 18.5%) → 10.5pp gap

**FINDING:** 🟡 The model is in the ballpark but not exact. The gaps suggest:
1. Direct subs might have <95% watcher% (could be 80-90%)
2. Low-intent trials might be <10% watcher% (could be 5-8%)
3. Or the 50%/10% split estimates are off

**ISSUE 🟡:** The hypothesis is plausible but not proven. The analysis correctly marks this "Medium confidence" and says "need Plan ID data to confirm." That's intellectually honest. GOOD.

---

### 3. "Every Tier Degraded" — Within-Tier Quality Collapse

**Claim:** T6 dropped 12%, T3 dropped 18%, T0 dropped 81% → proves acquisition channel quality degraded, not just mix shift

**Logic check:**
- IF only mix shifted (more T0, fewer T6) AND each tier's quality stayed constant → we'd see T6 at 74%, T3 at 55%, T0 at 43% in Feb
- BUT we see T6 at 65%, T3 at 45%, T0 at 8% → all tiers degraded
- THEREFORE: Quality within each tier collapsed, independent of mix

**FINDING:** ✅ This logic is sound. The "every tier degraded" observation directly disproves "mix shift only" hypothesis.

**CHECK:** Are the engagement tier definitions consistent V3 → V4?
- V3 used "days active during trial" as the metric
- V4 uses same (T0 = 0 days, T6 = 6 days)
- ✅ Consistent

---

### 4. Web Trial Attribution

**Claim:** "Web trials didn't grow" (disproven as primary cause)

**Evidence:** Web watcher contribution stayed ~1% (Nov: 0.69%, Feb: 1.06%)

**Logic:** If web trials spiked from 15% → 35% of M0 base, and web ghost rate = 95%, we'd see web watchers spike proportionally. They didn't.

**CHECK:** Is this reasoning valid?

Wait — this assumes web trial VOLUME and web WATCHER contribution move together. But:
- If web trials grew 15% → 35% of base (volume doubled)
- AND web ghost rate stayed 95%
- Then web watchers would grow from (15% × 5%) = 0.75% → (35% × 5%) = 1.75% of total watchers

Observed: 0.69% → 1.06% (modest increase, not doubling)

**FINDING:** ✅ The logic holds. Web watcher contribution grew modestly (0.69% → 1.06%), which means web trial VOLUME likely grew modestly too (not spiked). Hypothesis correctly disproven.

---

### 5. Attribution Percentages (65-70% + 20-25% = 95-110%)

**Claim:** T0 collapse = 65-70%, within-tier degradation = 20-25%, web trials = 5-10%, mix shift = 5%

**CHECK:** How were these calculated?

Looking at the document... it says "estimated" but doesn't show the math.

**ISSUE 🔴:** The attribution percentages (65-70%, 20-25%) are stated but not derived. Where do these numbers come from?

Let me check if this is explained elsewhere in the doc...

Reading through... the document says "estimated" repeatedly but never shows:
- How to isolate T0's contribution from within-tier degradation
- Why T0 = 65-70% specifically (vs 50% or 80%)
- How within-tier degradation was quantified as 20-25%

**FINDING 🔴 CRITICAL ISSUE:** The attribution breakdown looks precise (65-70%, 20-25%) but the methodology isn't shown. This could confuse readers into thinking these are calculated values when they're estimates.

**SHOULD SAY:** "Based on T0 representing ~65% of base and dropping 81%, we estimate T0 collapse contributes 65-70% of the overall crisis. The remaining 20-30% is attributed to within-tier quality degradation (all tiers dropped 12-26%)."

The numbers might be right, but the derivation needs to be explicit.

---

### 6. P0 Recommendation: "Gate Trial Conversions"

**Claim:** Filtering out T0 users would improve blended watcher% from 8% → 45%

**Logic:**
- Current: T0 (65% of base, 8% watcher%) + T1-T6 (35% of base, avg ~45% watcher?) = blended ~22%
- After filter: T2+ only (35% of base, avg ~45% watcher%) = blended 45%

**CHECK:** Does this math work?

Actually looking at Table 2:
- T2-T6 Feb watcher%: 34%, 45%, 54%, 61%, 65%
- If evenly distributed: avg = 51.8%
- If weighted toward lower tiers (likely): avg = ~40-45%

**FINDING:** ✅ The 45% estimate is reasonable for T2+ cohort.

**SECOND CHECK:** Impact estimate of "5x LTV increase"

Current LTV (with T0): (65% × ₹200) + (35% × ₹1000) = ₹480
After filter (T2+ only): ₹1000

Improvement: ₹1000 / ₹480 = 2.08x (NOT 5x)

**FINDING 🟡:** The "~5x better cohort quality" claim is inflated. Real improvement is ~2x. This should be corrected.

---

### 7. Reflection Section — Is it Authentic?

Reading the V1/V2/V3 journey sections...

**CHECK:** Does this match what actually happened?

- V1 mistakes: ✅ Accurate (media_source error, wrong metrics, averaging)
- Nikhil's correction: ✅ Accurate (caught web trial measurement)
- Vismit's framework: ✅ Accurate (5 requirements listed match conversation)
- V4 framework-first: ✅ Accurate (Vismit said "create framework first")

**FINDING:** ✅ Reflection is genuine and matches the actual V1→V3 evolution.

---

### 8. Data Consistency Check (V3 vs V4 Numbers)

Comparing key numbers:

| Metric | V3 | V4 | Match? |
|--------|----|----|--------|
| Feb ghost rate | 76% | 76% (via 100% - 4.89% ≠ 76%) | ❌ WAIT |
| Web trial ghost rate | 80.5% | 95%+ | Different |
| Paid ads watcher% | 54.8% | Not shown in V4 | Missing |
| Gujarati habit% | 0.5% | 0.5% | ✅ |

**CHECK:** Ghost rate calculation

Feb 2026: Watcher% = 4.89%
Ghost rate = 100% - 4.89% = **95.11%** (NOT 76%)

But V4 claims "76% Feb 2026 Ghost Rate" in the exec summary...

**FINDING 🔴 CRITICAL ERROR:** The ghost rate numbers don't align.

V3 said 76% ghost rate for Feb cohort.
V4 shows Watcher% = 4.89% which implies 95.11% ghost rate.

These can't both be true. Either:
1. Ghost rate definition changed (V3 used different calculation)
2. Watcher% definition changed
3. One number is wrong

**This is a major inconsistency that Vismit would catch immediately.**

---

## Summary of Issues Found

### 🔴 CRITICAL (Must Fix)

1. **Ghost rate inconsistency:** Exec summary says 76%, but Watcher% 4.89% implies 95.11% ghost rate
2. **Attribution percentages lack derivation:** 65-70% and 20-25% stated but not calculated
3. **5x LTV claim inflated:** Real improvement is ~2x, not 5x

### 🟡 MODERATE (Should Fix)

1. **T0 attribution confidence too high:** Math is directional but built on unverified base % assumptions
2. **Habit% estimates in Table 2:** Shows "Est. 12-15%" but these aren't calculated from data

### ✅ STRENGTHS (Confirmed)

1. Framework-first approach well-documented
2. V1→V3 reflection is authentic
3. "Every tier degraded" logic is sound
4. Web trial disproof is correct
5. Recommendations are specific and actionable
6. Template compliance is complete

---

## VERDICT: NOT READY — NEEDS FIXES

**Status:** ⚠️ HOLD FOR REVISION

The analysis has strong bones (framework, reflection, recommendations) but has **3 critical analytical errors** that would undermine credibility with Vismit:

1. Ghost rate number contradiction (76% vs 95%)
2. Attribution math not shown
3. LTV impact overstated (5x vs 2x)

**Next step:** Fix the 3 critical issues before delivery.

I failed the "stand the test" challenge. I would have shipped this with errors that Vismit would immediately catch.

Going to fix these now.
