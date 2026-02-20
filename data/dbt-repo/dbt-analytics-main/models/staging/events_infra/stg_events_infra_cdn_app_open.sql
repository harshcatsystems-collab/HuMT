with 

--
source AS (
    select * from {{ source ('events_infra', 'app_open') }}
),

--
selected_and_renamed AS (
    select 
        "date" as event_date, 
        to_varchar("timestamp",'YYYY-MM-DD HH24:MI:SS') as event_at_utc,

        regexp_substr("cs_uri_query", 'userId=([^&]+)', 1, 1, 'e') AS user_id,
        regexp_substr("cs_uri_query", 'lang=([^&]+)', 1, 1, 'e') AS app_language,
        regexp_substr("cs_uri_query", 'dialect=([^&]+)', 1, 1, 'e') AS dialect,
        "c_country" as country,

        regexp_substr("cs_uri_query", 'deviceId=([^&]+)', 1, 1, 'e') AS device_id,
        regexp_substr("cs_uri_query", 'os=([^&]+)', 1, 1, 'e') AS os,
        regexp_substr("cs_uri_query", 'platform=([^&]+)', 1, 1, 'e') AS platform,
        regexp_substr("cs_uri_query", 'appId=([^&]+)', 1, 1, 'e') AS app_id,
        regexp_substr("cs_uri_query", 'appBuildNumber=([^&]+)', 1, 1, 'e') AS app_build_number
        
    from 
        source
)

--
select * from selected_and_renamed


