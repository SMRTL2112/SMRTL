select sa1.hsn, 
sa2.hsn, 
sa1.collect_date, 
sa2.collect_date, 
ad1.aux_data, ad2.aux_data, 
sd1.result_nbr, 
sd2.result_nbr, 
SG_NORMALIZE(sa1.hsn,sd1.result_nbr,1.020) , 
SG_NORMALIZE(sa2.hsn,sd2.result_nbr,1.020),
sd3.result_nbr, sd4.result_nbr, SG_NORMALIZE(sa1.hsn,sd3.result_nbr,1.020), SG_NORMALIZE(sa2.hsn,sd4.result_nbr,1.020),
sd5.result_nbr, sd6.result_nbr, SG_NORMALIZE(sa1.hsn,sd5.result_nbr,1.020), SG_NORMALIZE(sa2.hsn,sd6.result_nbr,1.020),
sd7.result_nbr, sd8.result_nbr, SG_NORMALIZE(sa1.hsn,sd7.result_nbr,1.020), SG_NORMALIZE(sa2.hsn,sd8.result_nbr,1.020),
sd9.result_nbr, sd10.result_nbr, SG_NORMALIZE(sa1.hsn,sd9.result_nbr,1.020), SG_NORMALIZE(sa2.hsn,sd10.result_nbr,1.020),
sd11.result_nbr, sd12.result_nbr, SG_NORMALIZE(sa1.hsn,sd11.result_nbr,1.020), SG_NORMALIZE(sa2.hsn,sd12.result_nbr,1.020)
from samples sa1
inner join samples sa2 on sa2.reqnbr = sa1.reqnbr and sa1.collect_name = sa2.collect_name and (sa2.collect_date - sa1.collect_date)*60*24 < 90 and sa1.location = sa2.location
inner join aux_Data ad1 on ad1.aux_data_id = sa1.hsn and ad1.aux_Data_format = 'SV' and ad1.aux_field = 1
inner join aux_Data ad2 on ad2.aux_data_id = sa2.hsn and ad2.aux_Data_format = 'SV' and ad2.aux_field = 1
inner join sample_drugs sd1 on sd1.hsn = sa1.hsn and sd1.cmp = 'testosterone' and substr(sd1.flags,1,1) = 'S'
inner join sample_drugs sd2 on sd2.hsn = sa2.hsn and sd2.cmp = 'testosterone' and substr(sd2.flags,1,1) = 'S'
inner join sample_drugs sd3 on sd3.hsn = sa1.hsn and sd3.cmp = 'androsterone' and substr(sd3.flags,1,1) = 'S'
inner join sample_drugs sd4 on sd4.hsn = sa2.hsn and sd4.cmp = 'androsterone' and substr(sd4.flags,1,1) = 'S'
inner join sample_drugs sd5 on sd5.hsn = sa1.hsn and sd5.cmp = 'etiocholanolone' and substr(sd5.flags,1,1) = 'S'
inner join sample_drugs sd6 on sd6.hsn = sa2.hsn and sd6.cmp = 'etiocholanolone' and substr(sd6.flags,1,1) = 'S'
inner join sample_drugs sd7 on sd7.hsn = sa1.hsn and sd7.cmp = 'epitestosterone' and substr(sd7.flags,1,1) = 'S'
inner join sample_drugs sd8 on sd8.hsn = sa2.hsn and sd8.cmp = 'epitestosterone' and substr(sd8.flags,1,1) = 'S'
inner join sample_drugs sd9 on sd9.hsn = sa1.hsn and sd9.cmp = '5a-androdiol' and substr(sd9.flags,1,1) = 'S'
inner join sample_drugs sd10 on sd10.hsn = sa2.hsn and sd10.cmp = '5a-androdiol' and substr(sd10.flags,1,1) = 'S'
inner join sample_drugs sd11 on sd11.hsn = sa1.hsn and sd11.cmp = '5b-androdiol' and substr(sd11.flags,1,1) = 'S'
inner join sample_drugs sd12 on sd12.hsn = sa2.hsn and sd12.cmp = '5b-androdiol' and substr(sd12.flags,1,1) = 'S'
where sa1.reqnbr = 49
and ad1.aux_Data < 1.005
and sa1.receive_date > sysdate - 180
and sa1.hsn <> sa2.hsn
and (select count(*) from samples where hsn <> sa1.hsn and reqnbr = sa1.reqnbr and collect_name = sa1.collect_name and location = sa1.location) = 1
