# Snowflake Data Dictionary — STAGE Analytics

> **Connection:** Account KOCWHRB-LQ59958 | User BMAD_USER | WH_ANALYSIS | METABASE_ROLE
> **Last profiled:** 2026-02-18

---

## Data Model Relationships

### User Identity
- **user_id** = MongoDB ObjectId (24-char hex, e.g. `6705ee8dfc5c185a4dbe405e`)
- Consistent across: FCT_USER_SUBSCRIPTION_HISTORY, FCT_USER_ENGAGEMENT, FCT_USER_CONTENT_WATCH_DAILY, DIM_MANDATES_*
- FCT_USER_WATCH_HISTORY uses `MONGO_USER_ID` (same format) + `MONGO_DEVICE_ID`

### Subscription Lifecycle
```
Trial (₹1, 7-10d) → New Subscription (auto-convert via mandate) → Renewal → Renewal → ...
```
- Each transition = new row in FCT_USER_SUBSCRIPTION_HISTORY
- Previous sub gets STATUS='cancel' when replaced
- **PLAN_CATEGORY**: Trial / New Subscription / Renewal
- **SUBSCRIPTION_USER_TYPE**: trial_autopay_user | direct_autopay_user | trial_returning_user | None (legacy)
- 97% come through WEBHOOK (auto-renewal), only 1.6% manual APP

### Mandate Lifecycle
```
mandate_initiated → mandate_active → [paused_in_app | paused_psp | revoked_psp | cancelled_and_started_anew | refunded]
```

### Revenue Join Chain
```
FCT_USER_SUBSCRIPTION_HISTORY.MASTER_MANDATE_ID 
  → DIM_MANDATES_SCD.MANDATE_ID (has PG_TXN_ID)
  → FCT_PAYMENT_GATEWAY_TRANSACTIONS.TRANSACTION_ID
```
⚠️ FCT_PAYMENT_GATEWAY_TRANSACTIONS has NO user_id — must join through mandates.

### Content Hierarchy
```
DIM_CONTENT: CONTENT_ID → SHOW_ID → SEASON_ID
  + EPISODE_ORDER, CONTENT_DIALECT, SHOW_TITLE, GENRE_LIST, DURATION_SEC
  + Same show appears as multiple CONTENT_IDs (one per display_language: en, hin)
```

### Data Freshness (as of 2026-02-18)
| Table | Last Data | Status |
|-------|-----------|--------|
| FCT_USER_SUBSCRIPTION_HISTORY | Today | ✅ Real-time |
| FCT_USER_ENGAGEMENT | Today | ✅ Daily (has some future-date garbage) |
| FCT_USER_CONTENT_WATCH_DAILY | Today | ✅ Daily |
| DIM_MANDATES_HISTORY | Today | ✅ Real-time |
| FCT_USER_WATCH_HISTORY | Feb 2025 | ⚠️ STALE — possibly deprecated |
| FCT_PAYMENT_GATEWAY_TRANSACTIONS | Aug 2025 | ❌ Pipeline broken |
| FCT_MARKETING_AD_SPENDS_DAILY | Jun 2025 | ❌ Pipeline broken |

### Vendor Distribution
PhonePe 70% | Juspay 17% | Paytm 8% | Razorpay 3% | Apple 0.3%

### DBT Pipeline (unconfirmed)
```
RAW_PROD → DBT_BASE (76 staging) → DBT_PREP (17 intermediate) → DBT_CORE (38 dim/fact) → DBT_MARTS (15 agg) → DBT_VIZ (19 dashboard)
```
Also: DBT_ADHOC (9 one-offs), DBT_REVERSE_ETL (8 tables for CleverTap/recommendations)

### Event Catalog (EVENT_REGISTRY.EVENT_CATALOG)
409 active events tracked via RudderStack. Key events by volume (90-day):
- **PLAYBACK_PULSE** (2.3B): Heartbeat every 30s during playback — basis for watch time
- **THUMBNAIL_VIEWED** (458M): Thumbnail visible (10% threshold)
- **PLAYBACK_STARTED** (47M): First play of a video
- **APP_OPEN** (25M): App initialize
- **TITLE_PAGE_VIEWED** (23M): Content detail page load
- **TRIAL_PAYWALL_VIEWED** (11.3M): Paywall shown
- **TRIAL_INITIATED** (5.8M): User clicks "Start Trial"
- **TITLE_START** (4.7M): User watches >60 seconds of content

