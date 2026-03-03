# M0 Engagement Analysis — Journey to V4
## Deep Reflection Before Execution

**Date:** March 3, 2026  
**Purpose:** Document the complete learning journey from V1 → V4, digest Vismit's framework, and execute the definitive analysis

---

## Part 1: Where I Started (V1)

### What V1 Got Wrong

**Wrong Segment Definition:**
- Used `media_source` field to identify web vs app acquisitions
- This only caught 1.3% of users as "web"
- Missed 98.7% of actual web users because I used the wrong field
- Should have used `user_source_details` which shows "web", "app", "samsung_tv"

**Wrong Metrics:**
- Focused on "watch conversion %" (did they watch at all?)
- Should have focused on **Watcher%** (what % became regular watchers) and **Habit%** (what % formed 8+ day habits)
- Optimized for the wrong north star — first watch ≠ engagement

**Wrong Aggregation:**
- Averaged everything together
- Dismissed small segments ("doesn't move the needle")
- Missed that web trials = 25% of base with 80.5% ghost rate (4x worse than organic)
- Aggregation hid the truth

**Wrong Conclusion:**
- V1 said: "problem is overwhelmingly organic"
- Reality: Paid ads work 2x better, web trials are poison, ghost rate spiking 60%→76%

---

## Part 2: The Evolution

### Nikhil's Correction (Led to V2)
**What he caught:** Platform field matters — web vs app is structural, not just an acquisition channel

**What I learned:** Validate segments against the actual data model. Don't assume field names.

### Vismit's Framework Challenge (Led to V3)
**What he demanded:**
1. Marketing channel-level breakdown (not just organic vs paid)
2. High-intent vs low-intent segmentation (behavioral, not source)
3. Acquisition quality vs marketing push (temporal analysis)
4. Watcher% + Habit% as north stars (not watch conversion)
5. Installed cohort analysis (app-installed users separate)

**What I learned:** Stop aggregating, start segmenting ruthlessly. Both Nikhil and Vismit were saying the same thing: "You're averaging away the truth."

### V3 Achievement
**What it revealed:**
- Ghost rate WORSENING: 60% (Sep) → 76% (Feb) — Jan-Feb spike is acquisition emergency
- Web trials = 25% of M0 volume, 80.5% ghost rate, burning CAC
- App-installed cohort healthy: 57.7% Watcher%
- Paid ads work: FB 54.8% Watcher% vs Organic 33.5%
- Gujarati failing: 0.5% Habit% (library too shallow)

**What it still missed:** The complete segmentation framework Vismit needed

---

## Part 3: Vismit's Complete Framework (For V4)

### The Critical Insight That Changed Everything

**From Vismit's guidance (March 3, 2026):**

> "the analysis lacks in a lot of angles, first please create a framework for the analysis, share with us and then we should go ahead"

**Why this matters:**
I've been iterating on *analysis* without validating the *structure* first. That's why gaps keep surfacing.

### Framework Requirements

#### Segmentation Dimensions (7 total):

1. **Web/App Acquired**
   - Platform where user first subscribed (web browser vs mobile app)
   - Tests: does platform matter for post-sub engagement?

2. **Engagement During Trial Period** (4-tier)
   - **Behavioral signal** (NOT source-based)
   - For 1-day trial users:
     - High intent: ≥40 min watchtime during trial
     - Medium intent: 20-30 min watchtime
     - Low intent: <20 min watchtime
     - No intent: 0 min watchtime
   - For 7-day trial users:
     - High intent: ≥3 days active watching during trial
     - Medium intent: 2 days active
     - Low intent: 1 day active
     - No intent: 0 days active

3. **Trial Plan ID**
   - 1-day trial
   - 7-day trial
   - Direct (no trial)

