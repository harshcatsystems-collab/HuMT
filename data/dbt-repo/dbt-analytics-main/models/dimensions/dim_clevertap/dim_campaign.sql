with 
one_time_campaigns as (
    -- Source 1: ct_campaign_base (Static/Master Attributes)
    select
        campaign_id,
        journey_id,
        campaign_name,
        journey_name,
        campaign_channel,
        campaign_master_type, -- Use unique name for source clarity
        campaign_type,
        campaign_status,
        dialect,
        null as template_type,
        true as is_in_master_base,
        false as is_in_daily_schedule,
        campaign_start_dt,
        ingest_dt
    from 
        {{ ref('stg_clevertap_campaigns') }}
),

--
recurring_campaigns as (
    -- Source 2: ct_daily_push_noti (Daily Schedule Attributes)
    select
        campaign_id,
        null as journey_id,
        campaign_name,
        null as journey_name,
        null as campaign_channel,
        campaign_master_type,
        campaign_type,
        null as campaign_status,
        dialect, -- Use dialect from this source
        template_type,
        false as is_in_master_base,
        true as is_in_daily_schedule,
        campaign_start_dt,
        ingest_dt
    from 
        {{ ref('stg_clevertap_daily_campaigns') }}
),

--
union_data as (
    -- Combine all campaign IDs from both sources
    select * from one_time_campaigns
    union all
    select * from recurring_campaigns 
),

--
master_registry as (
    -- Aggregate and merge the attributes onto the distinct campaign ID
    select
        campaign_id,

        -- Coalesce static attributes (Master Base takes priority)
        max(journey_id) as journey_id,
        max(campaign_name) as campaign_name,
        max(journey_name) as journey_name,
        max(campaign_channel) as channel,
        max(campaign_master_type) as campaign_master_type,
        max(campaign_type) as campaign_type,
        max(campaign_status) as status,
        max(template_type) as template_type,
        -- Coalesce dialect, prioritizing master_base unless it's null
        coalesce(max(case when is_in_master_base then dialect end), max(dialect)) as dialect,

        -- Create flags to indicate presence in 2 sources
        max(is_in_master_base) as is_in_master_base,
        max(is_in_daily_schedule) as is_in_daily_schedule,
        max(campaign_start_dt) as campaign_start_dt,
        max(ingest_dt) as ingest_dt

    from 
        union_data
    group by 1 -- Group by campaign_id
)

--
select * 
from 
    master_registry