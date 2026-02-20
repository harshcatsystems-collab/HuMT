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
thumbnail_viewed_metric as (
    select
        date(sent_at) as report_date,

        user_id,
        content_id,
        content_slug,
        root_widget_title as widget_name,
        root_widget_position as widget_position,
        root_widget_key as widget_key,
        show_format,
        child_widget_title as thumbnail_name,
        child_widget_col_position as thumbnail_column_position,
        child_widget_row_position as thumbnail_row_position,

        count(*) as total_views
    
    from 
        thumbnail_viewed

    group by 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
),

--
thumbnail_clicked_metric as (
    select
        date(sent_at) as report_date,

        user_id,
        content_id,
        content_slug,
        root_widget_title as widget_name,
        root_widget_position as widget_position,
        root_widget_key as widget_key,
        show_format,
        child_widget_title as thumbnail_name,
        child_widget_col_position as thumbnail_column_position,
        child_widget_row_position as thumbnail_row_position,

        count(*) as total_clicks

    from 
        thumbnail_clicked

    group by 
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
),

--
aggregated_thumbnail_interaction_data as (
    select
        viewed_data.report_date,
        viewed_data.user_id,
        viewed_data.content_id,
        viewed_data.content_slug,
        viewed_data.widget_name,
        viewed_data.widget_position,
        viewed_data.widget_key,
        viewed_data.show_format,
        viewed_data.thumbnail_name,
        viewed_data.thumbnail_column_position,
        viewed_data.thumbnail_row_position,

        viewed_data.total_views,


        coalesce (clicked_data.total_clicks, 0) as total_clicks
        
    from 
        thumbnail_viewed_metric as viewed_data

    left join 
        thumbnail_clicked_metric as clicked_data
            on viewed_data.report_date = clicked_data.report_date
                and viewed_data.user_id = clicked_data.user_id
                and viewed_data.widget_name = clicked_data.widget_name
                and viewed_data.widget_key = clicked_data.widget_key
                and viewed_data.show_format = clicked_data.show_format
                and viewed_data.widget_position = clicked_data.widget_position
                and viewed_data.content_slug = clicked_data.content_slug
                and viewed_data.thumbnail_name = clicked_data.thumbnail_name
                and viewed_data.thumbnail_column_position = clicked_data.thumbnail_column_position
                and viewed_data.thumbnail_row_position = clicked_data.thumbnail_row_position
)

--
select * from aggregated_thumbnail_interaction_data