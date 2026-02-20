with

--
thumbnail_viewed as (
    select * from {{ ref('stg_events_thumbnail_viewed') }}
),

--
thumbnail_clicked as (
    select * from {{ ref('stg_events_thumbnail_clicked') }}
),

--
thumb_clicks as (
    select 
        content_slug, 
        thumbnail_path, 
        count(*) as click_count  
    
    from 
        analytics_prod.dbt_base.stg_events_thumbnail_clicked
    group by 
        1,2
    ),

--
thumb_views as (
    select 
        content_slug, 
        thumbnail_path, 
        count(*) as view_count  
    
    from 
        analytics_prod.dbt_base.stg_events_thumbnail_viewed
    group by 
        1,2
),

--
aggregated as (
    select 
        view_count,
        click_count,
        (click_count/ view_count)*100 as ctr,
        tv.content_slug,
        tv.thumbnail_path
    from 
        thumb_views as tv
    left join 
        thumb_clicks as tc
    on 
        tv.content_slug = tc.content_slug
    and
        tv.thumbnail_path = tc.thumbnail_path
    
    where 
        tv.content_slug is not null 
        and tv.thumbnail_path is not null
)

--
select * from aggregated