with 

-- 
events_nest_backend_app_uninstall as (
    select * from {{ ref('stg_events_nest_backend_app_uninstall') }}
),

--
events_backend_app_uninstall as (
    select * from {{ ref('stg_events_backend_app_uninstall') }}
),

--
events_app_uninstall as (
    select * from {{ ref('stg_events_app_uninstall') }}
),

--
engagement as (
    select * from {{ ref('fct_user_engagement') }}
),

--
uninstalls as 
(
    select 
        user_id,    
        max(last_uninstall_date) as last_uninstall_date 
    
    from 
    (
        select 
            user_id,
            max(date(original_timestamp_utc)) as last_uninstall_date 
        
        from 
            events_nest_backend_app_uninstall 
       group by 
            user_id

    union all  

        select 
            user_id,
            max(date(original_timestamp_utc)) as last_uninstall_date 
        
        from 
            events_backend_app_uninstall 
       group by 
            user_id

    union all 

       select 
           user_id,
           max(date(original_timestamp_utc)) as last_uninstall_date
        
        from 
           events_app_uninstall 
        group by 
           user_id
    )
    group by 
        user_id),

--
user_last_engagement as 
(
    select 
        user_id,
        max(report_date) as last_engagement_date 
    
    from 
        engagement
    group by 
        user_id
)


select 
    distinct uninst.user_id as user_id,
    'uninstalled' as app_status

from 
    uninstalls as uninst 

left join 
    user_last_engagement as engt 
    on 
        uninst.user_id = engt.user_id 
        and engt.last_engagement_date > uninst.last_uninstall_date

where 
    engt.last_engagement_date is null
