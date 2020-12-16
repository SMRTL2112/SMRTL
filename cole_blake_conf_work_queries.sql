-- # of LSCR and GSCR batches where CREV was completed
SELECT user_nbr
     , count(queue)
  FROM schedules
 WHERE queue = 'BREV'
   AND proc_code IN ('STER CREV','LSCR CREV')
   AND user_nbr IN ('CHUG','BHLD')
   AND comp_date BETWEEN to_date('04/01/2019','mm/dd/yyyy') AND to_date('05/11/2019','mm/dd/yyyy')
GROUP BY user_nbr
ORDER BY user_nbr;

SELECT user_nbr
     , count(queue)
  FROM schedules
 WHERE queue = 'BREV'
   AND proc_code IN ('STER CREV','LSCR CREV')
   AND user_nbr IN ('CHUG','BHLD')
   AND comp_date BETWEEN to_date('05/13/2019','mm/dd/yyyy') AND to_date('06/29/2019','mm/dd/yyyy')
GROUP BY user_nbr
ORDER BY user_nbr;

-- The time elapsed from completion of AREV until the completion of CREV for the LSCR and GSCR batches they completed CREV on 
SELECT ba.queue
     , ba.batch_number
     , sc.comp_date arev_comp_date
     , sc.user_nbr arev_reviewer
     , sc2.comp_date crev_comp_date
     , sc2.user_nbr crev_reviewer
     , round((sc2.comp_date - sc.comp_date)*24,2) time_elapsed_arev_crev_hrs
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN schedules sc2 ON ba.batch_seq = sc2.schedule_id
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('STER AREV','LSCR AREV')
   AND sc.comp_date BETWEEN to_date('04/01/2019','mm/dd/yyyy') AND to_date('05/11/2019','mm/dd/yyyy')
   AND sc2.queue = 'BREV'
   AND sc2.proc_code IN ('STER CREV','LSCR CREV')
   AND sc2.user_nbr IN ('CHUG','BHLD')
   AND round((sc2.comp_date - sc.comp_date)*24,2) != 0
ORDER BY ba.queue,ba.batch_number,sc.comp_date;

SELECT ba.queue
     , ba.batch_number
     , sc.comp_date arev_comp_date
     , sc.user_nbr arev_reviewer
     , sc2.comp_date crev_comp_date
     , sc2.user_nbr crev_reviewer
     , round((sc2.comp_date - sc.comp_date)*24,2) time_elapsed_arev_crev_hrs
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN schedules sc2 ON ba.batch_seq = sc2.schedule_id
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('STER AREV','LSCR AREV')
   AND sc.comp_date BETWEEN to_date('05/13/2019','mm/dd/yyyy') AND to_date('06/29/2019','mm/dd/yyyy')
   AND sc2.queue = 'BREV'
   AND sc2.proc_code IN ('STER CREV','LSCR CREV')
   AND sc2.user_nbr IN ('CHUG','BHLD')
   AND round((sc2.comp_date - sc.comp_date)*24,2) != 0
ORDER BY ba.queue,ba.batch_number,sc.comp_date;




-- # of CONF batches created
SELECT manager
     , count(queue) conf_batches_created
  FROM batches
 WHERE manager IN ('CHUG','BHLD')
   AND create_date BETWEEN to_date('04/01/2019','mm/dd/yyyy') AND to_date('05/11/2019','mm/dd/yyyy')
GROUP BY manager
ORDER BY manager;

SELECT manager
     , count(queue) conf_batches_created
  FROM batches
 WHERE manager IN ('CHUG','BHLD')
   AND create_date BETWEEN to_date('05/13/2019','mm/dd/yyyy') AND to_date('06/29/2019','mm/dd/yyyy')
GROUP BY manager
ORDER BY manager;




-- # of CONF batches with AREV completed
-- Time elapsed from CONF batch creation to AREV completion
-- For the CONF batches they worked on, it would be helpful for us to know how 
--   many samples were in each batch and the analyte they were testing for 
SELECT ba.queue
     , ba.batch_number
     , ba.create_date
     , ba.manager batch_creator
     , sc.comp_date arev_comp_date
     , sc.user_nbr arev_reviewer
     , round((sc.comp_date - ba.create_date)*24,2) time_elp_batch_create_arev_hrs
     , round((sc.comp_date - ba.create_date),2) time_elp_batch_create_arev_day
     , ba.qc_rule analyte_tested
     , count(bs.schedule_seq) num_samples_on_batch
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN batch_schedules bs ON ba.queue = bs.queue AND ba.batch_number = bs.batch_number
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('ANA REVIEW')
   AND sc.comp_date BETWEEN to_date('04/01/2019','mm/dd/yyyy') AND to_date('05/11/2019','mm/dd/yyyy')
   AND (sc.user_nbr IN ('CHUG','BHLD')
    OR  ba.manager IN ('CHUG','BHLD'))
   AND round((sc.comp_date - ba.create_date)*24,2) != 0
   AND bs.sample_type = 'PS'
GROUP BY ba.queue
       , ba.batch_number
       , ba.create_date
       , ba.manager
       , sc.comp_date
       , sc.user_nbr
       , round((sc.comp_date - ba.create_date)*24,2)
       , round((sc.comp_date - ba.create_date),2)
       , ba.qc_rule
ORDER BY ba.queue,ba.batch_number,ba.create_date;

SELECT ba.queue
     , ba.batch_number
     , ba.create_date
     , ba.manager batch_creator
     , sc.comp_date arev_comp_date
     , sc.user_nbr arev_reviewer
     , round((sc.comp_date - ba.create_date)*24,2) time_elp_batch_create_arev_hrs
     , round((sc.comp_date - ba.create_date),2) time_elp_batch_create_arev_day
     , ba.qc_rule analyte_tested
     , count(bs.schedule_seq) num_samples_on_batch
  FROM schedules sc
    JOIN batches ba ON sc.schedule_id = ba.batch_seq
    JOIN batch_schedules bs ON ba.queue = bs.queue AND ba.batch_number = bs.batch_number
 WHERE sc.queue = 'BREV'
   AND sc.proc_code IN ('ANA REVIEW')
   AND sc.comp_date BETWEEN to_date('05/13/2019','mm/dd/yyyy') AND to_date('06/29/2019','mm/dd/yyyy')
   AND (sc.user_nbr IN ('CHUG','BHLD')
    OR  ba.manager IN ('CHUG','BHLD'))
   AND round((sc.comp_date - ba.create_date)*24,2) != 0
   AND bs.sample_type = 'PS'
GROUP BY ba.queue
       , ba.batch_number
       , ba.create_date
       , ba.manager
       , sc.comp_date
       , sc.user_nbr
       , round((sc.comp_date - ba.create_date)*24,2)
       , round((sc.comp_date - ba.create_date),2)
       , ba.qc_rule
ORDER BY ba.queue,ba.batch_number,ba.create_date;