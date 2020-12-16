select pi.cust_sample_id "sample_code",
sa.hsn "lin",
ad.aux_data "SCA",
to_char(sa.receive_date,'YYYY-MM-DD') "date_received",
'-1' "steroid_profile_variable_v1",
't/e' "steroid_profile_variable_c1",
'URINE' "sample_type",
'A' "sampleAB"
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join aux_data ad on ad.aux_data_id = c.cust_seq and ad.aux_data_type = 'C' and ad.aux_data_format = 'ADMS' and ad.aux_field = 2
inner join permanent_ids pi on pi.hsn = sa.hsn 
where substr(c.flags,1,1) = 'W'
--and sa.report_date > sysdate - 90
and sa.original_coc = '1571284'