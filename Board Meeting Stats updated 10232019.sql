--Basic volume, TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN_TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
  from samples sa
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1 desc,2;

-- Blood volume, TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN_TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
    from samples sa
    where sa.sample_type in ('PS')
    and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
    and matrix = 'B'
    and exists (Select 1 from schedules where schedule_id = sa.hsn and queue IN ('CBC') and active_flag = 'F')
    and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1 desc,2;

-- Serum volume, TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN_TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
    from samples sa
    where sa.sample_type in ('PS')
    and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
    and matrix = 'B'
    and exists (Select 1 from schedules where schedule_id = sa.hsn and queue IN ('HGH','P3NP','EPO','IGF1') and active_flag = 'F')
    and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1 desc,2;

--IRMS TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN_TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
  from samples sa
 where sa.sample_type = 'PS'
   and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'IRMS' and active_flag = 'F')
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1,2;

--HGH TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
  from samples sa
 where sa.sample_type = 'PS'
   and sa.report_date > to_date('07/01/2016','mm/dd/yyyy')
   and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'HGH' and active_flag = 'F' and (proc_code = 'hGH'))
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1,2;


--EPO TAT -- toggle comment for matrix with just B for blood and all EPO (urine and blood)
select fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN_TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
  from samples sa
 where sa.sample_type = 'PS'
   and sa.report_date > to_date('07/01/2016','mm/dd/yyyy')
   and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'EPO' and active_flag = 'F')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
--   and sa.matrix = 'B'
group by fiscalyear(sa.report_date)
order by 1,2;


--HGH Biomarkers, TAT
select sa.matrix
     , fiscalyear(sa.report_date)
     , count(*)
     , round(avg(sa.turn_days),1) "MEAN TAT"
     , round(median(sa.turn_days),1) "MEDIAN_TAT"
  from samples sa
 where sa.sample_type = 'PS'
   and sa.report_date > to_date('07/01/2016','mm/dd/yyyy')
   and exists (Select 1 from schedules where schedule_id = sa.hsn and queue IN ('IGF1','P3NP') and active_flag = 'F')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), sa.matrix
order by 1,2;




-- totals + percentages -- Change the dates in: and sa.report_date <= to_date('07/01/2017','mm/dd/yyyy')
--                                              and sa.report_date > to_date('07/01/2016','mm/dd/yyyy')
--                         to get stats for different fiscal years.
select findings
     , cust_group
     , year
     , total
     , 100*(findings/total)
  from (select findings
             , cust_group
             , year
             , (select count(*)
                  from samples sa2
                    inner join sample_drugs sd on sd.hsn = sa2.hsn /*and sd.result_Call in ('A','P','I')*/ and substr(sd.flags,1,1) = 'D'
                 where get_cust_group(sa2.reqnbr) = cust_group
                   and sa2.sample_type = 'PS'
                   and sa2.matrix = 'U'
                   and fiscalyear(sa2.report_date) = year
                   and to_char(sa2.report_date,'mm') IN ('10','11','12','01')) "TOTAL"
          from (select get_cust_group(sa.reqnbr) "CUST_GROUP"
                     , count(*) "FINDINGS"
                     , fiscalyear(sa.report_date) "YEAR"
                  from samples sa
                    inner join profiles p on p.reqnbr = sa.reqnbr
                    inner join sample_drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
                 where sa.sample_type = 'PS'
                   and sa.report_date <= to_date('07/01/2020','mm/dd/yyyy')
                   and sa.report_date > to_date('07/01/2019','mm/dd/yyyy')
                   and sa.matrix = 'U'
                   and sa.final_result in ('P','3','4')
                   and p.cust_id not in ('COLUMBIA','DEA','KISS','SWOG-CTI','PLCR')
                   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), get_cust_group(sa.reqnbr)
order by 1,3));



-- AAFs
select count(*)
     , fiscalyear(sa.report_date)
     , decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
    inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
   and sa.matrix = 'U'
   and sa.final_result in ('P','3','4')--('A','P','3','4')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;



-- IRMS AAF
select count(distinct sa.hsn)
     , fiscalyear(sa.report_date)
     , decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
    inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
    inner join sample_acodes sac on sa.hsn = sac.hsn
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
   and sa.matrix = 'U'
   and sa.final_result in ('P','3','4')--('A','P','3','4')
   and sd.cmp_class = 'ENDG'
   and sac.acode LIKE '%IRMS%'
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;



-- Average Turn-around Time by Drug Class (positives)
select avg(sa.turn_days)
     , fiscalyear(sa.report_date)
     , decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
    inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
   and sa.matrix = 'U'
   and sa.final_result in ('P','3','4')--('A','P','3','4')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;



-- Average Turn-around Time IRMS (positives)
select avg(sa.turn_days)
     , fiscalyear(sa.report_date)
     , decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
    inner join sample_Drugs sd on sd.hsn = sa.hsn and sd.result_Call in ('A','P','I') and substr(sd.flags,1,1) = 'D'
    inner join sample_acodes sac on sa.hsn = sac.hsn
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and p.cust_Id not in ('COLUMBIA','DEA','SWOG-CTI','KISS','PLCR')
   and sa.matrix = 'U'
   and sa.final_result in ('P','3','4')--('A','P','3','4')
   and sd.cmp_class = 'ENDG'
   and sac.acode LIKE '%IRMS%'
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date), decode(sd.cmp_class,'AMP','STIM','RITA','STIM','OXYC','NARC','DIUR','MA','AEA','HAMM','SARM','OAA',sd.cmp_class)
order by 3, 2;



-- Supplement Testing
select count(*)
     , fiscalyear(sa.report_date)
  from samples sa
    inner join profiles p on p.reqnbr = sa.reqnbr
 where sa.sample_type = 'PS'
   and sa.report_date >= to_date('07/01/2016','mm/dd/yyyy')
   and p.cust_id IN ('SPECIAL')
   and sa.receive_user IN ('RVAN','SPET','TCAM','ZWEG')
   and to_char(sa.report_date,'mm') IN ('10','11','12','01')
group by fiscalyear(sa.report_date)
order by 2;