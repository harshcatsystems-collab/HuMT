with

--
playback_pulse as (
    select * from {{ ref('stg_events_playback_pulse') }}
)

--
select * from playback_pulse