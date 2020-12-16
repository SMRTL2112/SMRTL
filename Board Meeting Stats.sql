-- Number for Stacked-Area chart (blood only))
select fiscalyear(sa.report_date), get_cust_group(sa.reqnbr), count(*)
from samples sa
where sa.sample_type = 'PS'
group by fiscalyear(sa.report_date), get_cust_group(sa.reqnbr)
order by 1 desc, 2;


--Basic volume, TAT
select sa.matrix, fiscalyear(sa.report_date),  count(*), round(avg(sa.turn_days),1) "MEAN_TAT", round(median(sa.turn_days),1) "MEDIAN_TAT"
--, avg(get_working_days_2(sa.receive_date,sa.comp_date))
from samples sa
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2011','mm/dd/yyyy')
group by fiscalyear(sa.report_date), sa.matrix
order by 1 desc,2;


--IRMS TAT
select sa.matrix, fiscalyear(sa.report_date), count(*), round(avg(sa.turn_days),1) "MEAN_TAT", round(median(sa.turn_days),1)
from samples sa
where sa.sample_type = 'PS'
and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'IRMS' and active_flag = 'F')
group by fiscalyear(sa.report_date), sa.matrix
order by 1,2;

--HGH TAT
select sa.matrix, fiscalyear(sa.report_date), count(*), round(avg(sa.turn_days),1) "MEAN TAT", round(median(sa.turn_days),1) "MEDIAN"
from samples sa
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2011','mm/dd/yyyy')
and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'HGH' and active_flag = 'F')
group by fiscalyear(sa.report_date), sa.matrix
order by 1,2;


--EPO TAT
select fiscalyear(sa.report_date), count(*), round(avg(sa.turn_days),1) "MEAN_TAT", round(median(sa.turn_days),1)
from samples sa
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2011','mm/dd/yyyy')
and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'EPO' and active_flag = 'F')
group by fiscalyear(sa.report_date)
order by 1,2;


--CBC TAT
select sa.matrix, fiscalyear(sa.report_date), count(*), avg(sa.turn_days), get_cust_group(sa.reqnbr)
from samples sa
where sa.sample_type = 'PS'
and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'CBC' and active_flag = 'F')
group by fiscalyear(sa.report_date), sa.matrix, get_cust_group(sa.reqnbr)
order by 1,2;

select sa.matrix, sa.hsn, sa.reqnbr, fiscalyear(sa.report_date), sa.final_result
from samples sa
where sa.sample_type = 'PS'
and get_cust_group(sa.reqnbr) = 'BLOOD'
and sa.wip_status = 'RP'
and not exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'CBC' and active_flag = 'F')
and not exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'HGH' and active_flag = 'F')
order by 3 desc;

-- AAF and ATFs
select get_cust_group(sa.reqnbr), count(*), fiscalyear(sa.report_date)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2012','mm/dd/yyyy')
and sa.final_result in ('A','P','3','4')
and p.cust_Id not in ('COLUMBIA','KISS','SWOG-CTI','PLCR')
group by fiscalyear(sa.report_date), get_cust_group(sa.reqnbr)
order by 1,3;

-- totals + percentages
select findings, cust_group, year, total, 100*(findings/total) from (
select findings, cust_group, year,
(select count(*) from samples sa2
inner join sample_Drugs sd on sd.hsn = sa2.hsn /*and sd.result_Call in ('A','P','I')*/ and substr(sd.flags,1,1) = 'D'
where get_cust_group(sa2.reqnbr) = cust_group
and sa2.sample_type = 'PS'
and sa2.matrix = 'U'
and fiscalyear(sa2.report_date) = year) "TOTAL"
from (
select get_cust_group(sa.reqnbr) "CUST_GROUP", count(*) "FINDINGS", fiscalyear(sa.report_date) "YEAR"
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
where sa.sample_type = 'PS'
and sa.report_date <= to_date('07/01/2020','mm/dd/yyyy')
and sa.report_date > to_date('07/01/2019','mm/dd/yyyy')
and sa.matrix = 'U'
and sa.final_result in ('P','3','4')
and p.cust_Id not in ('COLUMBIA','DEA','KISS','SWOG-CTI','PLCR')
group by fiscalyear(sa.report_date), get_cust_group(sa.reqnbr)
order by 1,3));

-- Look at MLB TUE
select count(distinct sa.hsn), fiscalyear(sa.report_datE)
from samples sa
inner join sample_drugs sd on sd.hsn = sa.hsn and sd.result_call = 'P' and substr(sd.flags,1,1) = 'C'
where sa.reqnbr = 49
and sa.final_result in ('P','3','4')
and sd.cmp <> 'D-AMPHETAMINE'
group by fiscalyear(sa.report_date);

-- AAF and ATFs
select count(*), fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2012','mm/dd/yyyy')
and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
and sa.matrix = 'U'
and sa.final_result in ('P','3','4')--('A','P','3','4')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;

-- IRMS AAF
select count(distinct sa.hsn), fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
inner join sample_acodes sac on sa.hsn = sac.hsn
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2012','mm/dd/yyyy')
and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
and sa.matrix = 'U'
and sa.final_result in ('P','3','4')--('A','P','3','4')
and sd.cmp_class = 'ENDG'
and sac.acode LIKE '%IRMS%'
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;


