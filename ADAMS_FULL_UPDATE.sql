select pi.cust_sample_id "sample_code",
'URINE' "sample_type",
'A' "sampleAB",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD') "date_received",
sa.hsn "lin",
ad.aux_data "SCA",
'GH' "analysis_attribute"
from samples sa 
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join aux_data ad on ad.aux_data_id = c.cust_seq and ad.aux_data_type = 'C' and ad.aux_data_format = 'ADMS' and ad.aux_field = 2
inner join permanent_ids pi on pi.hsn = sa.hsn 
where p.cust_id like 'WRUGBY%'
and sa.matrix = 'U'
and sa.report_Date > sysdate - 1
and not exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'EPO' and active_flag = 'F')
and exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'GHRP' and active_flag = 'F')
and not exists (select 1 from schedules where schedule_id = sa.hsn and queue = 'IRMS' and active_flag = 'F')
