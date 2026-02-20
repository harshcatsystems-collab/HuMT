-- First, join the two tables to have all relevant data in one place
with all_subscription_data as (
    select
        s.user_id,
        s.subscription_id,
        date(s.subscription_end_at_ist) as trial_end_date,
        s.plan_id,
        date(s.created_at_ist) as subscription_date,
        m.status as mandate_status,
        m._id as mastermandate_id,
        s.PLAN_CATEGORY
    from
        analytics_prod.dbt_core.fct_user_subscription_history s
    left join
        raw_prod.mongo.mastermandates m
        on s.master_mandate_id = m._id
),

-- get trial subscriptions without standardizing plan names
trial_subscriptions as (
    select
        user_id,
        subscription_id,
        subscription_date,
        trial_end_date,
        plan_id as trial_plan_id,
        mastermandate_id,
        mandate_status
    from
        all_subscription_data
    where
        lower(plan_id) like 'trial%'
),

-- get subsequent paid subscriptions in a plan-agnostic way
paid_subscriptions as (
    select
        user_id,
        subscription_date,
        plan_id as subscription_plan_id
    from
        all_subscription_data
    where
        lower(plan_id) not like 'trial%'
        and PLAN_CATEGORY ='New Subscription'
),

-- CORRECTED: The SELECT statement now correctly references the subquery's columns.
conversion_pairs as (
    select
        user_id,
        trial_end_date,
        trial_plan_id,
        mastermandate_id,
        mandate_status,
        subscription_date,
        subscription_plan_id,
        diff
    from (
        select
            t.user_id,
            t.trial_end_date,
            t.trial_plan_id,
            t.mastermandate_id,
            t.mandate_status,
            p.subscription_date,
            p.subscription_plan_id,
            datediff(day, t.trial_end_date, p.subscription_date) as diff,
            row_number() over(partition by t.subscription_id order by p.subscription_date asc) as conversion_rank
        from
            trial_subscriptions t
        join
            paid_subscriptions p on t.user_id = p.user_id
        where
            p.subscription_date >= t.subscription_date
            and datediff(day, t.trial_end_date, p.subscription_date) >= -2
    ) as ranked_conversions
    where
      ranked_conversions.conversion_rank = 1
),

-- count renewals by trial end date, trial plan, and days since trial end
renewed_data as (
    select
        trial_end_date,
        trial_plan_id,
        diff,
        count(distinct user_id) as renewed
    from
        conversion_pairs
    group by
        trial_end_date,
        trial_plan_id,
        diff
),

-- count total trials ending on each date by the original plan_id
trial_ending_data as (
    select
        date(trial_end_date) as trial_end_date,
        plan_id as trial_plan_id,
        count(distinct user_id) as trials_ending
    from
        all_subscription_data
    where
        lower(plan_id) like 'trial%'
    group by
        trial_end_date,
        plan_id
),

-- Count mandates and active mandates ONLY from the successful conversions
renewed_mandate_counts as (
    select
        trial_end_date,
        trial_plan_id,
        count(distinct case when mastermandate_id is not null then user_id end) as trials_with_mandates_from_success,
        count(distinct case when mastermandate_id is not null and mandate_status = 'mandate_active' then user_id end) as trials_with_active_mandates_from_success
    from
        conversion_pairs
    group by
        trial_end_date,
        trial_plan_id
),

-- calculate cumulative renewal counts over time
cumulative_conversions as (
    select
        r.trial_end_date,
        r.trial_plan_id,
        r.diff,
        r.renewed,
        t.trials_ending,
        rmc.trials_with_mandates_from_success,
        rmc.trials_with_active_mandates_from_success,
        sum(r.renewed) over (
            partition by r.trial_end_date, r.trial_plan_id
            order by r.diff
            rows between unbounded preceding and current row
        ) as cumulative_renewal,
        sum(r.renewed) over (
            partition by r.trial_end_date, r.trial_plan_id
            order by r.diff
            rows between unbounded preceding and current row
        ) / t.trials_ending as success_rate
    from
        renewed_data r
    join
        trial_ending_data t
        on r.trial_end_date = t.trial_end_date
        and r.trial_plan_id = t.trial_plan_id
    join
        renewed_mandate_counts rmc
        on r.trial_end_date = rmc.trial_end_date
        and r.trial_plan_id = rmc.trial_plan_id
    where
        r.diff >= -2
        and r.trial_end_date >= dateadd(day, -360, current_date())
        and r.trial_end_date <= dateadd(day, 2, current_date())
),

-- get maximum values per trial end date and plan id
final_summary as (
    select
        trial_end_date,
        trial_plan_id,
        max(cumulative_renewal) as success,
        max(trials_ending) as trials_ending,
        max(trials_with_mandates_from_success) as "trials_with_mandates_(master_mandates)",
        max(trials_with_active_mandates_from_success) as "trials_with_active_mandates_(master_mandates)",
        max(success_rate) as success_rate,
        (max(trials_with_mandates_from_success) / nullif(max(cumulative_renewal), 0)) as trials_with_mandates_percentage,
        (max(trials_with_active_mandates_from_success) / nullif(max(cumulative_renewal), 0)) as trials_with_active_mandates_percentage
    from
        cumulative_conversions
    group by
        trial_end_date,
        trial_plan_id
)

-- final output
select
    trial_end_date,
    dateadd(day, -10, trial_end_date) as trial_start_date, -- Note: Assumes a 10-day trial for start date calculation
    trial_plan_id,
    success,
    success_rate as success_rate,
    "trials_with_active_mandates_(master_mandates)" as active_mandates_post_msr,
    trials_with_active_mandates_percentage as active_mandates_post_msr_percentage,
    trials_ending
from
    final_summary
order by
    trial_end_date desc,
    trial_plan_id