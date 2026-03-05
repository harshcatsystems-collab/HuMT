-- Simplified Weekly Watch Retention with M0/M1 Segmentation
-- Breaks complex query into simpler steps for execution

-- STEP 1: Get weekly watchers with cohort classification
WITH weekly_watchers AS (
  SELECT 
    DATE_TRUNC('week', date)::DATE as week_start,
    user_id,
    SUM(total_watch_time_seconds) as week_watch_seconds,
    COUNT(DISTINCT date) as days_watched
  FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_CONTENT_WATCH_DAILY
  WHERE date >= '2024-12-29' AND date <= '2025-02-16'
  GROUP BY 1, 2
),

-- Classify users: M0 (never watched before this week) vs M1 (has watch history)
user_history AS (
  SELECT 
    user_id,
    MIN(date) as first_watch_date,
    SUM(total_watch_time_seconds) as lifetime_watch_seconds
  FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_CONTENT_WATCH_DAILY
  WHERE date <= '2025-02-16'
  GROUP BY user_id
),

weekly_with_cohort AS (
  SELECT 
    ww.week_start,
    ww.user_id,
    ww.week_watch_seconds,
    ww.days_watched,
    CASE 
      WHEN uh.first_watch_date = ww.week_start THEN 'M0'  -- First time watcher this week
      WHEN uh.first_watch_date < ww.week_start THEN 'M1'  -- Has watched before
      ELSE 'M0'
    END as cohort
  FROM weekly_watchers ww
  LEFT JOIN user_history uh ON ww.user_id = uh.user_id
)

-- Calculate retention: did they watch next week?
SELECT 
  curr.week_start,
  curr.cohort,
  COUNT(DISTINCT curr.user_id) as watchers,
  COUNT(DISTINCT next.user_id) as retained_next_week,
  ROUND(100.0 * COUNT(DISTINCT next.user_id) / NULLIF(COUNT(DISTINCT curr.user_id), 0), 1) as wow_retention_pct,
  ROUND(AVG(curr.week_watch_seconds) / 60.0, 1) as avg_watch_minutes
FROM weekly_with_cohort curr
LEFT JOIN weekly_with_cohort next 
  ON curr.user_id = next.user_id 
  AND next.week_start = DATEADD('week', 1, curr.week_start)
GROUP BY 1, 2
ORDER BY 1, 2;
