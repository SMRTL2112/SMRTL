SELECT DISTINCT ba.queue
     , ba.batch_number
     , ba.create_date
     , ba.manager batch_creator
     , sc.comp_date arev_comp_date
     , sc.user_nbr arev_reviewer
     , sc3.comp_date crev_comp_date
     , sc3.user_nbr crev_reviewer
     , ba.qc_rule analyte_tested
     , pr.cust_id
     , sc2.cond_code
     , sa.report_date
     , min(sc4.create_date) first_conf_aliq_create_date
     , get_num_of_samps_on_batch(ba.queue,ba.batch_number) num_of_samples
     , get_num_of_pos_samps_on_batch(ba.queue,ba.batch_number) num_of_pos_samples
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN batch_schedules bs ON ba.queue = bs.queue AND ba.batch_number = bs.batch_number
    JOIN schedules sc2 ON bs.schedule_seq = sc2.schedule_seq
    JOIN samples sa ON sc2.schedule_id = sa.hsn
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc3 ON ba.batch_seq = sc3.schedule_id
    JOIN schedules sc4 ON sa.hsn = sc4.schedule_id
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('ANA REVIEW')
   AND sc.user_nbr != 'NEIC'
   AND bs.sample_type = 'PS'
   AND bs.queue = 'CONF'
   AND ba.create_date >= to_date('05/01/2019','mm/dd/yyyy')
   AND sc3.queue = 'BREV'
   AND sc3.proc_code = 'CS REVIEW'
   AND sc4.proc_code IN ('ALIQ/3mL')
   AND ba.qc_rule = substr(sc4.cmp_list,1,instr(sc4.cmp_list,'_',1,1)-1)
GROUP BY ba.queue
     , ba.batch_number
     , ba.create_date
     , ba.manager
     , sc.comp_date
     , sc.user_nbr
     , sc3.comp_date
     , sc3.user_nbr
     , ba.qc_rule
     , pr.cust_id
     , sc2.cond_code
     , sa.report_date
     , get_num_of_samps_on_batch(ba.queue,ba.batch_number)
     , get_num_of_pos_samps_on_batch(ba.queue,ba.batch_number)
ORDER BY ba.batch_number, sa.report_date, first_conf_aliq_create_date