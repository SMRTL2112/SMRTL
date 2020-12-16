SELECT sa.hsn
     , sa.original_coc
     , ab.receive_date airbill_receive_date
     , sa.receive_date
     , sa.report_date
     , pr.cust_id
     , pr.profile_name
     , pr.profile_desc
     , decode(sa.turn_code,'3D','3','2D','2','5D','5','5R','5','10D','10','2D','2','01','1','4D','4','No Configure') turn_code
     , sa.turn_days
     , (to_number(decode(sa.turn_code,'3D','3','2D','2','5D','5','5R','5','10D','10','2D','2','01','1','4D','4','No Configure')) - sa.turn_days) tat_diff
     , (SELECT acode
          FROM sample_acodes
         WHERE hsn = sa.hsn
           AND sort_item = 1) panel
     , sc.proc_code
     , decode(sc.queue,'IRMS','IRMS','CONF','CONF',NULL) queue
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN sample_acodes sac ON sa.hsn = sac.hsn
    JOIN airbills ab ON sa.original_coc = ab.original_coc
    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN batch_schedules bs ON sc.schedule_seq = bs.schedule_seq
 WHERE sac.acode = 'QTAFEE'
   AND bs.queue IN ('CONF','IRMS')
UNION
SELECT sa.hsn
     , sa.original_coc
     , ab.receive_date airbill_receive_date
     , sa.receive_date
     , sa.report_date
     , pr.cust_id
     , pr.profile_name
     , pr.profile_desc
     , decode(sa.turn_code,'3D','3','2D','2','5D','5','5R','5','10D','10','2D','2','01','1','4D','4','No Configure') turn_code
     , sa.turn_days
     , (to_number(decode(sa.turn_code,'3D','3','2D','2','5D','5','5R','5','10D','10','2D','2','01','1','4D','4','No Configure')) - sa.turn_days) tat_diff
     , (SELECT acode
          FROM sample_acodes
         WHERE hsn = sa.hsn
           AND sort_item = 1) panel
     , NULL
     , decode(sc.queue,'IRMS','IRMS','CONF','CONF',NULL) queue
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN sample_acodes sac ON sa.hsn = sac.hsn
    JOIN airbills ab ON sa.original_coc = ab.original_coc
    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN batch_schedules bs ON sc.schedule_seq = bs.schedule_seq
 WHERE sac.acode = 'QTAFEE'
   AND bs.queue NOT IN ('CONF','IRMS');