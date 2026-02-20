-- users table in mongo db
with users as (
    select
        _id,
        userculture,
        primarylanguage
    from 
        {{ source('mongo', 'users') }} 
),

-- user subscription history
sub as (
    select 
        * from 
        {{ ref('fct_user_subscription_history') }}
),

-- user watch history daily
wtc as (
    select 
        * 
        from 
        {{ ref('fct_user_content_watch_daily') }}
),

-- content dimension
content as (
    select 
        *
    from 
        {{ref('dim_content')}}
),

-- base of all trial users
trial_base as (
    select
        user_id,
        min(date(created_at_ist)) as trial_start_date,
        primary_dialect
    from 
        sub
    where
        is_valid_vendor
        and is_trial = true
    group by
        user_id,
        primary_dialect
),

-- a table of 7 days to cross join with trial users
days as (
    select
        seq4() as day_offset
    from 
        table(generator(rowcount => 7))
),

-- a table with each user's trial day
final_trial_base as (
    select
        ftb.user_id,
        ftb.trial_start_date,
        ftb.primary_dialect,
        dateadd(day, d.day_offset, ftb.trial_start_date) as date_in_trial,
        'd' || d.day_offset as tag
    from 
        trial_base as ftb
    cross join 
        days as d
),

-- content metadata
bbb_md as (
    select 
        content_id,
        show_slug,
        coalesce(total_show_duration_sec, duration_sec) as total_show_duration_sec
    from 
        content
    where 
        content_status = 'active' 
        and content_id != 0
),

-- watch data aggregated for completion analysis
watch_data_for_completion as (
    select
        user_id,
        watch_date,
        1 as active_flag,
        count(distinct show_slug) as title_started,
        sum(daily_watched_time_sec) as daily_watch_time
    from (
        select
            w.user_id,
            w.watch_date,
            bmd.show_slug,
            bmd.total_show_duration_sec,
            sum(w.watched_time_sec) as daily_watched_time_sec
        from 
            wtc as w
        join 
            bbb_md as bmd 
            on w.content_id = bmd.content_id
        group by 
            w.user_id,
            w.watch_date,
            bmd.show_slug,
            bmd.total_show_duration_sec
    )
    group by 
        user_id,
        watch_date,
        active_flag
),

-- combine trial base with watch data
raw_base as (
    select 
        a.*,
        coalesce(b.title_started,0) as title_started,
        (coalesce(b.daily_watch_time,0)/60) as watch_in_mins,
        coalesce(b.active_flag,0) as active_flag
    from 
        final_trial_base as a
    left join 
        watch_data_for_completion as b 
        on a.user_id = b.user_id 
        and a.date_in_trial = b.watch_date
),

-- identify aha moment users (active for >= 4 days)
aha_base as (
    select 
        user_id,
        1 as aha_flag,
        count(active_flag) as active_days
    from 
        raw_base
    where 
        active_flag = 1
    group by 
        1,
        2
    having 
        active_days >= 4
),

-- final raw data with aha moment flag
final_raw as (
    select 
        a.*,
        coalesce(b.aha_flag,0) as aha_flag
    from 
        raw_base as a 
    left join 
        aha_base as b 
        on a.user_id = b.user_id
),

