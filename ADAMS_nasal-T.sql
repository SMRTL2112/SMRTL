-- ADAMS query
select pi.cust_sample_id "sample_code",
sa.hsn "lin",
'IFTEST ABP' "sca",
'IFTEST ABP' "ta",
'CY' "sport_code",
'Negative' "test_result",
'IC' "test_type",
'CR' "discipline_code",
to_char(sa.receive_date,'YYYY-MM-DD') "date_received",
'URINE' "sample_type",
'A' "sampleAB",
get_sg(sa.hsn) "specific_gravity",
'Y' "valid",
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
'5b-androstanediol' "steroid_profile_variable_c6",
sd7.result_nbr "steroid_profile_variable_v7",
'T/E' "steroid_profile_variable_c7"
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
inner join permanent_ids pi on pi.hsn = sa.hsn 
where sa.reqnbr =874
order by 2;

-- ADAMS query 2
select pi.cust_sample_id "sample_code",
sa.hsn "lin",
'IFTEST ABP' "sca",
'IFTEST ABP' "ta",
'CY' "sport_code",
'Negative' "test_result",
'IC' "test_type",
'CR' "discipline_code",
to_char(sa.receive_date,'YYYY-MM-DD') "date_received",
'URINE' "sample_type",
'A' "sampleAB",
get_sg(sa.hsn) "specific_gravity",
'Y' "valid",
ar1.cmp_result "steroid_profile_variable_v1",
'testosterone' "steroid_profile_variable_c1",
ar2.cmp_result "steroid_profile_variable_v2",
'epitestosterone' "steroid_profile_variable_c2",
ar3.cmp_result "steroid_profile_variable_v3",
'androsterone' "steroid_profile_variable_c3",
ar4.cmp_result "steroid_profile_variable_v4",
'etiocholanolone' "steroid_profile_variable_c4",
ar5.cmp_result "steroid_profile_variable_v5",
'5a-androstanediol' "steroid_profile_variable_c5",
ar6.cmp_result "steroid_profile_variable_v6",
'5b-androstanediol' "steroid_profile_variable_c6",
ar7.cmp_result "steroid_profile_variable_v7",
'T/E' "steroid_profile_variable_c7"
from samples sa 
inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.queue = 'GSCR'
inner join analytical_results ar1 on ar1.schedule_seq = sc.schedule_seq and ar1.cmp ='testosterone'
inner join analytical_results ar2 on ar2.schedule_seq = sc.schedule_seq and ar2.cmp ='epitestosterone'
inner join analytical_results ar3 on ar3.schedule_seq = sc.schedule_seq and ar3.cmp ='androsterone'
inner join analytical_results ar4 on ar4.schedule_seq = sc.schedule_seq and ar4.cmp ='etiocholanolone'
inner join analytical_results ar5 on ar5.schedule_seq = sc.schedule_seq and ar5.cmp ='5a-androdiol'
inner join analytical_results ar6 on ar6.schedule_seq = sc.schedule_seq and ar6.cmp ='5b-androdiol'
inner join analytical_results ar7 on ar7.schedule_seq = sc.schedule_seq and ar7.cmp ='t/e'
inner join profiles p on p.reqnbr = sa.reqnbr 
inner join customers c on c.cust_id = p.cust_id
inner join permanent_ids pi on pi.hsn = sa.hsn 
where sa.reqnbr =874
and sa.wip_status = 'WP'
order by 2;