### Trial Funnel (from events):
```
TRIAL_PAYWALL_VIEWED (11.3M) → TRIAL_PAYWALL_CLOSED (8.2M, 73%!)
                              → TRIAL_INITIATED (5.8M)
                              → TRIAL_PAYMENT_INITIATED (5.1M)
                              → PAYMENT_SUCCESS (1.9M)
                              → TRIAL_ACTIVATED (905K)
```
8% paywall-to-activation rate. 73% close the paywall without acting.

### Aha & Habit Moment Definitions (inferred, needs confirmation)
- **Aha Moment**: Likely = user started ≥1 title (watched >60 sec of content, per TITLE_START event definition). ~4% of trial users achieve this.
- **Habit Moment**: Tracked via DAYS_ACTIVE_IN_TRIAL_PERIOD — likely = engaged on N+ distinct days during trial. ~3-5% of subscribers.
- Both definitions need confirmation from data team.

### Valuable Adhoc Tables
- **USER_360_VIEW**: Full user journey with attribution (signup→trial→subscription)
- **ADHOC_TRIAL_JOURNEY**: Day-by-day trial behavior with mandate action timestamps

---

## Databases Available

ANALYTICS_PROD, RAW_PROD, APPSFLYER_VIEW, MAXMIND_GEOLITE, RAW_DEV, ANALYTICS_DEV, REVERSE_ETL, SANDBOX, SNOWFLAKE, SNOWFLAKE_LEARNING_DB, USER$BMAD_USER

---

## ANALYTICS_PROD — The Star Schema

### Schemas
- **DBT_CORE** (38 tables) — Dimensions + Facts (the main model)
- **DBT_MARTS** (15 tables) — Business-level aggregations
- **DBT_VIZ** (19 tables) — Dashboard/visualization-ready views
- **DBT_BASE, DBT_PREP, DBT_ADHOC, DBT_REVERSE_ETL** — Staging/intermediate
- **EVENT_REGISTRY, _RUDDERSTACK** — Event pipeline

### Key Dimensions (DBT_CORE)

| Table | Rows | What it is |
|-------|------|-----------|
| DIM_CONTENT | 14K | Content catalog — shows, episodes, dialects, genres, duration, premium flag, release date |
| DIM_PLANID | 208 | Subscription plans — price, duration, OS, status |
| DIM_DEVICES | 31.5M | Device registry — SCD with platform, OS, app version |
| DIM_DEVICE_SESSION | 7.4M | Session-level device info (dialect, display language, manufacturer) |
| DIM_CAMPAIGN | 1.2K | CleverTap campaigns — name, channel, type, dialect |
| DIM_MANDATES_HISTORY | 26.7M | Payment mandate lifecycle (SCD) — status changes, renewal dates |
| DIM_MANDATES_SCD | 12.1M | Mandate snapshots — payment gateway, VPA, coupon, plan details |
| DIM_USER_LOCATION | 41.5M | User → IP mapping |
| DIM_VENDORS_PARTNERS | 22 | Vendor/partner flags |
| DIM_DATES | 73K | Calendar dimension |

### Key Facts (DBT_CORE)

