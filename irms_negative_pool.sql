select distinct sa.hsn, sa.wip_status, c.disposal_date, c.location, tc.sublocation, all_open_schedules(sa.hsn)
--, c.location, tc.sublocation, c.disposal_date
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join containers c on c.hsn = sa.hsn
inner join transfer_containers tc on tc.container_seq = c.container_seq 
inner join transfers t on t.transfer_seq = tc.transfer_seq
where c.container_type in ('A','B')
and tc.transfer_seq = (select max(Transfer_seq) from transfer_containers where container_seq = c.container_seq)
and c.disposal_date < sysdate
and c.actual_disposal is null
--and sa.final_result is null
and sa.receive_date > sysdate - 365
and p.cust_id = 'NFL'
and exists (select 1 from schedules where schedule_id = sa.hsn and schedule_type = 'S' and queue = 'IRMS' and cond_code = 'N' and active_flag in ('F','*'))
and exists (
  select 1 
  from analytical_results ar 
  inner join schedules sc on sc.schedule_Seq = ar.schedule_seq 
  where sc.schedule_id = sa.hsn 
  and sc.schedule_type = 'S' 
  and ar.status in ('O','F')
  and sc.queue = 'GSCR' 
  and ar.cmp in ('androsterone') 
  and ar.cmp_result > 1000)
and exists (
  select 1 
  from analytical_results ar 
  inner join schedules sc on sc.schedule_Seq = ar.schedule_seq 
  where sc.schedule_id = sa.hsn 
  and sc.schedule_type = 'S' 
  and ar.status in ('O','F')
  and sc.queue = 'GSCR' 
  and ar.cmp in ('etiocholanolone') 
  and ar.cmp_result > 1000)
  