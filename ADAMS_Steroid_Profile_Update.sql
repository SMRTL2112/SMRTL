select pi.cust_sample_id "sample_code",
sa.hsn "lin",
'IFTEST ABP' "sca",
'IFTEST ABP' "ta",
to_char(sa.receive_date,'YYYY-MM-DD') "date_received",
'URINE' "sample_type",
'A' "sampleAB",
sd1.result_nbr "steroid_profile_variable_v1",
'testosterone' "steroid_profile_variable_c1",
sd2.result_nbr "steroid_profile_variable_v2",
'epitestosterone' "steroid_profile_variable_c2",
sd3.result_nbr "steroid_profile_variable_v3",
'androsterone' "steroid_profile_variable_c3",
sd4.result_nbr "steroid_profile_variable_v4",
'etiocholanolone' "steroid_profile_variable_c4",
sd5.result_nbr "steroid_profile_variable_v5",
'5a-androstanediol' "steroid_profile_variable_c5",
sd6.result_nbr "steroid_profile_variable_v6",
'5b-androstanediol' "steroid_profile_variable_c6"
from samples sa 
inner join sample_drugs sd1 on sd1.hsn = sa.hsn and sd1.cmp = 'testosterone'
inner join sample_drugs sd7 on sd7.hsn = sa.hsn and sd7.cmp = 't/e'
inner join sample_drugs sd2 on sd2.hsn = sa.hsn and sd2.cmp = 'epitestosterone'
inner join sample_drugs sd3 on sd3.hsn = sa.hsn and sd3.cmp = 'androsterone'
inner join sample_drugs sd4 on sd4.hsn = sa.hsn and sd4.cmp = 'etiocholanolone'
inner join sample_drugs sd5 on sd5.hsn = sa.hsn and sd5.cmp = '5a-androdiol'
inner join sample_drugs sd6 on sd6.hsn = sa.hsn and sd6.cmp = '5b-androdiol'
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
left outer join aux_data ad on ad.aux_data_id = c.cust_seq and ad.aux_data_type = 'C' and ad.aux_data_format = 'ADMS' and ad.aux_field = 2
inner join permanent_ids pi on pi.hsn = sa.hsn 
where sa.reqnbr =874
order by 2;
