WITH table1 AS (
    SELECT DISTINCT
        uwh.user_id,
        uwh.watch_date AS createdat,
        lower(dc.content_type) as type,
        dc.show_slug AS showslug,
        SUM(uwh.watched_time_sec) OVER (PARTITION BY uwh.user_id, dc.show_slug) AS watchtime
    FROM {{ ref('fct_user_content_watch_daily') }} uwh
    LEFT JOIN {{ ref('dim_content') }} dc
        ON uwh.content_id = dc.content_id
),

episode_totals AS (
    SELECT
        show_slug AS showslug,
        SUM(duration_sec) AS totaltime
    FROM {{ ref('dim_content') }}
    WHERE display_language = 'en'
      AND content_status = 'active'
    GROUP BY 1
),

final_table AS (
    SELECT
        a.user_id,
        a.createdat,
        a.showslug,
        a.type,
        a.watchtime,
        b.totaltime
    FROM table1 AS a
    LEFT JOIN episode_totals AS b
    ON a.showslug = b.showslug
)

SELECT
    showslug AS slug,
    type,
    SUM(watchtime) / 60 AS total_watch_time,
    COUNT(DISTINCT user_id) AS unique_watchers,
    COUNT(DISTINCT CASE WHEN DATE(TO_DATE(createdat)) >= CURRENT_DATE - INTERVAL '7 DAY' THEN user_id END) AS last_7days_unique_watchers,
    COUNT(DISTINCT CASE WHEN div0(watchtime, totaltime) > 0.5 THEN user_id END) AS completed_above_50
FROM final_table
WHERE DATE(TO_DATE(createdat)) > '2023-01-01'
GROUP BY 1, 2