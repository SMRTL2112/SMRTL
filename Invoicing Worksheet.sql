select turn_days, count(*)
from sample_acodes 
where acode = 'IRMS STER'
group by turn_days;


update sample_acodes
set turn_days = 21
where  acode = 'IRMS STER'
and turn_days is null;

commit;


select * from analysis_details where acode in ('R AMPHETAM','AMPHETAMIN','IRMS STER','R HCG');

select * from analysis_Details where turn_code = 'PW01';

select * from base_price_sheets where part = 'IRMS STER';

update samples
set charge_trigger = -1
where hsn in (
select s.hsn
from sample_acodes sa
inner join samples s on s.hsn = sa.hsn
where sa.acode = 'IRMS STER' 
and s.report_date >= '10/1/09'
and sa.turn_days = 21);

rollback;

--select count(distinct hsn)
select count(*), part, charge
from accumulated_charges
where invoice_seq < 0
and charge_date < '1/1/2010'
and cust_id = 'USADA'
group by part, charge;

select count(*), reqnbr, part
from accumulated_charges
where invoice_seq < 0
and charge_date < '1/1/2010'
and cust_id = 'NFL'
group by reqnbr, part;

select * from accumulated_charges where hsn = 73773;

sel


select s.hsn, s.reqnbr
from profiles p
inner join samples s on s.reqnbr = p.reqnbr
where p.cust_id = 'NFL'
and s.report_Date >= '12/1/2009'
and s.report_Date < '1/1/2010'
MINUS
select hsn, reqnbr
from accumulated_charges
where invoice_seq < 0
and cust_id = 'NFL'
and part = 'NFL_PANEL'
and charge_date < '1/1/2010';


select * from accumulated_charges where hsn = 73566;
delete from accumulated_charges
where hsn = 80449;

update sample_acodes
set charge_seq = null
where hsn = 80449;


commit;



select hsn
from accumulated_charges
where part = 'IRMS STER'
and invoice_seq = -1
and cust_id = 'NFL'
MINUS
select hsn from samples where
hsn in
(77269,
77843,
77564,
78129,
78354,
78355,
78356,
78357,
78358,
78359,
78360,
78361,
78362,
78363,
77244,
75883,
76901,
76951);

update accumulated_charges
set charge = 215
where charge = 250
and cust_id = 'NFL'
and invoice_seq = -1;
commit;



select * from sample_acodes where hsn = 74944;

insert into sample_acodes values ('IRMS STER',null,74944,'A',2,21,unique_id.nextval,null,to_date('09/14/09','MM/DD/YY'),null,null);
commit;
update samples set charge_trigger = -1
where hsn in (72199,74937,74939,74944);
commit;


select charge, charge_date
from accumulated_charges
where cust_id = 'NFL'
--and part = 'NFL_PANEL'
and invoice_seq < 0
order by charge_date;

select reqnbr, count(*)
from accumulated_charges where part = 'CBC'
and invoice_seq < 0
and charge_date < '11/1/09'
group by reqnbr;


select hsn, cust_id, reqnbr
from accumulated_charges
where invoice_seq < 0
and charge_date < '01/01/2010'
MINUS
select s.hsn, p.cust_id, s.reqnbr
from samples s
inner join profiles p on p.reqnbr = s.reqnbr
where s.report_date >= '12/01/2009'
and s.report_date < '01/01/2010';



select s.hsn, p.cust_id, s.reqnbr, p.profile_name
from samples s
inner join profiles p on p.reqnbr = s.reqnbr
where s.report_date >= '12/01/2009'
and s.report_date < '01/01/2010'
and s.reqnbr <> 1
MINUS
select hsn, p.cust_id, p.reqnbr, p.profile_name
from accumulated_charges ac
inner join profiles p on p.reqnbr = ac.reqnbr
where invoice_seq < 0
and charge_date < '01/01/2010';

select hsn, p.cust_id, p.reqnbr, p.profile_name
from accumulated_charges ac
inner join profiles p on p.reqnbr = ac.reqnbr
where invoice_seq < 0
and charge_date < '01/01/2010'
MINUS
select s.hsn, p.cust_id, s.reqnbr, p.profile_name
from samples s
inner join profiles p on p.reqnbr = s.reqnbr
where s.report_date >= '12/01/2009'
and s.report_date < '01/01/2010'
and s.reqnbr <> 1;



select count(*), p.profile_name
from samples s
inner join profiles p on p.reqnbr = s.reqnbr
where p.cust_id = 'NFL'
and s.report_date >= '12/01/2009'
and s.report_date < '01/01/2010'
group by p.profile_Name;


select * from accumulated_charges where hsn = 78950;


select ac.hsn, ac.charge_date, s.report_date
from samples s
inner join accumulated_charges ac on ac.hsn = s.hsn
where s.original_coc in ('1526385','1523097');

select * from accumulated_charges where hsn in (66355,71960);


select * from accumulated_charges where hsn in 
(79713,
79189,
79191,
79192,
79196,
79692,
79693,
79702,
79703,
79706,
79710,
79723,
79889,
79906,
79935,
79936,
80171,
80183,
79120,
78964,
79126,
78974,
79114,
79115,
79119,
79121,
79122,
73773
