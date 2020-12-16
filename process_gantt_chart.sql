select 
p.cust_id,
'RECEIPT' "TASK",
median(sa.collect_date) "STEP1",
median(sa.receive_Date) "STEP2",
null "STEP3",
null "STEP4",
null "STEP5",
null "STEP6"
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.report_date >= :pStartDate
and sa.report_Date < :pEndDate
and sa.sample_type = 'PS' 
and sa.matrix = 'U'
and exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and active_flag = 'F' and queue in ('DIUR','SSCR','STER','STIM'))
and p.cust_id in ('USADA','NFL')
group by p.cust_id
UNION
select CUST_ID, 
'INVENTORY' "TASK",
median(INV_START) "STEP1",
median(INV_START) "STEP2", 
median(INV_END) "STEP3",
null "STEP4",
null "STEP5",
null "STEP6"
from (
select sa.receive_date "INV_START", sc.schedule_id, max(b.create_date) "INV_END", p.cust_Id
from batches b 
inner join batch_schedules bs on bs.batch_number = b.batch_number and b.queue = bs.queue 
inner join schedules sc on sc.schedule_seq = bs.schedule_seq 
inner join samples sa on sa.hsn = sc.schedule_id and sc.schedule_type = 'S' 
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.report_date >= :pStartDate
and sa.report_Date < :pEndDate
and sa.sample_type = 'PS' 
and sa.matrix = 'U'
and sc.queue in ('DIUR','SSCR','STER','STIM') 
and sc.active_flag = 'F'
and p.cust_id in ('USADA','NFL')
group by sa.receive_date, sc.schedule_id, p.cust_Id)
group by cust_id
UNION
select CUST_ID, 
'ANALYSIS' "TASK",
median(ANL_START) "STEP1",
median(ANL_START) "STEP2", 
median(ANL_START) "STEP3",
median(ANL_END) "STEP4",
null "STEP5",
null "STEP6"
from (
select min(b.create_date) "ANL_START", sc.schedule_id, max(sc.comp_date) "ANL_END", p.cust_Id
from batches b 
inner join batch_schedules bs on bs.batch_number = b.batch_number and b.queue = bs.queue 
inner join schedules sc on sc.schedule_seq = bs.schedule_seq 
inner join samples sa on sa.hsn = sc.schedule_id and sc.schedule_type = 'S' 
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.report_date >= :pStartDate
and sa.report_Date < :pEndDate
and sa.sample_type = 'PS' 
and sa.matrix = 'U'
and sc.queue in ('DIUR','SSCR','STER','STIM') 
and sc.active_flag = 'F'
and p.cust_id in ('USADA','NFL')
group by sc.schedule_id, p.cust_Id)
group by cust_id
UNION
select CUST_ID, 
'CS REVIEW' "TASK",
median(CS_START) "STEP1",
median(CS_START) "STEP2", 
median(CS_START) "STEP3",
median(CS_START) "STEP4",
median(CS_END) "STEP5",
null "STEP6"
from (
select min(sc.comp_date) "CS_START", sc.schedule_id, max(b.evaluation_date) "CS_END", p.cust_Id
from batches b 
inner join batch_schedules bs on bs.batch_number = b.batch_number and b.queue = bs.queue 
inner join schedules sc on sc.schedule_seq = bs.schedule_seq 
inner join samples sa on sa.hsn = sc.schedule_id and sc.schedule_type = 'S' 
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.report_date >= :pStartDate
and sa.report_Date < :pEndDate
and sa.sample_type = 'PS' 
and sa.matrix = 'U'
and sc.queue in ('DIUR','SSCR','STER','STIM') 
and sc.active_flag = 'F'
and p.cust_id in ('USADA','NFL')
group by sc.schedule_id, p.cust_Id)
group by cust_id
UNION
select CUST_ID, 
'CONF/REPORT' "TASK",
median(RPT_START) "STEP1",
median(RPT_START) "STEP2", 
median(RPT_START) "STEP3", 
median(RPT_START) "STEP4", 
median(RPT_START) "STEP5", 
median(RPT_END) "STEP6"
from (
select max(b.evaluation_date) "RPT_START", sc.schedule_id, sa.report_date "RPT_END", p.cust_Id
from batches b 
inner join batch_schedules bs on bs.batch_number = b.batch_number and b.queue = bs.queue 
inner join schedules sc on sc.schedule_seq = bs.schedule_seq 
inner join samples sa on sa.hsn = sc.schedule_id and sc.schedule_type = 'S' 
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.report_date >= :pStartDate
and sa.report_Date < :pEndDate
and sa.sample_type = 'PS' 
and sa.matrix = 'U'
and sc.queue in ('DIUR','SSCR','STER','STIM') 
and sc.active_flag = 'F'
and p.cust_id in ('USADA','NFL')
group by sc.schedule_id, sa.report_date, p.cust_Id)
group by cust_id
order by 1,3,4,5,6