-- SMRTL Profiling
select pa.patient_id, replace(replace(pi.cust_sample_id,'-10','-A'),'-11','-B'), pi.lab_sample_id, 
sa.collect_date, 
ar7.cmp_result "TE_RESULT", 
decode(ar1.cmp_result,0,null,trunc(ar3.cmp_result/ar1.cmp_result,2)) "AT_RESULT",
decode(ar2.cmp_result,0,null,trunc(ar6.cmp_result/ar2.cmp_result,2)) "5BE_RESULT",
ar1.cmp_result "TEST_RESULT",
SG_NORMALIZE(sa.hsn,ar1.cmp_result,1.020) "TEST_NORM",
ar2.cmp_result "EPI_RESULT",
SG_NORMALIZE(sa.hsn,ar2.cmp_result,1.020) "EPI_NORM",
ar3.cmp_result "ANDRO_RESULT",
SG_NORMALIZE(sa.hsn,ar3.cmp_result,1.020) "ANDRO_NORM",
ar4.cmp_result "ETIO_RESULT",
SG_NORMALIZE(sa.hsn,ar4.cmp_result,1.020) "ETIO_NORM",
nvl(sd_hcg.result_text,sd_hcg.result_nbr) "HCG_RESULT", 
SG_NORMALIZE(sa.hsn,sd_hcg.result_nbr,1.020) "HCG_NORM",
sd_lh.result_nbr "LH_RESULT", 
SG_NORMALIZE(sa.hsn,sd_lh.result_nbr,1.020) "LH_NORM",
ar5.cmp_result "5ADIOL_RESULT",
SG_NORMALIZE(sa.hsn,ar5.cmp_result,1.020) "5ADIOL_NORM",
ar6.cmp_result "5BDIOL_RESULT",
SG_NORMALIZE(sa.hsn,ar6.cmp_result,1.020) "5BDIOL_NORM",
ar8.cmp_result "DHEA_RESULT",
SG_NORMALIZE(sa.hsn,ar8.cmp_result,1.020) "DHEA_NORM",
ar_erc.cmp "ERC",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_a.result_nbr,sd_pd_a.result_nbr) "ERC-ANDRO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_e.result_nbr,sd_pd_e.result_nbr) "ERC-ETIO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5a.result_nbr,sd_pd_5a.result_nbr) "ERC-5A",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5b.result_nbr,sd_pd_5b.result_nbr) "ERC-5B",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_t.result_nbr,sd_pd_t.result_nbr) "ERC-TEST",
nvl(ad_sg.aux_data,nvl(sd_sg2.result_nbr,sd_sg.result_nbr)) "SPGR_RESULT"
from samples sa 
inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S' and sc.queue = 'GSCR' and sc.active_flag = 'F'
inner join analytical_results ar1 on ar1.schedule_seq = sc.schedule_seq and ar1.cmp ='testosterone'
inner join analytical_results ar2 on ar2.schedule_seq = sc.schedule_seq and ar2.cmp ='epitestosterone'
inner join analytical_results ar3 on ar3.schedule_seq = sc.schedule_seq and ar3.cmp ='androsterone'
inner join analytical_results ar4 on ar4.schedule_seq = sc.schedule_seq and ar4.cmp ='etiocholanolone'
inner join analytical_results ar5 on ar5.schedule_seq = sc.schedule_seq and ar5.cmp ='5a-androdiol'
inner join analytical_results ar6 on ar6.schedule_seq = sc.schedule_seq and ar6.cmp ='5b-androdiol'
inner join analytical_results ar7 on ar7.schedule_seq = sc.schedule_seq and ar7.cmp ='t/e'
inner join analytical_results ar8 on ar8.schedule_seq = sc.schedule_seq and ar8.cmp ='dhea'
left outer join sample_drugs sd_hcg on sd_hcg.hsn = sa.hsn and sd_hcg.cmp = 'hcg'
left outer join sample_drugs sd_pd_a on sd_pd_a.hsn = sa.hsn and sd_pd_a.cmp = 'PREGNANED-ANDRO'
left outer join sample_drugs sd_pd_e on sd_pd_e.hsn = sa.hsn and sd_pd_e.cmp = 'PREGNANED-ETIO'
left outer join sample_drugs sd_pd_t on sd_pd_t.hsn = sa.hsn and sd_pd_t.cmp = 'PREGNANED-TEST'
left outer join sample_drugs sd_pd_5a on sd_pd_5a.hsn = sa.hsn and sd_pd_5a.cmp = 'PREGNANED-5A'
left outer join sample_drugs sd_pd_5b on sd_pd_5b.hsn = sa.hsn and sd_pd_5b.cmp = 'PREGNANED-5B'
left outer join sample_drugs sd_11_a on sd_11_a.hsn = sa.hsn and sd_11_a.cmp = '11BOHANDR-ANDRO'
left outer join sample_drugs sd_11_e on sd_11_e.hsn = sa.hsn and sd_11_e.cmp = '11BOHANDRO-ETIO'
left outer join sample_drugs sd_11_t on sd_11_t.hsn = sa.hsn and sd_11_t.cmp = '11BOHANDRO-TEST'
left outer join sample_drugs sd_11_5a on sd_11_5a.hsn = sa.hsn and sd_11_5a.cmp = '11BOHANDR-5A'
left outer join sample_drugs sd_11_5b on sd_11_5b.hsn = sa.hsn and sd_11_5b.cmp = '11BOHANDR-5B'
left outer join sample_drugs sd_pd on sd_pd.hsn = sa.hsn and sd_pd.cmp like 'preg%delt%'
left outer join sample_drugs sd_lh on sd_lh.hsn = sa.hsn and sd_lh.cmp = 'lh'
left outer join sample_drugs sd_dt on sd_dt.hsn = sa.hsn and sd_dt.cmp = 'dht'
left outer join sample_drugs sd_sg on sd_sg.hsn = sa.hsn and sd_sg.cmp = 'spgr' and substr(sd_sg.flags,1,1) = 'S'
left outer join sample_drugs sd_sg2 on sd_sg2.hsn = sa.hsn and sd_sg2.cmp = 'spgr' and substr(sd_sg2.flags,1,1) = 'C'
left outer join analytical_results ar_erc on ar_erc.schedule_seq = sd_pd_a.schedule_seq and ar_erc.cmp_cond = 'E'
left outer join aux_data ad_sg on ad_sg.aux_data_id = sa.hsn and ad_sg.aux_data_type = 'S' and ad_sg.aux_data_format = 'SV' and ad_sg.aux_field = 1
inner join profiles pr on pr.reqnbr = sa.reqnbr
inner join permanent_ids pi on pi.hsn = sa.hsn
inner join patients pa on pa.patient_seq = pi.patient_seq
where sa.reqnbr = 874
and sa.receive_date > sysdate - 60
order by 1,2;