-- Average Turn-around Time by Drug Class (positives)
select avg(sa.turn_days), fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2012','mm/dd/yyyy')
and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
and sa.matrix = 'U'
and sa.final_result in ('P','3','4')--('A','P','3','4')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;


-- Average Turn-around Time IRMS (positives)
select avg(sa.turn_days), fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
inner join sample_acodes sac on sa.hsn = sac.hsn
where sa.sample_type = 'PS'
and sa.report_date > to_date('07/01/2012','mm/dd/yyyy')
and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
and sa.matrix = 'U'
and sa.final_result in ('P','3','4')--('A','P','3','4')
and sd.cmp_class = 'ENDG'
and sac.acode LIKE '%IRMS%'
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;

-- Inventory
select d.full_date,
(select count(*) from samples sa where substr(sa.flags,8,1) <> 'u' and sa.sample_type = 'PS' and sa.reqnbr <> 574 AND SA.reqnbr <> 1084 and nvl(sa.report_date,sysdate+1) > d.full_date and nvl(sa.report_date,sysdate+1) < d.full_date + 7) "REPORTED",
(select count(*) from samples sa where substr(sa.flags,8,1) <> 'u' and sa.sample_type = 'PS' and sa.reqnbr <> 574 AND SA.reqnbr <> 1084 and sa.receive_date < d.full_date and nvl(sa.report_date,sysdate+1) >= d.full_date) "INVENTORY",
(select count(*) from samples sa where substr(sa.flags,8,1) <> 'u' and sa.sample_type = 'PS' and sa.reqnbr <> 574 AND SA.reqnbr <> 1084 and nvl(sa.collect_date,sysdate+1) > d.full_date and nvl(sa.collect_date,sysdate+1) < d.full_date + 7) "COLLECTED",
400 "TARGET"
from d_date d
where rtrim(d.week_day) = 'Sunday'
-- Exclude COLUMBIA samples
and d.full_date > '01/01/2014'
and d.full_date < sysdate;


select count(*)
from samples sa
where sa.collect_date >='06/03/2014'
and sa.collect_date <'09/03/2014'
and sa.sample_type = 'PS'
and sa.reqnbr <> 574
and sa.reqnbr <> 1084;

-- Historical billable tests by client group 
select fiscalyear(ac.charge_DatE),count(*),get_cust_group(sa.reqnbr)
from samples sa
inner join accumulated_charges ac on ac.hsn = sa.hsn
where sa.sample_type = 'PS'
and ac.charge_date >= '07/01/2008'
group by fiscalyear(ac.charge_date), get_cust_group(sa.reqnbr)
order by 1,3;


-- Historical billable tests by specialty test type
select fiscalyear(ac.charge_DatE),count(*), 
decode(ac.part,'EPO','EPO','EPO PG SCR','EPO','EPO SDS PG','EPO','ESA BLOOD','EPO','ESA SERUM','EPO','CERA','EPO','EPO CONF', 'EPO','IRMS STERx','IRMS','IRMS STER','IRMS','B IRMS STE','IRMS','CBC','CBC','CBC FULL','CBC','GHRP','GHRP','hGH','HGH','HGH','HGH','HGH CONF','HGH',null)
from samples sa
inner join accumulated_charges ac on ac.hsn = sa.hsn
where sa.sample_type = 'PS'
and ac.charge_date >= '07/01/2008'
group by fiscalyear(ac.charge_date), 
decode(ac.part,'EPO','EPO','EPO PG SCR','EPO','EPO SDS PG','EPO','ESA BLOOD','EPO','ESA SERUM','EPO','CERA','EPO','EPO CONF', 'EPO','IRMS STERx','IRMS','IRMS STER','IRMS','B IRMS STE','IRMS','CBC','CBC','CBC FULL','CBC','GHRP','GHRP','hGH','HGH','HGH','HGH','HGH CONF','HGH',null)
order by 1,3;

--HIstorical Sample Volume
select fiscalyear(sa.report_DatE),count(*)
from samples sa
where sa.sample_type = 'PS'
group by fiscalyear(sa.report_date)
order by 1;


-- Volume by quarter
select fiscalyear(sa.report_DatE),count(*)
from samples sa
where sa.sample_type = 'PS'
and fiscalqtr(sa.report_datE) like '%Q4'
group by fiscalyear(sa.report_date)
order by 1;



--Historical billable tests
select fiscalyear(ac.charge_DatE),count(*)
from samples sa
inner join accumulated_charges ac on ac.hsn = sa.hsn
where sa.sample_type = 'PS'
and ac.charge_date >= '07/01/2008'
group by fiscalyear(ac.charge_date)
order by 1;

-- Billable tests by quarter
select fiscalyear(ac.charge_DatE),count(*)
from samples sa
inner join accumulated_charges ac on ac.hsn = sa.hsn
where sa.sample_type = 'PS'
and ac.charge_date >= '07/01/2008'
and fiscalqtr(ac.charge_date) not like '%Q4'
group by fiscalyear(ac.charge_date)
order by 1;


