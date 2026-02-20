# Snowflake Deep Analysis — STAGE Retention & Content ROI

> **Queried:** 2026-02-20 | **Source:** ANALYTICS_PROD (Snowflake) via Metabase API
> **Scope:** Jun 2025 – Feb 2026

---

## 1. M0 Cohort Metrics: New Subscribers Who Watch 0 Titles in Month 0

**The core finding: ~60-66% of new paid subscribers never watch anything in their first 30 days.**

| Cohort Month | New Subs | Watched in M0 | Watch % | **Zero-Watch %** |
|:------------|--------:|:------------:|-------:|:---------------:|
| Jun 2025 | 104,225 | 35,438 | 34.0% | **66.0%** |
| Jul 2025 | 99,928 | 38,275 | 38.3% | **61.7%** |
| Aug 2025 | 116,090 | 49,501 | 42.6% | **57.4%** |
| Sep 2025 | 212,321 | 74,352 | 35.0% | **65.0%** |
| Oct 2025 | 226,071 | 84,808 | 37.5% | **62.5%** |
| Nov 2025 | 187,849 | 73,051 | 38.9% | **61.1%** |
| Dec 2025 | 189,847 | 73,592 | 38.8% | **61.2%** |
| Jan 2026 | 198,354 | 70,385 | 35.5% | **64.5%** |

### Key Insights:
- **Steady-state zero-watch rate: ~61-65%.** This has NOT improved over 8 months.
- Aug 2025 was the best month (57.4% zero-watch) — smaller, higher-quality cohort (116K vs 200K+ in later months).
- **When volume goes up (Sep: 212K, Oct: 226K), quality drops.** Suggests paid acquisition is bringing in low-intent users.
- Jan 2026 regression to 64.5% despite 198K subs is concerning — quality degrading even at moderate volume.

### What This Means:
For every 200K new paid subscribers, ~128K never open a single piece of content. At ~₹199/quarter average, that's ₹2.5 Cr/month in subscriptions from users who are overwhelmingly likely to churn at first renewal. **The #1 lever for STAGE is getting M0 watch rate above 50%.**

---

## 2. D0 Metrics: Day-0 Trial User Engagement

### 2a. D0 Activity Rate (from FCT_USER_ENGAGEMENT)

| Trial Month | Trials | Active D0 | D0 Active % | Avg Pulses (active users) |
|:-----------|------:|:---------:|:----------:|:------------------------:|
| Aug 2025 | 289,358 | 192,919 | 66.7% | 633 |
| Sep 2025 | 557,440 | 365,726 | 65.6% | 637 |
| Oct 2025 | 463,891 | 293,550 | 63.3% | 635 |
| Nov 2025 | 407,838 | 247,600 | 60.7% | 648 |
| Dec 2025 | 516,389 | 300,135 | 58.1% | 680 |
| Jan 2026 | 489,436 | 285,010 | 58.2% | 645 |
| Feb 2026 (MTD) | 266,557 | 128,791 | 48.3% | 662 |

**D0 activity is declining:** From 66.7% (Aug) → 58.2% (Jan) → 48.3% (Feb MTD). This is a **crisis-level trend.** One-third of trial users don't even open the app on their trial start day.

### 2b. D0 User Buckets (from D0_USER_BUCKETS — includes app opens, not just watch)

| Trial Month | Total | Active D0 | Active % | Aha D0 | Aha % | Zero-Watch D0 |
|:-----------|------:|:---------:|:-------:|------:|:----:|:------------:|
| Aug 2025 | 289,304 | 242,237 | 83.7% | 25,635 | 8.9% | 54,894 |
| Sep 2025 | 557,344 | 472,505 | 84.8% | 29,133 | 5.2% | 97,363 |
| Oct 2025 | 463,813 | 397,134 | 85.6% | 23,370 | 5.0% | 75,071 |
| Nov 2025 | 407,711 | 355,392 | 87.2% | 21,193 | 5.2% | 59,120 |
| Dec 2025 | 516,029 | 447,394 | 86.7% | 33,362 | 6.5% | 75,561 |
| Jan 2026 | 489,100 | 391,994 | 80.1% | 27,295 | 5.6% | 105,072 |
| Feb 2026 | 260,266 | 177,881 | 68.3% | 8,526 | 3.3% | 85,652 |

