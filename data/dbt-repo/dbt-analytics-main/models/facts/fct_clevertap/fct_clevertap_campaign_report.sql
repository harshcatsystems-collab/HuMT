with 
-- 1. Get Daily Metrics (The Core Fact Data)
campaign_report as (
    select * 
    from 
        {{ ref('stg_clevertap_campaign_report') }}
),

--
raw_fct as (

    select
        -- PRIMARY KEYS / GRAIN
        r.campaign_id,
        r.report_run_date as report_date,

        -- FOREIGN KEY (Linking to Dimension)
        r.campaign_id as fk_campaign_id, -- Links to dim_campaign
        
        -- ATTRIBUTES
        r.operating_system,

        -- METRICS (The Numbers!)
        r.total_sent_users,
        r.total_viewed_users,
        r.total_clicked_users,
        r.total_delivered_users,
        r.total_unsubscribes,

        r.total_sent_events,
        r.total_viewed_events,
        r.total_clicked_events,
        
        r.click_through_conversions,
        
        r.ingestion_timestamp_utc as fact_ingestion_utc,
        r.raw_data_date

        
    from 
        campaign_report r
)

--
select * 
from 
    raw_fct   
