select pid.lab_sample_id, pid.cust_sample_id, 
pr.cust_id, pr.profile_name, pr.profile_desc,
sa.turn_days, sa.collect_date, sa.receive_date, sa.report_date, 
decode((select count(*) from schedules sc 
inner join analytical_results ar on ar.schedule_seq = sc.schedule_seq
where sc.schedule_id = sa.hsn and sc.schedule_type = 'S' 
and sc.queue in ('BBLK','GLUC','DIUR','STER','STIM','SSCR','PEPT')
and sc.cond_code = 'P'
and ar.cmp_cond = 'P'),0,'N','P') as SCREENING_RESULT,
sa.final_result, 
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'STER') AS STER_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'STER') AS STER_COMP_DATE,
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'STER'
and s2.proc_code in ('STER AREV','ANA REVIEW')) AS STER_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'STIM') AS STIM_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'STIM') AS STIM_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'STIM'
and s2.proc_code in ('STIM AREV','ANA REVIEW')) AS STIM_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'SSCR') AS SSCR_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'SSCR') AS SSCR_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'SSCR'
and s2.proc_code in ('SSCR AREV','ANA REVIEW')) AS SSCR_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'DIUR') AS DIUR_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'DIUR') AS DIUR_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'DIUR'
and s2.proc_code in ('DIUR AREV','ANA REVIEW')) AS DIUR_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'BBLK') AS BBLK_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'BBLK') AS BBLK_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'BBLK'
and s2.proc_code in ('BBLK AREV','ANA REVIEW')) AS BBLK_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'GLUC') AS GLUC_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'GLUC') AS GLUC_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'GLUC'
and s2.proc_code in ('GLUC AREV','ANA REVIEW')) AS GLUC_ANA_REVIEW,
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'PEPT') AS PEPT_COMP_DATE,
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'PEPT'
and s2.proc_code in ('PEPT AREV','ANA REVIEW')) AS PEPT_ANA_REVIEW,
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'SV') AS SV_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'SV'
and s2.proc_code in ('ANA REVIEW','SV REVIEW')) AS SV_ANA_REVIEW,
(select max(b.create_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'IRMS') AS IRMS_EXTR_DATE, 
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'IRMS') AS IRMS_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'IRMS'
and s2.proc_code in ('IRMS AREV','ANA REVIEW')) AS IRMS_ANA_REVIEW,
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'CONF') AS CONF_COMP_DATE,
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'CONF'
and s2.proc_code in ('ANA REVIEW')) AS CONF_ANA_REVIEW,
(select max(b.evaluation_date)
from batches b
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s on s.schedule_seq = bs.schedule_seq
where s.schedule_type = 'S' and s.schedule_id = sa.hsn 
and s.queue = 'IMUN') AS IMUN_COMP_DATE, 
(select min(s2.comp_date) 
from schedules s2 
inner join batches b on b.batch_seq = s2.schedule_id and s2.schedule_type = 'B'
inner join batch_schedules bs on bs.queue = b.queue and bs.batch_number = b.batch_number
inner join schedules s1 on s1.schedule_seq = bs.schedule_seq
where s1.schedule_type = 'S' and s1.schedule_id = sa.hsn 
and s1.queue = 'IMUN'
and s2.proc_code in ('IMUN AREV','ANA REVIEW')) AS IMUN_ANA_REVIEW
from samples sa 
inner join permanent_ids pid on pid.hsn = sa.hsn
inner join profiles pr on pr.reqnbr = sa.reqnbr 
where pr.cust_id = 'NFL'
and sa.receive_date >= '08/01/2009' 
and sa.receive_date < '09/01/2009'
and sa.sample_type = 'PS';