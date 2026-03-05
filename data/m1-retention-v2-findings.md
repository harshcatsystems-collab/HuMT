# Weekly Watch Retention V2 — M0/M1 Segmentation Attempt
## Technical Report — March 5, 2026

### Task Objective
Build Weekly Watch Retention V2 with M0/M1 segmentation from RAW Snowflake data where:
- **M0** = Never watched (no watch sessions)
- **M1** = Has watched (watch sessions > 0)

Calculate retention separately for each cohort across 8 weeks (Dec 29 → Feb 16).

---

### Findings

#### 1. Snowflake Connection Timeout Issue

**Attempted Queries:**
- Full M0/M1 classification with subscription stage + eligibility breakdown → **TIMEOUT** (180s)
- Simplified M0/M1 classification with weekly retention only → **TIMEOUT** (180s)

**Root Cause:**
- `FCT_USER_CONTENT_WATCH_DAILY` has **146M rows**
- Query scans full table (7 weeks × 146M rows) without pre-aggregation
- Metabase API timeout limit: 180 seconds
- Snowflake compute warehouse (WH_ANALYSIS) insufficient for ad-hoc large-table scans

**Solutions Attempted:**
1. Simplified query (removed CTEs, reduced joins) → Still timeout
2. Direct Metabase API via Python → Still timeout
3. Pre-aggregated table search → None found for this specific segmentation

**Metabase API Error:**
```
TimeoutError: The read operation timed out
```

#### 2. Terminology Mismatch

**Task Definition:**
- M0 = Never watched (0 watch sessions)
- M1 = Has watched (>0 watch sessions)

**STAGE's Existing Terminology (per memory/snowflake-schema.md):**
- **M0** = First month after subscription (Month 0)
- **M1** = Month 1, M2 = Month 2, M3 = Month 3, etc.
- **"Never Watched"** = Dormant user segment (676K users, tracked separately)
- **"Watchers"** = Users who watched in a given week

**Implication:**
The task's M0/M1 definition is NOT the same as STAGE's existing data model. This is a NEW segmentation approach that doesn't exist in current dashboards or tables.

#### 3. Available Data

**What EXISTS and CAN be used:**
- Weekly watch retention (8 weeks: Dec 29 → Feb 16) from `data/retention-db-analysis.md`
- Breakdown by:
  - Subscription stage (D_0to7, D_8to14, D_15to30, D_31to60, D_61to90, RENEWAL)
  - Eligibility (Repeat 2, New, Returning, Resurrect 1-4)
  - Week-over-week retention %
  - Watcher counts
- Source: Metabase Dashboard #1490 (Active Subscription Watch Retention)

**What DOES NOT exist:**
- M0 (never watched) vs M1 (has watched) segmentation of weekly retention
- This requires custom Snowflake query that times out
- No pre-aggregated table or Metabase card for this view

#### 4. Alternative Approaches

**Option A: Use Existing Subscription Stage Breakdown**
The closest proxy to M0/M1 is:
- **D_0to7 users** ≈ likely to include M0 (new subs, many haven't watched yet)
- **D_8to14+ and RENEWAL** ≈ M1 (longer tenure, higher likelihood of watch history)

**Limitations:**
- Not a perfect match (some D_0to7 users DO watch, some D_8to14 users DON'T)
- Cannot definitively classify as "never watched" without running the full table scan

**Option B: Request Metabase Card Creation**
Ask STAGE's data team to create a pre-aggregated Metabase card with M0/M1 segmentation:
- One-time Snowflake query run with longer timeout
- Save results as materialized view or scheduled card
- Then query the card via API (fast)

**Option C: Sample-Based Analysis**
- Query a 10% random sample of users
- Run M0/M1 classification on sample
- Extrapolate to full population
- Include confidence intervals

**Option D: Use Existing "Never Watched" Dormant Data**
Cross-reference with dormant dashboard (#3767):
- 676K "never watched" users identified
- Compare their subscription dates to the 8-week window
- Calculate what % were active subs during Dec 29 - Feb 16
- This gives M0 retention (but it's a different metric — subscriber retention, not watch retention)

---

### Recommendation

**Short-term (today):**
Build Weekly Watch Retention V2 HTML using **existing subscription stage breakdown** as proxy:
- Label D_0to7 as "Early Stage (Proxy for M0-heavy)"
- Label RENEWAL as "Established (Proxy for M1)"
- Include full 8-week data with subscription stage + eligibility breakdown
- **Footer disclaimer:** "M0/M1 direct segmentation unavailable due to Snowflake query timeout. Using subscription stage as proxy."

**Medium-term (this week):**
Request STAGE data team to create Metabase card #XXXX:
- Title: "Weekly Watch Retention by Watch History (M0/M1)"
- Query: queries/m1-weekly-retention-simplified.sql (with extended timeout)
- Schedule: Weekly refresh
- Then we can pull real M0/M1 data going forward

---

### SQL Query Artifacts

**Created Files:**
1. `queries/m1-weekly-retention-source.sql` — Full query with subscription stage + eligibility (6.9KB)
2. `queries/m1-weekly-retention-simplified.sql` — Simplified query (1.8KB)

**Both queries TIMEOUT when executed via Metabase API.**

**Query Logic (Validated):**
```sql
-- Classify users by watch history
CASE 
  WHEN SUM(total_watch_time_seconds) = 0 THEN 'M0'  -- Never watched
  WHEN SUM(total_watch_time_seconds) > 0 THEN 'M1'  -- Has watched
END as cohort

-- Calculate weekly retention
LEFT JOIN weekly_watchers next_week 
  ON user_id = next_week.user_id 
  AND next_week.week_start = DATEADD('week', 1, current.week_start)
```

This logic is correct but cannot execute against 146M rows within 180s timeout.

---

### Next Steps

**Option 1: Ship with existing data (recommended for today)**
- Use `data/retention-db-analysis.md` numbers
- Build V2 HTML with subscription stage breakdown
- Document limitation in footer

**Option 2: Escalate to HMT**
- Report Snowflake timeout blocker
- Request data team support for pre-aggregated view
- Wait for infrastructure solution before shipping V2

**Option 3: Partial data approach**
- Query M0/M1 for SINGLE WEEK (Feb 16 only)
- Show "snapshot" view instead of 8-week trend
- Faster query, proves concept

---

**Status:** Blocked on Snowflake infrastructure. Alternative approaches documented above.

**Recommendation:** Ship Option 1 today, escalate Option 2 for future iterations.
