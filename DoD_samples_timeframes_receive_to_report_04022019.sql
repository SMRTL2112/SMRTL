SELECT sa.hsn
     , sa.original_coc
     , pr.cust_id
     , ab.receive_date
     , sa.receive_date login_date
     , round(sa.receive_date - ab.receive_date,2) days_receipt_to_login
     , sc.comp_date
     , round(sc.comp_date - sa.receive_date,2) days_login_to_screen_comp
     , sc2.create_date min_conf_create_date
     , round(sc2.create_date - sc.comp_date,2) days_screen_comp_to_start_conf
     , sc3.comp_date max_conf_comp_date
     , round(sc3.comp_date - sc2.create_date,2) days_start_to_comp_conf
     , round(sa.report_date - sc3.comp_date,2) days_comp_conf_to_report
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN airbills ab ON sa.original_coc = ab.original_coc
    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN schedules sc2 ON sa.hsn = sc2.schedule_id
    JOIN schedules sc3 ON sa.hsn = sc3.schedule_id
 WHERE pr.cust_id IN ('AIR FORCE','ARMY','NAVY')
   AND ab.receive_date >= '07/01/2018'
   AND sc.comp_date = (SELECT max(comp_date)
                         FROM schedules
                        WHERE queue IN ('GSCR','LSCR','GHRP')
                          AND schedule_id = sa.hsn)
   AND sc2.create_date = (SELECT min(create_date)
                            FROM schedules
                           WHERE queue = 'CONF'
                             AND schedule_id = sa.hsn
                             AND cond_code IN ('P','N','A'))
   AND sc3.comp_date = (SELECT max(comp_date)
                            FROM schedules
                           WHERE queue = 'CONF'
                             AND schedule_id = sa.hsn
                             AND cond_code IN ('P','N','A'))
ORDER BY ab.receive_date;