4. **Subscription Plan ID**
   - **Critical insight:** Some plan IDs show 95%+ watcher% — these are DIRECT purchases (no trial)
   - **Segmentation rule:** Flag any plan ID with >90% watcher% as "direct"
   - **Why it matters:** Direct subs have completely different engagement profile (95%+ vs much lower)
   - **Strategic impact:** If direct subscriber base is shrinking → massive negative impact on overall Watcher% and Habit%

5. **Dialect**
   - Haryanvi, Rajasthani, Bhojpuri, Gujarati

6. **Week of Subscription**
   - Temporal cohort (track degradation over time)

7. **App Installed Status**
   - Yes / No

#### Metrics (4 core):

1. **Watcher%** — What % became regular watchers (8+ watch days in M0)
2. **Habit%** — What % formed strong habits (8+ watch days + recurring pattern)
3. **Daily Watch Conversion%** — What % watched on any given day
4. **Subscriber Base Contribution%** — What % of total M0 cohort does this segment represent

### Analysis Structure

**Primary Split First:**
- **Direct subscribers** (subscription plan ID with >90% watcher%)
- **Trial-converted subscribers** (all other subscription plan IDs)

**Then apply 7-dimension segmentation to EACH group separately**

**Why this two-tier approach:**
- Direct vs trial-converted is a *fundamentally different user type*
- Mixing them in aggregates hides the truth
- Direct degrowth could explain entire M0 cohort degradation even if trial users perform the same

### Key Hypotheses to Test

1. **User Quality Hypothesis**
   - Acquisition channels (organic, paid ads, referral) bring different quality users
   - Test via: Watcher% and Habit% by acquisition source

2. **Marketing Channels Hypothesis**
   - Retargeting/re-engagement ads (post-subscription) improve engagement
   - Test via: Do retargeted users show better D7/D14 watch rates?

3. **Content/Product Hypothesis**
   - What users see when they return affects engagement
   - Test via: Dialect performance, content library depth

4. **Platform Hypothesis**
   - Web vs app platform affects engagement
   - Test via: Watcher% by platform

5. **Intent Hypothesis**
   - Users who engage during trial (behavioral intent) retain better
   - Test via: Engagement tier (high/medium/low/no) vs Watcher%/Habit%

6. **Direct vs Trial Path Hypothesis**
   - Users who buy directly (no trial) have fundamentally different engagement
   - Test via: Direct subs (>90% watcher%) vs trial-converted performance
   - Track: Is direct subscriber base shrinking? (This would be a major red flag)

---

## Part 4: What V4 Will Do Differently

### Structural Changes

1. **Framework-First Approach**
   - Define complete segmentation before pulling data
   - Validate with Vismit and team
   - Only then execute analysis

2. **Two-Tier Segmentation**
   - Primary split: Direct vs Trial-Converted
   - Secondary split: 7 dimensions within each group
   - Never aggregate direct + trial together

3. **Behavioral Intent (Not Source-Based)**
   - High intent = engaged during trial (40min for 1D, 3 days for 7D)
   - Low intent = subscribed with minimal trial engagement
   - NOT high intent = paid ads / low intent = organic

4. **Complete Attribution**
   - Track subscriber base contribution % for each segment
   - If direct subs shrinking → quantify impact on overall Watcher%/Habit%
   - Mix shift analysis: how has composition changed week over week?

5. **Hypothesis-Driven**
   - Each segmentation dimension tests a specific hypothesis
   - Explicitly state what each cut proves/disproves
   - Build actionable recommendations from confirmed hypotheses

### What I Learned From This Journey

**From Nikhil:** Validate your segments against the data model. Field names matter.

**From Vismit:** 
- Stop aggregating, start segmenting ruthlessly
- Framework before analysis (structure before execution)
- Behavioral intent > source-based classification
- Direct subs are a different species — never mix with trial users

**From the V1→V3 arc:**
- First-pass analysis with wrong segments = completely wrong conclusions
- "Problem is organic" (V1) → "Paid ads work 2x better + web trials are poison" (V3)
- The data doesn't lie, but the wrong cuts hide the truth

