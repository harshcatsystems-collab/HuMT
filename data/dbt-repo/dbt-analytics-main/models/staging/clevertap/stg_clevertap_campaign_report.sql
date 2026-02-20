-- File: models/staging/clevertap/stg_clevertap__clevertap_campaign_report.sql

with 
source as (

    -- Reference the raw source table defined in your sources.yml
    select * from {{ source('clevertap', 'clevertap_campaign_report') }}

),

--
renamed as (

    select
        -- 1. Primary Key and Identifiers (Rename and Standardize)
        "CAMPAIGN ID" as campaign_id,
        "CAMPAIGN NAME" as campaign_name,
        channel as campaign_channel,
        type as campaign_type,
        variant as campaign_variant,
        status as campaign_status,
        os as operating_system, -- Added OS

        -- 2. Timestamps and Dates (Standardize and Cast)
        cast(data_date as date) as report_run_date,

        -- Combine start date and time into a single timestamp
        try_to_timestamp_ntz(
            coalesce("START DATE" || ' ' || "START TIME", "START DATE")
        ) as campaign_start_at,

        cast("END DATE" as date) as campaign_end_date,
        cast("CREATED TIME" as timestamp_tz) as campaign_created_at,

        -- 3. Core Metrics - USER COUNT (Rename and Cast to Numeric/Integer)
        try_to_number(trim("TOTAL SENT(USERS)")) as total_sent_users,
        try_to_number(trim("TOTAL VIEWED(USERS)")) as total_viewed_users,
        try_to_number(trim("TOTAL CLICKED(USERS)")) as total_clicked_users,
        try_to_number(trim("TOTAL DELIVERED(USERS)")) as total_delivered_users,

        -- 4. Core Metrics - EVENT COUNT (Rename and Cast)
        try_to_number(trim("TOTAL SENT(EVENTS)")) as total_sent_events,
        try_to_number(trim("TOTAL VIEWED(EVENTS)")) as total_viewed_events,
        try_to_number(trim("TOTAL CLICKED(EVENTS)")) as total_clicked_events,
        try_to_number(trim("TOTAL DELIVERED(EVENTS)")) as total_delivered_events,

        -- 5. Conversion Metrics
        try_to_number(trim("CLICK THROUGH CONVERSIONS")) as click_through_conversions,
        try_to_number(trim("CLICK THROUGH CONVERSIONS %")) as click_through_conversion_pct,
        try_to_number(trim("TOTAL UNSUBSCRIBES")) as total_unsubscribes,

        -- 6. Other Key Metadata
        "CREATED BY" as created_by_user,
        "CONVERSION EVENT" as conversion_event_name,
        try_to_number(trim("CONVERSION TIME (IN MINUTES)")) as conversion_window_minutes,

        -- Source System Metadata
        data_date as raw_data_date,
        ingestion_timestamp as ingestion_timestamp_utc

    from source

)

--
select * 
from 
    renamed