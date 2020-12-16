select pi.cust_sample_id "sample_code",
ad2.aux_data "sca",
to_char(sa.receive_date,'YYYY-MM-DD HH24:MI:SS') "date_received",
ad4.aux_data "mo_number",
'LAB-UTAH-USA-SMRTL' "lab",
'Blood_passport' "sample_type"
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
left outer join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
left outer join aux_data ad3 on ad3.aux_data_id = sa.hsn and ad3.aux_data_type = 'S' and ad3.aux_data_format = 'WAD2' and ad3.aux_field = 3
left outer join aux_data ad4 on ad4.aux_data_id = sa.hsn and ad4.aux_data_type = 'S' and ad4.aux_data_format = 'WAD2' and ad4.aux_field = 5
inner join permanent_ids pi on pi.hsn = sa.hsn 
where pi.cust_sample_id in (
'062702'
);






