with

--
source as (
    select * from {{ source('mongo', 'shows') }}
),

--
renamed as (
    select
        _id::int as show_id,
    
        slug as show_slug,
        split(tags, ',') as show_tags,
    
        label,
        title,
        status,
        compliancerating as compliance_rating,
        selectedperipheral as selected_peripheral,
        
        language as show_dialect,
        displaylanguage as display_language,
    
        duration as duration_sec,

        seasoncount as count_seasons,
        episodecount as count_episodes,
        peripheralcount as count_peripherals,
        genrelist as genre_list,
        subgenrelist as sub_genre_list,
        description,
        
        startdate as started_at,
        enddate as ended_at

    from
        source
)

--
select * from renamed