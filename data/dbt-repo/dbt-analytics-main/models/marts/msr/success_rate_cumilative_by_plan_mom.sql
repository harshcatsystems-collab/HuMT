WITH
-- 1. Get all subscription history and identify the next subscription for each user
ranked_subscriptions AS (
    SELECT
        user_id,
        is_trial,
        created_at_ist, -- Keep the original timestamp for accurate ordering
        date(subscription_end_at_ist) AS subscription_end_date,
        -- Find the details of the next subscription to check for conversion
        LEAD(is_trial) OVER (PARTITION BY user_id ORDER BY created_at_ist) AS next_is_trial,
        LEAD(date(created_at_ist)) OVER (PARTITION BY user_id ORDER BY created_at_ist) AS next_subscription_start_date
    FROM
        analytics_prod.dbt_core.fct_user_subscription_history
),

-- 2. Isolate conversion events (trial -> paid) and calculate the difference in months
conversion_events AS (
    SELECT
        user_id,
        DATE_TRUNC('month', subscription_end_date) AS trial_end_month,
        -- Calculate the difference in months between the end of the trial and the start of the paid plan
        DATEDIFF(month, subscription_end_date, next_subscription_start_date) AS diff_months
    FROM
        ranked_subscriptions
    WHERE
        is_trial = 'True'       -- The current subscription is a trial
        AND next_is_trial = 'False' -- The next subscription is a paid one
),

-- 3. Count the number of users who converted, grouped by trial end month and conversion time
renewed_counts AS (
    SELECT
        trial_end_month,
        diff_months,
        COUNT(DISTINCT user_id) AS renewed_users
    FROM
        conversion_events
    GROUP BY
        trial_end_month,
        diff_months
),

-- 4. Count the total number of trials ending in each month (our denominator)
total_trials_ending AS (
    SELECT
        DATE_TRUNC('month', date(subscription_end_at_ist)) AS trial_end_month,
        COUNT(DISTINCT user_id) AS trials_ending
    FROM
        analytics_prod.dbt_core.fct_user_subscription_history
    WHERE
        is_trial = 'True'
    GROUP BY
        trial_end_month
)

-- 5. Final calculation: Join renewed counts with total trials and compute the cumulative monthly success rate
SELECT
    r.trial_end_month AS "Trial End Month",
    r.diff_months AS "Months to Convert",
    -- Calculate the cumulative sum of monthly renewals
    (SUM(r.renewed_users) OVER (
        PARTITION BY r.trial_end_month
        ORDER BY r.diff_months
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) * 100.0 / t.trials_ending) AS "Cumulative Conversion Rate (%)"
FROM
    renewed_counts r
JOIN
    total_trials_ending t ON r.trial_end_month = t.trial_end_month
WHERE
    -- Filter for a relevant time window and conversion period
    r.diff_months >= 0
    AND r.trial_end_month >= DATE_TRUNC('month', DATEADD(month, -20, CURRENT_DATE()))
    AND r.trial_end_month <= DATE_TRUNC('month', CURRENT_DATE())
ORDER BY
    "Trial End Month" DESC,
    "Months to Convert" ASC