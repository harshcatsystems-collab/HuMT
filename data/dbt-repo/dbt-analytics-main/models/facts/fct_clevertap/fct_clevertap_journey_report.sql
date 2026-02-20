
-- 1. Get Journey Flow Data
with 
journey_report as (

    select * 
    from 
        {{ ref('stg_clevertap_journey_report') }}

),

--
raw_fct as (

    select
        -- PRIMARY KEYS / GRAIN
        r.journey_node_pk, -- Surrogate PK for the node entry
        r.raw_data_date as report_date, -- Use raw_data_date as the reporting date

        r.journey_id,
        r.version_number,
        r.node_id,

        -- FOREIGN KEYS
        r.campaign_or_segment_id as fk_campaign_id, -- Links to dim_campaign

        -- ATTRIBUTES (Kept for immediate context)
        r.node_type,
        r.previous_node_id,

        -- METRICS (The Flow Numbers!)
        r.users_moved_forward,
        r.users_moved_forward_yes,
        r.users_moved_forward_no,
        r.users_timeout_journey,
        r.users_completed_journey,

        -- Node-level Campaign Metrics (if applicable)
        r.total_sent,
        r.total_clicked,
        r.total_delivered,

        -- Goal Metrics
        r.goal_1_conversions,
        r.users_goal_met
        
    from 
        journey_report r
)

--
select * 
from 
    raw_fct