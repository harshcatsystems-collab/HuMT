#!/usr/bin/env python3
"""
M0 Engagement Analysis v2 — Data Extraction via Metabase/Snowflake
Addresses Vismit Bansal's 5 requirements for deeper segmentation.
"""

import json
import urllib.request
import sys
from datetime import datetime, timedelta

API_KEY = "mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4="
BASE = "https://stage.metabaseapp.com/api"
DB_ID = 299  # Snowflake - Prod

def query(sql, timeout=120):
    """Run SQL against Snowflake via Metabase API."""
    data = json.dumps({"database": DB_ID, "type": "native", "native": {"query": sql}}).encode()
    req = urllib.request.Request(f"{BASE}/dataset", data=data, headers={
        "x-api-key": API_KEY,
        "Content-Type": "application/json"
    })
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            result = json.loads(resp.read())
            if "data" not in result:
                return {"error": "No data in response", "response": result}
            cols = [c["name"] for c in result["data"]["cols"]]
            rows = result["data"]["rows"]
            return [dict(zip(cols, row)) for row in rows]
    except Exception as e:
        return {"error": str(e)}

def save_json(data, filename):
    """Save data to JSON file."""
    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"✓ Saved to {filename}")

# ========== QUERY 1: M0 Baseline Metrics ==========
print("Query 1: M0 Baseline Metrics (last 90 days)...")
q1_sql = """
SELECT 
  COUNT(DISTINCT user_id) as total_m0_users,
  COUNT(DISTINCT CASE WHEN total_watch_time_sec > 0 THEN user_id END) as watchers,
  COUNT(DISTINCT CASE WHEN unique_watch_days >= 8 THEN user_id END) as habit_formers,
  COUNT(DISTINCT CASE WHEN unique_watch_days = 0 THEN user_id END) as ghost_users,
  AVG(CASE WHEN total_watch_time_sec > 0 THEN unique_watch_days END) as avg_watch_days_watchers,
  AVG(total_watch_time_sec / 60.0) as avg_watch_min_all
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
WHERE first_trial_date >= CURRENT_DATE - 90
  AND first_trial_date < CURRENT_DATE - 30
"""
q1_result = query(q1_sql)
save_json(q1_result, '/tmp/m0_baseline.json')

# ========== QUERY 2: Channel-Level Breakdown ==========
print("Query 2: Channel-level breakdown...")
q2_sql = """
SELECT 
  COALESCE(du.ACQUIRING_MEDIA_SOURCE, 'organic') as channel,
  COALESCE(du.ACQUIRING_CHANNEL_NAME, 'organic') as channel_detail,
  COUNT(DISTINCT wa.user_id) as total_users,
  COUNT(DISTINCT CASE WHEN wa.total_watch_time_sec > 0 THEN wa.user_id END) as watchers,
  COUNT(DISTINCT CASE WHEN wa.unique_watch_days >= 8 THEN wa.user_id END) as habit_formers,
  COUNT(DISTINCT CASE WHEN wa.unique_watch_days = 0 THEN wa.user_id END) as ghost_users,
  AVG(wa.total_watch_time_sec / 60.0) as avg_watch_min
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY wa
LEFT JOIN ANALYTICS_PROD.DBT_CORE.DIM_USERS du ON wa.user_id = du.user_id
WHERE wa.first_trial_date >= CURRENT_DATE - 90
  AND wa.first_trial_date < CURRENT_DATE - 30
GROUP BY 1, 2
ORDER BY total_users DESC
"""
q2_result = query(q2_sql)
save_json(q2_result, '/tmp/m0_by_channel.json')

