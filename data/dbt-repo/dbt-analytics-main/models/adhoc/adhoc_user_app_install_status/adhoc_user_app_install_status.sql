-- this query builds a daily snapshot of each user's install status, correctly handling multiple devices.
-- the logic considers a user "uninstalled" only if they are uninstalled on all of their devices.

-- ctes for event sources
with 

-- gets the date range for the report.
dim_dates as (
    select 
        base_date as report_date
    from   
        {{ ref('dim_dates') }}
    where   
        base_date between '2025-02-01' and current_date
), 

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
    -- important: assuming the engagement fact table contains a device_id
    select * from {{ ref('fct_user_engagement') }}
),

bigquery_backup_20251001_TO_20251211 as (
    select * from SANDBOX.HARSHIT.BIGQUERY_UNINSTALL_EVENTS_BACKUP_20251001_TO_20251211
    where date(left(original_timestamp_utc,19)) >= '2025-10-01'
),

-- consolidate all key events (installs, uninstalls, engagements) at a device level.
all_device_events as (
 
    -- uninstalls mark the beginning of an 'uninstalled' state for a device
    select 
        user_id, 
        device_id, 
        date(original_timestamp_utc) as event_date, 
        'uninstalled' as event_type 
    from 
        events_nest_backend_app_uninstall
    where 
        date(original_timestamp_utc) < '2025-10-01' or date(original_timestamp_utc) > '2025-12-11'
    
    union all
    
    select 
        user_id, 
        device_id, 
        date(original_timestamp_utc) as event_date, 
        'uninstalled' as event_type 
    from 
        events_backend_app_uninstall
    where 
        date(original_timestamp_utc) < '2025-10-01' or date(original_timestamp_utc) > '2025-12-11'

    
    union all
    
    select 
        user_id, 
        device_id, 
        date(original_timestamp_utc) as event_date, 
        'uninstalled' as event_type 
    from 
        events_app_uninstall
    where 
        date(original_timestamp_utc) < '2025-10-01' or date(original_timestamp_utc) > '2025-12-11'

    union all

    -- uninstall events between '2025-10-01' and '2025-12-11' from bigquery

    select
        user_id,
        device_id,
        date(left(original_timestamp_utc,19)) as event_date,
        'uninstalled' as event_type
    from 
        bigquery_backup_20251001_TO_20251211

    union all

    -- any engagement on a device implies it is 'installed' on that date
    select
        user_id,
        device_id, -- assuming this column exists
        report_date as event_date,
        'installed' as event_type
    from engagement
),

-- for each day in our report, find the most recent event for each user's device that occurred on or before that day.
daily_device_status as (
    select
        d.report_date,
        e.user_id,
        e.device_id,
        -- this window function finds the most recent event for each device on each report_date
        first_value(e.event_type) over (partition by d.report_date, e.user_id, e.device_id order by e.event_date desc) as status
    from
        all_device_events e
    join
        dim_dates d on e.event_date < d.report_date
)

-- final step: aggregate the daily device statuses up to a final user status.
select
    s.report_date,
    s.user_id,
    -- if any device was 'installed' on a given day, the user is 'installed'.
    -- otherwise, if all their devices were 'uninstalled', the user is 'uninstalled'.
    case
        when sum(case when s.status = 'installed' then 1 else 0 end) > 0 then 'installed'
        else 'uninstalled'
    end as overall_user_status
from
    daily_device_status s
group by
    1, 2
order by
    report_date desc,
    user_id