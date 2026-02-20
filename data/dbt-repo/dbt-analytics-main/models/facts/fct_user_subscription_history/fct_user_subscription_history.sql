with

-- 
user_subscription_history as (
    select * from {{ ref('stg_mongo_usersubscriptionhistory') }}
),

-- Add columns helpful for plan categorisation
ordered_user_subscription_history as (
    select
        *,

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
        user_subscription_history

    where
        is_valid_vendor
        and lower(plan_id) not like 'resume_trial%'
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

),

subs_flag as (
    select 
        f.*,
        case
            when plan_category = 'New Subscription' then
            case
                when SUM(case when plan_category = 'New Subscription' then 1 else 0 end)
                over (
                partition by user_id
                order by created_at_ist
               rows between unbounded preceding and 1 preceding
               ) > 0
            then 1 else 0
            end
        else null
    end as sub_count,

  -- Only show trial_count for subscription rows
        case
            when plan_category = 'New Subscription' then
            case
                when SUM(case when plan_category = 'Trial' then 1 else 0 end)
                over (
                partition by user_id
                order by created_at_ist
                rows between unbounded preceding and 1 preceding
                ) > 0
            then 1 else 0
            end
        else null
    end as trial_count

    from  
        
        final_categorization f

 )

-- Bifurcating users basis subscription history
    select 
        *, 
        case
            when plan_category = 'New Subscription' then 
            case
                when sub_count = 1 AND trial_count = 1 then 'trial_returning_user'
                when sub_count = 1 AND trial_count = 0 then 'direct_returning_user'
                when sub_count = 0 AND trial_count = 1 then 'trial_autopay_user'
                when sub_count = 0 AND trial_count = 0 then 'direct_autopay_user'
            end
        else null
    end AS subscription_user_type
from 
    subs_flag 
--
