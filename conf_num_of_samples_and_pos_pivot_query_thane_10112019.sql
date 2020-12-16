SELECT x.batch_number
     , x.create_date
     , x.batch_creator
     , x.arev_comp_date
     , x.arev_reviewer
     , x.crev_comp_date
     , x.crev_reviewer
     , x.analyte_tested
     , x.cust_id
     , x.cond_code
--     , min(x.first_conf_aliq_create_date) first_conf_aliq_create_date
     , x.report_date
     , x.num_of_samples
     , nvl(y.num_of_pos_samples,0) num_of_pos_samples
  FROM
     (
SELECT *
  FROM (
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
--     , (SELECT min(create_date)
--          FROM schedules
--         WHERE schedule_seq = sc4.schedule_seq) first_conf_aliq_create_date
     , bs.schedule_seq
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN batch_schedules bs ON ba.queue = bs.queue AND ba.batch_number = bs.batch_number
    JOIN schedules sc2 ON bs.schedule_seq = sc2.schedule_seq
    JOIN samples sa ON sc2.schedule_id = sa.hsn
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc3 ON ba.batch_seq = sc3.schedule_id
--    JOIN schedules sc4 ON sa.hsn = sc4.schedule_id
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('ANA REVIEW')
   AND sc.user_nbr != 'NEIC'
   AND bs.sample_type = 'PS'
   AND bs.queue = 'CONF'
   AND ba.create_date >= to_date('05/01/2019','mm/dd/yyyy')
   AND sc3.queue = 'BREV'
   AND sc3.proc_code = 'CS REVIEW'
--   AND sc4.proc_code IN ('ALIQ/2mL','ALIQ/3mL')
--   AND ba.qc_rule = substr(sc4.cmp_list,1,instr(sc4.cmp_list,'_',1,1)-1)
)
PIVOT (
  count(schedule_seq)
  FOR queue IN ('CONF' as num_of_samples)
)) x
  LEFT JOIN
(SELECT *
  FROM (
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
--     , (SELECT min(create_date)
--          FROM schedules
--         WHERE schedule_seq = sc4.schedule_seq) first_conf_aliq_create_date
     , bs.schedule_seq
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN batch_schedules bs ON ba.queue = bs.queue AND ba.batch_number = bs.batch_number
    JOIN schedules sc2 ON bs.schedule_seq = sc2.schedule_seq
    JOIN samples sa ON sc2.schedule_id = sa.hsn
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc3 ON ba.batch_seq = sc3.schedule_id
--    JOIN schedules sc4 ON sa.hsn = sc4.schedule_id
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('ANA REVIEW')
   AND sc.user_nbr != 'NEIC'
   AND bs.sample_type = 'PS'
   AND bs.queue = 'CONF'
   AND ba.create_date >= to_date('05/01/2019','mm/dd/yyyy')
   AND sa.final_result IN ('P','3','4')
   AND sc3.queue = 'BREV'
   AND sc3.proc_code = 'CS REVIEW'
   AND sc2.cond_code = 'P'
--   AND sc4.proc_code IN ('ALIQ/2mL','ALIQ/3mL')
--   AND ba.qc_rule = substr(sc4.cmp_list,1,instr(sc4.cmp_list,'_',1,1)-1)
)
PIVOT (
  count(schedule_seq)
  FOR queue IN ('CONF' as num_of_pos_samples)
)) y ON /*x.first_conf_aliq_create_date = y.first_conf_aliq_create_date AND*/ x.analyte_tested = y.analyte_tested AND x.cust_id = y.cust_id AND x.report_date = y.report_date
GROUP BY x.batch_number
     , x.create_date
     , x.batch_creator
     , x.arev_comp_date
     , x.arev_reviewer
     , x.crev_comp_date
     , x.crev_reviewer
     , x.analyte_tested
     , x.cust_id
     , x.cond_code
     , x.report_date
     , x.num_of_samples
     , nvl(y.num_of_pos_samples,0)
ORDER BY x.batch_number,x.create_date--,first_conf_aliq_create_date