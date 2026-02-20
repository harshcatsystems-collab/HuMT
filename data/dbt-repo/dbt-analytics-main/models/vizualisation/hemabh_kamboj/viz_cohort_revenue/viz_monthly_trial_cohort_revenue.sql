-- This dbt model calculates user trial cohort revenue and active mandate status over time.
-- It serves as a base model for further performance analysis.

with fct_user_subscription_history as (

    select * from {{ ref('fct_user_subscription_history') }}

),

stg_master_mandates as (

    -- This CTE now references the new staging model for master mandates.
    select * from {{ ref('stg_mongo_mastermandates') }}

),

trial_starting_cohorts as (

    -- 1. Define the monthly cohort based on when a user's trial starts.
    select distinct
        date_trunc('month', date(subscription_start_at_ist)) as trial_start_month,
        user_id,
        date(subscription_start_at_ist) as trial_start_date
    from
        fct_user_subscription_history
    where
        plan_category = 'Trial' and is_valid_vendor

),

active_mandates_at_trial as (

    -- New CTE to count active mandates at the trial level
    select
        date_trunc('month', date(s.subscription_start_at_ist)) as trial_start_month,
        count(distinct case
            when m.status = 'mandate_active'
            then s.user_id
        end) as total_trial_mandates
    from
        fct_user_subscription_history s
    left join
        stg_master_mandates m
        on s.master_mandate_id = m.mandate_id
    where
        s.plan_category = 'Trial'
        and s.is_valid_vendor
    group by 1

),

subsequent_paid_subscriptions as (

    -- 2. Find all subsequent paid subscriptions and JOIN to get mandate status.
    select
        c.trial_start_month,
        c.user_id,
        s.paying_price,
        s.created_at_ist,
        m.status as mandate_status
    from
        trial_starting_cohorts c
    join
        fct_user_subscription_history s
        on c.user_id = s.user_id
    left join
        stg_master_mandates m
        on s.master_mandate_id = m.mandate_id
    where
        s.plan_category != 'Trial' and s.is_valid_vendor
        and date(s.created_at_ist) >= c.trial_start_date

),

ranked_paid_subscriptions as (

    -- 3. Pre-calculate the rank of each paid subscription for each user in the cohort.
    select
        *,
        row_number() over(partition by user_id
        order by created_at_ist asc) as subscription_rank
    from
        subsequent_paid_subscriptions

),

cohort_summary as (

    -- 4. Create the cohort summary using the pre-ranked data.
    select
        trial_start_month,
        -- Calculate total revenue for the first subscription + 35 renewals
        sum(case when subscription_rank <= 36 then paying_price else 0 end) as total_revenue,
        -- Pivot revenue into renewal cycle columns.
        sum(case when subscription_rank = 1 then paying_price else 0 end) as first_subscription_revenue,
        sum(case when subscription_rank = 2 then paying_price else 0 end) as renewal_1_revenue,
        sum(case when subscription_rank = 3 then paying_price else 0 end) as renewal_2_revenue,
        sum(case when subscription_rank = 4 then paying_price else 0 end) as renewal_3_revenue,
        sum(case when subscription_rank = 5 then paying_price else 0 end) as renewal_4_revenue,
        sum(case when subscription_rank = 6 then paying_price else 0 end) as renewal_5_revenue,
        sum(case when subscription_rank = 7 then paying_price else 0 end) as renewal_6_revenue,
        sum(case when subscription_rank = 8 then paying_price else 0 end) as renewal_7_revenue,
        sum(case when subscription_rank = 9 then paying_price else 0 end) as renewal_8_revenue,
        sum(case when subscription_rank = 10 then paying_price else 0 end) as renewal_9_revenue,
        sum(case when subscription_rank = 11 then paying_price else 0 end) as renewal_10_revenue,
        sum(case when subscription_rank = 12 then paying_price else 0 end) as renewal_11_revenue,
        sum(case when subscription_rank = 13 then paying_price else 0 end) as renewal_12_revenue,
        sum(case when subscription_rank = 14 then paying_price else 0 end) as renewal_13_revenue,
        sum(case when subscription_rank = 15 then paying_price else 0 end) as renewal_14_revenue,
        sum(case when subscription_rank = 16 then paying_price else 0 end) as renewal_15_revenue,
        sum(case when subscription_rank = 17 then paying_price else 0 end) as renewal_16_revenue,
        sum(case when subscription_rank = 18 then paying_price else 0 end) as renewal_17_revenue,
        sum(case when subscription_rank = 19 then paying_price else 0 end) as renewal_18_revenue,
        sum(case when subscription_rank = 20 then paying_price else 0 end) as renewal_19_revenue,
        sum(case when subscription_rank = 21 then paying_price else 0 end) as renewal_20_revenue,
        sum(case when subscription_rank = 22 then paying_price else 0 end) as renewal_21_revenue,
        sum(case when subscription_rank = 23 then paying_price else 0 end) as renewal_22_revenue,
        sum(case when subscription_rank = 24 then paying_price else 0 end) as renewal_23_revenue,
        sum(case when subscription_rank = 25 then paying_price else 0 end) as renewal_24_revenue,
        sum(case when subscription_rank = 26 then paying_price else 0 end) as renewal_25_revenue,
        sum(case when subscription_rank = 27 then paying_price else 0 end) as renewal_26_revenue,
        sum(case when subscription_rank = 28 then paying_price else 0 end) as renewal_27_revenue,
        sum(case when subscription_rank = 29 then paying_price else 0 end) as renewal_28_revenue,
        sum(case when subscription_rank = 30 then paying_price else 0 end) as renewal_29_revenue,
        sum(case when subscription_rank = 31 then paying_price else 0 end) as renewal_30_revenue,
        sum(case when subscription_rank = 32 then paying_price else 0 end) as renewal_31_revenue,
        sum(case when subscription_rank = 33 then paying_price else 0 end) as renewal_32_revenue,
        sum(case when subscription_rank = 34 then paying_price else 0 end) as renewal_33_revenue,
        sum(case when subscription_rank = 35 then paying_price else 0 end) as renewal_34_revenue,
        sum(case when subscription_rank = 36 then paying_price else 0 end) as renewal_35_revenue
    from
        ranked_paid_subscriptions
    group by
        trial_start_month

),