| Table | Rows | What it measures |
|-------|------|-----------------|
| FCT_USER_SUBSCRIPTION_HISTORY | 23.4M | Every subscription event — plan, vendor, dialect, trial flag, price, dates |
| FCT_FRONTEND_EVENTS | 7B | ALL frontend events — the raw event stream |
| FCT_THUMBNAIL_ENGAGEMENT | 961M | Thumbnail views/clicks per user/content/widget |
| FCT_USER_WATCH_HISTORY | 257M | User watch history (pulse-based) |
| FCT_USER_CONTENT_WATCH_DAILY | 146M | Daily user-content watch time |
| FCT_USER_CONTENT_WATCH_HISTORY | 109M | Aggregated user-content watch |
| FCT_USER_CONTENT_WATCH_SESSION | 82M | Session-level content watch |
| FCT_USER_ENGAGEMENT | 65M | Daily user engagement (opens, pulses, thumbnails) |
| FCT_CONTENT_WATCH_SESSION | 2.1M | Content-level watch sessions (lighter) |
| FCT_PAYMENT_GATEWAY_TRANSACTIONS | 16.3M | PG transactions — amounts, refunds, settlements, fees |
| FCT_MARKETING_AD_SPENDS_DAILY | 306K | Daily ad spend by campaign/adset/ad (FB + Google) |
| FCT_USER_AD_INTERACTION | 13.6M | User → ad attribution (AppsFlyer) |
| FCT_USER_AD_INTERACTIONS | 51.8M | Same + event_name dimension |
| FCT_CLEVERTAP_CAMPAIGN_REPORT | 43K | Campaign performance (sent/viewed/clicked) |
| FCT_COMPLETION_RATIO | 37K | Content completion buckets |
| FCT_CONTENT_MANDATES | 380K | Content → mandate attribution |

### Business Marts (DBT_MARTS)

| Table | Rows | What it answers |
|-------|------|----------------|
| TRIAL_COUNT_TODAY | 913 | Daily trial count (rolling) |
| TRIAL_COUNT_THIS_WEEK | 132 | Weekly trial count |
| TRIAL_COUNT_THIS_MONTH | 31 | Monthly trial count |
| D0_TRIAL_CONVERSION | 30 | Day-0 trial→paid conversion + revenue |
| MSR_TRIAL_PLAN_SUCCESS_RATE | 362 | Trial success rate (mandate success rate) |
| MSR_TRIAL_PLAN_SUCCESS_RATE_BY_PLAN | 4K | Same, broken by plan |
| AGG_SUBSCRIPTION_COUNTS_CONDITIONAL | 16K | Sub counts by dialect/plan/granularity |
| AGG_TRIAL_COUNTS_BY_CONTENT | 22K | Trials by content/dialect |
| AGG_TV_ADOPTION_COUNTS | 15K | TV adoption metrics |
| PLANID_ANALYSIS | 5K | Plan-level funnel: paywall→trial→D1 retention→cancellation→subscription |
| NEVER_WATCHED_USER_TAGGING | 103M | Dormant user segments |
| PREVIOUSLY_WATCHED_USER_TAGGING | 61M | Lapsed user segments |
| SUBSCRIPTION_INFO_SUPPORT | 23M | Support lookup (phone, email, plan, mandate) |

### Visualization Views (DBT_VIZ)

| Table | Rows | What it shows |
|-------|------|-------------|
| VIZ_MONTHLY_TRIAL_COHORT_REVENUE | 31 | Monthly cohort → total revenue + renewal breakdown (up to R35) |
| VIZ_MONTHLY_TRIAL_COHORT_REVENUE_*_{price} | 5-29 each | Same, per plan price (99/149/199/249/299/399) |
| VIZ_AHA_MOMENT_ACHIEVED_TREND | 3.6K | Aha moment conversion by dialect/date |
| VIZ_HABIT_MOMENT_ACHIEVED | 344K | Habit formation by sub cohort |
| VIZ_NEW_SUBSCRIBER_COHORT_WATCH_RETENTION_ENGAGEMENT | 30M | Subscriber cohort watch retention curves |
| VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY | 169M | M0 watch activity for new subs |
| VIZ_RETENTION_M0_COHORT_BUCKET_MOVEMENT | 171M | Retention bucket movement over time |
| D0_USER_BUCKETS | 60M | Trial user behavior buckets (watch, aha, intent) |
| D0_CALLING / D1_CALLING | 75K/83K | Calling campaign targeting |
| MAINO_APP_METRICS_COHORT | 219K | Marketing cohort analysis (AppsFlyer) |
| VIZ_USER_APP_UNINSTALL_TILL_DATE | 9.6M | Uninstall tracking |
| VIZ_SQUADSTACK_DORMANT_CALLING | 1.2M | Dormant user calling targets |

---

## RAW_PROD — Source Data

