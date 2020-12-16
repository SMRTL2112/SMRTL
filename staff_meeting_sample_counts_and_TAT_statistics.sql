-- Get sample received count
SELECT *
  FROM airbills
 WHERE receive_date BETWEEN (sysdate-7) AND sysdate;

-- Get sample reported count
SELECT *
  FROM samples
 WHERE report_date BETWEEN (sysdate-7) AND sysdate
  AND  sample_type = 'PS';

-- Get positive result sample count
SELECT *
  FROM samples
 WHERE report_date BETWEEN (sysdate-7) AND sysdate
   AND sample_type = 'PS'
   AND final_result = 'P';
   
-- Get mean and median TAT grouping by turn_code
SELECT avg(turn_days) mean_tat
     , median(turn_days) median_tat
     , count(turn_days) num_samples
     , turn_code
  FROM samples
 WHERE report_date BETWEEN (sysdate-7) AND sysdate
   AND sample_type = 'PS'
   AND matrix = 'U'
 GROUP BY turn_code
ORDER BY turn_code;

-- Get median TAT grouping by turn_code
--SELECT median(turn_days) median_tat
--     , count(turn_days) num_samples
--     , turn_code
--  FROM samples
-- WHERE report_date BETWEEN (sysdate-7) AND sysdate
--   AND sample_type = 'PS'
--GROUP BY turn_code
--ORDER BY turn_code;

-- Get selected samples for a given turn_code group
--SELECT sa.hsn
--     , sa.original_coc
--     , sa.turn_days
--     , sa.turn_code
--     , pr.cust_id
--  FROM samples sa
--    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
-- WHERE report_date BETWEEN (sysdate-7) AND sysdate
--   AND sample_type = 'PS'
--   AND turn_code = '01';

-- number of samples in prelogin (not logged in yet) that have been airbilled and are grouped by cust_id
SELECT pr.cust_id
     , count(*)
  FROM sample_schedules ss
    JOIN profiles pr ON ss.reqnbr = pr.reqnbr
    JOIN airbills ab ON ss.original_coc = ab.original_coc
 WHERE ss.original_coc NOT IN (SELECT sa.original_coc
                                 FROM samples sa
                                WHERE sa.original_coc = ss.original_coc)
GROUP BY pr.cust_id
ORDER BY pr.cust_id;
