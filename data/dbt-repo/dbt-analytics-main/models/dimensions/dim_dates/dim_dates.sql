with

--
dates_spine as (
    {{ 
        dbt_utils.date_spine(
            datepart="day",
            start_date="cast('1900-01-01' as date)",
            end_date="cast('2100-01-01' as date)"
        )
    }}
),

--
dates_spine_with_added_columns as (
    select
        date_day as base_date,

        date_trunc('week', base_date) as calendar_week,
        date_trunc('month', base_date) as calendar_month,
        date_trunc('quarter', base_date) as calendar_quarter,
        date_trunc('year', base_date) as calendar_year,

        dayname(base_date) as day_name,
        monthname(base_date) as month_name,

        dayofweekiso(base_date) as day_of_week,
        dayofmonth(base_date) as day_of_month,
        dayofyear(base_date) as day_of_year,

        weekofyear(base_date) as week_of_year,
        month(base_date) as month_of_year,
        quarter(base_date) as quarter_of_year,
        year(base_date) as year_number,

        day_name not in ('Sat', 'Sun') as is_weekday
    
    from
        dates_spine
)

--
select * from dates_spine_with_added_columns