**Note:** The D0_USER_BUCKETS table shows higher "active" rates (~80-87%) than engagement data (~58-67%). Likely because it counts app opens, not just playback. The gap = users who open the app but don't watch.

### 2c. D0 Watch Time Distribution (Nov 2025 – Jan 2026 combined)

| Watch Bucket | Nov 2025 | Dec 2025 | Jan 2026 |
|:------------|--------:|--------:|--------:|
| 0 mins | 90,358 (22%) | 113,186 (22%) | 148,915 (30%) |
| 1-10 mins | 69,707 (17%) | 85,684 (17%) | 79,181 (16%) |
| 11-30 mins | 71,492 (18%) | 92,334 (18%) | 76,409 (16%) |
| 31-60 mins | 57,787 (14%) | 71,310 (14%) | 57,494 (12%) |
| 61-120 mins | 92,863 (23%) | 119,642 (23%) | 95,946 (20%) |
| 120+ mins | 14,103 (3%) | 21,661 (4%) | 21,155 (4%) |

**Bimodal distribution:** Users either don't watch at all OR watch 60+ minutes. The "casual browsing" cohort (1-30 min) is smaller than the "binge" cohort (60+ min). This confirms that when users find content they like, they binge hard.

### 2d. D0 Intent Buckets

| Trial Month | Low | Medium | High | Very High |
|:-----------|----:|------:|----:|--------:|
| Oct 2025 | 209K (45%) | 157K (34%) | 59K (13%) | 38K (8%) |
| Nov 2025 | 175K (43%) | 140K (34%) | 56K (14%) | 37K (9%) |
| Dec 2025 | 215K (42%) | 170K (33%) | 76K (15%) | 55K (11%) |
| Jan 2026 | 234K (48%) | 126K (26%) | 71K (14%) | 58K (12%) |
| Feb 2026 | 145K (56%) | 56K (22%) | 33K (13%) | 26K (10%) |

**Low intent is growing:** From 42-45% → 48% (Jan) → 56% (Feb). This correlates directly with the declining D0 active rate. **Feb 2026 has the worst intent mix ever recorded.**

---

## 3. Content ROI Analysis

### 3a. Top Shows Driving Trial Acquisitions (Oct 2025 – Jan 2026)

| Show | Dialect | Trials Acquired |
|:-----|:-------|:--------------:|
| Saanwari | Rajasthani | 308,964 |
| Saanwari | Bhojpuri | 265,413 |
| Jholachhap | Bhojpuri | 248,217 |
| Saanwari | Haryanvi | 214,285 |
| Others (aggregated) | Bhojpuri | 199,704 |
| Others (aggregated) | Haryanvi | 181,441 |
| Others (aggregated) | Rajasthani | 138,290 |
| Chakka Jaam | Rajasthani | 29,822 |
| Husband on Sale (Microdrama) | Haryanvi | 20,834 |
| Mokhan Vahini 2 | Rajasthani | 13,152 |
| Bhairavi | Rajasthani | 12,667 |
| Crorepati Biwi Ka Raaz (Microdrama) | Haryanvi | 10,177 |

**Saanwari dominates:** Across 3 dialects, it drove 788K+ trials. This is a franchise-level property.

### 3b. Content Retention ROI: Which Shows Keep Users Subscribed?

Shows watched in M0 (Oct-Dec 2025 new subs) vs. mandate still active today:

