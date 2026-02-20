with

-- 
user_subscription_history as (
    select * from {{ ref('stg_mongo_usersubscriptionhistory') }}
),

dim_vendor as (
    select 
        vendor as partner_vendor 
    from    
        {{ ref('dim_vendors_partners') }} 
    where 
        is_partner
),
-- Add columns helpful for plan categorisation
ordered_user_subscription_history as (
    select
        ush.*,

        row_number() over (
            partition by user_id
            order by created_at_ist asc
        ) as plan_order,

        first_value(dialect) over (
            partition by user_id
            order by created_at_ist asc
        ) as primary_dialect,

        lag(is_trial) over (
            partition by user_id 
            order by created_at_ist
        ) as prev_is_trial,

        lag(plan_id) over (
            partition by user_id 
            order by created_at_ist
        ) as prev_plan_id
    
    from
        user_subscription_history as ush 
    join 
        dim_vendor as vndr
    on ush.vendor = vndr.partner_vendor
    where
        lower(plan_id) not like 'resume_trial%'
),

-- Final categorization with all categories in one place
final_categorization as (
    select
        *,

        case
            when is_trial = true
            then 'Trial'

            when plan_order = 1 or (prev_is_trial = true and is_trial = false) 
            then 'New Subscription' 

            else 'Renewal'
        end as plan_category

    from
        ordered_user_subscription_history
)
--
select * from final_categorization
