-- Findings
select count(*), nvl(get_Ic_ooc(sa.hsn),'OOC'), decode(sa.final_result,'P','AAF','3','AAF','4','AAF','I','N','A','N',sa.final_result),
sa.matrix
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('B','U')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and substr(c.flags,1,1) in ('S','F')
and sa.final_result <> 'F'
and sa.final_result is not null
group by nvl(get_ic_ooc(sa.hsn),'OOC'), 
sa.matrix,
decode(sa.final_result,'P','AAF','3','AAF','4','AAF','I','N','A','N',sa.final_result)
order by 4,2,3;

-- Totals
select count(*), nvl(get_Ic_ooc(sa.hsn),'OOC'), sa.matrix
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('B','U')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and substr(c.flags,1,1) in ('S','F')
and sa.final_result <> 'F'
and sa.final_result is not null
group by nvl(get_ic_ooc(Sa.hsn),'OOC'), sa.matrix;


--Grand Total
-- Totals
select count(*)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('B','U')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and substr(c.flags,1,1) in ('S','F')
and sa.final_result <> 'F'
and sa.final_result is not null;


-- Look for actual atypicals
-- GH atypicals
select count(*), get_ic_ooc(sa.hsn)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('B')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and sa.final_result = 'A'
and substr(c.flags,1,1) in ('S','F')
group by get_ic_ooc(sa.hsn);

-- IRMS Atypicals
select count(distinct sa.hsn)
from samples sa
inner join sample_drugs sd on sd.hsn = sa.hsn and sd.cmp_class = 'ENDG' and sd.method = 'IR'
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('U')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and sd.result_call in ('A','I')
and substr(c.flags,1,1) in ('S','F');


-- hCG Atypicals
select count(distinct sa.hsn), sa.final_result, get_ic_ooc(sa.hsn)
from samples sa
inner join sample_drugs sd on sd.hsn = sa.hsn and sd.cmp_class = 'PEPT' and sd.result_call = 'A'
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
where sa.matrix in ('U')
and sa.receive_date >= '01/01/2014'
and sa.receive_date < '01/01/2015'
and sa.sample_type = 'PS'
and substr(c.flags,1,1) in ('S','F')
group by sa.final_result, get_ic_ooc(sa.hsn);