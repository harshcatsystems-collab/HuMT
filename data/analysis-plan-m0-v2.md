# M0 Engagement Analysis v2 — Execution Plan

**Goal:** Build comprehensive M0 engagement analysis addressing Vismit's 5 requirements

## Data Sources Available

### 1. Metabase API
- Base URL: https://stage.metabaseapp.com/api
- Dashboard 2182: M0 Engagement Action Plan
- Key cards found:
  - 6182: adhoc_new_subscriber_m0_watch_activity
  - 6152: adhoc_new_subscriber_cohort_watch_retention_engagement
  - 14336: Bho M0 Watchers - First Playback Channel
  - 14338: Dialect wise M0 Watchers - First Playback Channel
  - 4641-4648: Channel wise MSR cards
  - 14302-14306: D0-M60 TCR by Acquisition Platform

### 2. Snowflake (via DBT Model Reference)
- Database: ANALYTICS_PROD
- Key tables/views:
  - `dim_users` — attribution fields (acquiring_channel, media_source, campaign_id)
  - `fct_user_subscription_history` — subscription_user_type (trial vs direct)
  - `fct_watch_activity_daily/history` — watch behavior
  - `viz_new_subscriber_m0_watch_activity` — M0 watch metrics
  - `viz_aha_moment_achieved_trend` — Aha metrics by dialect
  - `viz_habit_moment_achieved` — Habit formation (8+ watch days)

### 3. Existing Analysis (m0-engagement.html)
- Ghost rate: 65% (110K zero activity)
- Watch conversion: 3.09%
- Dialect breakdown (Rajasthani 3.52%, Haryanvi 3.49%, Bhojpuri 2.51%)
- Average watch days: 2.17

## Required Analyses

### 1. Marketing Channel-Level Breakdown ✅
**Data needed:**
- M0 cohort segmented by `acquiring_media_source`, `acquiring_channel_name`
- Metrics per channel: ghost rate, watch conversion, Watcher%, Habit%
- Source: Metabase card 4641-4648 (Channel wise MSR) + card 14338 (dialect/channel)

### 2. High-Intent vs Low-Intent Users ✅
**Intent signals to define:**
- Direct subscription vs trial
- App install vs web trial
- Paid search vs display ads vs organic
- Source: `dim_users.acquiring_channel_name` + `subscription_user_type`

### 3. Acquisition Quality vs Marketing Push 🔍
**Hypothesis:** Ghost rate improvement (65% → 34% claim) — need to find source
**Data needed:**
- Campaign-level correlation between creative/targeting changes and ghost rate
- Temporal analysis: when did ghost rate drop? What campaigns were running?
- Source: CleverTap campaign data + AppsFlyer attribution

### 4. Watcher% + Habit% as North Stars ✅
**Definitions (confirmed from stage-metrics-model.md):**
- **Watcher%** = % of M0 users who watched ≥1 sec in first 30 days
- **Habit%** = % of M0 users with ≥8 unique watch days in first 30 days
**Current metrics:**
- Watcher%: ~36.3% (Jan 2026, from viz_new_subscriber_m0_watch_activity)
- Habit%: ~3.3% (Jan 2026, from viz_habit_moment_achieved)
**Need:** Rebuild entire analysis with these as primary metrics, not daily watch conversion

### 5. Installed Cohort Analysis ✅
**Filter:** Exclude web trials, show app-installed-only users
**Source:** `platform = 'android' OR platform = 'ios'` filter on subscription history
**Hypothesis:** App-installed users have higher engagement than web trials

## Execution Strategy

### Phase 1: Data Collection (via Metabase API)
1. Query card 6182 for M0 watch activity baseline
2. Query card 14338 for dialect+channel breakdown
3. Query card 4641-4648 for MSR by channel
4. Query card 14302-14306 for TCR by acquisition platform

### Phase 2: Analysis Build
1. Calculate Watcher% and Habit% from raw data
2. Segment by acquisition channel (organic, paid search, display, social)
3. Define high/low intent buckets based on:
   - Trial vs direct sub
   - App vs web
   - Channel quality (organic > search > social > display)
4. Compare metrics across segments
5. Identify installed-only cohort performance

### Phase 3: HTML Output
- Same format as m0-engagement.html (Google Sans, callouts, stat grids)
- Save to: data/serve/m0-engagement-v2.html
- Structure:
  1. Executive Summary (Watcher% + Habit% as hero metrics)
  2. Channel-Level Breakdown
  3. High-Intent vs Low-Intent Comparison
  4. Acquisition Quality Analysis
  5. Installed Cohort Deep Dive
  6. Recommendations

### Phase 4: Deployment
1. Run deploy script: `bash scripts/deploy-presentation.sh m0-engagement-v2.html`
2. Upload to Google Drive (folder: Strategy/Analysis — 155j3ClW1pK9FZHH6PkocG6DVkt9zeAzq)
3. Post to #engagement-solver-team (C0904NE9Y2K) tagging:
   - @U07LFSB0PM5 (Vismit Bansal)
   - @U05QMQHCVNY (HMT)
   - @U0A4V6M3BT5 (Kawaljeet)

## Open Questions
1. Where is the "65% → 34%" ghost rate claim documented? Need to search Slack threads.
2. Do we have campaign-level creative data accessible via Metabase?
3. What date range should the analysis cover? (Default: last 90 days Jan-Mar 2026)

## Timeline
- Data collection: 30 min
- Analysis build: 2 hours
- HTML generation: 1 hour
- Review + deployment: 30 min
**Total:** ~4 hours

---
*Plan created: 2026-03-02 10:35 UTC*
