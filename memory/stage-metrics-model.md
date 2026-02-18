# STAGE Metrics Framework — The Complete Model

> Based on HMT's whiteboard framework. Every metric mapped to Snowflake data.
> Arrows indicate desired direction. Baseline captured 2026-02-18.

---

## 🎬 CONTENT (Top of Framework)

**Goal:** Find and amplify Winning Titles

### WTR (Watch Through Rate) ↑
- **Definition:** % of users who complete content at various thresholds
- **Source:** `ANALYTICS_PROD.DBT_CORE.FCT_COMPLETION_RATIO` (buckets: 10-100%)
- **Top performers by 100% completion rate (all-time):**
  - **मेवात** — 511K users reached 100% (out of 2.9M who started = 17.6%)
  - **पुनर्जन्म** — 407K/2M = 20%
  - **बैड बॉयज भिवानी** — 222K/1.25M = 17.8%
  - **कॉलेज काण्ड** — 201K/1.24M = 16.2%
  - **अखाड़ा** — 192K/1.13M = 17%
  - **सेफ हाउस** — 148K/812K = 18.2%
  - **सेफ हाउस - 2** — 157K/665K = 23.6% ← best completion rate among top titles
  - **दहलीज़** — 118K/803K = 14.7%
  - **चौधर - 2** — 113K/769K = 14.6%
  - **ओपरी पराई** — 107K/853K = 12.6%
- **10% → 100% drop-off pattern:** Typical title retains 12-20% from first 10% to completion
- **Best completion curves:** Shows with episodic drama (Safe House, Mewat, Akhada, Punarjanam)

### CR (Completion Rate) ↑
- Measured same way as WTR. Higher CR = stickier content.
- **Pattern:** Regional-language dramas significantly outperform comedy/music/short-form

### Winning Titles (Current — Feb 2026)
**By trial acquisition:**
1. **Saanwari** (Rajasthani) — 24.4K trials (biggest single title driver)
2. **Jholachhap** (Bhojpuri) — 15.4K trials
3. **Saanwari** (Haryanvi) — 13.9K trials
4. **Bhairavi** (Rajasthani) — 12.2K trials
5. **Saanwari** (Bhojpuri) — 10.9K trials
6. **Saanwari** (Gujarati) — 10.5K trials
→ **Saanwari is the cross-dialect acquisition machine** (drives trials in 4 dialects)

**By watch time (30 days):**
1. Mahapunarjanam (Har) — 74K hrs
2. Bhairavi (Raj) — 45K hrs
3. Videshi Bahu 2 (Har) — 28K hrs
4. Jaan Legi Sonam (Bho) — 22K hrs

---

## 📈 GROWTH (Left Side)

### TAM ↑ (Total Addressable Market)
- **Not in Snowflake** — external market data needed
- Current languages: Haryanvi, Rajasthani, Bhojpuri, Gujarati (+ tiny pan, mar, awa, etc.)
- Gujarati is the newest expansion (25K trials/month in Feb)

### Reach ↑ (CPM ↓) → Better Creatives
- **Source:** `FCT_MARKETING_AD_SPENDS_DAILY` — but data stops Jun 2025
- **Historical:** Google ₹53.7 Cr + Facebook ₹7.9 Cr = ₹61.65 Cr total tracked spend
- ⚠️ **Can't track current CPM/Reach — pipeline broken**

### Traffic ↑ (CTR ↑)
- **Source:** AppsFlyer attribution in `FCT_USER_AD_INTERACTION` (51.8M records)
- `MAINO_APP_METRICS_COHORT` has install→registration→trial funnel by campaign
- CTR itself would need raw ad platform data

---

## 📱 APP (Left-Bottom)

### Trial Rate (TR) ↑
- **Definition:** Paywall viewers → Trial activated
- **Source:** `ANALYTICS_PROD.DBT_MARTS.PLANID_ANALYSIS`
- **Current:** ~25-30% of paywall viewers start a trial
- **Weekly trend (recent):**
  - Week of Feb 16: 79.6K paywall views → 17.1K trials (21.5%)
  - Week of Feb 9: 254.6K → 53.5K (21.0%)
  - Week of Feb 2: 296.7K → 67.9K (22.9%)
  - Week of Jan 26: 331.3K → 75.6K (22.8%)

