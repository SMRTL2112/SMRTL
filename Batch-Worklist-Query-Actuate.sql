select
 b.queue,
 b.batch_number,
 ed.edd_value,
 b.qc_rule,
 b.batch_seq,
 b.wip_status,
(select t.to_location ||': '||tc.sublocation
from containers ca
inner join containers cp on cp.container_seq = ca.parent_seq
inner join transfer_containers tc on tc.container_seq = cp.container_seq
inner join transfers t on t.transfer_seq = tc.transfer_seq
where ca.container_seq = c.container_seq
and t.transfer_seq = (
  Select max(t2.transfer_seq) 
  from transfers t2
  inner join transfer_containers tc2 on tc2.transfer_seq = t2.transfer_seq
  where tc2.container_seq = cp.container_seq
  and t2.to_location not in ('ACCESSION RM','LABALIQSTOR','EXTRACTION','SMRT LAB'))) "PARENT_LOCATION",
  (select t.to_location ||': '||tc.sublocation
from transfer_containers tc
inner join transfers t on t.transfer_seq = tc.transfer_seq
where tc.container_seq = c.container_seq
and t.transfer_seq = (
  Select max(t2.transfer_seq) 
  from transfers t2
  inner join transfer_containers tc2 on tc2.transfer_seq = t2.transfer_seq
  where tc2.container_seq = c.container_seq
  and t2.to_location not in ('ACCESSION RM','LABALIQSTOR','EXTRACTION','SMRT LAB'))) "SUBLOCATION",
 b.create_date,
 formatshortname(l.addr_seq) as name,
 bs.batch_pos,
 to_char(ceil(bs.batch_pos/8)) || chr(mod(bs.batch_pos-1,8)+65) "GRID",
 c.container_id,
 DECODE(hv.blind_flag, 'B', (select sample_type from hv$sample_type where default_flag = 'Y'),
  bs.sample_type) as sample_type,
decode((select count(*) from batch_schedules where batch_number = b.batch_number and queue = b.queue and sample_type = bs.sample_type and sample_type <> 'PS' and batch_pos < bs.batch_pos),0,'','2') as QC_SUFFIX,
 pi.cust_sample_id,
 pi.lab_sample_id "LAB_ID",
 s.proc_code,
 s.cmp_list,
 s.hold_date,
 s.due_date,
 SUBSTR(s.flags, 3, 1) as flag3,
s.schedule_seq,
 pi2.lab_sample_id as original_lab_sample_id,
 sa.manager,
 nvl(sa.HSN,s.schedule_id) as hsn,
 SUBSTR(sa.flags, 19, 1) as flag19,
decode(s.queue,'BBLK',get_sport(s.schedule_id),'') || s.note "NOTE",
 p.cust_id, 
 hv.blind_flag,
s.schedule_type,
s.schedule_id,
bs.matrix "q_matrix",
 sa.matrix "MATRIX",
hv.sample_desc,
(select distinct pa.patient_id from patients pa where pa.patient_seq = s.schedule_id) patient_id,
(select distinct pa.patient_seq from patients pa where pa.patient_seq = s.schedule_id) patient_seq,
get_proc_code_security(:tqsBWUCG, null, s.proc_code, null, null) as show_obscure_data
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