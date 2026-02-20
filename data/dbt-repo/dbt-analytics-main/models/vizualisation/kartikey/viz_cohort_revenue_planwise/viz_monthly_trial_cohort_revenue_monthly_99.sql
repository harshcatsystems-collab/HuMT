with
    -- plans base 
    plans as (
        select
            p.planid as plan_id,
            coalesce(s.plantype, p.plantype) as plan_type,
            coalesce(s.actualprice, p.actualprice) as actual_price,
            s.planid as subscription_plan_id,
            s.plantype as subscription_plan_type
        from raw_prod.mongo.plans p
        left join
            raw_prod.mongo.plans s on s.planid = p.posttrialplan and s.status = 'active'
        where p.status = 'active'
        group by 1, 2, 3, 4, 5
    ),
    -- 1. Define the monthly cohort based on when a user's trial starts.
    trial_starting_cohorts as (
        select distinct
            date_trunc('month', date(subscription_start_at_ist)) as trial_start_month,
            user_id,
            date(subscription_start_at_ist) as trial_start_date,
            p.plan_type,
            p.actual_price
        from {{ ref("fct_user_subscription_history") }} his
        left join plans p on p.plan_id = his.plan_id
        where plan_category = 'Trial' and is_valid_vendor
    ),

    -- New CTE to count active mandates at the trial level
    active_mandates_at_trial as (
        select
            date_trunc('month', date(subscription_start_at_ist)) as trial_start_month,
            p.plan_type,
            p.actual_price,
            count(
                distinct case when m.status = 'mandate_active' then s.user_id end
            ) as total_trial_mandates
        from {{ ref("fct_user_subscription_history") }} s
        join plans p on p.plan_id = s.plan_id
        left join {{ ref("stg_mongo_mastermandates") }} m on s.master_mandate_id = m.mandate_id
        where s.plan_category = 'Trial' and s.is_valid_vendor
        group by 1, 2, 3
    ),

    -- 2. Find all subsequent paid subscriptions and JOIN to get mandate status.
    subsequent_paid_subscriptions as (
        select
            c.trial_start_month,
            c.plan_type,
            c.actual_price,
            c.user_id,
            s.paying_price,
            s.created_at_ist,
            m.status as mandate_status
        from trial_starting_cohorts c
        join
            {{ ref("fct_user_subscription_history") }} s
            on c.user_id = s.user_id
        -- and c.plan_type = s.plan_type
        -- and c.actual_price = s.actual_price
        left join {{ ref("stg_mongo_mastermandates") }} m on s.master_mandate_id = m.mandate_id
        where
            s.plan_category != 'Trial'
            and s.is_valid_vendor
            and date(s.created_at_ist) >= c.trial_start_date
    ),

    -- 3. Pre-calculate the rank of each paid subscription for each user in the cohort.
    -- This rank serves as our renewal cycle number (1=first subscription, 2=first
    -- renewal, etc.).
    ranked_paid_subscriptions as (
        select
            *,
            row_number() over (
                partition by user_id order by created_at_ist asc
            ) as subscription_rank
        from subsequent_paid_subscriptions
    ),
    -- select * from ranked_paid_subscriptions where trial_start_month = '2025-09-01'
    -- and user_id = '605d8fd60ac6543c02e0cd39'
    -- 4. Create the cohort summary using the pre-ranked data.
    cohort_summary as (
        select
            trial_start_month,
            plan_type,
            actual_price,
            -- Calculate total revenue for the first subscription + 35 renewals
            sum(
                case when subscription_rank <= 36 then paying_price else 0 end
            ) as total_revenue,
            -- Pivot revenue into renewal cycle columns.
            sum(
                case when subscription_rank = 1 then paying_price else 0 end
            ) as first_subscription_revenue,
            sum(
                case when subscription_rank = 2 then paying_price else 0 end
            ) as renewal_1_revenue,
            sum(
                case when subscription_rank = 3 then paying_price else 0 end
            ) as renewal_2_revenue,
            sum(
                case when subscription_rank = 4 then paying_price else 0 end
            ) as renewal_3_revenue,
            sum(
                case when subscription_rank = 5 then paying_price else 0 end
            ) as renewal_4_revenue,
            sum(
                case when subscription_rank = 6 then paying_price else 0 end
            ) as renewal_5_revenue,
            sum(
                case when subscription_rank = 7 then paying_price else 0 end
            ) as renewal_6_revenue,
            sum(
                case when subscription_rank = 8 then paying_price else 0 end
            ) as renewal_7_revenue,
            sum(
                case when subscription_rank = 9 then paying_price else 0 end
            ) as renewal_8_revenue,
            sum(
                case when subscription_rank = 10 then paying_price else 0 end
            ) as renewal_9_revenue,
            sum(
                case when subscription_rank = 11 then paying_price else 0 end
            ) as renewal_10_revenue,
            sum(
                case when subscription_rank = 12 then paying_price else 0 end
            ) as renewal_11_revenue,
            sum(
                case when subscription_rank = 13 then paying_price else 0 end
            ) as renewal_12_revenue,
            sum(
                case when subscription_rank = 14 then paying_price else 0 end
            ) as renewal_13_revenue,
            sum(
                case when subscription_rank = 15 then paying_price else 0 end
            ) as renewal_14_revenue,
            sum(
                case when subscription_rank = 16 then paying_price else 0 end
            ) as renewal_15_revenue,
            sum(
                case when subscription_rank = 17 then paying_price else 0 end
            ) as renewal_16_revenue,
            sum(
                case when subscription_rank = 18 then paying_price else 0 end
            ) as renewal_17_revenue,
            sum(
                case when subscription_rank = 19 then paying_price else 0 end
            ) as renewal_18_revenue,
            sum(
                case when subscription_rank = 20 then paying_price else 0 end
            ) as renewal_19_revenue,
            sum(
                case when subscription_rank = 21 then paying_price else 0 end
            ) as renewal_20_revenue,
            sum(
                case when subscription_rank = 22 then paying_price else 0 end
            ) as renewal_21_revenue,
            sum(
                case when subscription_rank = 23 then paying_price else 0 end
            ) as renewal_22_revenue,
            sum(
                case when subscription_rank = 24 then paying_price else 0 end
            ) as renewal_23_revenue,
            sum(
                case when subscription_rank = 25 then paying_price else 0 end
            ) as renewal_24_revenue,
            sum(
                case when subscription_rank = 26 then paying_price else 0 end
            ) as renewal_25_revenue,
            sum(
                case when subscription_rank = 27 then paying_price else 0 end
            ) as renewal_26_revenue,
            sum(
                case when subscription_rank = 28 then paying_price else 0 end
            ) as renewal_27_revenue,
            sum(
                case when subscription_rank = 29 then paying_price else 0 end
            ) as renewal_28_revenue,
            sum(
                case when subscription_rank = 30 then paying_price else 0 end
            ) as renewal_29_revenue,
            sum(
                case when subscription_rank = 31 then paying_price else 0 end
            ) as renewal_30_revenue,
            sum(
                case when subscription_rank = 32 then paying_price else 0 end
            ) as renewal_31_revenue,
            sum(
                case when subscription_rank = 33 then paying_price else 0 end
            ) as renewal_32_revenue,
            sum(
                case when subscription_rank = 34 then paying_price else 0 end
            ) as renewal_33_revenue,
            sum(
                case when subscription_rank = 35 then paying_price else 0 end
            ) as renewal_34_revenue,
            sum(
                case when subscription_rank = 36 then paying_price else 0 end
            ) as renewal_35_revenue
        from ranked_paid_subscriptions
        group by 1, 2, 3
    ),
    -- 5. Get the total number of trials starting, which serves as our denominator.
    total_trials as (
        select
            trial_start_month,
            plan_type,
            actual_price,
            count(distinct user_id) as total_trials_starting
        from trial_starting_cohorts
        group by 1, 2, 3
    ),

    -- 6. Find the latest subscription for each user in the cohort to get their
    -- current mandate status.
    latest_subscription_per_user as (
        select user_id, master_mandate_id
        from
            (
                select
                    user_id,
                    master_mandate_id,
                    row_number() over (
                        partition by user_id order by created_at_ist desc
                    ) as rn
                from {{ ref("fct_user_subscription_history") }}
            )
        where rn = 1
    ),

    -- 7. Get the current count of users with an active mandate from the cohorts.
    current_active_mandate_users as (
        select
            c.trial_start_month,
            c.plan_type,
            c.actual_price,
            count(distinct c.user_id) as current_active_mandates
        from trial_starting_cohorts c
        join latest_subscription_per_user l on c.user_id = l.user_id
        left join {{ ref("stg_mongo_mastermandates") }} m on l.master_mandate_id = m.mandate_id
        where m.status = 'mandate_active'
        group by 1, 2, 3
    )