total_trials as (

    -- 5. Get the total number of trials starting, which serves as our denominator.
    select
      trial_start_month,
      count(distinct user_id) as total_trials_starting
    from trial_starting_cohorts
    group by trial_start_month

),

latest_subscription_per_user as (

    -- 6. Find the latest subscription for each user in the cohort to get their current mandate status.
    select
        user_id,
        master_mandate_id
    from (
        select
            user_id,
            master_mandate_id,
            row_number() over(partition by user_id order by created_at_ist desc) as rn
        from
            fct_user_subscription_history
    )
    where rn = 1

),

current_active_mandate_users as (

    -- 7. Get the current count of users with an active mandate from the cohorts.
    select
        c.trial_start_month,
        count(distinct c.user_id) as current_active_mandates
    from
        trial_starting_cohorts c
    join
        latest_subscription_per_user l on c.user_id = l.user_id
    left join
        stg_master_mandates m on l.master_mandate_id = m.mandate_id
    where
        m.status = 'mandate_active'
    group by 1

),

base as (

    -- 8. Combine all cohort data into a single base result set
    select
        t.trial_start_month,
        t.total_trials_starting,
        coalesce(camu.current_active_mandates, 0) as current_active_mandates,
        coalesce(cs.total_revenue, 0) as total_revenue,
        coalesce(cs.first_subscription_revenue, 0) as first_subscription_revenue,
        coalesce(cs.renewal_1_revenue, 0) as renewal_1_revenue,
        cast(coalesce(cs.renewal_2_revenue, 0) * 0.82 as integer) as renewal_2_revenue,
        cast(coalesce(cs.renewal_3_revenue, 0) * 0.82 as integer) as renewal_3_revenue,
        cast(coalesce(cs.renewal_4_revenue, 0) * 0.82 as integer) as renewal_4_revenue,
        cast(coalesce(cs.renewal_5_revenue, 0) * 0.82 as integer) as renewal_5_revenue,
        cast(coalesce(cs.renewal_6_revenue, 0) * 0.82 as integer) as renewal_6_revenue,
        cast(coalesce(cs.renewal_7_revenue, 0) * 0.82 as integer) as renewal_7_revenue,
        cast(coalesce(cs.renewal_8_revenue, 0) * 0.82 as integer) as renewal_8_revenue,
        cast(coalesce(cs.renewal_9_revenue, 0) * 0.82 as integer) as renewal_9_revenue,
        cast(coalesce(cs.renewal_10_revenue, 0) * 0.82 as integer) as renewal_10_revenue,
        cast(coalesce(cs.renewal_11_revenue, 0) * 0.82 as integer) as renewal_11_revenue,
        cast(coalesce(cs.renewal_12_revenue, 0) * 0.82 as integer) as renewal_12_revenue,
        cast(coalesce(cs.renewal_13_revenue, 0) * 0.82 as integer) as renewal_13_revenue,
        cast(coalesce(cs.renewal_14_revenue, 0) * 0.82 as integer) as renewal_14_revenue,
        cast(coalesce(cs.renewal_15_revenue, 0) * 0.82 as integer) as renewal_15_revenue,
        cast(coalesce(cs.renewal_16_revenue, 0) * 0.82 as integer) as renewal_16_revenue,
        cast(coalesce(cs.renewal_17_revenue, 0) * 0.82 as integer) as renewal_17_revenue,
        cast(coalesce(cs.renewal_18_revenue, 0) * 0.82 as integer) as renewal_18_revenue,
        cast(coalesce(cs.renewal_19_revenue, 0) * 0.82 as integer) as renewal_19_revenue,
        cast(coalesce(cs.renewal_20_revenue, 0) * 0.82 as integer) as renewal_20_revenue,
        cast(coalesce(cs.renewal_21_revenue, 0) * 0.82 as integer) as renewal_21_revenue,
        cast(coalesce(cs.renewal_22_revenue, 0) * 0.82 as integer) as renewal_22_revenue,
        cast(coalesce(cs.renewal_23_revenue, 0) * 0.82 as integer) as renewal_23_revenue,
        cast(coalesce(cs.renewal_24_revenue, 0) * 0.82 as integer) as renewal_24_revenue,
        cast(coalesce(cs.renewal_25_revenue, 0) * 0.82 as integer) as renewal_25_revenue,
        cast(coalesce(cs.renewal_26_revenue, 0) * 0.82 as integer) as renewal_26_revenue,
        cast(coalesce(cs.renewal_27_revenue, 0) * 0.82 as integer) as renewal_27_revenue,
        cast(coalesce(cs.renewal_28_revenue, 0) * 0.82 as integer) as renewal_28_revenue,
        cast(coalesce(cs.renewal_29_revenue, 0) * 0.82 as integer) as renewal_29_revenue,
        cast(coalesce(cs.renewal_30_revenue, 0) * 0.82 as integer) as renewal_30_revenue,
        cast(coalesce(cs.renewal_31_revenue, 0) * 0.82 as integer) as renewal_31_revenue,
        cast(coalesce(cs.renewal_32_revenue, 0) * 0.82 as integer) as renewal_32_revenue,
        cast(coalesce(cs.renewal_33_revenue, 0) * 0.82 as integer) as renewal_33_revenue,
        cast(coalesce(cs.renewal_34_revenue, 0) * 0.82 as integer) as renewal_34_revenue,
        cast(coalesce(cs.renewal_35_revenue, 0) * 0.82 as integer) as renewal_35_revenue
    from
        total_trials t
    left join
        cohort_summary cs on t.trial_start_month = cs.trial_start_month
    left join
        active_mandates_at_trial atm on t.trial_start_month = atm.trial_start_month
    left join
        current_active_mandate_users camu on t.trial_start_month = camu.trial_start_month
    where
        t.trial_start_month >= date_trunc('month', dateadd(month, -48, current_date()))
        and t.trial_start_month <= date_trunc('month', current_date())

),