| Schema | Tables | Source |
|--------|--------|-------|
| EVENTS | 1,210 | All frontend/backend events (granular) |
| MONGO / MONGO_V2 | varies | MongoDB snapshots |
| CLEVERTAP | - | CleverTap engagement data |
| APPSFLYER | - | Attribution data |
| GOOGLE_ADS | - | Google Ads raw data |
| FACEBOOK_MARKETING | - | FB/Meta ads raw data |
| GCP_BIGQUERY | - | BigQuery imports |
| EVENTS_BACKEND / EVENTS_INFRA / EVENTS_WEB / EVENTS_NEST_BACKEND | - | Backend event streams |

---

## Content Dialects (by catalog size)

| Code | Language | Content Count |
|------|----------|--------------|
| har | Haryanvi | 6,696 |
| raj | Rajasthani | 4,016 |
| bho | Bhojpuri | 2,686 |
| guj | Gujarati | 826 |

---

## Plan Structure

- **Trial plans:** ₹1 for 7-10 day trial, then convert to quarterly (₹199) or annual (₹399)
- **Quarterly:** ₹179-₹399 (90 days)
- **Monthly:** ₹99-₹199 (30 days)
- **Half-yearly:** ₹249-₹299 (180 days)
- **Annual:** ₹399 (365 days, actual ₹799)
- **Weekly:** ₹29 (7 days)
- **iOS:** Higher prices (sub_quarterly_149 = $19.99, sub_annual_399 = $79.99 mapped)
- **Experiments:** Many paywall variants (randeep, spin-the-wheel, hammer-crack, special-access, content-depth, social-proof, etc.)

---

## Current Pulse (as of 2026-02-18)

### Trials
- **Today (partial):** 7,233
- **Yesterday:** 14,137
- **Last 7 days:** ~12-14K/day
- **Feb MTD:** 242,890
- **Jan 2026:** 489,432
- **Dec 2025:** 516,381

### D0 Trial Conversion
- **Conversion rate:** ~21.5-23% (consistent)
- **D0 pause/revoke rate:** ~46-48%
- **Estimated daily revenue from conversions:** ₹45-58L

### Monthly Cohort Revenue (cumulative)
| Cohort | Trials | Active Mandates | Total Revenue |
|--------|--------|-----------------|---------------|
| Feb 2026 | 238K | 123K | ₹68.7L (still early) |
| Jan 2026 | 489K | 159K | ₹3.3 Cr |
| Dec 2025 | 516K | 121K | ₹5.3 Cr |
| Nov 2025 | 408K | 89K | ₹5.65 Cr |
| Oct 2025 | 464K | 99K | ₹8.4 Cr |
| Sep 2025 | 557K | 117K | ₹10.46 Cr |

---

## Core Business Metrics — Baseline (2026-02-18)

### 1. Active Subscribers (Current)
- **Active mandates:** 2.09M
- **Paused (in-app):** 550K | **Paused (PSP):** 250K
- **Revoked (lifetime):** 5.05M

**By category (active subs with valid end date):**
- Renewals: 1.1M | New Paid: 280K | Active Trials: 119K | **Total: ~1.5M**

**Monthly subscription mix:**
| Month | Trials | New Paid | Renewals | Total |
|-------|--------|----------|----------|-------|
| Feb 2026 (MTD) | 245K | 110K | 274K | 629K |
| Jan 2026 | 489K | 201K | 438K | 1.13M |
| Dec 2025 | 516K | 188K | 397K | 1.10M |
| Nov 2025 | 408K | 188K | 408K | 1.00M |
| Oct 2025 | 464K | 224K | 373K | 1.06M |
| Sep 2025 | 557K | 215K | 360K | 1.13M |
| Aug 2025 | 289K | 117K | 411K | 817K |

### 2. Revenue
| Month | Total Subs | Revenue (₹) |
|-------|------------|-------------|
| Feb 2026 (MTD) | 636K | ₹8.35 Cr |
| Jan 2026 | 1.15M | ₹13.73 Cr |
| Dec 2025 | 1.12M | ₹12.92 Cr |
| Nov 2025 | 1.01M | ₹14.24 Cr |
| Oct 2025 | 1.07M | ₹14.17 Cr |
| Sep 2025 | 1.15M | ₹13.6 Cr |
| Aug 2025 | 824K | ₹12.25 Cr |

