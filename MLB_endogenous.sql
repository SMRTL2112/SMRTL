select pi.cust_sample_id, pi.lab_sample_id, 
sa.collect_date, 
nvl(sd_te2.result_nbr,sd_te.result_nbr) "TE_RESULT", 
nvl(sd_tt2.result_nbr,sd_tt.result_nbr) "TEST_RESULT",
nvl(sd_ep2.result_nbr,sd_ep.result_nbr) "EPI_RESULT",
nvl(sd_an2.result_nbr,sd_an.result_nbr) "ANDRO_RESULT",
nvl(sd_et2.result_nbr,sd_et.result_nbr) "ETIO_RESULT",
nvl(sd_hcg.result_text,sd_hcg.result_nbr) "HCG_RESULT", 
sd_lh.result_nbr "LH_RESULT", 
nvl(sd_5a2.result_nbr,sd_5a.result_nbr) "5ADIOL_RESULT",
nvl(sd_5b2.result_nbr,sd_5b.result_nbr) "5BDIOL_RESULT",
nvl(sd_dh2.result_nbr,sd_dh.result_nbr) "DHEA_RESULT",
sd_pd.result_nbr "IRMS_PREGNANEDIOL",
sd_11b.result_nbr "IRMS_11BOHANDRO",
sd_irms_a.result_nbr "IRMS_ANDRO",
sd_irms_e.result_nbr "IRMS_ETIO",
sd_irms_t.result_nbr "IRMS_TEST",
null "IRMS_DHEA",
sd_irms_5a.result_nbr "IRMS_5A-DIOL",
sd_irms_5b.result_nbr "IRMS_5B-DIOL",
nvl(ad_sg.aux_data,nvl(sd_sg2.result_nbr,sd_sg.result_nbr)) "SPGR_RESULT"
from samples sa 
left outer join sample_drugs sd_te2 on sd_te2.hsn = sa.hsn and sd_te2.cmp in ('t/e') and substr(sd_te2.flags,1,1) = 'C'
left outer join sample_drugs sd_te on sd_te.hsn = sa.hsn and sd_te.cmp in ('t/e') and substr(sd_te.flags,1,1) = 'S'
inner join sample_drugs sd_an on sd_an.hsn = sa.hsn and sd_an.cmp = 'androsterone' and substr(sd_an.flags,1,1) = 'S'
left outer join sample_drugs sd_an2 on sd_an2.hsn = sa.hsn and sd_an2.cmp = 'androsterone' and substr(sd_an2.flags,1,1) = 'C'
left outer join sample_drugs sd_5a on sd_5a.hsn = sa.hsn and sd_5a.cmp = '5a-androdiol' and substr(sd_5a.flags,1,1) = 'S'
left outer join sample_drugs sd_5a2 on sd_5a2.hsn = sa.hsn and sd_5a2.cmp = '5a-androdiol' and substr(sd_5a2.flags,1,1) = 'C'
left outer join sample_drugs sd_5b on sd_5b.hsn = sa.hsn and sd_5b.cmp = '5b-androdiol' and substr(sd_5b.flags,1,1) = 'S'
left outer join sample_drugs sd_5b2 on sd_5b2.hsn = sa.hsn and sd_5b2.cmp = '5b-androdiol' and substr(sd_5b2.flags,1,1) = 'C'
inner join sample_drugs sd_et on sd_et.hsn = sa.hsn and sd_et.cmp = 'etiocholanolone'  and substr(sd_et.flags,1,1) = 'S'
left outer join sample_drugs sd_et2 on sd_et2.hsn = sa.hsn and sd_et2.cmp = 'etiocholanolone'  and substr(sd_et2.flags,1,1) = 'C'
inner join sample_drugs sd_ep on sd_ep.hsn = sa.hsn and sd_ep.cmp = 'epitestosterone' and substr(sd_ep.flags,1,1) = 'S'
left outer join sample_drugs sd_ep2 on sd_ep2.hsn = sa.hsn and sd_ep2.cmp = 'epitestosterone' and substr(sd_ep2.flags,1,1) = 'C'
inner join sample_drugs sd_tt on sd_tt.hsn = sa.hsn and sd_tt.cmp = 'testosterone' and substr(sd_tt.flags,1,1) = 'S'
left outer join sample_drugs sd_tt2 on sd_tt2.hsn = sa.hsn and sd_tt2.cmp = 'testosterone' and substr(sd_tt2.flags,1,1) = 'C'
inner join sample_drugs sd_dh on sd_dh.hsn = sa.hsn and sd_dh.cmp = 'dhea' and substr(sd_tt.flags,1,1) = 'S'
left outer join sample_drugs sd_dh2 on sd_dh.hsn = sa.hsn and sd_dh.cmp = 'dhea' and substr(sd_tt.flags,1,1) = 'C'
left outer join sample_drugs sd_hcg on sd_hcg.hsn = sa.hsn and sd_hcg.cmp = 'hcg'
left outer join sample_drugs sd_irms_a on sd_irms_a.hsn = sa.hsn and sd_irms_a.cmp = 'andro-delta-C'
left outer join sample_drugs sd_irms_e on sd_irms_e.hsn = sa.hsn and sd_irms_e.cmp = 'etio-delta-C'
left outer join sample_drugs sd_irms_5a on sd_irms_5a.hsn = sa.hsn and sd_irms_5a.cmp = '5a-diol-delta-C'
left outer join sample_drugs sd_irms_5b on sd_irms_5b.hsn = sa.hsn and sd_irms_5b.cmp = '5b-diol-delta-C'
left outer join sample_drugs sd_irms_t on sd_irms_t.hsn = sa.hsn and sd_irms_t.cmp = 'test-delta-C'
left outer join sample_drugs sd_pd on sd_pd.hsn = sa.hsn and sd_pd.cmp like 'preg%'
left outer join sample_drugs sd_11b on sd_11b.hsn = sa.hsn and sd_11b.cmp = '11bOHandro-d-C'
left outer join sample_drugs sd_lh on sd_lh.hsn = sa.hsn and sd_lh.cmp = 'lh'
left outer join sample_drugs sd_dt on sd_dt.hsn = sa.hsn and sd_dt.cmp = 'dht'
left outer join sample_drugs sd_sg on sd_sg.hsn = sa.hsn and sd_sg.cmp = 'spgr' and substr(sd_sg.flags,1,1) = 'S'
left outer join sample_drugs sd_sg2 on sd_sg2.hsn = sa.hsn and sd_sg2.cmp = 'spgr' and substr(sd_sg2.flags,1,1) = 'C'
left outer join aux_data ad_sg on ad_sg.aux_data_id = sa.hsn and ad_sg.aux_data_type = 'S' and ad_sg.aux_data_format = 'SV' and ad_sg.aux_field = 1
inner join profiles pr on pr.reqnbr = sa.reqnbr
inner join permanent_ids pi on pi.hsn = sa.hsn
where sa.original_coc in (
'S008798811',
'S008809345',
'S008818452',
'S009030412')
and sa.report_date is not null
and pr.cust_id = 'MLB'
and pr.reqnbr = 49
order by 3;