### D₀ TCR ↓ (Trial Cancellation Rate — push DOWN)
- **Definition:** % who cancel/pause on Day 0
- **Source:** `D0_TRIAL_CONVERSION`, `PLANID_ANALYSIS`
- **Current:** ~47% pause/revoke on D0 (from D0_TRIAL_CONVERSION)
- **D0 cancel from PLANID:** 15-18% of activated trials cancel D0 (recent weeks)
- **This is the biggest lever in the funnel**

### D₁ Retention ↑
- **Source:** `PLANID_ANALYSIS.D1_RETAINED_USERS`
- **Current:** ~28-30% of trial users retained on D1
- **Trend:** Stable around 29% (recent 4 weeks)

### AHA Moment ↑
- **Definition:** User hits engagement threshold during trial
- **Source:** `VIZ_AHA_MOMENT_ACHIEVED_TREND`
- **Current (last 30 days):**
  - Haryanvi: 4.3% | Rajasthani: 4.1% | Bhojpuri: 3.6% | Gujarati: 3.4%
  - **Overall: ~3.9%** — only 1 in 25 trial users hits aha
- **D0 aha:** 7,603 out of 235K = 3.2%

### SR ↑ (Mandate Success Rate)
- **Definition:** Trial → successful paid mandate
- **Source:** `MSR_TRIAL_PLAN_SUCCESS_RATE`
- **Current (10-day cumulative):** ~26-27%
- **Cumulative conversion curve:**
  - D0: 21% → D7: 26% → D14: 28% → D30: 29%
  - Flattens after D10 — most conversions happen early

### Re Activation % ↑
- **Definition:** Previously cancelled users returning
- **Source:** `FCT_USER_SUBSCRIPTION_HISTORY.SUBSCRIPTION_USER_TYPE = 'trial_returning_user'`
- **Current monthly:**
  - Feb 2026: 1,188 returning users (out of ~110K typed users = ~1.1%)
  - Jan 2026: 1,739 (~0.9%)
  - Dec 2025: 2,530 (~1.4%)
  - Nov 2025: 2,350 (~1.3%)
- **Very low reactivation.** Mostly one-shot trial users.

---

## 🌐 WEB (Middle)

### Trial Rate (TR) ↑ — Web
- **Source:** `FCT_USER_SUBSCRIPTION_HISTORY` (PLATFORM = 'web')
- **Current split:**
  - Feb 2026: 160K app trials + 93K web trials (37% web)
  - Jan 2026: 413K app + 103K web (20% web)
  - Dec 2025: 439K app + 92K web (17% web)
- **Web trial share GROWING** — 37% in Feb vs 17% in Dec. Significant shift.

### App Install (IR) ↑ — Web to App
- **Not directly tracked** in current schema
- Could be derived from web trial → subsequent app session (cross-referencing device data)

---

## 🔄 RETENTION (Right Side)

### M₀ Watchers % ↑
- **Definition:** % of new subscribers who watch anything in first month
- **Source:** `VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY`
- **Current:**
  - Jan 2026: 36.3% | Dec 2025: 39.5% | Nov 2025: 40.1% | Oct 2025: 38.5%
- **60% of new subs DON'T WATCH in M0.** This is the #1 retention problem.
- Avg watch when they do: 28-37 min

### Habit Moment % ↑
- **Definition:** Subscriber forms a regular watching habit
- **Source:** `VIZ_HABIT_MOMENT_ACHIEVED`
- **Current:**
  - Jan 2026: 3.3% | Dec 2025: 4.4% | Nov 2025: 4.5% | Aug 2025: 6.8% (best)
- **Only 3-5% form a habit.** Directly correlates with renewal.

### Week 4 Watchers % ↑
- **Definition:** % of D0 watchers still watching at Day 30
- **Source:** `VIZ_NEW_SUBSCRIBER_COHORT_WATCH_RETENTION_ENGAGEMENT`
- **Current D30 retention:** 10-16% of D0 watchers
  - Jan 2026: 10.2% | Dec 2025: 15.5% | Nov 2025: 15.0% | Oct 2025: 15.8%

### Renewal Rate ↑
- **Definition:** Mandate survival at renewal date
- **Source:** `VIZ_MONTHLY_TRIAL_COHORT_REVENUE` (active mandates / total trials)
- **Current mandate survival by cohort age:**
  - 1 month: ~51% | 2 months: ~32% | 3 months: ~23% | Steady-state: ~21-25%
