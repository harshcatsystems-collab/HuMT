# Metabase M0/M1 Card Search Results

**Date:** 2026-03-05 10:30 UTC  
**Task:** Find pre-computed cards with M0/M1 retention data

---

## Summary

✅ **FOUND:** Pre-computed cards with M0/M1 data exist in Metabase  
📊 **Total cards matching M0/M1/retention/watch:** 1,048 cards  
🎯 **Key dashboards:**
- Dashboard #1490: Active Subscription Watch Retention DB v1 (111 cards)
- Dashboard #2182: M0 Engagement Action Plan (111 cards)
- Dashboard #4261: >= M1 Watchers - Retention Action Plan
- Dashboard #3238: Content Overall Performance
- Dashboard #3700: Content Overall Performance (duplicate)

---

## 🔥 **HIGH-VALUE CARDS: M0 vs M1 Comparison**

### **Card #10905 & #11170: Watchers - Trial<>M0<>M1**

- **Location:** Dashboard #3238 (Content Overall Performance) and #3700
- **Description:** Breakdown of watchers by Trial / M0 / M1 status
- **This is EXACTLY what we need** ✅

### **Dashboard #4261: >= M1 Watchers - Retention Action Plan**

Contains M1-specific retention cards:
- #13377: >= M1 Active Users
- #13379: >= M1 Watcher Conversion
- #13382: >= M1 Watchers (+ absolutes)

---

## 🎯 **Dashboard #2182: M0 Engagement Action Plan**

**30+ M0-specific cards**, including:

| Card ID | Card Name | Description |
|---------|-----------|-------------|
| 6289 | M0 Active Subscribers | Total M0 users |
| 6291 | M0 Watch Conversion | M0 watch % |
| 6292 | M0 Watch Conversion by Dialect | M0 watch % (HAR/BHO/RAJ) |
| 6290 | M0 Watchers | M0 watchers count |
| 6295 | M0 Watchers by Dialect | M0 watchers by dialect |
| 6297 | M0 Watchers - Active Watch Days per Watching User | Engagement depth |
| 12683 | Har M0 Watchers - First Playback Channel | Haryanvi M0 watchers |
| 14336 | Bho M0 Watchers - First Playback Channel | Bhojpuri M0 watchers |

---

## 🎯 **Dashboard #1490: Active Subscription Watch Retention DB v1**

**Weekly retention cards** (likely broken down by subscription age):

| Card ID | Card Name | Type |
|---------|-----------|------|
| 7470 | Agg Monthly Retention Overall [W Retention %] | Retention |
| 7438 | Agg Weekly Retention Overall [W Retention %] | Retention |
| 6017 | Daily Trial Watchers by Trial Age | Trial engagement |
| 5229 | DAU - Subscribers, Watchers & Conversion | Daily active |
| 5225 | WAU - Subscribers, Watchers & Conversion | Weekly active |
| 6479 | Last 28 Days Watchers {excl M0} - As of Today | M1+ users |

---

## ❌ **What's MISSING:**

- **No direct "M0 vs M1 weekly retention" card found**
- M0 and M1 data exist in **separate cards** across different dashboards
- Need to check if **card #10905** has M0/M1 breakdown in time series

---

## 🔍 **Next Steps:**

1. **Fetch data from card #10905 (Watchers - Trial<>M0<>M1)** ← PRIMARY TARGET
2. Check if it has weekly time series breakdown
3. If yes → use this data for V2
4. If no → combine:
   - M0 cards from Dashboard #2182
   - M1 cards from Dashboard #4261
   - Build comparison manually

---

## 📂 **Full Search Results:**

Saved 1,048 matching cards to: `/tmp/m0_m1_cards.json`

**Filter criteria:**
- Searched for: `M0|M1|retention|watch` (case-insensitive)
- Focused on dashboards: #1490, #2182, #4261, #3238, #3700

---

## 🚨 **API Access Note:**

- Card catalog endpoint works: `GET /api/card?f=all`
- Card query endpoint returns "Instance not found" error
- May need different auth method or session token
- **Alternative:** Extract SQL from `dataset_query` and run via Snowflake directly

---

**Recommendation:** Proceed with card #10905 metadata inspection to confirm M0/M1 breakdown structure.
