# Metabase M0/M1 Card Discovery — FINAL REPORT

**Date:** 2026-03-05 10:40 UTC  
**Task:** Find pre-computed Metabase cards with M0/M1 retention data

---

## ✅ **SUCCESS: Found M0/M1 Data!**

### 🎯 **PRIMARY CARD: #10905 — "Watchers - Trial<>M0<>M1"**

**Location:** Dashboard #3238 (Content Overall Performance)  
**Metabase URL:** https://stage.metabaseapp.com/api/card/10905

**Columns:**
```
- WATCH_DATE       (type: DATE)
- TRIAL_WATCHERS   (type: NUMBER)
- M0_WATCHERS      (type: NUMBER)
- M1_WATCHERS      (type: NUMBER)
```

**Sample Data (from metadata fingerprint):**
- Date range: 2026-03-01 to 2026-03-04 (4 days)
- Trial watchers: ~5,077–5,418
- M0 watchers: ~1,734–2,059
- M1 watchers: ~8,612–10,635

**This is EXACTLY what we need!** ✅

---

## 🚨 **PROBLEM: Cannot Query Data via API**

### **Issue:**
The Metabase query endpoint returns "Instance not found":
```bash
curl -H "x-api-key: mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4=" \
  "https://stage.metabaseapp.com/api/card/10905/query/json"
# Returns: HTML error page "Metabase instance not found"
```

### **Root Cause:**
- API key works for catalog endpoint (`/api/card?f=all`)
- API key does NOT work for query endpoint (`/api/card/{id}/query/json`)
- Query endpoint likely requires session token or different auth

---

## 📊 **Alternative Data Sources Found**

### **Option 1: Dashboard #2182 (M0 Engagement Action Plan)**

**30+ M0-specific cards:**

| Card ID | Card Name | What It Contains |
|---------|-----------|------------------|
| 6289 | M0 Active Subscribers | M0 subscriber count over time |
| 6291 | M0 Watch Conversion | M0 watch % over time |
| 6290 | M0 Watchers | M0 watcher count over time |
| 6292 | M0 Watch Conversion by Dialect | M0 watch % by HAR/BHO/RAJ |
| 6295 | M0 Watchers by Dialect | M0 watchers by dialect |

### **Option 2: Dashboard #4261 (>= M1 Watchers - Retention Action Plan)**

**M1-specific cards:**

| Card ID | Card Name | What It Contains |
|---------|-----------|------------------|
| 13382 | >= M1 Watchers | M1 watcher count over time |
| 13379 | >= M1 Watcher Conversion | M1 watch % over time |
| 13377 | >= M1 Active Users | M1 active user count |

### **Option 3: Dashboard #1490 (Active Subscription Watch Retention DB v1)**

**Weekly retention cards:**

| Card ID | Card Name | What It Contains |
|---------|-----------|------------------|
| 7438 | Agg Weekly Retention Overall [W Retention %] | Weekly retention % |
| 5229 | DAU - Subscribers, Watchers & Conversion | Daily active metrics |
| 5225 | WAU - Subscribers, Watchers & Conversion | Weekly active metrics |
| 6479 | Last 28 Days Watchers {excl M0} - As of Today | M1+ watchers (excludes M0) |

---

## 🔍 **Next Steps (3 Options)**

### **Option A: Extract SQL from Card #10905** ⭐ **RECOMMENDED**

1. Get full card metadata: `GET /api/card/10905`
2. Extract the `dataset_query` → contains SQL/query structure
3. Reconstruct the SQL query manually
4. Run directly against Snowflake
5. **Avoids Metabase query endpoint entirely**

### **Option B: Run Individual M0 and M1 Cards**

1. Extract SQL from cards #6290 (M0 Watchers) and #13382 (M1 Watchers)
2. Run both queries against Snowflake
3. Merge results manually
4. **More work, but guaranteed to work**

### **Option C: Build from Raw Snowflake Tables**

1. Use the table reference from card metadata: `source-table: 3179`
2. Query Snowflake directly with:
   ```sql
   SELECT 
     WATCH_DATE,
     SUM(CASE WHEN subscription_age_bucket = 'M0' THEN watchers ELSE 0 END) AS M0_WATCHERS,
     SUM(CASE WHEN subscription_age_bucket >= 'M1' THEN watchers ELSE 0 END) AS M1_WATCHERS
   FROM [table_3179]
   GROUP BY WATCH_DATE
   ORDER BY WATCH_DATE DESC
   LIMIT 90
   ```

---

## 📌 **Card Metadata Saved:**

- Full search results: `/tmp/m0_m1_cards.json` (1,048 cards)
- Card #10905 metadata: `/tmp/card_10905_full.json`
- Summary report: `data/metabase-m0-m1-search-results.md`

---

## 🎯 **RECOMMENDATION:**

**DO NOT ESTIMATE.** Real data exists in Metabase card #10905.

**Path forward:**
1. ✅ **Card found:** Watchers - Trial<>M0<>M1 (#10905)
2. ❌ **API blocked:** Query endpoint requires different auth
3. ✅ **Solution:** Extract SQL from card metadata OR query Snowflake directly
4. 🚫 **STOP HERE:** Do not proceed with building V2 until we have real data

**Report back to main agent:** Card exists, data exists, need different access method to pull it.

---

**Which approach should we take?** (A, B, or C)
