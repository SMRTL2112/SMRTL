SELECT DISTINCT sa.hsn
     , sa.original_coc
     , sa.receive_date
     , sa.report_date
     , pr.cust_id
     , pr.profile_name
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN customers cu ON pr.cust_id = cu.cust_id
    JOIN schedules sc ON sa.hsn = sc.schedule_id
 WHERE (pr.cust_id IN ('NFL','MLB')
    OR  substr(cu.flags,1,1) = 'W')
   AND sa.report_date >= to_date('01/01/2016','mm/dd/yyyy')
   AND sc.proc_code = 'IRMS STER'
   AND sc.cond_code = 'P'
ORDER BY sa.report_date;