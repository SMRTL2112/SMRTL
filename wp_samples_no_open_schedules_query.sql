SELECT DISTINCT sa.hsn
     , sa.original_coc
     , pr.cust_id
     , sa.receive_date login_date
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc ON sa.hsn = sc.schedule_id
 WHERE sa.wip_status = 'WP'
   AND sa.sample_type = 'PS'
MINUS
SELECT DISTINCT sa.hsn
     , sa.original_coc
     , pr.cust_id
     , sa.receive_date login_date
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc ON sa.hsn = sc.schedule_id
 WHERE sa.wip_status = 'WP'
   AND sa.sample_type = 'PS'
   AND (sc.cond_code IS NULL
    OR  sc.active_flag = '*')
ORDER BY 1 DESC;