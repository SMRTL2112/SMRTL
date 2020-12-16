select distinct bs.queue
     , bs.batch_number
     , b.qc_rule
     , trunc(b.create_datE) "Date"
     , decode(substr(sc.flags,7,1),'S','Screen','C','Confirmation') "Type"
  from schedules sc 
    inner join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
    inner join batches b on b.queue = bs.queue and bs.batch_number = b.batch_number
    inner join samples sa on sa.hsn = sc.schedule_id
    inner join profiles p on p.reqnbr = sa.reqnbr
 where (p.cust_id in ('ARMY','NAVY','AIR FORCE') or p.cust_id like 'DOD%')
   and substr(sc.flags,7,1) in ('S','C')
   and b.create_DATE BETWEEN to_date('10/01/2015','mm/dd/yyyy') AND to_date('09/30/2016','mm/dd/yyyy')
order by 5,3,4;



select p.cust_id
     , count(sc.schedule_id)
  from schedules sc 
    inner join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
    inner join batches b on b.queue = bs.queue and bs.batch_number = b.batch_number
    inner join samples sa on sa.hsn = sc.schedule_id
    inner join profiles p on p.reqnbr = sa.reqnbr
 where (p.cust_id in ('ARMY','NAVY','AIR FORCE') or p.cust_id like 'DOD%')
   and substr(sc.flags,7,1) in ('S','C')
   and b.create_DATE BETWEEN to_date('10/01/2015','mm/dd/yyyy') AND to_date('09/30/2016','mm/dd/yyyy')
group by p.cust_id
order by p.cust_id;