### 3. Trial Funnel & Conversion

**D0 Trial Conversion (daily snapshot):**
- **D0 conversion:** ~22% (consistent)
- **D0 cancel/pause:** ~47%
- **Daily conversion revenue:** ₹45-58L

**Cumulative Conversion Curve (Jan-Feb 2026 trials):**
| Days | Cumulative Conversion % |
|------|------------------------|
| D-1 (pre-trial) | 19.9% |
| D0 | 21.2% |
| D1 | 21.5% |
| D3 | 23.7% |
| D7 | 26.0% |
| D10 | 26.9% |
| D14 | 27.6% |
| D30 | 28.7% |
→ Most conversion happens D0-D7. After D10, gains are marginal.

**PLANID Funnel (weekly, most recent):**
- Paywall views → Trial activation: ~25-30% trial rate
- D1 retention of trial users: ~28-30%
- D0 cancellation: ~15-18% of activated
- D10 cancellation: ~17-32% (varies by plan)

### 4. Trial Cohort Mandate Survival (Long-Term)
| Cohort | Trials | Active Mandates Now | Survival % | Lifetime Revenue |
|--------|--------|--------------------:|----------:|----------------:|
| Feb 2026 | 239K | 123K | 51.5% | ₹68.7L (early) |
| Jan 2026 | 489K | 159K | 32.5% | ₹3.3 Cr |
| Dec 2025 | 516K | 121K | 23.5% | ₹5.3 Cr |
| Nov 2025 | 408K | 89K | 21.7% | ₹5.65 Cr |
| Oct 2025 | 464K | 99K | 21.3% | ₹8.4 Cr |
| Sep 2025 | 557K | 117K | 21.0% | ₹10.46 Cr |
| Aug 2025 | 289K | 63K | 21.9% | ₹7.09 Cr |
| Jul 2024 | 529K | 130K | 24.5% | ₹24.77 Cr |
| Jun 2024 | 507K | 129K | 25.5% | ₹25.62 Cr |
→ Steady-state mandate survival: ~21-25% across mature cohorts.
→ Older cohorts (2023) drop to 7-11%.

### 5. Watch Retention Curves (New Subscribers)
**% of D0 watchers still watching on Day X:**
| Cohort | D1 | D3 | D7 | D14 | D30 | D60 | D90 |
|--------|-----|-----|-----|------|------|------|------|
| Feb 2026 | 57% | 35% | 17% | 4% | — | — | — |
| Jan 2026 | 58% | 38% | 25% | 18% | 10% | — | — |
| Dec 2025 | 63% | 40% | 27% | 20% | 16% | 4% | — |
| Nov 2025 | 67% | 41% | 28% | 20% | 15% | 9% | 5% |
| Oct 2025 | 65% | 44% | 30% | 23% | 16% | 11% | 11% |
| Sep 2025 | 64% | 41% | 29% | 23% | 20% | 10% | 13% |
| Aug 2025 | 74% | 57% | 45% | 33% | 23% | 11% | 11% |

**Key pattern:** D1 retention ~58-67%. Steep drop D1→D7. D30 retains only 10-16% of new subs. Aug 2025 was anomalously good (smaller cohort, higher quality?).

**Avg watch time per retained user (min/day):**
- D0: 135-161 min | D1: 107-154 min | D7: 75-109 min | D30: 44-70 min | D90: 38-54 min
→ Engaged users watch A LOT. But the pool shrinks fast.

### 6. M0 Watch Activity (First Month After Subscription)
| Cohort | Total Subs | Watched in M0 | Watch % | Avg Watch (min) |
|--------|-----------|:-------------:|--------:|----------------:|
| Feb 2026 | 108K | 20K | 18.8% | 36.8 |
| Jan 2026 | 199K | 72K | 36.3% | 36.5 |
| Dec 2025 | 186K | 73K | 39.5% | 35.7 |
| Nov 2025 | 186K | 74K | 40.1% | 32.0 |
| Oct 2025 | 222K | 86K | 38.5% | 28.2 |
| Sep 2025 | 214K | 77K | 36.1% | 29.9 |
| Aug 2025 | 115K | 49K | 42.9% | 35.5 |
→ **~60% of new subscribers don't watch anything in their first month.** This is the core retention problem.