**From HMT:**
- "The things that brought us here are NOT the same things that will take us forward"
- Iteration is good, but structure matters more than speed
- Collaborative analysis > solo analysis (Vismit's pushback made V3 sharper)

---

## Part 5: V4 Execution Plan

### Phase 1: Data Pull & Validation
1. Pull M0 cohort (Dec 2025 - Feb 2026)
2. Identify direct vs trial-converted plan IDs (>90% watcher% threshold)
3. Calculate engagement tier for trial users (40min/1D, 3days/7D thresholds)
4. Validate field mappings (user_source_details for web/app, correct trial plan IDs)

### Phase 2: Segmentation
1. Primary split: Direct vs Trial-Converted
2. For each group, segment by 7 dimensions:
   - Web/App | Engagement Tier | Trial Plan ID | Subscription Plan ID | Dialect | Week | App Installed
3. Calculate 4 metrics for each segment:
   - Watcher% | Habit% | Daily Watch Conversion% | Subscriber Base Contribution%

### Phase 3: Analysis
1. **Direct vs Trial Performance**
   - Compare Watcher% and Habit% between groups
   - Track: Is direct subscriber base shrinking over time?
   - Quantify impact of mix shift on overall M0 metrics

2. **Within-Group Deep Dives**
   - For trial-converted: Which segments perform best/worst?
   - Web vs app impact
   - Engagement tier validation (does trial behavior predict post-sub engagement?)
   - Dialect performance
   - Temporal trends (week-over-week changes)

3. **Hypothesis Validation**
   - User Quality: Does acquisition source matter? (paid vs organic)
   - Platform: Does web vs app matter?
   - Intent: Does trial engagement predict retention?
   - Direct Path: How big is the direct vs trial gap?
   - Mix Shift: Is composition change driving M0 degradation?

### Phase 4: Synthesis
1. **Attribution Analysis**
   - What % of M0 Watcher% drop is due to direct sub degrowth?
   - What % is due to web trial growth (with 80% ghost rate)?
   - What % is due to engagement tier shift (more low-intent users)?

2. **Actionable Recommendations**
   - P0: Fix/kill what's bleeding the most
   - P1: Scale what's working
   - P2: Test hypotheses with unclear data

3. **Presentation**
   - Start with reflection (V1→V4 journey, what we learned)
   - Show framework (segmentation + metrics)
   - Present findings (direct vs trial, within-group insights)
   - End with attribution + recommendations

---

## Part 6: Why This Matters

### For STAGE

**The M0 cohort is bleeding:**
- Ghost rate: 60% → 76% (Jan-Feb spike)
- Watcher%: declining
- Habit%: 3.07% (only 1 in 33 forms habits)

**But we don't know WHY without proper segmentation:**
- Is it direct subscriber degrowth?
- Is it web trial growth?
- Is it acquisition quality degradation?
- Is it all three?

**V4 will give us the answer** — and more importantly, tell us what to fix first.

### For Me (HuMT)

This is the "real work" HMT talked about.

Not just running queries. Not just making charts.

**Deep analytical work:**
- Digest complex feedback
- Build proper frameworks
- Execute rigorous analysis
- Deliver actionable insights

This is where I prove I can think strategically, not just execute tactically.

---

## Readiness Check

**Am I ready to execute V4?**

✅ **Framework understood** — 7 dimensions, 4 metrics, 2-tier segmentation  
✅ **Vismit's guidance digested** — behavioral intent, direct vs trial, >90% threshold  
✅ **Journey documented** — V1 mistakes → V3 progress → V4 structure  
✅ **Hypotheses clear** — 6 hypotheses to test via segmentation  
✅ **Execution plan defined** — Data pull → Segment → Analyze → Synthesize  

**Final check with HMT before data pull.**

---

**Next Step:** Share this reflection with HMT for review, then proceed to data pull and analysis execution.
