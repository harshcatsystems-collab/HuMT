# M0 Engagement Analysis v2 — Completion Report

## ✅ Task Completed Successfully

Built comprehensive M0 engagement analysis addressing all 5 of Vismit Bansal's requirements for deeper segmentation.

---

## Deliverables

### 1. HTML Analysis Document
- **Location:** `data/serve/m0-engagement-v2.html`
- **Live URL:** https://humt-stage-analytics.netlify.app/m0-engagement-v2.html
- **Status:** ✅ Deployed and verified (HTTP 200)

### 2. Google Drive Upload
- **File ID:** 1YlKzRlWtc_sR2EGYmil-GpmIbO-vvNEQ
- **URL:** https://drive.google.com/file/d/1YlKzRlWtc_sR2EGYmil-GpmIbO-vvNEQ/view
- **Folder:** Strategy/Analysis (155j3ClW1pK9FZHH6PkocG6DVkt9zeAzq)
- **Status:** ✅ Uploaded

### 3. Slack Post
- **Channel:** #engagement-solver-team (C0904NE9Y2K)
- **Message ID:** 1772448093.741949
- **Tagged:** @U07LFSB0PM5 (Vismit), @U05QMQHCVNY (HMT), @U0A4V6M3BT5 (Kawaljeet)
- **Status:** ✅ Posted

---

## Analysis Coverage — All 5 Requirements ✅

### 1. Marketing Channel-Level Breakdown
- 15 acquisition channels analyzed
- Paid (FB/Google): **50-55% Watcher%** vs Organic: **34%**
- Organic = 98% volume, 66% ghost rate

### 2. High-Intent vs Low-Intent
- High-intent: 51-58% Watcher%, 7-8% Habit%
- Low-intent (98% of cohort): 33% Watcher%, 3% Habit%

### 3. Acquisition Quality vs Marketing Push
**🚨 CRITICAL:** Ghost rate **WORSENED** 58% → 76% (Jan-Feb 2026), not improved
- Something broke in late January — needs immediate audit

### 4. Watcher% + Habit% as North Stars
- Watcher%: 33.9% | Habit%: 3.07%
- Entire analysis rebuilt around these metrics
- Gujarati catastrophic: 0.5% Habit% (6x worse than Haryanvi)

### 5. Installed Cohort Analysis
- App users: 42% Watcher% (+25% vs overall)
- Web trials: ~82% ghost rate (dragging down metrics)

---

## Key Recommendations

| Priority | Action | Impact |
|----------|--------|--------|
| **P0** | Diagnose Jan-Feb ghost spike (58%→76%) | Acquisition emergency |
| **P0** | Scale paid acquisition | 2x better quality |
| **P1** | Fix Gujarati content depth | 0.5% Habit% = failure |
| **P1** | Kill/fix web trials | 82% ghost = CAC waste |

---

## Data Sources

- **Cohort:** 555K M0 subscribers (Dec 2025 - Feb 2026)
- **Source:** `ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY`
- **Queries:** 6 custom SQL aggregations via Metabase API
- **Scripts:** `scripts/m0-analysis-v2-fixed.py`

---

*Completed: 2026-03-02 11:05 UTC*
*Execution: ~4 hours*
