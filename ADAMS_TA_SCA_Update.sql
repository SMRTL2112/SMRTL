select pi.cust_sample_id "sample_code",
ad1.aux_Data "ta",
ad3.aux_Data "rma",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD') "date_received",
to_char(sa.collect_date,'YYYY-MM-DD') "sample_collection_date",
ad5.aux_data "mo_number",
'A' "sampleAB",
'Urine' "sample_type"
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
left outer join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
left outer join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
left outer join aux_data ad3 on ad3.aux_data_id = c.cust_seq and ad3.aux_data_type = 'C' and ad3.aux_data_format = 'ADMS' and ad3.aux_field = 3
left outer join aux_data ad4 on ad4.aux_data_id = sa.hsn and ad4.aux_data_type = 'S' and ad4.aux_data_format = 'WAD2' and ad4.aux_field = 3
left outer join aux_data ad5 on ad5.aux_data_id = sa.hsn and ad5.aux_data_type = 'S' and ad5.aux_data_format = 'WAD2' and ad5.aux_field = 5
inner join permanent_ids pi on pi.hsn = sa.hsn 
where sa.reqnbr = 1472
order by 4;
