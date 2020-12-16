select pi.cust_sample_id "sample_code",
ad1.aux_Data "ta",
substr(ad3.aux_Data,1,instr(ad3.aux_Data,'|')-1) "sport_code",
substr(ad3.aux_data,4) "discipline_code",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD HH24:MI') "date_received",
--'OOC' "event_type",
--'A' "sampleAB",
--decode(sa.matrix,'U','Urine','B','Blood') "sample_type"
'blood_passport' "sample_type",
'LAB-UTAH-USA-SMRTL' "lab"
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
left outer join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
left outer join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
left outer join aux_data ad3 on ad3.aux_data_id = sa.hsn and ad3.aux_data_type = 'S' and ad3.aux_data_format = 'WAD2' and ad3.aux_field = 3
left outer join aux_data ad4 on ad4.aux_data_id = sa.hsn and ad4.aux_data_type = 'S' and ad4.aux_data_format = 'WAD2' and ad4.aux_field = 5
inner join permanent_ids pi on pi.hsn = sa.hsn 
where exists (select 1 from containers where hsn = sa.hsn and container_type in ('EDTA-A'))
--and sa.wip_status = 'RP'
and sa.original_coc in (
'304511','199880','4005659', 
'304507','4005830','300475',
'304508','199812','4005658',
'304510','4005808','199786',
'304592','4005807','300491',
'304531','4005566','300150',
'304519','4005805','179205')
