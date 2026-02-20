WITH install_cohort AS (
    SELECT 
        USER_ID,
        MEDIA_SOURCE,
        CAMPAIGN,
        AF_C_ID,
        AF_ADSET,
        AF_ADSET_ID,
        AF_AD,
        AF_AD_ID,
        AF_CHANNEL,
        EVENT_NAME,
        EVENT_TYPE,
        CONVERT_TIMEZONE('Asia/Kolkata', INSTALL_TIME) AS install_time_ist,
        DATE(CONVERT_TIMEZONE('Asia/Kolkata', INSTALL_TIME)) AS install_date
    FROM RAW_PROD.EVENTS_APPSFLYER.INSTALL
    WHERE  
        DATE(CONVERT_TIMEZONE('Asia/Kolkata', INSTALL_TIME)) >=
            DATEADD(day, -100, DATE(CONVERT_TIMEZONE('Asia/Kolkata', CURRENT_TIMESTAMP())))
),

-- ========== REGISTRATION ==========
registration_events AS (
    SELECT 
        r.USER_ID,
        r.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', r.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.AF_COMPLETE_REGISTRATION r
    INNER JOIN install_cohort ic ON r.USER_ID = ic.USER_ID AND r.CAMPAIGN = ic.CAMPAIGN
    WHERE r.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== START TRIAL ==========
start_trial_events AS (
    SELECT 
        st.USER_ID,
        st.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', st.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.AF_START_TRIAL st
    INNER JOIN install_cohort ic ON st.USER_ID = ic.USER_ID AND st.CAMPAIGN = ic.CAMPAIGN
    WHERE st.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== CHECKOUT ==========
checkout_events AS (
    SELECT 
        co.USER_ID,
        co.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', co.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.AF_INITIATED_CHECKOUT co
    INNER JOIN install_cohort ic ON co.USER_ID = ic.USER_ID AND co.CAMPAIGN = ic.CAMPAIGN
    WHERE co.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== SUBSCRIBED ==========
subscribed_events AS (
    SELECT 
        s.USER_ID,
        s.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', s.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.AF_SUBSCRIBE s
    INNER JOIN install_cohort ic ON s.USER_ID = ic.USER_ID AND s.CAMPAIGN = ic.CAMPAIGN
    WHERE s.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== D1 RETAINED ==========
d1_retained_events AS (
    SELECT 
        d1.USER_ID,
        d1.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', d1.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.D1_RETAINED_USER d1
    INNER JOIN install_cohort ic ON d1.USER_ID = ic.USER_ID AND d1.CAMPAIGN = ic.CAMPAIGN
    WHERE d1.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== D2 RETAINED ==========
d2_retained_events AS (
    SELECT 
        d2.USER_ID,
        d2.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', d2.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.D2_RETAINED_USER d2
    INNER JOIN install_cohort ic ON d2.USER_ID = ic.USER_ID AND d2.CAMPAIGN = ic.CAMPAIGN
    WHERE d2.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== D7 RETAINED ==========
d7_retained_events AS (
    SELECT 
        d7.USER_ID,
        d7.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', d7.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.D7_RETAINED_USER d7
    INNER JOIN install_cohort ic ON d7.USER_ID = ic.USER_ID AND d7.CAMPAIGN = ic.CAMPAIGN
    WHERE d7.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 4MIN ==========
watchtime_4min_events AS (
    SELECT 
        w4.USER_ID,
        w4.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w4.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_4MIN_ACHIEVED w4
    INNER JOIN install_cohort ic ON w4.USER_ID = ic.USER_ID AND w4.CAMPAIGN = ic.CAMPAIGN
    WHERE w4.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 8MIN ==========
watchtime_8min_events AS (
    SELECT 
        w8.USER_ID,
        w8.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w8.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_8MIN_ACHIEVED w8
    INNER JOIN install_cohort ic ON w8.USER_ID = ic.USER_ID AND w8.CAMPAIGN = ic.CAMPAIGN
    WHERE w8.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 12MIN ==========
watchtime_12min_events AS (
    SELECT 
        w12.USER_ID,
        w12.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w12.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_12MIN_ACHIEVED w12
    INNER JOIN install_cohort ic ON w12.USER_ID = ic.USER_ID AND w12.CAMPAIGN = ic.CAMPAIGN
    WHERE w12.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 20MIN ==========
watchtime_20min_events AS (
    SELECT 
        w20.USER_ID,
        w20.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w20.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_20_MIN_ACHIEVED w20
    INNER JOIN install_cohort ic ON w20.USER_ID = ic.USER_ID AND w20.CAMPAIGN = ic.CAMPAIGN
    WHERE w20.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 30MIN ==========
watchtime_30min_events AS (
    SELECT 
        w30.USER_ID,
        w30.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w30.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_30_MIN_ACHIEVED w30
    INNER JOIN install_cohort ic ON w30.USER_ID = ic.USER_ID AND w30.CAMPAIGN = ic.CAMPAIGN
    WHERE w30.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== WATCHTIME 60MIN ==========
watchtime_60min_events AS (
    SELECT 
        w60.USER_ID,
        w60.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', w60.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.WATCHTIME_60_MIN_ACHIEVED w60
    INNER JOIN install_cohort ic ON w60.USER_ID = ic.USER_ID AND w60.CAMPAIGN = ic.CAMPAIGN
    WHERE w60.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== FIRST TITLE COMPLETED ==========
first_title_events AS (
    SELECT 
        ft.USER_ID,
        ft.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', ft.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.FIRST_TITLE_COMPLETED ft
    INNER JOIN install_cohort ic ON ft.USER_ID = ic.USER_ID AND ft.CAMPAIGN = ic.CAMPAIGN
    WHERE ft.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== TRIAL PAYWALL ==========
trial_paywall_events AS (
    SELECT 
        tp.USER_ID,
        tp.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', tp.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.TRIAL_PAYWALL_VIEWED tp
    INNER JOIN install_cohort ic ON tp.USER_ID = ic.USER_ID AND tp.CAMPAIGN = ic.CAMPAIGN
    WHERE tp.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== TRIAL PAUSED ==========
trial_paused_events AS (
    SELECT 
        tpa.USER_ID,
        tpa.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', tpa.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.TRIAL_MANDATE_PAUSED tpa
    INNER JOIN install_cohort ic ON tpa.USER_ID = ic.USER_ID AND tpa.CAMPAIGN = ic.CAMPAIGN
    WHERE tpa.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== TRIAL REVOKED ==========
trial_revoked_events AS (
    SELECT 
        tr.USER_ID,
        tr.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', tr.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.TRIAL_MANDATE_REVOKED tr
    INNER JOIN install_cohort ic ON tr.USER_ID = ic.USER_ID AND tr.CAMPAIGN = ic.CAMPAIGN
    WHERE tr.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== SUB PAUSED ==========
sub_paused_events AS (
    SELECT 
        sp.USER_ID,
        sp.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', sp.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.SUBSCRIPTION_MANDATE_PAUSED sp
    INNER JOIN install_cohort ic ON sp.USER_ID = ic.USER_ID AND sp.CAMPAIGN = ic.CAMPAIGN
    WHERE sp.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== SUB REVOKED ==========
sub_revoked_events AS (
    SELECT 
        sr.USER_ID,
        sr.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', sr.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.SUBSCRIPTION_MANDATE_REVOKED sr
    INNER JOIN install_cohort ic ON sr.USER_ID = ic.USER_ID AND sr.CAMPAIGN = ic.CAMPAIGN
    WHERE sr.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== SUB RENEWED ==========
sub_renewed_events AS (
    SELECT 
        sn.USER_ID,
        sn.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', sn.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.SUBSCRIPTION_RENEWED sn
    INNER JOIN install_cohort ic ON sn.USER_ID = ic.USER_ID AND sn.CAMPAIGN = ic.CAMPAIGN
    WHERE sn.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== CONSUMPTION ==========
consumption_events AS (
    SELECT 
        c.USER_ID,
        c.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', c.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.CONSUMPTION_STARTED c
    INNER JOIN install_cohort ic ON c.USER_ID = ic.USER_ID AND c.CAMPAIGN = ic.CAMPAIGN
    WHERE c.IS_PRIMARY_ATTRIBUTION = TRUE
),

-- ========== AHA MOMENT ==========
aha_moment_events AS (
    SELECT 
        aha.USER_ID,
        aha.CAMPAIGN,
        DATEDIFF('day', ic.install_time_ist, CONVERT_TIMEZONE('Asia/Kolkata', aha.EVENT_TIME_SELECTED_TIMEZONE)) AS day_diff
    FROM RAW_PROD.EVENTS_APPSFLYER.AHA_MOMENT_ACHIEVED aha
    INNER JOIN install_cohort ic ON aha.USER_ID = ic.USER_ID AND aha.CAMPAIGN = ic.CAMPAIGN
    WHERE aha.IS_PRIMARY_ATTRIBUTION = TRUE
)

-- ========================================================================
-- FINAL SELECT WITH COHORT ANALYSIS
-- ========================================================================
SELECT
    ic.MEDIA_SOURCE,
    ic.CAMPAIGN,
    ic.AF_C_ID,
    ic.AF_ADSET,
    ic.AF_ADSET_ID,
    ic.AF_AD,
    ic.AF_AD_ID,
    ic.AF_CHANNEL,
    ic.EVENT_NAME,
    ic.EVENT_TYPE,
    ic.install_date AS INSTALL_DATE,
    
    -- ========== COHORT SIZE ==========
    COUNT(DISTINCT ic.USER_ID) AS COHORT_SIZE,
    
    -- ========== REGISTRATION COHORT ==========
    COUNT(DISTINCT CASE WHEN reg.day_diff = 0 THEN reg.USER_ID END) AS D0_REGISTRATION_USERS,
    COUNT(DISTINCT CASE WHEN reg.day_diff <= 1 THEN reg.USER_ID END) AS D1_REGISTRATION_USERS,
    COUNT(DISTINCT CASE WHEN reg.day_diff <= 7 THEN reg.USER_ID END) AS D7_REGISTRATION_USERS,
    COUNT(DISTINCT CASE WHEN reg.day_diff <= 30 THEN reg.USER_ID END) AS D30_REGISTRATION_USERS,
    
    -- ========== START TRIAL COHORT ==========
    COUNT(DISTINCT CASE WHEN st.day_diff = 0 THEN st.USER_ID END) AS D0_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 1 THEN st.USER_ID END) AS D1_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 2 THEN st.USER_ID END) AS D2_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 3 THEN st.USER_ID END) AS D3_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 7 THEN st.USER_ID END) AS D7_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 10 THEN st.USER_ID END) AS D10_START_TRIAL_USERS,
    COUNT(DISTINCT CASE WHEN st.day_diff <= 30 THEN st.USER_ID END) AS D30_START_TRIAL_USERS,
    
    -- ========== CHECKOUT COHORT ==========
    COUNT(DISTINCT CASE WHEN co.day_diff = 0 THEN co.USER_ID END) AS D0_CHECKOUT_USERS,
    COUNT(DISTINCT CASE WHEN co.day_diff <= 7 THEN co.USER_ID END) AS D7_CHECKOUT_USERS,
    COUNT(DISTINCT CASE WHEN co.day_diff <= 30 THEN co.USER_ID END) AS D30_CHECKOUT_USERS,
    
    -- ========== SUBSCRIBED COHORT ==========
    COUNT(DISTINCT CASE WHEN sub.day_diff = 0 THEN sub.USER_ID END) AS D0_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 1 THEN sub.USER_ID END) AS D1_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 7 THEN sub.USER_ID END) AS D7_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 10 THEN sub.USER_ID END) AS D10_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 30 THEN sub.USER_ID END) AS D30_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 60 THEN sub.USER_ID END) AS D60_SUBSCRIBED_USERS,
    COUNT(DISTINCT CASE WHEN sub.day_diff <= 90 THEN sub.USER_ID END) AS D90_SUBSCRIBED_USERS,
    
    -- ========== RETENTION COHORT ==========
    COUNT(DISTINCT CASE WHEN d1ret.day_diff <= 1 THEN d1ret.USER_ID END) AS D1_RETAINED_USERS,
    COUNT(DISTINCT CASE WHEN d2ret.day_diff <= 2 THEN d2ret.USER_ID END) AS D2_RETAINED_USERS,
    COUNT(DISTINCT CASE WHEN d7ret.day_diff <= 7 THEN d7ret.USER_ID END) AS D7_RETAINED_USERS,
    
    -- ========== WATCHTIME COHORT ==========
    COUNT(DISTINCT CASE WHEN wt4.day_diff = 0 THEN wt4.USER_ID END) AS D0_WATCHTIME_4MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt4.day_diff <= 7 THEN wt4.USER_ID END) AS D7_WATCHTIME_4MIN_USERS,
    
    COUNT(DISTINCT CASE WHEN wt8.day_diff = 0 THEN wt8.USER_ID END) AS D0_WATCHTIME_8MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt8.day_diff <= 7 THEN wt8.USER_ID END) AS D7_WATCHTIME_8MIN_USERS,
    
    COUNT(DISTINCT CASE WHEN wt12.day_diff = 0 THEN wt12.USER_ID END) AS D0_WATCHTIME_12MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt12.day_diff <= 7 THEN wt12.USER_ID END) AS D7_WATCHTIME_12MIN_USERS,
    
    COUNT(DISTINCT CASE WHEN wt20.day_diff = 0 THEN wt20.USER_ID END) AS D0_WATCHTIME_20MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt20.day_diff <= 7 THEN wt20.USER_ID END) AS D7_WATCHTIME_20MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt20.day_diff <= 30 THEN wt20.USER_ID END) AS D30_WATCHTIME_20MIN_USERS,
    
    COUNT(DISTINCT CASE WHEN wt30.day_diff = 0 THEN wt30.USER_ID END) AS D0_WATCHTIME_30MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt30.day_diff <= 7 THEN wt30.USER_ID END) AS D7_WATCHTIME_30MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt30.day_diff <= 30 THEN wt30.USER_ID END) AS D30_WATCHTIME_30MIN_USERS,
    
    COUNT(DISTINCT CASE WHEN wt60.day_diff = 0 THEN wt60.USER_ID END) AS D0_WATCHTIME_60MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt60.day_diff <= 7 THEN wt60.USER_ID END) AS D7_WATCHTIME_60MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt60.day_diff <= 30 THEN wt60.USER_ID END) AS D30_WATCHTIME_60MIN_USERS,
    COUNT(DISTINCT CASE WHEN wt60.day_diff <= 60 THEN wt60.USER_ID END) AS D60_WATCHTIME_60MIN_USERS,
    
    -- ========== FIRST TITLE COMPLETED COHORT ==========
    COUNT(DISTINCT CASE WHEN ft.day_diff = 0 THEN ft.USER_ID END) AS D0_FIRST_TITLE_USERS,
    COUNT(DISTINCT CASE WHEN ft.day_diff <= 7 THEN ft.USER_ID END) AS D7_FIRST_TITLE_USERS,
    COUNT(DISTINCT CASE WHEN ft.day_diff <= 30 THEN ft.USER_ID END) AS D30_FIRST_TITLE_USERS,
    
    -- ========== TRIAL PAYWALL COHORT ==========
    COUNT(DISTINCT CASE WHEN tp.day_diff = 0 THEN tp.USER_ID END) AS D0_TRIAL_PAYWALL_USERS,
    COUNT(DISTINCT CASE WHEN tp.day_diff <= 7 THEN tp.USER_ID END) AS D7_TRIAL_PAYWALL_USERS,
    COUNT(DISTINCT CASE WHEN tp.day_diff <= 30 THEN tp.USER_ID END) AS D30_TRIAL_PAYWALL_USERS,
    
    -- ========== CONSUMPTION COHORT ==========
    COUNT(DISTINCT CASE WHEN cons.day_diff = 0 THEN cons.USER_ID END) AS D0_CONSUMPTION_USERS,
    COUNT(DISTINCT CASE WHEN cons.day_diff <= 1 THEN cons.USER_ID END) AS D1_CONSUMPTION_USERS,
    COUNT(DISTINCT CASE WHEN cons.day_diff <= 7 THEN cons.USER_ID END) AS D7_CONSUMPTION_USERS,
    COUNT(DISTINCT CASE WHEN cons.day_diff <= 30 THEN cons.USER_ID END) AS D30_CONSUMPTION_USERS,
    
    -- ========== AHA MOMENT COHORT ==========
    COUNT(DISTINCT CASE WHEN aha.day_diff = 0 THEN aha.USER_ID END) AS D0_AHA_MOMENT_USERS,
    COUNT(DISTINCT CASE WHEN aha.day_diff <= 7 THEN aha.USER_ID END) AS D7_AHA_MOMENT_USERS,
    COUNT(DISTINCT CASE WHEN aha.day_diff <= 30 THEN aha.USER_ID END) AS D30_AHA_MOMENT_USERS,
    
    -- ========== CANCELLATION COHORT ==========
    COUNT(DISTINCT CASE WHEN tpa.day_diff <= 10 THEN tpa.USER_ID END) AS D10_TRIAL_PAUSED_USERS,
    COUNT(DISTINCT CASE WHEN trev.day_diff <= 10 THEN trev.USER_ID END) AS D10_TRIAL_REVOKED_USERS,
    COUNT(DISTINCT CASE WHEN sp.day_diff <= 30 THEN sp.USER_ID END) AS D30_SUB_PAUSED_USERS,
    COUNT(DISTINCT CASE WHEN srev.day_diff <= 30 THEN srev.USER_ID END) AS D30_SUB_REVOKED_USERS,
    
    -- ========== SUB RENEWED COHORT ==========
    COUNT(DISTINCT CASE WHEN snew.day_diff <= 30 THEN snew.USER_ID END) AS D30_SUB_RENEWED_USERS,
    COUNT(DISTINCT CASE WHEN snew.day_diff <= 60 THEN snew.USER_ID END) AS D60_SUB_RENEWED_USERS,
    COUNT(DISTINCT CASE WHEN snew.day_diff <= 90 THEN snew.USER_ID END) AS D90_SUB_RENEWED_USERS

FROM install_cohort ic

-- LEFT JOIN all event CTEs on USER_ID + CAMPAIGN
LEFT JOIN registration_events reg ON ic.USER_ID = reg.USER_ID AND ic.CAMPAIGN = reg.CAMPAIGN
LEFT JOIN start_trial_events st ON ic.USER_ID = st.USER_ID AND ic.CAMPAIGN = st.CAMPAIGN
LEFT JOIN checkout_events co ON ic.USER_ID = co.USER_ID AND ic.CAMPAIGN = co.CAMPAIGN
LEFT JOIN subscribed_events sub ON ic.USER_ID = sub.USER_ID AND ic.CAMPAIGN = sub.CAMPAIGN
LEFT JOIN d1_retained_events d1ret ON ic.USER_ID = d1ret.USER_ID AND ic.CAMPAIGN = d1ret.CAMPAIGN
LEFT JOIN d2_retained_events d2ret ON ic.USER_ID = d2ret.USER_ID AND ic.CAMPAIGN = d2ret.CAMPAIGN
LEFT JOIN d7_retained_events d7ret ON ic.USER_ID = d7ret.USER_ID AND ic.CAMPAIGN = d7ret.CAMPAIGN
LEFT JOIN watchtime_4min_events wt4 ON ic.USER_ID = wt4.USER_ID AND ic.CAMPAIGN = wt4.CAMPAIGN
LEFT JOIN watchtime_8min_events wt8 ON ic.USER_ID = wt8.USER_ID AND ic.CAMPAIGN = wt8.CAMPAIGN
LEFT JOIN watchtime_12min_events wt12 ON ic.USER_ID = wt12.USER_ID AND ic.CAMPAIGN = wt12.CAMPAIGN
LEFT JOIN watchtime_20min_events wt20 ON ic.USER_ID = wt20.USER_ID AND ic.CAMPAIGN = wt20.CAMPAIGN
LEFT JOIN watchtime_30min_events wt30 ON ic.USER_ID = wt30.USER_ID AND ic.CAMPAIGN = wt30.CAMPAIGN
LEFT JOIN watchtime_60min_events wt60 ON ic.USER_ID = wt60.USER_ID AND ic.CAMPAIGN = wt60.CAMPAIGN
LEFT JOIN first_title_events ft ON ic.USER_ID = ft.USER_ID AND ic.CAMPAIGN = ft.CAMPAIGN
LEFT JOIN trial_paywall_events tp ON ic.USER_ID = tp.USER_ID AND ic.CAMPAIGN = tp.CAMPAIGN
LEFT JOIN trial_paused_events tpa ON ic.USER_ID = tpa.USER_ID AND ic.CAMPAIGN = tpa.CAMPAIGN
LEFT JOIN trial_revoked_events trev ON ic.USER_ID = trev.USER_ID AND ic.CAMPAIGN = trev.CAMPAIGN
LEFT JOIN sub_paused_events sp ON ic.USER_ID = sp.USER_ID AND ic.CAMPAIGN = sp.CAMPAIGN
LEFT JOIN sub_revoked_events srev ON ic.USER_ID = srev.USER_ID AND ic.CAMPAIGN = srev.CAMPAIGN
LEFT JOIN sub_renewed_events snew ON ic.USER_ID = snew.USER_ID AND ic.CAMPAIGN = snew.CAMPAIGN
LEFT JOIN consumption_events cons ON ic.USER_ID = cons.USER_ID AND ic.CAMPAIGN = cons.CAMPAIGN
LEFT JOIN aha_moment_events aha ON ic.USER_ID = aha.USER_ID AND ic.CAMPAIGN = aha.CAMPAIGN

GROUP BY 1,2,3,4,5,6,7,8,9,10,11
ORDER BY ic.install_date DESC, COHORT_SIZE DESC