final as (

    -- 9. Final SELECT to join the base cohort data
    select
        base.trial_start_month,
        base.total_trials_starting,
        base.current_active_mandates as active_mandates_as_of_today,
        base.total_revenue,
        
        -- All renewal columns
        base.first_subscription_revenue,
        base.renewal_1_revenue,
        base.renewal_2_revenue,
        base.renewal_3_revenue,
        base.renewal_4_revenue,
        base.renewal_5_revenue,
        base.renewal_6_revenue,
        base.renewal_7_revenue,
        base.renewal_8_revenue,
        base.renewal_9_revenue,
        base.renewal_10_revenue,
        base.renewal_11_revenue,
        base.renewal_12_revenue,
        base.renewal_13_revenue,
        base.renewal_14_revenue,
        base.renewal_15_revenue,
        base.renewal_16_revenue,
        base.renewal_17_revenue,
        base.renewal_18_revenue,
        base.renewal_19_revenue,
        base.renewal_20_revenue,
        base.renewal_21_revenue,
        base.renewal_22_revenue,
        base.renewal_23_revenue,
        base.renewal_24_revenue,
        base.renewal_25_revenue,
        base.renewal_26_revenue,
        base.renewal_27_revenue,
        base.renewal_28_revenue,
        base.renewal_29_revenue,
        base.renewal_30_revenue,
        base.renewal_31_revenue,
        base.renewal_32_revenue,
        base.renewal_33_revenue,
        base.renewal_34_revenue,
        base.renewal_35_revenue

    from
        base
)

select * from final
order by trial_start_month desc

