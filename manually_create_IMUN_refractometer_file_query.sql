select
 b.queue,
 b.batch_number,
 nvl(sa.HSN,s.schedule_id) as hsn
from
 batches b
 inner join batch_schedules bs on bs.batch_number = b.batch_number and bs.queue = b.queue
 left outer join schedules s on s.schedule_seq = bs.schedule_seq
 left outer join permanent_ids pi on pi.hsn = s.schedule_id
 left outer join containers c on c.container_seq = s.container_seq 
 left outer join samples sa on sa.hsn = s.schedule_id
inner join lims_users l on l.user_nbr = b.manager
 left outer join profiles p on p.reqnbr = sa.reqnbr  
 left outer join hv$sample_type hv on hv.sample_type = bs.sample_type  
 left outer join addresses a on a.addr_seq = l.addr_seq
 left outer join permanent_ids pi2 on pi2.hsn = sa.original_hsn
 left outer join edd_mapper ed on ed.edd_format = 'INSTR' and ed.horizon_value = 'STER'
where b.queue = :pQueue 
AND b.batch_number = :pBatchNumber 
order by
bs.batch_pos