# Manasvi's Work vs Live Dashboard — Alignment Analysis
**Date:** February 19, 2026  
**Dashboard:** #4699 — ML Widget vs Non-ML Widget (Thumbnail → Playback Funnel)  
**Data Sources:** Metabase API (live), Manasvi's Feed PRD, Brainstorming Numbers, HP Personalisation Gemini Notes (Feb 19)

---

## Dashboard Overview

Dashboard #4699 tracks the **Thumbnail Viewed → Playback conversion** funnel, comparing ML-powered widget ranking against static (Non-ML) widgets. Two views:
1. **Real content only** (excl. trailers, CONTENT_ID ≠ 0)
2. **All playback** (incl. trailers, CONTENT_ID = 0)

Data available up to: **19 Feb 2026, 17:42 IST**

---

## Live Data Summary (Feb 19, 2026)

| Metric | ML Widget | Non-ML Widget | Delta |
|--------|-----------|---------------|-------|
| **Real Content Conversion** | **64.1%** | 52.1% | **+12pp** |
| **Any Playback Conversion** (incl trailers) | **91.4%** | 78.6% | **+12.8pp** |
| Thumbnail Viewers | 2,663 | 34,788 | — |
| Real Content Players | 1,707 | 18,123 | — |

### Non-ML Baseline Trend (Jan 26 → Feb 19)

| Period | Avg Real Content Conversion (Non-ML) |
|--------|--------------------------------------|
| Jan 26–31 | ~49.1% |
| Feb 1–7 | ~50.8% |
| Feb 8–14 | ~51.8% |
| Feb 15–19 | ~51.5% |

Baseline has been flat at 50-52% throughout. No organic lift — confirming static feeds plateau.

### ML Widget Ramp-Up

| Date | ML Viewers | ML Conversion (Real Content) | ML Conversion (Any Playback) |
|------|-----------|------------------------------|------------------------------|
| Feb 18 | 9 | 55.6% | 77.8% |
| Feb 19 | 2,663 | 64.1% | 91.4% |

ML Widget went live Feb 18 (soft launch), ramping to ~2,663 viewers on Feb 19 (~7% of total).

---

## Alignment with Manasvi's Work

### ✅ Strongly Aligned

**1. Core Hypothesis Validated**

Manasvi's brainstorming doc (Jan 22) identified the key problem: the "Special for you" tray had a **0.27% CTR — essentially broken**. Her recommendation was to replace static popularity-based widgets with personalized, ML-driven ranking.

Dashboard result: **+12pp conversion lift** on Day 2 of ML Widget. Her hypothesis is being validated.

**2. Phased Approach Playing Out**

Her PRD (Jan 27) laid out a clear progression:
- Epic 1: Rule-based contextual ranking (no ML)
- Epic 2: Simple collaborative filtering ("Because You Watched")
- Epic 3: ML-based evolving system (auto-decides tray/title ordering)

The "ML Widget" in the dashboard represents Epic 2/3 going live. The flat Non-ML baseline confirms her prediction that static feeds plateau.

**3. Continue Watching Results Corroborate**

From the Feb 19 HP Personalisation meeting:
- Continue Watching notifications showed **2x D1 retention lift**
- D3: 13% vs 5% (control), D7: 8% vs 3% (control)
- +9 minutes absolute watch time increase
- Scaled on Jan 26

Looking at the Non-ML baseline: slight uptick from ~49% (late Jan) to ~51-52% (Feb) could partly reflect the notification flow driving users back → higher thumbnail-to-playback conversion.

**4. Data Analysis Quality**

Manasvi's brainstorming doc contained extensive Snowflake analysis:
- Subscription distribution by dialect (599K Bhojpuri trials, 388K Haryanvi, 399K Rajasthani)
- Trial watch depth: 8-12% "No Watch" problem (52K users/month)
- Cross-dialect consumption: 25-37% watch outside registered dialect
- RFD segmentation: 68% of active subscribers have no watch activity in 30 days
- Celebrity endorsement trays 5x higher CTR than "Special for you"
- Time-of-day patterns: short-form daytime, movies nighttime

All of this informed the ML Widget strategy and the Limited HP MVP design.

---

### ⚠️ Gaps / Questions to Investigate

**1. ML Widget Volume Is Small (~7%)**

- Feb 19: 2,663 ML viewers vs 34,788 Non-ML
- Manasvi mentioned a **10% user pool test** for the Limited HP MVP
- Current split is ~7%, not 10% — either ramp isn't complete or targeting is narrower than planned
- Need 3-5 more days for statistical confidence

**2. Which Test Is This Dashboard Tracking?**

Manasvi launched **two distinct experiments** this week:

| Experiment | What It Does | Target Users |
|-----------|--------------|--------------|
| **Limited HP MVP** | Stripped-down homepage (3 rails only) for first 3 impressions | M0 users with <2 completed titles |
| **ML Widget Ranking** | ML-ranked content within individual widgets | Broader user base |

Dashboard #4699 is labeled "ML Widget vs Non-ML Widget" — sounds like **widget-level ML ranking**, not the Limited HP layout test. These are different experiments measuring different things.

**Need to confirm:** Is dashboard #4699 tracking the widget-level ML ranking, the Limited HP layout, or a blend?

**3. 0.8% Notification CTR Concern**

Manasvi flagged that Continue Watching notification CTR is only 0.8% and recommended limiting to 10-20% of users to avoid notification fatigue. This is a **separate surface** (push notifications) from the homepage funnel (dashboard #4699), but they're related levers in the same pipeline.

**4. Missing: Cohort-Level Breakdown**

Manasvi's most valuable analytical work was the **cohort-level segmentation**:
- Trial No-Watch: 14.5% of trials
- Trial Single Title: 13.3%
- M0 subscribers: 68% no activity in 30 days
- Champions vs Browsers vs Lapsed

Dashboard #4699 shows **aggregate** ML vs Non-ML only. The ML Widget might be working great for Champions but poorly for No-Watch users, and we can't tell from this view.

**Recommendation:** Request a cohort-segmented version of this dashboard from the data team.

---

## Summary Scorecard

| Dimension | Alignment | Notes |
|-----------|-----------|-------|
| Core hypothesis (personalization > static) | ✅ Strong | +12pp conversion lift confirms thesis |
| Phased approach (rules → ML) | ✅ Strong | Dashboard shows ML phase going live |
| Continue Watching impact | ✅ Directional | Slight baseline improvement post Jan-26 launch |
| Data analysis quality | ✅ Strong | Comprehensive Snowflake analysis, solid cohort definitions |
| Test population (10% target) | ⚠️ Check | Only ~7% currently in ML widget |
| Which experiment is this? | ⚠️ Unclear | Limited HP MVP vs ML Widget — need disambiguation |
| Cohort-level visibility | ❌ Missing | Dashboard is aggregate only |
| Notification CTR concern | ➡️ Separate | Different surface, related pipeline |

---

## Bottom Line

Manasvi's analytical work and PRD framework are **solid and validated by live data**. The +12pp lift on Day 2 of ML Widget is a strong early signal. Her brainstorming doc's insights (cross-dialect behavior, cohort segmentation, tray CTR analysis) directly informed the experiments now showing results.

**Caveats:**
- Volume is still small (~7% of viewers) — needs 3-5 more days
- Need to disambiguate which experiment the dashboard tracks
- Cohort-level dashboard needed to confirm impact isn't skewed by user selection bias (ML Widget users might over-represent engaged cohorts)

---

*Analysis by HuMT | Data pulled via Metabase API (key: humt-bot) | Feb 19, 2026*
