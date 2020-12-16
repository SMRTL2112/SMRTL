-- Old samples waiting on NNCSREVIEW
select sa.original_coc, sa.matrix, sa.hsn, sa.collect_date, sa.receive_date, all_open_schedules(sa.hsn), sa.sample_desc
--select count(*)
from samples sa
where sa.wip_status = 'CO'
and sa.sample_type = 'PS'
and sa.hsn > 0
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and create_date > sysdate - 7)
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and comp_date > sysdate - 7)
and exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and queue = 'CREV' and active_flag = 'A');

-- Old samples waiting on reporting
select count(*)
from samples sa
where sa.wip_status = 'CO'
and sa.sample_type = 'PS'
and sa.collect_date < sysdate - 5
and sa.reqnbr <> 1186
and sa.hsn > 0
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and create_date > sysdate - 7)
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and comp_date > sysdate - 7)
and exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and queue = '*REP' and active_flag = 'A');

-- Old samples waiting on something besides reporting/CREV
select sa.original_coc, sa.hsn, sa.collect_date, sa.receive_date, all_open_schedules(sa.hsn), sa.sample_desc, sa.cancel_code
from samples sa
where sa.wip_status <> 'RP'
and sa.sample_type = 'PS'
and sa.receive_Date > sysdate - 365
and nvl(sa.collect_date,'01/01/1990') < sysdate - 30
and sa.hsn > 0
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and create_date > sysdate - 7)
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and comp_date > sysdate - 7)
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and queue = 'CREV' and active_flag = 'A')
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and queue = '*REP' and active_flag = 'A')
and sa.matrix in ('U','B');


-- REALLY Old samples waiting on anything
-- Filter out multi-sample workorder things
select sa.original_coc, sa.hsn, sa.collect_date, sa.receive_date, all_open_schedules(sa.hsn), sa.sample_desc, sa.cancel_code
from samples sa
where sa.wip_status <> 'RP'
and sa.sample_type = 'PS'
and nvl(sa.collect_date,'01/01/1990') < sysdate - 14
and sa.hsn > 0
and sa.reqnbr <> 1186
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and create_date > sysdate - 14)
and not exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and comp_date > sysdate - 14)
and sa.matrix in ('U','B');





