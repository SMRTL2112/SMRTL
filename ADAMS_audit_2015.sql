select sa.hsn, sa.original_coc, sa.receive_date, p.cust_id, sa.final_result, sa.report_date, sa.matrix, substr(sa.flags,8,1)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where substr(c.flags,1,1) = 'W'
and sa.receive_date >= '01/01/2015'
and sa.receive_date < '01/01/2016'
and sa.wip_status = 'RP'
--and c.cust_id <> 'USADA'
and sa.matrix in ('U','B')
and not exists (select 1 from schedules where queue = 'CBC' and schedule_id = sa.hsn)
and sa.sample_type = 'PS'
and sa.final_result not in ('F','C')
and sa.hsn not in (select hsn from adams_samples)
--and not exists (Select 1 from schedules where schedule_id = sa.hsn and proc_code = 'REREPORT' and comp_date > sysdate-2)
--and not exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'HGH')
order by 1;