-- 8. Final SELECT statement to join all the results.
select
    t.trial_start_month as "Trial Start Month",
    t.plan_type as "Plan Type",
    t.actual_price as "Plan Price",
    t.total_trials_starting as "No. of trials starting",
    coalesce(camu.current_active_mandates, 0) as "No. of Active Mandates (As of Today)",
    coalesce(cs.total_revenue, 0) as "Total Revenue",
    coalesce(cs.first_subscription_revenue, 0) as "First Subscription Revenue",
    coalesce(cs.renewal_1_revenue, 0) as "Renewal 1 Revenue",
    cast(coalesce(cs.renewal_2_revenue, 0) * 0.82 as integer) as "Renewal 2 Revenue",
    cast(coalesce(cs.renewal_3_revenue, 0) * 0.82 as integer) as "Renewal 3 Revenue",
    cast(coalesce(cs.renewal_4_revenue, 0) * 0.82 as integer) as "Renewal 4 Revenue",
    cast(coalesce(cs.renewal_5_revenue, 0) * 0.82 as integer) as "Renewal 5 Revenue",
    cast(coalesce(cs.renewal_6_revenue, 0) * 0.82 as integer) as "Renewal 6 Revenue",
    cast(coalesce(cs.renewal_7_revenue, 0) * 0.82 as integer) as "Renewal 7 Revenue",
    cast(coalesce(cs.renewal_8_revenue, 0) * 0.82 as integer) as "Renewal 8 Revenue",
    cast(coalesce(cs.renewal_9_revenue, 0) * 0.82 as integer) as "Renewal 9 Revenue",
    cast(coalesce(cs.renewal_10_revenue, 0) * 0.82 as integer) as "Renewal 10 Revenue",
    cast(coalesce(cs.renewal_11_revenue, 0) * 0.82 as integer) as "Renewal 11 Revenue",
    cast(coalesce(cs.renewal_12_revenue, 0) * 0.82 as integer) as "Renewal 12 Revenue",
    cast(coalesce(cs.renewal_13_revenue, 0) * 0.82 as integer) as "Renewal 13 Revenue",
    cast(coalesce(cs.renewal_14_revenue, 0) * 0.82 as integer) as "Renewal 14 Revenue",
    cast(coalesce(cs.renewal_15_revenue, 0) * 0.82 as integer) as "Renewal 15 Revenue",
    cast(coalesce(cs.renewal_16_revenue, 0) * 0.82 as integer) as "Renewal 16 Revenue",
    cast(coalesce(cs.renewal_17_revenue, 0) * 0.82 as integer) as "Renewal 17 Revenue",
    cast(coalesce(cs.renewal_18_revenue, 0) * 0.82 as integer) as "Renewal 18 Revenue",
    cast(coalesce(cs.renewal_19_revenue, 0) * 0.82 as integer) as "Renewal 19 Revenue",
    cast(coalesce(cs.renewal_20_revenue, 0) * 0.82 as integer) as "Renewal 20 Revenue",
    cast(coalesce(cs.renewal_21_revenue, 0) * 0.82 as integer) as "Renewal 21 Revenue",
    cast(coalesce(cs.renewal_22_revenue, 0) * 0.82 as integer) as "Renewal 22 Revenue",
    cast(coalesce(cs.renewal_23_revenue, 0) * 0.82 as integer) as "Renewal 23 Revenue",
    cast(coalesce(cs.renewal_24_revenue, 0) * 0.82 as integer) as "Renewal 24 Revenue",
    cast(coalesce(cs.renewal_25_revenue, 0) * 0.82 as integer) as "Renewal 25 Revenue",
    cast(coalesce(cs.renewal_26_revenue, 0) * 0.82 as integer) as "Renewal 26 Revenue",
    cast(coalesce(cs.renewal_27_revenue, 0) * 0.82 as integer) as "Renewal 27 Revenue",
    cast(coalesce(cs.renewal_28_revenue, 0) * 0.82 as integer) as "Renewal 28 Revenue",
    cast(coalesce(cs.renewal_29_revenue, 0) * 0.82 as integer) as "Renewal 29 Revenue",
    cast(coalesce(cs.renewal_30_revenue, 0) * 0.82 as integer) as "Renewal 30 Revenue",
    cast(coalesce(cs.renewal_31_revenue, 0) * 0.82 as integer) as "Renewal 31 Revenue",
    cast(coalesce(cs.renewal_32_revenue, 0) * 0.82 as integer) as "Renewal 32 Revenue",
    cast(coalesce(cs.renewal_33_revenue, 0) * 0.82 as integer) as "Renewal 33 Revenue",
    cast(coalesce(cs.renewal_34_revenue, 0) * 0.82 as integer) as "Renewal 34 Revenue",
    cast(coalesce(cs.renewal_35_revenue, 0) * 0.82 as integer) as "Renewal 35 Revenue"
from total_trials t
left join
    cohort_summary cs
    on t.trial_start_month = cs.trial_start_month
    and t.plan_type = cs.plan_type
    and t.actual_price = cs.actual_price

left join
    active_mandates_at_trial atm
    on t.trial_start_month = atm.trial_start_month
    and t.plan_type = atm.plan_type
    and t.actual_price = atm.actual_price
left join
    current_active_mandate_users camu
    on t.trial_start_month = camu.trial_start_month
    and t.plan_type = camu.plan_type
    and t.actual_price = camu.actual_price
where
    t.trial_start_month >= date_trunc('month', dateadd(month, -48, current_date()))
    and t.trial_start_month < date_trunc('month', current_date)
    and t.plan_type = 'Monthly'
    and t.actual_price = 99
order by 1 desc, 2 desc, 3 desc
