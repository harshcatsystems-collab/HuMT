with

--
mongo_user_data as (
    select 
        user_id, ip_address
    from 
        {{ ref('stg_mongo_users') }}
    where
        ip_address is not null
),

--
app_open_events as (
    select
        user_id, geo_ip, event_at 
    from 
        {{ ref('stg_events_app_open') }} 
    where 
        geo_ip is not null
),

--
latest_user_app_open as (
    select
        user_id,
        geo_ip
    
    from
        app_open_events

    qualify
        row_number() over (
            partition by user_id
            order by event_at desc
        ) = 1
),

--
combined_user_ip_list as (
    select
        coalesce(ao.user_id, mud.user_id) as user_id,
        coalesce(ao.geo_ip, mud.ip_address) as ip_address

    from
        latest_user_app_open as ao
    full outer join
        mongo_user_data as mud
            on ao.user_id = mud.user_id
)

-- --
-- user_location_from_maxmind as (
--     select
--         user_id,
--         ip_address,

--         geo.geoname_id,
--         geo.postal_code,
--         geo.latitude,
--         geo.longitude

--     from
--         combined_user_ip_list,
--     lateral 
--         ANALYTICS_DEV.UTILS.GET_GEOLITE_CITY_BLOCKS(ip_address) AS geo
-- ),

-- --
-- user_location_with_h3_and_geonames as (
--     select
--         loc.user_id,

--         geoname.city_name,
--         geoname.subdivision_1_name as state_name,
--         geoname.country_name,
--         geoname.country_iso_code,

--         analytics_utils.h3_cell(loc.latitude, loc.longitude, 4) as res_4_h3_cell_hex,
--         analytics_utils.h3_cell(loc.latitude, loc.longitude, 5) as res_5_h3_cell_hex
    
--     from
--         user_location_from_maxmind as loc
--     left join
--         maxmind_geolite.public.geolite_city_locations_en as geoname
--             using (geoname_id)

-- )

--
-- select * from user_location_with_h3_and_geonames
-- 
select * from combined_user_ip_list
