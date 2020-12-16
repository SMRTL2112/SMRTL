SELECT sa.hsn
     , sa.original_coc
     , ar.cmp
     , ar.cmp_result
     , ar.cmp_cond
     , CASE
         WHEN substr(c.container_id,8,2) = '1A'
           THEN 'Screen'
         WHEN substr(c.container_id,8,1) = '1' AND substr(c.container_id,9,1) != 'A'
           THEN 'A Bottle Confirmation'
         ELSE
           'B Bottle Confirmation'
       END "Screen or Conf"
     , c.container_id
     , sc.comp_date
  FROM analytical_results ar
    JOIN schedules sc ON ar.schedule_seq = sc.schedule_seq
    JOIN containers c ON sc.container_seq = c.container_seq
    JOIN samples sa ON sc.schedule_id = sa.hsn
WHERE /*sc.queue = 'CONF'
   AND sc.proc_code IN ('THC TRANS','CARBOXY-TH')
   AND */ar.cmp IN ('carboxy-thc','CARBOXY-THC-X')
--   AND sc.schedule_type = 'S'
   AND sc.comp_date >= to_date('02/01/2016','mm/dd/yyyy')
   AND ar.cmp_result IS NOT NULL
   AND sc.schedule_id IN (SELECT sac.hsn
                            FROM sample_acodes sac
                           WHERE sac.hsn IN (SELECT hsn
                                               FROM sample_acodes
                                              WHERE acode = 'B CARBX-TH')
                             AND sac.acode IN ('CARBOXY-TH','THC TRANS')
                         )
ORDER BY sc.schedule_id DESC, c.container_id;