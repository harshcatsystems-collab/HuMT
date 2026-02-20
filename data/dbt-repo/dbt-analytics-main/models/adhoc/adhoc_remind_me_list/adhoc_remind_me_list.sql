 with remind_me_table as 
 (select * from {{ ref('dim_users') }})

  

SELECT 
DISTINCT 
        user_id, 
        DATE(TO_DATE(created_at)) AS date,
        REPLACE(flattened.value, '"', '') AS remindmelist_item
    FROM remind_me_table,
         LATERAL FLATTEN(input => remind_me_list) AS flattened
    WHERE flattened.value IS NOT NULL 
          AND user_id IS NOT NULL


