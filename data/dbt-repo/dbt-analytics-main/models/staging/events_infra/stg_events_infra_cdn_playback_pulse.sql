with 

--
source AS (
    select * from {{ source ('events_infra', 'cdn_playback_log') }}
),

--
selected_and_renamed AS (
    select 
        -- Concat date and time to form timestamp
        to_timestamp(log_date || ' ' || log_time, 'YYYY-MM-DD HH24:MI:SS') AS event_timestamp_utc,

        edge_location,
        bytes_sent,
        client_ip,

        status_code,
        host,
        uri,
        uri_query,
        referer,
        user_agent,
        cookie,
        edge_result_type,

        bytes_received,
        time_taken,

        edge_response_result_type,

        time_to_first_byte,
        edge_detailed_result_type,

        content_length,

        -- Extracting show slug
        regexp_substr(uri, '/show/(.*)/episodes/', 1, 1, 'e') AS show_slug,

        -- Extracting content slug 
        regexp_substr(uri, '/HLS/(.*)_', 1, 1, 'e') AS content_slug,

        -- Extracting segment if present
        regexp_substr(uri, 'seg-\\d+') AS segment_name,
        try_to_number(split_part(segment_name, '-', -1)) as segment_index,

        -- Extracting log type based on URL structure
        case 
            when uri like '%.m3u8'
            then 'manifest'
            
            when uri like '%/audio/%' 
            then 'audio'

            when uri like '%/video/%'  
            then 'video'

            else 'unknown'
        end as file_type,

        -- Extract user_id , content_id and environment from uri_query using regexp_substr() with a capturing group
        regexp_substr(uri_query, 'uId=([^&]+)', 1, 1, 'e', 1) AS user_id,

        regexp_substr(uri_query, 'epId=([^&]+)', 1, 1, 'e', 1) AS content_id,
        
        regexp_substr(uri_query, 'env=([^&]+)', 1, 1, 'e', 1) AS environment
    
    from 
        source 
)

--
select * from selected_and_renamed