-- categorize d0 watch and title started metrics
d0_base as (
    select 
        user_id,
        trial_start_date,
        date_in_trial,
        tag,
        primary_dialect,
        watch_in_mins,
        title_started,
        active_flag,
        aha_flag,
        case
            when watch_in_mins <1 and tag='d0' then '0 mins'
            when watch_in_mins >=1 and watch_in_mins<=5 and tag='d0' then '1 to 5 mins'
            when watch_in_mins >5 and watch_in_mins<=10 and tag='d0' then '6 to 10 mins'
            when watch_in_mins >10 and watch_in_mins<=15 and tag='d0' then '11 to 15 mins'
            when watch_in_mins >15 and watch_in_mins<=20 and tag='d0' then '16 to 20 mins'
            when watch_in_mins >20 and watch_in_mins<=25 and tag='d0' then '21 to 25 mins'
            when watch_in_mins >25 and watch_in_mins<=30 and tag='d0' then '26 to 30 mins'
            when watch_in_mins >30 and watch_in_mins<=35 and tag='d0' then '31 to 35 mins'
            when watch_in_mins >35 and watch_in_mins<=40 and tag='d0' then '36 to 40 mins'
            when watch_in_mins >40 and watch_in_mins<=45 and tag='d0' then '41 to 45 mins'
            when watch_in_mins >45 and watch_in_mins<=50 and tag='d0' then '46 to 50 mins'
            when watch_in_mins >50 and watch_in_mins<=55 and tag='d0' then '51 to 55 mins'
            when watch_in_mins >55 and watch_in_mins<=60 and tag='d0' then '56 to 60 mins'
            when watch_in_mins >60 and watch_in_mins<=75 and tag='d0' then '61 to 75 mins'
            when watch_in_mins >75 and watch_in_mins<=90 and tag='d0' then '76 to 90 mins'
            when watch_in_mins >90 and watch_in_mins<=105 and tag='d0' then '91 to 105 mins'
            when watch_in_mins >105 and watch_in_mins<=120 and tag='d0' then '106 to 120 mins'
            when watch_in_mins >120 and tag='d0' then '120+ mins'
        end as watch_bucket,
        case
            when title_started = 0 and tag='d0' then '0'
            when title_started = 1 and tag='d0' then '1'
            when title_started = 2 and tag='d0' then '2'
            when title_started = 3 and tag='d0' then '3'
            when title_started = 4 and tag='d0' then '4'
            when title_started = 5 and tag='d0' then '5'
            when title_started = 6 and tag='d0' then '6'
            when title_started = 7 and tag='d0' then '7'
            when title_started = 8 and tag='d0' then '8'
            when title_started = 9 and tag='d0' then '9'
            when title_started = 10 and tag='d0' then '10'
            when title_started > 10 and tag='d0' then '>=11'
        end as title_started_bucket
    from 
        final_raw
),

-- final data with d0 intent bucket assigned based on combined metrics
final_base_data_d0 as (
    select 
        *,
        case 
            when watch_bucket in ('120+ mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('10') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('9') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('8') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('7') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('6') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('5') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('4') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('3') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('2') and tag='d0' then  'very high'
            when watch_bucket in ('120+ mins') and title_started_bucket in ('1') and tag='d0' then  'very high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('10') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('10') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('10') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('9') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('9') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('9') and tag='d0' then  'high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('9') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('8') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('8') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('8') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('7') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('7') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('7') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('6') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('6') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('6') and tag='d0' then  'high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('6') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('5') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('5') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('5') and tag='d0' then  'high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('4') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('4') and tag='d0' then  'high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('4') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('4') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('4') and tag='d0' then  'high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('3') and tag='d0' then  'high'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('2') and tag='d0' then  'high'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('10') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('10') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('10') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('9') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('9') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('9') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('8') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('8') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('8') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('7') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('7') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('7') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('6') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('6') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('6') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('5') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('5') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('5') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('4') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('4') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('4') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('3') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('3') and tag='d0' then  'medium'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('3') and tag='d0' then  'medium'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('2') and tag='d0' then  'medium'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('2') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('2') and tag='d0' then  'medium'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('2') and tag='d0' then  'medium'
            when watch_bucket in ('61 to 75 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('76 to 90 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('91 to 105 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('106 to 120 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('51 to 55 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('56 to 60 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('36 to 40 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('31 to 35 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('41 to 45 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('26 to 30 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('21 to 25 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('16 to 20 mins') and title_started_bucket in ('1') and tag='d0' then  'medium'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('10') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('10') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('9') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('9') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('8') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('8') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('7') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('7') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('6') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('6') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('5') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('5') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('4') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('4') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('3') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('3') and tag='d0' then  'low'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('2') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('2') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('2') and tag='d0' then  'low'
            when watch_bucket in ('46 to 50 mins') and title_started_bucket in ('1') and tag='d0' then  'low'
            when watch_bucket in ('11 to 15 mins') and title_started_bucket in ('1') and tag='d0' then  'low'
            when watch_bucket in ('6 to 10 mins') and title_started_bucket in ('1') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('1') and tag='d0' then  'low'
            when watch_bucket in ('1 to 5 mins') and title_started_bucket in ('1') and tag='d0' then  'low'
            when watch_bucket in ('0 mins') and title_started_bucket in ('0') and tag='d0' then  'low'
            when title_started_bucket in ('>=11') and tag='d0' then  'high'
        end as d0_intent_bucket
    from 
        d0_base
)

select * from 
    final_base_data_d0