| Show | Dialect | M0 Viewers | Still Active | **Retention %** |
|:-----|:-------|:---------:|:----------:|:--------------:|
| प्रेम कबूतर (Prem Kabutar) | Haryanvi | 294 | 11 | **3.7%** |
| 1600 मीटर | Haryanvi | 224 | 6 | **2.7%** |
| राखी रो कवच (Rakhi Ro Kavach) | Rajasthani | 221 | 5 | **2.3%** |
| Akhada Phir Se | Haryanvi | 298 | 7 | **2.3%** |
| Mayajaal | Haryanvi | 265 | 6 | **2.3%** |
| बेरोज़गार इंजीनियर | Rajasthani | 222 | 5 | **2.3%** |
| धाकड़ छोरियां | Haryanvi | 820 | 18 | **2.2%** |
| मुंहनोचणी | Haryanvi | 451 | 10 | **2.2%** |
| अखाड़ा (Akhada) | Haryanvi | 1,664 | 33 | **2.0%** |
| पुनर्जन्म (Punarjanam) | Haryanvi | 3,645 | 70 | **1.9%** |
| मायाजाल (Mayajaal) | Haryanvi | 1,096 | 21 | **1.9%** |
| बजरी माफिया | Haryanvi | 906 | 16 | **1.8%** |
| क्राइम हरियाणा | Haryanvi | 712 | 13 | **1.8%** |
| अखाड़ा फिर से | Haryanvi | 2,606 | 43 | **1.7%** |

**Absolute retention is extremely low** (1.7-3.7%). But the relative ranking reveals:
- **Haryanvi content has the best retention** (most of the top 15 are Haryanvi)
- **Akhada franchise** (Akhada + Akhada Phir Se): 4,568 viewers, 83 retained = decent at scale
- **Punarjanam** (Mahapunarjanam): 3,645 viewers at 1.9% = highest absolute retention count (70 users)
- **Small niche shows** (Prem Kabutar, 1600 Meter) retain better percentage-wise but small scale

### 3c. Key Content Insight

The gap between "content that drives trials" and "content that retains" is enormous:
- **Saanwari** = trial acquisition machine (788K trials) but not in the top retention list
- **Akhada franchise** = moderate acquisition, best retention at scale
- **Microdramas** (Husband on Sale, Crorepati Biwi Ka Raaz) drive trials but don't appear in retention rankings

**Implication:** STAGE needs different content strategies for acquisition vs. retention. Current strategy is acquisition-optimized (Saanwari, microdramas for ads). Retention requires deeper, franchise-style content (Akhada, Punarjanam).

---

## 4. Summary: The Three Biggest Problems

### Problem 1: 60-65% of New Paid Subscribers Never Watch Anything
- This is the single biggest retention lever
- The onboarding flow after payment needs a complete rethink
- Push notifications, D0 content recommendations, and "start watching" nudges could move this

### Problem 2: D0 Trial Engagement Is Declining (67% → 48%)
- Feb 2026 is the worst month on record for D0 engagement
- 56% of Feb trial users show "low intent" on D0
- Correlates with scaling volume — more aggressive acquisition = lower quality
- The 1-day trial experiment (50/50 split) may improve this by forcing faster engagement

### Problem 3: Content-Retention Gap
- Shows that drive trials ≠ shows that retain users
- Haryanvi content retains best; needs more investment in franchise content
- Current ad strategy (microdramas) is optimized for top-of-funnel, not retention
- Need a "second show" strategy — after users finish their acquisition show, what's next?

---

## 5. Data Quality Notes

- FCT_USER_ENGAGEMENT only has 7 columns (app opens, pulses, thumbnails) — no direct watch time
- FCT_USER_CONTENT_WATCH_DAILY has WATCHED_TIME_SEC — the real watch metric
- D0_USER_BUCKETS (DBT_VIZ) is the best pre-computed table for trial D0 analysis
- VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY has day-by-day M0 data (169M rows)
- Mandate retention measured via DIM_MANDATES_SCD.CURRENT_STATUS = 'mandate_active'
- Content attribution via AGG_TRIAL_COUNTS_BY_CONTENT (uses FINAL_SHOW_SLUG)

---

*Analysis by HuMT | Data from ANALYTICS_PROD.DBT_CORE + DBT_VIZ + DBT_MARTS*
