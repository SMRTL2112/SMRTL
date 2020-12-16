-- All urine records in XML file
--select count(*)
select count(distinct hsn) from (
select sa.hsn, sa.original_coc, sa.final_result, decode(
(select distinct 1
from mlb_results
where existsNode(XML_DOC,'/resultUpload/samples/sample[labCode="'||sa.hsn||'"]')=1),1,'Y','N') "IN_DTS"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.final_result = 'N'
and sa.matrix = 'U'
and substr(sa.flags,8,1) = 'd'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate)
where in_dts = 'Y';

select sa.hsn, sa.original_coc, sa.final_result, decode(
(select distinct 1
from mlb_results
where existsNode(XML_DOC,'/resultUpload/samples/sample[labCode="'||sa.hsn||'"]')=1),1,'Y','N') "IN_DTS"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.final_result <> 'N'
and sa.matrix = 'U'
and substr(sa.flags,8,1) = 'd'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate;



-- All biomarkers records in XML file
select hsn, original_coc, final_result
from (
select sa.hsn, sa.original_coc, sa.final_result, decode(
(select distinct 1
from mlb_results
where existsNode(XML_DOC,'/resultUpload/samples/sample[labCode="'||sa.hsn||'"]')=1),1,'Y','N') "IN_DTS"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB-Blood'
and sa.final_result = 'N'
and sa.matrix = 'B'
and substr(sa.flags,8,1) = 'd'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate)
where in_dts = 'N';

-- MLB-Blood
select count(*), trunc(sa.report_date)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
where p.cust_id= 'MLB-Blood'
and substr(sa.flags,8,1) = 'd'
and sa.wip_status = 'RP'
group by trunc(sa.report_date);


select sa.hsn, all_open_schedules(sa.hsn), substr(sa.flags,8,1)
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
where p.cust_id= 'MLB-Blood'
and sa.wip_status = 'RP'
and sa.receive_date > sysdate - 90
and sa.report_date > sysdate - 14
and substr(sa.flags,8,1) = 'C';


select count(*), sa.final_result
from samples sa
where sa.reqnbr = 49
and substr(sa.flags,8,1) = 'd'
and sa.wip_status = 'RP'
and sa.report_date > sysdate - 1/24
group by sa.final_result