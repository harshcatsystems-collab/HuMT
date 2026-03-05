-- Weekly Watch Retention with M0/M1 Segmentation
-- Author: HuMT (via Snowflake direct query)
-- Created: 2026-03-05
-- Purpose: Calculate WoW retention separately for M0 (never watched) vs M1 (has watched) cohorts
--
-- DATA MODEL:
-- - FCT_USER_CONTENT_WATCH_DAILY: Daily watch activity per user/content
-- - VIZ_NEW_SUBSCRIBER_COHORT_WATCH_RETENTION_ENGAGEMENT: Pre-computed retention curves
-- - FCT_USER_SUBSCRIPTION_HISTORY: Subscription lifecycle
--
-- APPROACH:
-- 1. Classify users as M0 (never watched during trial/sub) or M1 (has watched)
-- 2. Join with retention data to get weekly watch patterns
-- 3. Calculate WoW retention % for each cohort
-- 4. Break down M1 by subscription stage (D_0to7, D_8to14, etc.) and eligibility (Repeat 2, New, etc.)

WITH user_classification AS (
  -- Classify each user as M0 or M1 based on watch activity across analysis period
  SELECT 
    user_id,
    CASE 
      WHEN SUM(COALESCE(total_watch_time_seconds, 0)) = 0 THEN 'M0'  -- Never watched
      WHEN SUM(COALESCE(total_watch_time_seconds, 0)) > 0 THEN 'M1'  -- Has watched
      ELSE 'UNKNOWN'
    END as cohort,
    SUM(COALESCE(total_watch_time_seconds, 0)) as total_watch_seconds,
    COUNT(DISTINCT date) as days_watched
  FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_CONTENT_WATCH_DAILY
  WHERE date BETWEEN '2024-12-29' AND '2025-02-16'
  GROUP BY user_id
),

weekly_watchers AS (
  -- Get weekly watcher counts with subscription stage context
  SELECT 
    DATE_TRUNC('week', date) as week_start,
    user_id,
    SUM(total_watch_time_seconds) as week_watch_seconds,
    COUNT(DISTINCT content_id) as titles_watched
  FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_CONTENT_WATCH_DAILY
  WHERE date BETWEEN '2024-12-29' AND '2025-02-16'
  GROUP BY 1, 2
),

subscription_context AS (
  -- Get subscription stage for each user during the analysis window
  SELECT DISTINCT
    sub.user_id,
    CASE
      WHEN DATEDIFF('day', sub.created_at_ist::DATE, '2025-02-16'::DATE) <= 7 THEN 'D_0to7'
      WHEN DATEDIFF('day', sub.created_at_ist::DATE, '2025-02-16'::DATE) <= 14 THEN 'D_8to14'
      WHEN DATEDIFF('day', sub.created_at_ist::DATE, '2025-02-16'::DATE) <= 30 THEN 'D_15to30'
      WHEN DATEDIFF('day', sub.created_at_ist::DATE, '2025-02-16'::DATE) <= 60 THEN 'D_31to60'
      WHEN DATEDIFF('day', sub.created_at_ist::DATE, '2025-02-16'::DATE) <= 90 THEN 'D_61to90'
      WHEN sub.plan_category = 'Renewal' THEN 'RENEWAL'
      ELSE 'OTHER'
    END as subscription_stage,
    sub.plan_category,
    sub.dialect
  FROM ANALYTICS_PROD.DBT_CORE.FCT_USER_SUBSCRIPTION_HISTORY sub
  WHERE sub.created_at_ist::DATE <= '2025-02-16'
    AND sub.status = 'active'
),

weekly_retention_base AS (
  -- Calculate week-over-week retention
  SELECT 
    ww.week_start,
    uc.cohort,
    sc.subscription_stage,
    sc.dialect,
    COUNT(DISTINCT ww.user_id) as watchers_this_week,
    COUNT(DISTINCT CASE 
      WHEN next_ww.user_id IS NOT NULL THEN ww.user_id 
    END) as retained_next_week,
    AVG(ww.week_watch_seconds) / 60.0 as avg_watch_minutes
  FROM weekly_watchers ww
  INNER JOIN user_classification uc ON ww.user_id = uc.user_id
  LEFT JOIN subscription_context sc ON ww.user_id = sc.user_id
  LEFT JOIN weekly_watchers next_ww 
    ON ww.user_id = next_ww.user_id 
    AND next_ww.week_start = DATEADD('week', 1, ww.week_start)
  GROUP BY 1, 2, 3, 4
),

