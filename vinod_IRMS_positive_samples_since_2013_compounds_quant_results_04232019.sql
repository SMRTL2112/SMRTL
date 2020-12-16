SELECT DISTINCT sa.hsn
     , sa.original_coc
     , sa.receive_date
     , sa.report_date
     , pr.cust_id
     , pr.profile_name
     , sd.cmp
     , sd.result_nbr
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
--    JOIN customers cu ON pr.cust_id = cu.cust_id
--    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN sample_drugs sd ON sa.hsn = sd.hsn
 WHERE /*(pr.cust_id IN ('NFL','MLB')
    OR  substr(cu.flags,1,1) = 'W')
   AND*/ sa.report_date >= to_date('01/01/2013','mm/dd/yyyy')
--   AND sc.proc_code = 'IRMS STER'
--   AND sc.cond_code = 'P'
  AND sd.cmp IN ('16-ENE-5A','16-ENE-5B','16-ENE-ETIO',
                  '16-ENE-ANDRO','16-ENE-TEST','PREGNANED-5A',
                  'PREGNANED-5B','PREGNANED-ETIO','PREGNANED-ANDRO',
                  'PREGNANED-TEST','11BOHANDR-5A','11BOHANDR-5B','11BOHANDR-ANDRO','11BOHANDR-TEST','11BOHANDRO-ETIO')
   AND sd.result_call = 'P'
ORDER BY sa.report_date,sa.hsn,sd.cmp;