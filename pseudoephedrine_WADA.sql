select sa.original_coc, ar.cmp, ar.cmp_cond, bs.batch_number, bs.queue, bs2.batch_number
from samples sa 
inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' 
inner join analytical_results ar on sc.schedule_seq = ar.schedule_seq 
inner join profiles pr on pr.reqnbr = sa.reqnbr 
inner join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
inner join schedules sc2 on sc2.schedule_id = sa.hsn and sc2.queue = 'SV'
inner join batch_schedules bs2 on bs2.schedule_seq = sc2.schedule_seq
where ar.cmp = 'pseudoephedrine' 
and pr.cust_id in ('USADA','IRB','ISU')
and ar.cmp_cond in ('P','PN','CCN') 
and sc.comp_date >= '01/01/2010'
and sa.sample_type = 'PS'
order by bs.batch_number;

select * from compounds where name like '5%';