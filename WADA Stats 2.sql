--select count(*), upper(nvl(cl1.choice_desc,cl2.choice_desc))
select count(*), c.cust_id
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
--and sa.final_result = 'N'
and substr(c.flags,1,1) = 'S'
and sa.matrix = 'U'
--and ad2.aux_data = 'IC'
and sa.sample_type = 'PS' 
--and cust_id not in ('COLUMBIA','MISC','Aegis','IntBlindQC')
group by c.cust_id;
--group by upper(nvl(cl1.choice_desc,cl2.choice_desc))
--order by 2;

-- All Baseball, non-WADA samples, negative & positive
select count(*)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
and sa.final_result in ('A','N','P')
and substr(c.flags,1,1) <> 'W'
--and sd.cmp_class = 'hGH'
and sa.matrix = 'B'
and sa.sample_type = 'PS'
and p.cust_id like 'MLB-Blood';

-- All Football non-WADA samples, negative & positive
select count(*), sa.final_result
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
and sa.final_result in ('A','N','P')
and substr(c.flags,1,1) <> 'W'
and sa.matrix = 'U'
--and ad2.aux_data = 'IC'
and sa.sample_type = 'PS'
and p.cust_id = 'NFL'
group by sa.final_result;

-- All NBA samples
select count(*), sa.final_result
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
and sa.final_result in ('A','N','P')
and substr(c.flags,1,1) <> 'W'
and sa.matrix = 'U'
--and ad2.aux_data = 'IC'
and sa.sample_type = 'PS'
and p.cust_id = 'NBA'
group by sa.final_result;


-- All NCAA
select count(*), sa.final_result
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
and sa.final_result in ('A','N','P')
and substr(c.flags,1,1) <> 'W'
and sa.matrix = 'U'
--and ad2.aux_data = 'IC'
and sa.sample_type = 'PS'
and (p.profile_name like '%NCAA%'
or p.cust_id in ('IOWA','UTAH','NC6.228'))
group by sa.final_result;

-- Try to determine which should have been ATFs
select sa.hsn, sac.acode, sd.*, sa.final_result, sc.cond_code
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
--inner join sample_Drugs sd on sd.hsn = sa.hsn
left outer join sample_acodes sac on sac.hsn = sa.hsn and sac.acode like '%IRMS%'
left outer join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.queue = 'IRMS' and sc.active_flag = 'F'
where sa.receive_date >= '01/01/2010' 
and sa.receive_date < '01/01/2011' 
and sa.final_result in ('A','N','P')
and sa.final_result = 'P'
and substr(c.flags,1,1) <> 'W'
--and sd.cmp_class in ('ENDG','AAS')
--and sd.result_call = 'P'
and substr(sd.flags,1,1) = 'S' 
and sa.matrix = 'U'
and sa.sample_type = 'PS'
--and (p.profile_name like '%NCAA%'
--or p.cust_id in ('IOWA','UTAH','NC6.228'))
and c.cust_id = 'NBA'
--and sd.cmp in ('corrected t/e','dhea','androsterone','testosterone','t/e','epitestosterone','etiocholanolone')
--and nvl(sc.cond_code,'N') = 'N'
order by 1;



select * 
from accumulated_charges 
where cust_id = 'CFDFS' 
and part = 'NCAA CH M' 
and charge_date < '05/01/2011' 
and charge_date > '02/01/2011';


select count(*), cust_id
from accumulated_charges 
where invoice_seq < 0
and charge_date < '05/01/2011'
group by cust_id;

select * from invoices where actual_date > sysdate - 1;