-- Calculate eligibility (Repeat 2 = watched 2+ consecutive weeks, New = first week, etc.)
user_watch_streak AS (
  SELECT 
    user_id,
    week_start,
    COUNT(*) OVER (
      PARTITION BY user_id 
      ORDER BY week_start 
      ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) as consecutive_weeks
  FROM weekly_watchers
),

eligibility_classification AS (
  SELECT 
    ws.user_id,
    ws.week_start,
    CASE 
      WHEN ws.consecutive_weeks >= 2 THEN 'Repeat 2'
      WHEN prev_ws.user_id IS NULL THEN 'New'
      WHEN prev_ws.user_id IS NOT NULL AND ws.consecutive_weeks = 1 THEN 'Returning'
      ELSE 'Other'
    END as eligibility
  FROM user_watch_streak ws
  LEFT JOIN user_watch_streak prev_ws 
    ON ws.user_id = prev_ws.user_id 
    AND prev_ws.week_start = DATEADD('week', -1, ws.week_start)
)

-- Final aggregation: Weekly retention by M0/M1, with M1 breakdowns
SELECT 
  wrb.week_start,
  wrb.cohort,
  
  -- Overall cohort metrics
  SUM(wrb.watchers_this_week) as watchers,
  SUM(wrb.retained_next_week) as retained,
  ROUND(100.0 * SUM(wrb.retained_next_week) / NULLIF(SUM(wrb.watchers_this_week), 0), 1) as wow_retention_pct,
  ROUND(AVG(wrb.avg_watch_minutes), 1) as avg_watch_min,
  
  -- M1 subscription stage breakdown
  SUM(CASE WHEN wrb.subscription_stage = 'D_0to7' THEN wrb.watchers_this_week ELSE 0 END) as m1_d0to7_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'D_0to7' THEN wrb.retained_next_week ELSE 0 END) as m1_d0to7_retained,
  
  SUM(CASE WHEN wrb.subscription_stage = 'D_8to14' THEN wrb.watchers_this_week ELSE 0 END) as m1_d8to14_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'D_8to14' THEN wrb.retained_next_week ELSE 0 END) as m1_d8to14_retained,
  
  SUM(CASE WHEN wrb.subscription_stage = 'D_15to30' THEN wrb.watchers_this_week ELSE 0 END) as m1_d15to30_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'D_15to30' THEN wrb.retained_next_week ELSE 0 END) as m1_d15to30_retained,
  
  SUM(CASE WHEN wrb.subscription_stage = 'D_31to60' THEN wrb.watchers_this_week ELSE 0 END) as m1_d31to60_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'D_31to60' THEN wrb.retained_next_week ELSE 0 END) as m1_d31to60_retained,
  
  SUM(CASE WHEN wrb.subscription_stage = 'D_61to90' THEN wrb.watchers_this_week ELSE 0 END) as m1_d61to90_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'D_61to90' THEN wrb.retained_next_week ELSE 0 END) as m1_d61to90_retained,
  
  SUM(CASE WHEN wrb.subscription_stage = 'RENEWAL' THEN wrb.watchers_this_week ELSE 0 END) as m1_renewal_watchers,
  SUM(CASE WHEN wrb.subscription_stage = 'RENEWAL' THEN wrb.retained_next_week ELSE 0 END) as m1_renewal_retained,
  
  -- M1 eligibility breakdown (join with eligibility_classification)
  SUM(CASE WHEN ec.eligibility = 'Repeat 2' THEN wrb.watchers_this_week ELSE 0 END) as m1_repeat2_watchers,
  SUM(CASE WHEN ec.eligibility = 'Repeat 2' THEN wrb.retained_next_week ELSE 0 END) as m1_repeat2_retained,
  
  SUM(CASE WHEN ec.eligibility = 'New' THEN wrb.watchers_this_week ELSE 0 END) as m1_new_watchers,
  SUM(CASE WHEN ec.eligibility = 'New' THEN wrb.retained_next_week ELSE 0 END) as m1_new_retained,
  
  SUM(CASE WHEN ec.eligibility = 'Returning' THEN wrb.watchers_this_week ELSE 0 END) as m1_returning_watchers,
  SUM(CASE WHEN ec.eligibility = 'Returning' THEN wrb.retained_next_week ELSE 0 END) as m1_returning_retained

FROM weekly_retention_base wrb
LEFT JOIN eligibility_classification ec 
  ON wrb.week_start = ec.week_start 
  AND wrb.watchers_this_week > 0  -- Only join for users who actually watched
WHERE wrb.cohort IN ('M0', 'M1')
GROUP BY 1, 2
ORDER BY 1, 2;
