-- File: models/staging/clevertap/stg_clevertap__clevertap_journey_report.sql

with 
source as (

    -- Reference the raw source table defined in your sources.yml
    select * from {{ source('clevertap', 'clevertap_journey_report') }}

),

--
renamed as (

    select
        -- 1. Primary Keys & Identifiers
        "JOURNEY ID" as journey_id,
        "JOURNEY NAME" as journey_name,
        "VERSION NUMBER" as version_number,
        "VERSION NAME" as version_name,
        "NODE ID" as node_id,
        "NODE TYPE" as node_type,

        -- Surrogate Primary Key for this report line item
        "JOURNEY ID" || '-' || "VERSION NUMBER" || '-' || "NODE ID" as journey_node_pk,

        -- 2. Timestamps and Dates
        try_to_timestamp_ntz("JOURNEY START TIME") as journey_start_at,
        try_to_timestamp_ntz("JOURNEY END TIME") as journey_end_at,
        try_to_timestamp_ntz("VERSION PUBLISHED ON") as version_published_at,

        -- 3. Node and Campaign Details
        "PREVIOUS NODE" as previous_node_id,
        "CAMPAIGN / SEGMENT / CONTROLLER ID" as campaign_or_segment_id,
        "CAMPAIGN / SEGMENT / CONTROLLER NAME" as campaign_or_segment_name,
        "CHANNEL / SEGMENT / CONTROLLER TYPE" as node_target_type,

        -- 4. Funnel Metrics (Standardize and Cast to Numeric)
        try_to_number(trim("MOVED FORWARD")) as users_moved_forward,
        try_to_number(trim("MOVED FORWARD VIA YES")) as users_moved_forward_yes,
        try_to_number(trim("MOVED FORWARD VIA NO")) as users_moved_forward_no,
        try_to_number(trim("JOURNEY TIMEOUT")) as users_timeout_journey,
        try_to_number(trim(completed)) as users_completed_journey,

        -- 5. Campaign Metrics at the Node 
        try_to_number(trim("TOTAL SENT")) as total_sent,
        try_to_number(trim("TOTAL DELIVERED")) as total_delivered,
        try_to_number(trim("TOTAL VIEWED")) as total_viewed,
        try_to_number(trim("TOTAL CLICKED")) as total_clicked,
        try_to_number(trim("TOTAL UNSUBSCRIBES")) as total_unsubscribes,

        -- 6. Goal Metrics (Primary Goals)
        "GOAL 1 NAME" as goal_1_name,
        try_to_number(trim("GOAL 1 CONVERSIONS")) as goal_1_conversions,
        try_to_number(trim("GOAL MET")) as users_goal_met,

        -- 7. Metadata
        "VERSION STATUS" as version_status,
        data_date as raw_data_date,
        ingestion_timestamp as ingestion_timestamp_utc

    from source

)

--
select * 
from 
    renamed