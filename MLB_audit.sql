-- Total MLB results reported
select count(*), substr(sa.flags,8,1)
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
group by substr(sa.flags,8,1);

-- All MLB results with flag 8 = 'C'
select sa.hsn, sa.final_result, sa.original_coc, substr(sa.flags,8,1),
(select count(*) from schedules where schedule_id = sa.hsn and queue = 'IRMS') "IRMS",
(select count(*) from footnotes where footnote_id = sa.hsn and predefined like 'MICROB%') "MICROBE"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.matrix in ('U','X')
and substr(sa.flags,8,1) in ('C','F')
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
order by 3;


-- Biomarkers results with flag 8 = 'C'
select sa.hsn, sa.final_result, sa.original_coc,
(select count(*) from map_to_hdm where object_id = sa.hsn and object_type = 'S' and lims_use = 'Final Report') "HCM_COUNT"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB-Blood'
and sa.matrix in ('B')
and substr(sa.flags,8,1) in ('C','F','d')
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
order by 3;



-- All MLB positives
select sa.hsn, sa.final_result, sa.original_coc, substr(sa.flags,8,1)
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.final_result <> 'N'
and sa.matrix = 'U'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
order by 3;

-- All non-negative Records in XML file
select sa.hsn, sa.final_result, sa.original_coc || ' ('||decode(
(select distinct 1
from mlb_results
where existsNode(XML_DOC,'/TABLE/LABRESULTS[labCode="'||sa.hsn||'"]')=1),1,'Y','N')||')' "IN_DTS"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and sa.final_result <> 'N'
and sa.matrix = 'U'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
order by 3;

-- Negative check; look for samples not in DTS
select hsn, original_coc, in_dts
from (
select sa.hsn, sa.final_result, sa.original_coc, decode(
(select distinct 1
from mlb_results
where existsNode(XML_DOC,'/TABLE/LABRESULTS[labCode="'||sa.hsn||'"]')=1),1,'Y','N') "IN_DTS"
from samples sa
inner join profiles p on p.reqnbr =sa.reqnbr
and p.cust_id = 'MLB'
and substR(sa.flags,8,1) = 'X'
and sa.final_result = 'N'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate)
where in_dts = 'Y'
order by 1;

select count(*) from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
where p.cust_id = 'MLB'
and sa.report_date > :pStartDate
and sa.report_date < :pStopDate
and sa.final_result = 'N'
and sa.matrix = 'U'
and substr(sa.flags,8,1) = 'X';

