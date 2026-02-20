# Snowflake → Morning Brief Integration Plan

> **Purpose:** Define which Snowflake metrics feed into HMT's daily morning brief cron job
> **Drafted:** 2026-02-20

---

## 1. Daily Numbers That Matter

Based on the deep analysis, here are the metrics that should appear in every morning brief, grouped by urgency:

### 🔴 Critical Daily Metrics (Always Show)

| Metric | Source Table | Query Logic | Why It Matters |
|--------|-------------|-------------|----------------|
| **Yesterday's trials** | FCT_USER_SUBSCRIPTION_HISTORY | `PLAN_CATEGORY='Trial' AND CREATED_AT_IST::DATE = yesterday` | Volume indicator, spot anomalies |
| **Yesterday's new paid subs** | FCT_USER_SUBSCRIPTION_HISTORY | `PLAN_CATEGORY='New Subscription' AND CREATED_AT_IST::DATE = yesterday` | Conversion signal |
| **D0 active rate (yesterday's trials)** | D0_USER_BUCKETS | `ACTIVE_FLAG=1 WHERE TRIAL_START_DATE = yesterday` | Early warning if engagement drops |
| **D0 aha rate** | D0_USER_BUCKETS | `AHA_FLAG=1` | Content-market fit signal |
| **Active mandates** | DIM_MANDATES_SCD | `CURRENT_STATUS='mandate_active'` count | Subscriber base health |
| **Yesterday's revocations** | DIM_MANDATES_HISTORY | Status changed to revoked/paused yesterday | Churn velocity |

### 🟡 Important Weekly Metrics (Show Mon/Thu)

| Metric | Source Table | Why It Matters |
|--------|-------------|----------------|
| **7-day M0 watch rate** (new subs from 7 days ago) | FCT_USER_CONTENT_WATCH_DAILY + FCT_USER_SUBSCRIPTION_HISTORY | Are new subs engaging? |
| **Trailing 7-day revenue estimate** | VIZ_MONTHLY_TRIAL_COHORT_REVENUE | Revenue velocity |
| **Top 5 trial-driving shows (7d)** | AGG_TRIAL_COUNTS_BY_CONTENT | Content performance |
| **D0 intent bucket distribution (7d)** | D0_USER_BUCKETS | Quality of incoming traffic |
| **Aha moment rate by dialect (7d)** | VIZ_AHA_MOMENT_ACHIEVED_TREND | Per-market health |

### 🟢 Monthly Metrics (Show 1st/15th)

| Metric | Source Table | Why It Matters |
|--------|-------------|----------------|
| **Cohort mandate survival curve** | VIZ_MONTHLY_TRIAL_COHORT_REVENUE | Long-term retention health |
| **M0 zero-watch rate by cohort** | VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY | The #1 problem metric |
| **Dormant user counts** | NEVER_WATCHED_USER_TAGGING / PREVIOUSLY_WATCHED_USER_TAGGING | Reactivation opportunity |
| **Content retention leaderboard** | Custom query (see deep analysis) | Investment decisions |

---

## 2. Implementation Architecture

### Option A: Direct Snowflake Queries via Metabase API (Recommended)

```
Morning Brief Cron (6:30 AM IST)
  → Python script calls Metabase API (POST /api/dataset)
  → Runs 4-6 SQL queries against Snowflake Prod (DB 299)
  → Formats results into brief section
  → Injects into morning brief template
  → Delivers to Telegram/Slack
```

**Pros:** Already working (API key active), no new infra needed, queries return in <30s
**Cons:** Metabase API rate limits (unclear), dependent on Metabase uptime

### Option B: Saved Metabase Questions

```
Pre-save each metric as a Metabase Question
  → Cron fetches results via GET /api/card/{id}/query
  → Faster, cached, less query overhead
```

**Pros:** Metabase handles caching, can be viewed in dashboard too
**Cons:** Need to create/maintain saved questions, harder to modify dynamically

### Recommendation: **Option A** for phase 1, migrate to Option B for frequently-used queries once stable.

---

## 3. Query Templates (Ready to Use)

### Q1: Yesterday's Trials + New Paid

```sql
SELECT 
  PLAN_CATEGORY,
  COUNT(*) AS COUNT,
  COUNT(DISTINCT USER_ID) AS UNIQUE_USERS
FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY
WHERE CREATED_AT_IST::DATE = CURRENT_DATE - 1
  AND PLAN_CATEGORY IN ('Trial', 'New Subscription', 'Renewal')
GROUP BY 1
```

### Q2: D0 Active & Aha Rate

```sql
SELECT 
  COUNT(DISTINCT USER_ID) AS TOTAL,
  COUNT(DISTINCT CASE WHEN ACTIVE_FLAG = 1 THEN USER_ID END) AS ACTIVE,
  COUNT(DISTINCT CASE WHEN AHA_FLAG = 1 THEN USER_ID END) AS AHA,
  ROUND(COUNT(DISTINCT CASE WHEN ACTIVE_FLAG = 1 THEN USER_ID END) * 100.0 / COUNT(DISTINCT USER_ID), 1) AS ACTIVE_PCT,
  ROUND(COUNT(DISTINCT CASE WHEN AHA_FLAG = 1 THEN USER_ID END) * 100.0 / COUNT(DISTINCT USER_ID), 1) AS AHA_PCT
FROM ANALYTICS_PROD.DBT_VIZ.D0_USER_BUCKETS
WHERE TRIAL_START_DATE = CURRENT_DATE - 1
  AND DATE_IN_TRIAL = TRIAL_START_DATE
```

### Q3: Active Mandates Count

```sql
SELECT 
  COUNT(DISTINCT USER_ID) AS ACTIVE_MANDATES
FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_SCD
WHERE CURRENT_STATUS = 'mandate_active'
```

### Q4: Yesterday's Revocations

```sql
SELECT 
  STATUS_VALUE,
  COUNT(*) AS COUNT
FROM ANALYTICS_PROD.DBT_CORE.DIM_MANDATES_HISTORY
WHERE STATUS_CHANGED_AT_IST::DATE = CURRENT_DATE - 1
  AND STATUS_VALUE IN ('revoked_psp', 'paused_in_app', 'paused_psp')
GROUP BY 1
```

### Q5: Top Trial-Driving Shows (7d)

```sql
SELECT 
  FINAL_SHOW_SLUG, DIALECT,
  SUM(TOTAL_TRIALS_ACQUIRED) AS TRIALS
FROM ANALYTICS_PROD.DBT_MARTS.AGG_TRIAL_COUNTS_BY_CONTENT
WHERE GRANULARITY = 'daily'
  AND PERIOD_START_DATE >= CURRENT_DATE - 7
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10
```

---

## 4. Brief Format: Daily Snowflake Section

```
📊 STAGE Metrics (Yesterday)
━━━━━━━━━━━━━━━━━━━━
Trials: 14,137 (prev: 12,890, +9.7%)
New Paid: 6,892 (prev: 6,440, +7.0%)
Renewals: 14,302
Active Mandates: 2.09M

D0 Engagement:
• Active: 62.3% (7d avg: 58.2%) ⚠️
• Aha: 5.1% (7d avg: 5.6%)
• Zero-watch: 21.5%

Churn Yesterday:
• Revoked: 16,230
• Paused (app): 1,820
• Paused (PSP): 890

Top Shows (7d trials):
1. Saanwari (raj) — 8,420
2. Jholachhap (bho) — 7,115
3. Saanwari (bho) — 6,890
```

### Anomaly Alerts (auto-triggered):

| Condition | Alert |
|-----------|-------|
| D0 active rate < 55% | 🔴 D0 engagement critically low |
| Trials drop > 30% day-over-day | 🔴 Trial volume crash — check ads |
| Revocations > 20K in a day | 🟡 Elevated churn |
| Aha rate < 4% | 🟡 Content-market fit degrading |
| New paid subs < 5K | 🟡 Conversion funnel issue |

---

## 5. Implementation Steps

1. **Create `/home/harsh/.openclaw/workspace/scripts/snowflake-brief.py`** — Python script with Metabase API calls
2. **Add to morning brief cron job** — Run at 6:15 AM IST (before the 6:30 AM brief)
3. **Cache results** — Save to `/tmp/snowflake-brief-cache.json` for the brief to pick up
4. **Add anomaly detection** — Compare against 7-day rolling averages
5. **Test for 3 days** — Verify data accuracy before including in HMT's brief

### Dependencies:
- Metabase API key (already configured: `mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4=`)
- Snowflake Prod DB (ID: 299) accessible via Metabase
- D0_USER_BUCKETS table freshness (updates daily? — need to confirm)
- AGG_TRIAL_COUNTS_BY_CONTENT freshness (daily granularity available)

### Data Freshness Risks:
- Most tables update daily by ~6 AM IST (via DBT pipeline)
- D0_USER_BUCKETS may have a 1-day lag (yesterday's trials show up today)
- If DBT pipeline fails, brief should show "⚠️ Data may be stale" with last-updated timestamp

---

## 6. Phase 2: Advanced Metrics (After Phase 1 Stable)

- **Weekly cohort waterfall** — Trial → D0 active → D7 active → Conversion → Renewal
- **Content velocity** — Which new shows are gaining watch time fastest
- **Revenue by dialect** — Daily revenue contribution per market
- **CAC trends** — When ad spend data pipeline is fixed (currently stale since Jun 2025)
- **LTV by acquisition source** — Requires AppsFlyer attribution join

---

*Plan by HuMT | Ready for implementation*
