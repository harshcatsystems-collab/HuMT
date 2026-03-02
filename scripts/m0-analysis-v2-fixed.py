#!/usr/bin/env python3
"""
M0 Engagement Analysis v2 — Data Extraction (FIXED)
Uses correct schema and column names from VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
"""

import json
import urllib.request
import sys

API_KEY = "mb_TFdivJ3ePUe5v9xeA77Xphanlq+n0BiKVGXhmT3H1o4="
BASE = "https://stage.metabaseapp.com/api"
DB_ID = 299

def query(sql, timeout=180):
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
                return {"error": "No data in response"}
            cols = [c["name"] for c in result["data"]["cols"]]
            rows = result["data"]["rows"]
            return [dict(zip(cols, row)) for row in rows]
    except Exception as e:
        return {"error": str(e)}

def save_json(data, filename):
    """Save data to JSON file."""
    with open(filename, 'w') as f:
        json.dump(data, f, indent=2)
    print(f"✓ Saved to {filename} ({len(data)} rows)")

# ========== QUERY 1: M0 Baseline Metrics (Jan-Feb 2026) ==========
print("Query 1: M0 Baseline Metrics...")
q1_sql = """
WITH m0_agg AS (
  SELECT 
    user_id,
    MAX(dialect) as dialect,
    SUM(watch_time_min) as total_watch_min,
    COUNT(DISTINCT CASE WHEN watch_time_min > 0 THEN date_from_subscription_start END) as watch_days
  FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
  WHERE subscription_start_date >= '2025-12-01'
    AND subscription_start_date < '2026-03-01'
    AND days_from_subscription_start BETWEEN 0 AND 30
  GROUP BY 1
)
SELECT 
  COUNT(DISTINCT user_id) as total_m0_users,
  COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) as watchers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as watcher_pct,
  COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) as habit_formers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as habit_pct,
  COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_pct,
  ROUND(AVG(CASE WHEN total_watch_min > 0 THEN watch_days END), 2) as avg_watch_days_watchers,
  ROUND(AVG(total_watch_min), 2) as avg_watch_min_all
FROM m0_agg
"""
q1_result = query(q1_sql)
save_json(q1_result, '/tmp/m0_baseline.json')

# ========== QUERY 2: Dialect Breakdown ==========
print("Query 2: Dialect breakdown...")
q2_sql = """
WITH m0_agg AS (
  SELECT 
    user_id,
    MAX(dialect) as dialect,
    SUM(watch_time_min) as total_watch_min,
    COUNT(DISTINCT CASE WHEN watch_time_min > 0 THEN date_from_subscription_start END) as watch_days
  FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
  WHERE subscription_start_date >= '2025-12-01'
    AND subscription_start_date < '2026-03-01'
    AND days_from_subscription_start BETWEEN 0 AND 30
  GROUP BY 1
)
SELECT 
  dialect,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) as watchers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as watcher_pct,
  COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) as habit_formers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as habit_pct,
  COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_pct,
  ROUND(AVG(total_watch_min), 2) as avg_watch_min
FROM m0_agg
GROUP BY 1
ORDER BY total_users DESC
"""
q2_result = query(q2_sql)
save_json(q2_result, '/tmp/m0_by_dialect.json')

# ========== QUERY 3: Channel-Level Breakdown ==========
print("Query 3: Channel-level breakdown...")
q3_sql = """
WITH m0_agg AS (
  SELECT 
    m0.user_id,
    MAX(m0.dialect) as dialect,
    COALESCE(du.acquiring_media_source, 'organic') as channel,
    COALESCE(du.acquiring_channel_name, 'organic') as channel_detail,
    SUM(m0.watch_time_min) as total_watch_min,
    COUNT(DISTINCT CASE WHEN m0.watch_time_min > 0 THEN m0.date_from_subscription_start END) as watch_days
  FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY m0
  LEFT JOIN ANALYTICS_PROD.DBT_CORE.DIM_USERS du ON m0.user_id = du.user_id
  WHERE m0.subscription_start_date >= '2025-12-01'
    AND m0.subscription_start_date < '2026-03-01'
    AND m0.days_from_subscription_start BETWEEN 0 AND 30
  GROUP BY 1, 3, 4
)
SELECT 
  channel,
  channel_detail,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) as watchers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as watcher_pct,
  COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) as habit_formers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as habit_pct,
  COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_pct
FROM m0_agg
GROUP BY 1, 2
ORDER BY total_users DESC
LIMIT 50
"""
q3_result = query(q3_sql, timeout=240)
save_json(q3_result, '/tmp/m0_by_channel.json')

# ========== QUERY 4: Installed Cohort (App-Only) ==========
print("Query 4: Installed cohort analysis...")
q4_sql = """
WITH m0_agg AS (
  SELECT 
    m0.user_id,
    MAX(m0.dialect) as dialect,
    MAX(m0.install_status) as install_status,
    SUM(m0.watch_time_min) as total_watch_min,
    COUNT(DISTINCT CASE WHEN m0.watch_time_min > 0 THEN m0.date_from_subscription_start END) as watch_days
  FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY m0
  WHERE m0.subscription_start_date >= '2025-12-01'
    AND m0.subscription_start_date < '2026-03-01'
    AND m0.days_from_subscription_start BETWEEN 0 AND 30
    AND m0.install_status = 'installed'
  GROUP BY 1
)
SELECT 
  dialect,
  COUNT(DISTINCT user_id) as total_app_users,
  COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) as watchers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as watcher_pct,
  COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) as habit_formers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN watch_days >= 8 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as habit_pct,
  COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_pct
FROM m0_agg
GROUP BY 1
ORDER BY total_app_users DESC
"""
q4_result = query(q4_sql)
save_json(q4_result, '/tmp/m0_installed_only.json')

# ========== QUERY 5: Ghost Rate Trend ==========
print("Query 5: Ghost rate trend...")
q5_sql = """
WITH m0_agg AS (
  SELECT 
    DATE_TRUNC('week', subscription_start_date) as cohort_week,
    user_id,
    SUM(watch_time_min) as total_watch_min
  FROM ANALYTICS_PROD.DBT_VIZ.VIZ_NEW_SUBSCRIBER_M0_WATCH_ACTIVITY
  WHERE subscription_start_date >= '2025-09-01'
    AND subscription_start_date < '2026-03-01'
    AND days_from_subscription_start BETWEEN 0 AND 30
  GROUP BY 1, 2
)
SELECT 
  cohort_week,
  COUNT(DISTINCT user_id) as total_users,
  COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) as ghost_users,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min = 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as ghost_pct,
  COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) as watchers,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN total_watch_min > 0 THEN user_id END) / NULLIF(COUNT(DISTINCT user_id), 0), 2) as watcher_pct
FROM m0_agg
GROUP BY 1
ORDER BY 1 DESC
LIMIT 24
"""
q5_result = query(q5_sql)
save_json(q5_result, '/tmp/m0_ghost_rate_trend.json')

print("\n✅ All queries complete!")
