# App Open Analysis — Vismit's Diagnostic Framework

**Question:** Is the M0 engagement drop due to:
1. App open drop (users stop opening app), OR
2. App open → watch funnel problem (users open but don't watch)?

**If #1 (app open drop):** Is it organic or reengagement channel failure?

---

## Step 1: Diagnose WHERE They Drop

### Metric 1: App Opens per User (Trial vs Subscription)

**During Trial (D1-D7):**
- Nov cohort: X app opens per user
- Feb cohort: Y app opens per user
- Change: (Y-X)/X

**Post-Subscription (D8-D30):**
- Nov cohort: A app opens per user
- Feb cohort: B app opens per user
- Change: (B-A)/A

**Diagnosis:**
- If trial opens stable BUT post-sub opens dropped → **App Open Drop confirmed**
- If both stable, check conversion below

### Metric 2: App Open → Watch Conversion

**Among users who opened app D8-D30:**
- Nov cohort: X% watched when they opened
- Feb cohort: Y% watched when they opened
- Change: Y - X

**Diagnosis:**
- If opens stayed same BUT conversion dropped → **Funnel Problem confirmed**
- If opens dropped AND conversion dropped → **Both problems**

---

## Step 2: If App Open Drop, What Caused It?

### H1: Organic Drop (Natural Disengagement)

**Test:** Control for reengagement activity
- If push notifications, emails, retargeting stayed constant Nov→Feb
- AND app opens still dropped
- = Organic drop (content/product issue)

### H2: Reengagement Channel Failure

**Test:** Did our nudges stop?
- Push notification volume/CTR Nov vs Feb
- Email campaign sends Nov vs Feb
- Retargeting ad spend/impressions Nov vs Feb

**If any dropped significantly → Reengagement failure confirmed**

---

## What Kawaljeet Taught Me

**Kawaljeet's insight:** "if the user is watching during the trial and not performing upto the mark in current subscription. Then there is no way we can take trial performance as a benchmark in defining user quality."

**Translation:** 
- Tiers (T0-T6) are defined by TRIAL engagement
- If T6 users engaged during trial, acquisition did its job (brought engaged users)
- Post-sub disengagement ≠ acquisition failure
- Post-sub disengagement = subscription experience failure

**The logical flaw I made:**
- Tier degradation (T6: 74% → 65%) exists
- I concluded: "Acquisition quality degraded"
- But trial engagement defines the tier
- T6 users engaged 3+ days during trial (both Nov and Feb)
- So acquisition brought engaged users in BOTH months
- **The degradation happened POST-trial, not AT acquisition**

---

## V4 Conclusion That Needs Correction

### What I Said (WRONG)

**Primary Root Cause:** "Acquisition Source Quality Collapse"
- "Acquisition channels (organic, paid ads, carrier billing) bringing lower-quality users"
- "Within-tier quality degradation: Even T6 users dropped 12%"
- "Lookalike audience degradation, carrier billing quality drop"

### What I Should Have Said (CORRECT)

**Primary Root Cause:** "Subscription Engagement Failure"
- "Trial-engaged users (T6 = 3+ watch days during trial) disengage post-subscription"
- "Problem occurs AFTER trial ends, not during acquisition"
- "Need to diagnose: App open drop? Or app open→watch funnel weakening?"

### The Attribution Change

**V4 attribution:**
- 71% from T0 collapse (direct sub base shrinking)
- 20-25% from within-tier quality degradation ← **THIS FRAMING IS WRONG**

**Corrected attribution:**
- 71% from T0 collapse (direct sub base shrinking) ← **STILL VALID**
- 20-25% from subscription-period engagement failure ← **CORRECT FRAMING**
  - Mechanism TBD: App open drop? Funnel problem? Reengagement failure?

---

## The Analysis I'm About to Run

### Data Sources

1. **App opens:** Metabase card #6852 (M0 App Open Users by Activity Bucket)
2. **App opens by dialect:** Card #10572
3. **Existing V4 data:** Platform, trial engagement tiers, temporal trends

### Analysis Structure

**Part 1: App Open Trends**
- App opens per user (trial period D1-D7) Nov vs Feb
- App opens per user (subscription period D8-D30) Nov vs Feb
- % of users who opened app at least once D8-D30

**Part 2: Funnel Analysis**
- Among users who opened app D8-D30, what % watched?
- App open → watch conversion Nov vs Feb
- Is the problem "they don't open" or "they open but don't watch"?

**Part 3: If App Open Drop**
- Reengagement campaign volume (push, email, retargeting) Nov vs Feb
- CTR/engagement on reengagement Nov vs Feb
- Organic vs reengagement-driven drop

**Part 4: Corrected V4 Synthesis**
- Update root cause framing
- Remove "acquisition quality" language
- Replace with "subscription engagement failure"
- Specify mechanism (app open vs funnel vs reengagement)

---

## What This Teaches Me About Working with Vismit

### Pattern 1: He Tests Assumptions with Data

When I said "Watcher% dropped to 4.89%", he knew immediately that's wrong (Watcher% is ~50%).

He didn't say "that's wrong" — he asked "what does that mean?" to see if I'd catch my own error.

When I didn't, he corrected: "thats not correct, watcher% is somewhere around 50%."

**Lesson:** He knows the metrics cold. Don't present numbers without validating they make sense first.

### Pattern 2: He Demands Logical Consistency

Kawaljeet caught the logical contradiction: "Trial engagement proves they're engaged → can't be acquisition quality problem."

Vismit co-signed: "we both dont agree to [your conclusion]."

**Lesson:** If data contradicts conclusion, the conclusion is wrong. Trial engagement is evidence. Can't ignore it.

### Pattern 3: He Gives Diagnostic Frameworks, Not Answers

Instead of telling me "it's an app open drop," he said: "figure that out — app open drop OR funnel problem. If app open drop, check organic vs reengagement."

**Lesson:** He wants me to think, not just execute. The framework is the teaching moment.

---

## Next Step

Run the app open analysis, determine:
1. App open drop? Or funnel?
2. If app open: Organic or reengagement?
3. Update V4 with corrected framing

**ETA:** 20-30 min (data pull + analysis + synthesis)
