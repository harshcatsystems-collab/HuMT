
WITH 

-- users table in mongo db
users as 
(select *
--_id, userculture, primarylanguage 
    from 
        {{ source('mongo', 'users') }} 
),

-- dim users
dim_users as (
    select * 
    from {{ ref('dim_users') }}
),

-- user subscription history
sub as (
    select * 
    from {{ ref('fct_user_subscription_history') }}
),

-- user watch history daily
wtc as (
    select * 
    from {{ ref('fct_user_content_watch_daily') }}
),

geography_users AS 
(
          SELECT
            ud.user_id,
            CASE
                WHEN (
                    COALESCE(ud.dialect, u.userculture, u.primarylanguage) = 'har' AND
                    (
                        TRIM(LOWER(ud.current_city)) IN (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer', 'beawar',
                            'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu', 'dausa', 'didwana kuchaman',
                            'dudu', 'dungarpur', 'gangapur city', 'hanumangarh', 'jaipur', 'jaipur gramin', 'gangapur',
                            'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin',
                            'karauli', 'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali', 'phalodi',
                            'pratapgarh', 'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur', 'shahpura',
                            'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur', 'delhi', 'new delhi', 'chandigarh',
                            'ghaziabad', 'gurugram', 'gurgaon', 'Sirsa', 'fatehabad', 'hisar', 'bhiwani', 'mahendragarh',
                            'charkhi dadri', 'jind', 'rohtak', 'jhajjar', 'rewari', 'kaithal', 'panchkula', 'ambala',
                            'kurukshetra', 'karnal', 'panipat', 'sonipat', 'gurgaon (gurgaon)', 'nuh', 'faridabad',
                            'palwal', 'yamunanagar', 'noida (gautam buddh nagar)', 'bulandshahr', 'baghpat', 'meerut',
                            'shamli', 'muzaffarnagar', 'saharanpur', 'bharatpur', 'deeg', 'alwar', 'khairthal-tijara',
                            'kotputli-behror', 'neem ka thana', 'karauli'
                        ) OR
                        TRIM(LOWER(ud.current_state)) IN ('hr')
                    )
                ) OR (
                    COALESCE(ud.dialect, u.userculture, u.primarylanguage) = 'bho' AND
                    (
                        LOWER(ud.current_city) IN (
                            'akbarpur (ambedkar nagar)', 'akbarpur', 'azamgarh', 'ballia', 'basti', 'bhadohi', 'chandauli',
                            'deoria', 'ghazipur', 'gorakhpur', 'jaunpur', 'padrauna (kushinagarh)', 'maharajganj',
                            'mau', 'mirzapur', 'khalilabad (sant kabir nagar)', 'naugarh (siddharthnagar)',
                            'robertsganj (sonbhadra)', 'varanasi', 'motihari',
                            'ara (bhojpur)', 'buxar', 'motihari (east champaran)', 'gopalganj', 'kaimur',
                            'kaimur (bhabhua)', 'muzaffarpur', 'sasaram (rohtas)', 'sasaram', 'siwan', 'chhapra',
                            'chhapra (saran)', 'bettiah (west champaran)', 'bettiah',
                            'singrauli', 'garhwa','bhairahawa','ramgram','birgunj', 'kalaiya',
                            'bhairahawa (rupandehi)', 'ramgram (nawalparasi)', 'birgunj (parsa)', 'kalaiya (bara)',
                            'patna', 'delhi', 'new delhi'
                        ) OR
                        TRIM(LOWER(ud.current_state)) IN ('br')
                    )
                ) OR (
                    COALESCE(ud.dialect, u.userculture, u.primarylanguage) = 'raj' AND
                    (
                        LOWER(ud.current_city) IN (
                            'alwar', 'ajmer', 'anupgarh', 'balotra', 'banswara', 'baran', 'barmer', 'beawar',
                            'bhilwara', 'bikaner', 'bundi', 'chittorgarh', 'churu', 'dausa', 'didwana kuchaman',
                            'dudu', 'dungarpur', 'gangapur city', 'hanumangarh', 'jaipur', 'jaipur gramin',
                            'jaisalmer', 'jalore', 'jhalawar', 'jhunjhunun', 'jodhpur', 'jodhpur gramin',
                            'karauli', 'kekri', 'kota', 'neem ka thana', 'nagaur', 'pali', 'phalodi',
                            'pratapgarh', 'rajsamand', 'salumbar', 'sanchor', 'sawai madhopur', 'shahpura',
                            'sikar', 'sirohi', 'sri ganganagar', 'tonk', 'udaipur'
                        ) OR
                        TRIM(LOWER(ud.current_state)) IN ('hr')
                    )
                ) THEN 'core'
                ELSE 'non-core'
            END AS geography
          FROM
    dim_users ud        
LEFT JOIN 
    users u ON ud.user_id = u._id
    ) --------------------------------------------------------------------------------
    -- Query 3: Monthly Cohort Retention for Core Users
    --------------------------------------------------------------------------------
,
    cohorts AS (
        SELECT
            distinct 
            DATE_TRUNC('month', sh.CREATED_AT_IST:: date) AS cohort_month,
            DATE_TRUNC('week', sh.CREATED_AT_IST:: date) AS cohort_week,
            DATE(sh.CREATED_AT_IST) as cohort_date,
            sh.user_id,
            sh.dialect,
            coalesce(cu.geography,'non-core') as geography
        FROM
            sub as sh 
        LEFT JOIN 
            geography_users cu 
        ON 
            sh.user_id = cu.user_id
        WHERE
            plan_category IN ('New Subscription')
            AND is_valid_vendor
    ),

user_activity_final AS (
      SELECT
        c.cohort_month,
        c.cohort_week,
        c.cohort_date,
        c.user_id,
        c.dialect,
        c.geography,
        w.watch_date,
        DATEDIFF('day',c.cohort_date,w.watch_date) AS days_since_start,
        sum(w.watched_time_sec) as watched_time_sec
      FROM
        cohorts c
        LEFT JOIN wtc w 
      ON c.user_id = w.user_id and w.watch_date >= c.cohort_date
      GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8
    )

select * from user_activity_final