- **Renewal revenue kicking in:**
  - Sep 2025 cohort: ₹6.48 Cr first sub + ₹2.73 Cr R1 + ₹0.48 Cr R2 + ₹0.32 Cr R3
  - Revenue concentration: ~62% from first subscription, ~26% from R1

### M1+ Watcher % ↑
- **Definition:** Subscribers still watching beyond month 1
- **Source:** Watch retention curves (D60, D90)
- **Current:**
  - D60 retention: 4-11% | D90 retention: 5-13%
  - Huge variance by cohort quality
- **Aug 2025:** D90 = 10.5% | **Oct 2025:** D90 = 10.9% (best recent)

### Dormants Watcher % ↑
- **Definition:** Reactivating dormant users (still installed, not watching)
- **Source:** `VIZ_SQUADSTACK_DORMANT_CALLING`, `PREVIOUSLY_WATCHED_USER_TAGGING`
- **Current dormant pool:**
  - **1.18M dormant users** (app still installed)
  - HVU (High Value): 187K installed (avg 28 days dormant) — most winnable
  - MVU (Medium Value): 142K installed (avg 75 days)
  - LVU (Low Value): 572K installed (avg 480 days) — likely lost
- **700K "never watched" users** who subscribed but never watched anything
- SquadStack calling campaigns target these segments

### Re Acquisition ? ↑
- **Definition:** Winning back churned users
- **Source:** `trial_returning_user` in subscription history
- **Current:** ~1,200-2,500/month returning users
- **Very small** relative to monthly churn of 500K+ revocations

---

## 💰 Amazing CAC (Bottom)

- **Source:** `FCT_MARKETING_AD_SPENDS_DAILY` + trial counts
- **⚠️ Ad spend data stops Jun 2025** — can't compute current CAC
- **Historical (through Jun 2025):**
  - Total tracked spend: ₹61.65 Cr (Google ₹53.7 Cr + Facebook ₹7.9 Cr)
  - At ~400-500K trials/month, implied CAC was ~₹120-150 per trial
  - Effective CAC per paying subscriber (~22% conversion): ~₹550-680

---

## 📊 D0 User Behavior Deep Dive (Feb 2026)

**235K trial users on D0:**
| Watch Bucket | Users | % of Total | Avg Watch (min) | Aha % |
|-------------|------:|----------:|:------:|:-----:|
| 0 mins (didn't watch) | 95.6K | 40.7% | 0 | 0.6% |
| 1-5 mins | 19.5K | 8.3% | 2.6 | 2.9% |
| 6-15 mins | 22.9K | 9.7% | 7-12 | 2.5% |
| 16-30 mins | 20.3K | 8.6% | 17-28 | 3.0% |
| 31-60 mins | 21.5K | 9.1% | 32-58 | 3.5% |
| 61-120 mins | 30.2K | 12.8% | 67-110 | 5.0% |
| 120+ mins | 8.4K | 3.6% | 170 | 13.4% |

**Key insight:** 41% of trial users watch ZERO minutes on D0. The aha rate jumps dramatically for users who watch 120+ min (13.4% vs 0.6% for non-watchers).

**Intent buckets:**
- Low intent: ~129K (55%) — mostly 0-10 min watchers
- Medium intent: ~38K (16%) — 11-60 min watchers
- High intent: ~25K (11%) — moderate watchers
- Very high intent: ~22K (9%) — 60+ min heavy watchers

---

## 🔑 Key Relationships & Leverage Points

1. **Content → Trials:** Saanwari alone drives ~60K+ trials across 4 dialects. Finding the next Saanwari is existential.
2. **D0 Watch → Everything:** Users who watch 120+ min on D0 have 13.4% aha rate vs 0.6% for non-watchers. Getting users to watch is THE lever.
3. **Aha → Habit → Renewal:** 4% aha → 3-5% habit → 21-25% mandate survival. Each step has massive drop-off.
4. **Web growing fast:** 37% of Feb trials are web (up from 17% in Dec). Web-to-app install rate is the new bottleneck.
5. **Reactivation is tiny:** Only ~1-2K returning users/month vs 500K churning. The funnel is forward-heavy, almost no win-back.
6. **Dormant HVUs are winnable:** 187K high-value users dormant for avg 28 days with app installed. This is low-hanging fruit.

---

*Model built: 2026-02-18 | Source: STAGE Snowflake (ANALYTICS_PROD)*
