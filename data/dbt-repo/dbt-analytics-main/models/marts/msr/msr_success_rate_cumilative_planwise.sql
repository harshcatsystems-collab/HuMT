WITH
-- 1. Get all subscription history and identify the next subscription for each user
ranked_subscriptions AS (
    SELECT
        user_id,
        is_trial,
        date(subscription_end_at_ist) AS subscription_end_date,
        -- Find the details of the next subscription to check for conversion
        LEAD(is_trial) OVER (PARTITION BY user_id ORDER BY created_at_ist) AS next_is_trial,
        LEAD(date(created_at_ist)) OVER (PARTITION BY user_id ORDER BY created_at_ist) AS next_subscription_start_date
    FROM
        analytics_prod.dbt_core.fct_user_subscription_history
),

-- 2. Isolate the conversion events (trial -> paid) and calculate the time difference
conversion_events AS (
    SELECT
        user_id,
        subscription_end_date AS trial_end_date,
        DATEDIFF(day, subscription_end_date, next_subscription_start_date) AS diff_days
    FROM
        ranked_subscriptions
    WHERE
        is_trial = 'True'       -- The current subscription is a trial
        AND next_is_trial = 'False' -- The next subscription is a paid one
),

-- 3. Count the number of users who converted, grouped by trial end date and conversion time
renewed_counts AS (
    SELECT
        trial_end_date,
        diff_days,
        COUNT(DISTINCT user_id) AS renewed_users
    FROM
        conversion_events
    GROUP BY
        trial_end_date,
        diff_days
),

-- 4. Count the total number of trials ending on each day (our denominator)
total_trials_ending AS (
    SELECT
        date(subscription_end_at_ist) AS trial_end_date,
        COUNT(DISTINCT user_id) AS trials_ending
    FROM
        analytics_prod.dbt_core.fct_user_subscription_history
    WHERE
        is_trial = 'True'
    GROUP BY
        trial_end_date
)

-- 5. Final calculation: Join renewed counts with total trials and compute the cumulative success rate
SELECT
    r.trial_end_date AS "Trial End Date",
    r.diff_days AS "Days to Convert",
    -- Calculate the cumulative sum of renewals for each day
    SUM(r.renewed_users) OVER (
        PARTITION BY r.trial_end_date
        ORDER BY r.diff_days
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) * 100.0 / t.trials_ending AS "Cumulative Conversion Rate (%)"
FROM
    renewed_counts r
JOIN
    total_trials_ending t ON r.trial_end_date = t.trial_end_date
WHERE
    -- Filter for a relevant time window and conversion period
    r.diff_days >= -2
    AND r.trial_end_date BETWEEN DATEADD(day, -30, CURRENT_DATE()) AND DATEADD(day, 2, CURRENT_DATE())
ORDER BY
    "Trial End Date" DESC,
    "Days to Convert" ASC