### 7. Aha Moment & Habit Formation

**Aha Moment (last 30 days, by dialect):**
| Dialect | Trials | Aha Achieved | % |
|---------|--------|-------------|---|
| Haryanvi | 112K | 4,744 | 4.3% |
| Rajasthani | 137K | 5,632 | 4.1% |
| Bhojpuri | 166K | 5,982 | 3.6% |
| Gujarati | 26K | 896 | 3.4% |
→ Only ~4% of trial users hit aha moment. Huge room to improve.

**Habit Moment (by subscription cohort):**
| Cohort | Total Subs | Habit Achieved | % |
|--------|-----------|:-------------:|---:|
| Feb 2026 | 108K | 463 | 0.4% (early) |
| Jan 2026 | 199K | 6,603 | 3.3% |
| Dec 2025 | 186K | 8,146 | 4.4% |
| Nov 2025 | 186K | 8,356 | 4.5% |
| Oct 2025 | 222K | 8,438 | 3.8% |
| Sep 2025 | 214K | 6,576 | 3.1% |
| Aug 2025 | 115K | 7,756 | 6.8% |
→ ~3-5% form a habit. Aug 2025 was best at 6.8% (smaller, higher-quality cohort).

### 8. D0 Trial User Behavior
- **Feb 2026 trials:** 235K users on D0
- **Active on D0:** 161K (68.5%)
- **Aha achieved D0:** 7,603 (3.2%)
- **Avg watch time D0:** 28.7 min
→ 31.5% of trial users don't even open the app on D0.

### 9. Churn & Dormancy

**Monthly Mandate Revocations:**
| Month | Revoked (PSP) | Paused (In-App) | Cancelled & Restarted |
|-------|:------------:|:---------------:|:--------------------:|
| Feb 2026 (MTD) | 281K | 21K | 12K |
| Jan 2026 | 511K | 51K | 36K |
| Dec 2025 | 489K | 58K | 27K |
| Nov 2025 | 400K | 37K | 23K |
| Oct 2025 | 493K | 119K | 25K |

**Dormant User Segments (latest snapshot):**
| Segment | Installed | Uninstalled | Total | Avg Dormancy Days |
|---------|:---------:|:-----------:|:-----:|:-----------------:|
| LVU (Low Value) | 572K | 57K | 629K | 480 / 283 |
| HVU (High Value) | 187K | 123K | 311K | 28 / 27 |
| MVU (Medium Value) | 142K | 93K | 235K | 75 / 93 |
→ 1.18M dormant users total. HVUs churn fast (28 days avg) but keep the app. LVUs linger for over a year.

**Previously Watched (not watching now):**
- LVU: 235K | HVU: 121K | MVU: 116K (all not watched in 4 weeks)

**Never Watched:**
- LVU: 386K | HVU: 202K | MVU: 112K
→ 700K users who subscribed and NEVER watched anything.

**App Uninstalls:** 9.57M (lifetime)

### 10. Content Performance

**Top Shows by Watch Time (Last 30 Days):**
| Show | Dialect | Watch Hours | Viewers |
|------|---------|:----------:|:-------:|
| Mahapunarjanam | Haryanvi | 74K | 83K |
| Bhairavi | Rajasthani | 45K | 87K |
| Videshi Bahu 2 | Haryanvi | 28K | 36K |
| Jaan Legi Sonam | Bhojpuri | 22K | 57K |
| (Gujarati general) | Gujarati | 27K | 29K |

**Trials by Dialect (Feb 2026 MTD):**
1. Bhojpuri: 93K (37%)
2. Rajasthani: 74K (29%)
3. Haryanvi: 61K (24%)
4. Gujarati: 25K (10%)

### Data Gaps Noted
- **PG Transactions:** Only through Aug 2025 (pipeline stopped?)
- **Ad Spend:** Only through Jun 2025 (FB ₹7.9 Cr + Google ₹53.7 Cr = ₹61.65 Cr tracked)
- Marketing ROI/CAC analysis blocked by stale data
