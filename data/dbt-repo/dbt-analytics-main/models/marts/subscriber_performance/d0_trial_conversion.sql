{{
  config(
    materialized='table'
  )
}}

with

fct_usersubscription_history as (
    select * from {{ ref('fct_user_subscription_history') }}
),

mastermandates as (
    select * from {{ source('mongo', 'mastermandates') }}
),

base as (
    select 
        _id, 
        user_id, 
        subscription_start_at_ist, 
        subscription_end_at_ist, 
        plan_id, 
        plan_category,
        master_mandate_id, 
        paying_price,
        date(subscription_end_at_ist) as trial_ended_day,
        lead(paying_price) over(partition by user_id order by created_at_ist) as next_paying_price,
        lead(plan_category) over(partition by user_id order by created_at_ist) as next_plan_category,
        lead(created_at_ist) over(partition by user_id order by created_at_ist) as next_subscription_start,
        date(next_subscription_start) as next_subscription_start_day,
        case
            when next_plan_category = 'New Subscription'
                and (next_subscription_start <= subscription_end_at_ist 
                     or date(subscription_end_at_ist) = date(next_subscription_start))
            then true
            else false
        end as is_included
    from fct_usersubscription_history
    where is_valid_vendor
        and subscription_end_at_ist > current_date - interval '30 days'
),

next_plan_price as (
    select 
        plan_id, 
        max(next_paying_price) as next_paying_price 
    from base 
    where plan_category = 'Trial' 
    group by 1
),

status_history as (
    select 
        _id, 
        min(status_time) as status_time 
    from (
        select
            m._id,
            m.user as user_id,
            m.pgname,
            m.maxamount,
            f.value:status as status,
            date(f.value:time::timestamp_ntz) as status_time
        from mastermandates m,
            lateral flatten(input => m.statushistory) f
    )
    where (lower(status) like '%mandate_revoked%' or lower(status) like '%mandate_paused%')
        and status_time > current_date - interval '90 days'
    group by 1
)

select
    trial_ended_day,
    count(distinct b._id) as trials_ended,
    count(distinct case when is_included then b._id end) as conversion_count,
    count(distinct case
        when sh._id is not null and b.next_subscription_start is null
        then b._id
    end) as trials_paused_revoked,
    (conversion_count * 100.00 / trials_ended) as conversion_percentage,
    sum(case
        when is_included then b.next_paying_price
        when next_plan_category is null then coalesce(npp.next_paying_price, 0)
    end) as estimated_revenue,
    sum(case
        when is_included then b.next_paying_price
    end) as actual_revenue,
    (trials_paused_revoked * 100.00 / trials_ended) as paused_revoked_percentage
from base b
left join next_plan_price npp 
    on npp.plan_id = b.plan_id
left join status_history sh 
    on sh._id = b.master_mandate_id
    and date(sh.status_time) < date(b.subscription_end_at_ist)
where trial_ended_day <= date_trunc('day', current_date)
    and trial_ended_day > current_date - interval '30 days'
    and plan_category = 'Trial'
group by 1