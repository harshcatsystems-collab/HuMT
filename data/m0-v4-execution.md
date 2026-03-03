# M0 V4 Analysis — Execution Log

**Started:** March 3, 2026 10:05 UTC  
**Framework:** Vismit's 7-dimension segmentation  
**Goal:** Definitive M0 engagement analysis with complete attribution

---

## Data Sources Available

### Metabase Dashboard #2182 (M0 Engagement Action Plan)
- 99 cards with rich M0 segmentation
- Base query fields: user_id, install_status, dialect, subscription_start_date, days_active_in_trial_period, active_days_since_subs_start

### Key Metrics Already Available:
- Watcher% by trial activity bucket
- Habit% trends by dialect
- Watch conversion by trial active days
- Platform breakdowns (web/app)
- Install status segmentation

---

## V4 Framework Execution Plan

### Step 1: Identify Direct vs Trial-Converted Subscribers ✅ IN PROGRESS

**Method:** Query subscription plan IDs with Watcher% >90%

Need to:
1. Pull all subscription_plan_ids with their Watcher%
2. Flag any with >90% as "direct"
3. Calculate subscriber base % for direct vs trial-converted
4. Track week-over-week trend (is direct base shrinking?)

### Step 2: Build 7-Dimension Segmentation Matrix

For EACH group (Direct / Trial-Converted), segment by:

1. **Web/App Acquired** — from user_source_details field
2. **Engagement Tier** (4-level)
   - For 1-day trial: High (≥40min), Medium (20-30min), Low (<20min), None (0min)
   - For 7-day trial: High (≥3 days active), Medium (2 days), Low (1 day), None (0 days)
3. **Trial Plan ID** — 1-day / 7-day / Direct
4. **Subscription Plan ID** — Group by plan ID, flag direct (>90% watcher%)
5. **Dialect** — har, raj, bho, guj
6. **Week of Subscription** — W1-W13 (Dec-Feb cohorts)
7. **App Installed Status** — installed / uninstalled

### Step 3: Calculate 4 Core Metrics per Segment

1. **Watcher%** — Users with 8+ watch days in M0
2. **Habit%** — Users with 8+ watch days + recurring pattern
3. **Daily Watch Conversion%** — Avg % of days watched
4. **Subscriber Base Contribution%** — What % of total M0 this segment represents

### Step 4: Attribution Analysis

**Question:** Why did M0 Watcher% degrade from 60% (Sep) → 76% ghost rate (Feb)?

**Test via segmentation:**
- How much is direct subscriber degrowth?
- How much is web trial growth (with 80% ghost rate)?
- How much is engagement tier shift (more low-intent users)?
- How much is dialect mix change?
- How much is app uninstall increase?

### Step 5: Hypothesis Validation

| Hypothesis | Test Via | Expected Signal |
|------------|----------|-----------------|
| Direct subs shrinking | Week-over-week direct % | Declining direct base |
| Web trials growing | Week-over-week web % | Increasing web proportion |
| Low-intent users increasing | Engagement tier distribution by week | More "None" and "Low" tiers |
| Acquisition quality degrading | Paid vs organic watcher% by week | Declining paid%, increasing organic% |
| Platform matters | Web vs app watcher% | Significant gap |
| Trial behavior predicts retention | Engagement tier vs Watcher%/Habit% | Clear tier separation |

---

## Execution Status

### Phase 1: Data Exploration ✅ COMPLETE
- Metabase dashboard identified (#2182)
- Base query structure understood
- 99 cards available with existing segmentations

### Phase 2: Direct vs Trial Identification 🔄 IN PROGRESS
- Need to query subscription_plan_id performance
- Calculate Watcher% per plan ID
- Flag >90% as direct

### Phase 3: Full Segmentation — NEXT
### Phase 4: Metric Calculation — NEXT
### Phase 5: Attribution & Synthesis — NEXT

---

## Progress Updates

**10:05 UTC:** Starting execution, identified Metabase dashboards
**10:XX UTC:** [Next update when Phase 2 complete]