# ========== QUERY 3: High-Intent vs Low-Intent ==========
print("Query 3: Intent segmentation...")
q3_sql = """
SELECT 
  CASE 
    WHEN fsh.subscription_user_type = 'direct_autopay_user' THEN 'high_intent_direct_sub'
    WHEN fsh.subscription_user_type = 'trial_autopay_user' AND fsh.platform IN ('android', 'ios') THEN 'medium_intent_app_trial'
    WHEN fsh.subscription_user_type = 'trial_autopay_user' AND fsh.platform = 'web' THEN 'low_intent_web_trial'
    WHEN du.acquiring_channel_name ILIKE '%search%' THEN 'medium_intent_search'
    WHEN du.acquiring_channel_name ILIKE '%organic%' OR du.acquiring_media_source IS NULL THEN 'high_intent_organic'
    WHEN du.acquiring_channel_name ILIKE '%display%' OR du.acquiring_channel_name ILIKE '%uac%' THEN 'low_intent_display'
    ELSE 'medium_intent_other'
  END as intent_bucket,
  COUNT(DISTINCT wa.user_id) as total_users,
  COUNT(DISTINCT CASE WHEN wa.total_watch_time_sec > 0 THEN wa.user_id END) as watchers,
  COUNT(DISTINCT CASE WHEN wa.unique_watch_days >= 8 THEN wa.user_id END) as habit_formers,
  AVG(wa.unique_watch_days) as avg_watch_days,
  AVG(wa.total_watch_time_sec / 60.0) as avg_watch_min
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY wa
LEFT JOIN ANALYTICS_PROD.DBT_CORE.DIM_USERS du ON wa.user_id = du.user_id
LEFT JOIN ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY fsh 
  ON wa.user_id = fsh.user_id 
  AND fsh.plan_category = 'Trial'
  AND fsh.created_at_ist::date = wa.first_trial_date
WHERE wa.first_trial_date >= CURRENT_DATE - 90
  AND wa.first_trial_date < CURRENT_DATE - 30
GROUP BY 1
ORDER BY total_users DESC
"""
q3_result = query(q3_sql, timeout=180)
save_json(q3_result, '/tmp/m0_by_intent.json')

# ========== QUERY 4: Installed Cohort (App-Only) ==========
print("Query 4: Installed cohort analysis...")
q4_sql = """
SELECT 
  wa.dialect,
  COUNT(DISTINCT wa.user_id) as total_app_users,
  COUNT(DISTINCT CASE WHEN wa.total_watch_time_sec > 0 THEN wa.user_id END) as watchers,
  COUNT(DISTINCT CASE WHEN wa.unique_watch_days >= 8 THEN wa.user_id END) as habit_formers,
  COUNT(DISTINCT CASE WHEN wa.unique_watch_days = 0 THEN wa.user_id END) as ghost_users,
  AVG(wa.total_watch_time_sec / 60.0) as avg_watch_min
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY wa
LEFT JOIN ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY fsh 
  ON wa.user_id = fsh.user_id 
  AND fsh.plan_category = 'Trial'
  AND fsh.created_at_ist::date = wa.first_trial_date
WHERE wa.first_trial_date >= CURRENT_DATE - 90
  AND wa.first_trial_date < CURRENT_DATE - 30
  AND fsh.platform IN ('android', 'ios')
GROUP BY 1
ORDER BY total_app_users DESC
"""
q4_result = query(q4_sql)
save_json(q4_result, '/tmp/m0_installed_only.json')

# ========== QUERY 5: Dialect Breakdown ==========
print("Query 5: Dialect-level metrics...")
q5_sql = """
SELECT 
  dialect,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN total_watch_time_sec > 0 THEN user_id END) as watchers,
  COUNT(DISTINCT CASE WHEN unique_watch_days >= 8 THEN user_id END) as habit_formers,
  COUNT(DISTINCT CASE WHEN unique_watch_days = 0 THEN user_id END) as ghost_users,
  AVG(CASE WHEN total_watch_time_sec > 0 THEN unique_watch_days END) as avg_watch_days_watchers,
  AVG(total_watch_time_sec / 60.0) as avg_watch_min
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
WHERE first_trial_date >= CURRENT_DATE - 90
  AND first_trial_date < CURRENT_DATE - 30
GROUP BY 1
ORDER BY total_users DESC
"""
q5_result = query(q5_sql)
save_json(q5_result, '/tmp/m0_by_dialect.json')

# ========== QUERY 6: Temporal Trend (Ghost Rate Over Time) ==========
print("Query 6: Ghost rate trend analysis...")
q6_sql = """
SELECT 
  DATE_TRUNC('week', first_trial_date) as cohort_week,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN unique_watch_days = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN unique_watch_days = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_rate_pct
FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
WHERE first_trial_date >= CURRENT_DATE - 180
  AND first_trial_date < CURRENT_DATE - 30
GROUP BY 1
ORDER BY 1 DESC
LIMIT 24
"""
q6_result = query(q6_sql)
save_json(q6_result, '/tmp/m0_ghost_rate_trend.json')

print("\n✅ All queries complete. Data files saved to /tmp/")
print("Files created:")
print("  - /tmp/m0_baseline.json")
print("  - /tmp/m0_by_channel.json")
print("  - /tmp/m0_by_intent.json")
print("  - /tmp/m0_installed_only.json")
print("  - /tmp/m0_by_dialect.json")
print("  - /tmp/m0_ghost_rate_trend.json")
