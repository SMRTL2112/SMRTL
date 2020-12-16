select cpi.player_id, pi.cust_sample_id, pi.lab_sample_id, 
sa.collect_date, 
sd_te.result_nbr "TE_RESULT", 
decode(sd_tt.result_nbr,0,null,trunc(sd_an.result_nbr/sd_tt.result_nbr,2)) "AT_RESULT",
decode(sd_ep.result_nbr,0,null,trunc(sd_5b.result_nbr/sd_ep.result_nbr,2)) "5BE_RESULT",
sd_tt.result_nbr "TEST_RESULT",
SG_NORMALIZE(sa.hsn,sd_tt.result_nbr,1.020) "TEST_NORM",
sd_ep.result_nbr "EPI_RESULT",
SG_NORMALIZE(sa.hsn,sd_ep.result_nbr,1.020) "EPI_NORM",
sd_an.result_nbr "ANDRO_RESULT",
SG_NORMALIZE(sa.hsn,sd_an.result_nbr,1.020) "ANDRO_NORM",
sd_et.result_nbr "ETIO_RESULT",
SG_NORMALIZE(sa.hsn,sd_et.result_nbr,1.020) "ETIO_NORM",
nvl(sd_hcg.result_text,sd_hcg.result_nbr) "HCG_RESULT", 
SG_NORMALIZE(sa.hsn,sd_hcg.result_nbr,1.020) "HCG_NORM",
sd_lh.result_nbr "LH_RESULT", 
SG_NORMALIZE(sa.hsn,sd_lh.result_nbr,1.020) "LH_NORM",
sd_5a.result_nbr "5ADIOL_RESULT",
SG_NORMALIZE(sa.hsn,sd_5a.result_nbr,1.020) "5ADIOL_NORM",
sd_5b.result_nbr "5BDIOL_RESULT",
SG_NORMALIZE(sa.hsn,sd_5b.result_nbr,1.020) "5BDIOL_NORM",
sd_dh.result_nbr "DHEA_RESULT",
SG_NORMALIZE(sa.hsn,sd_dh.result_nbr,1.020) "DHEA_NORM",
ar_erc.cmp "ERC",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_a.result_nbr,sd_pd_a.result_nbr) "ERC-ANDRO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_e.result_nbr,sd_pd_e.result_nbr) "ERC-ETIO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5a.result_nbr,sd_pd_5a.result_nbr) "ERC-5A",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5b.result_nbr,sd_pd_5b.result_nbr) "ERC-5B",
nvl(ad_sg.aux_data,nvl(sd_sg2.result_nbr,sd_sg.result_nbr)) "SPGR_RESULT"
from samples sa 
left outer join cust_player_ids cpi on cpi.cust_sample_id = sa.original_coc
inner join sample_drugs sd_te on sd_te.hsn = sa.hsn and sd_te.cmp in ('t/e') and substr(sd_te.flags,1,1) = 'S'
inner join sample_drugs sd_an on sd_an.hsn = sa.hsn and sd_an.cmp = 'androsterone'
left outer join sample_drugs sd_5a on sd_5a.hsn = sa.hsn and sd_5a.cmp = '5a-androdiol'
left outer join sample_drugs sd_5b on sd_5b.hsn = sa.hsn and sd_5b.cmp = '5b-androdiol'
inner join sample_drugs sd_et on sd_et.hsn = sa.hsn and sd_et.cmp = 'etiocholanolone'
inner join sample_drugs sd_ep on sd_ep.hsn = sa.hsn and sd_ep.cmp = 'epitestosterone' and substr(sd_ep.flags,1,1) = 'S'
inner join sample_drugs sd_tt on sd_tt.hsn = sa.hsn and sd_tt.cmp = 'testosterone' and substr(sd_tt.flags,1,1) = 'S'
inner join sample_drugs sd_dh on sd_dh.hsn = sa.hsn and sd_dh.cmp = 'dhea'
left outer join sample_drugs sd_hcg on sd_hcg.hsn = sa.hsn and sd_hcg.cmp = 'hcg'
left outer join sample_drugs sd_pd_a on sd_pd_a.hsn = sa.hsn and sd_pd_a.cmp = 'PREGNANED-ANDRO'
left outer join sample_drugs sd_pd_e on sd_pd_e.hsn = sa.hsn and sd_pd_e.cmp = 'PREGNANED-ETIO'
left outer join sample_drugs sd_pd_5a on sd_pd_5a.hsn = sa.hsn and sd_pd_5a.cmp = 'PREGNANED-5A'
left outer join sample_drugs sd_pd_5b on sd_pd_5b.hsn = sa.hsn and sd_pd_5b.cmp = 'PREGNANED-5B'
left outer join sample_drugs sd_11_a on sd_11_a.hsn = sa.hsn and sd_11_a.cmp = '11BOHANDR-ANDRO'
left outer join sample_drugs sd_11_e on sd_11_e.hsn = sa.hsn and sd_11_e.cmp = '11BOHANDRO-ETIO'
left outer join sample_drugs sd_11_5a on sd_11_5a.hsn = sa.hsn and sd_11_5a.cmp = '11BOHANDR-5A'
left outer join sample_drugs sd_11_5b on sd_11_5b.hsn = sa.hsn and sd_11_5b.cmp = '11BOHANDR-5B'
left outer join sample_drugs sd_pd on sd_pd.hsn = sa.hsn and sd_pd.cmp like 'preg%'
left outer join sample_drugs sd_lh on sd_lh.hsn = sa.hsn and sd_lh.cmp = 'lh'
left outer join sample_drugs sd_dt on sd_dt.hsn = sa.hsn and sd_dt.cmp = 'dht'
left outer join sample_drugs sd_sg on sd_sg.hsn = sa.hsn and sd_sg.cmp = 'spgr' and substr(sd_sg.flags,1,1) = 'S'
left outer join sample_drugs sd_sg2 on sd_sg2.hsn = sa.hsn and sd_sg2.cmp = 'spgr' and substr(sd_sg2.flags,1,1) = 'C'
left outer join analytical_results ar_erc on ar_erc.schedule_seq = sd_pd_a.schedule_seq and ar_erc.cmp_cond = 'E'
left outer join aux_data ad_sg on ad_sg.aux_data_id = sa.hsn and ad_sg.aux_data_type = 'S' and ad_sg.aux_data_format = 'SV' and ad_sg.aux_field = 1
inner join profiles pr on pr.reqnbr = sa.reqnbr
inner join permanent_ids pi on pi.hsn = sa.hsn
where sa.receive_date > '01/01/2012' 
--and sa.report_date is not null
and pr.cust_id = 'NFL'
and cpi.player_id in 
(
35769
)
order by 1,4;
