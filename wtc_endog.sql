select 
--w.insert_date,
w.athlete_id,
w.gender,
w.cust_sample_id,
w.lab,
w.collect_date,
w.te_result,
trunc(w.andro_result/w.test_result,1),
trunc(w.diol5b_result/w.epi_result,2),
w.test_result,
null,
w.epi_result,
null,
w.andro_result,
null,
w.etio_result,
null,
null,
null,
null,
null,
w.diol5a_result,
null,
w.diol5b_result,
null,
null,
null,
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_a.result_nbr,sd_pd_a.result_nbr) "ERC-ANDRO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_e.result_nbr,sd_pd_e.result_nbr) "ERC-ETIO",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5a.result_nbr,sd_pd_5a.result_nbr) "ERC-5A",
decode(ar_erc.cmp,'11bOHandro-d-C',sd_11_5b.result_nbr,sd_pd_5b.result_nbr) "ERC-5B",
w.sg_result
from wtc_steroids w
left outer join samples sa on sa.original_coc = w.cust_sample_id
left outer join sample_drugs sd_pd_a on sd_pd_a.hsn = sa.hsn and sd_pd_a.cmp = 'PREGNANED-ANDRO'
left outer join sample_drugs sd_pd_e on sd_pd_e.hsn = sa.hsn and sd_pd_e.cmp = 'PREGNANED-ETIO'
left outer join sample_drugs sd_pd_5a on sd_pd_5a.hsn = sa.hsn and sd_pd_5a.cmp = 'PREGNANED-5A'
left outer join sample_drugs sd_pd_5b on sd_pd_5b.hsn = sa.hsn and sd_pd_5b.cmp = 'PREGNANED-5B'
left outer join sample_drugs sd_11_a on sd_11_a.hsn = sa.hsn and sd_11_a.cmp = '11BOHANDR-ANDRO'
left outer join sample_drugs sd_11_e on sd_11_e.hsn = sa.hsn and sd_11_e.cmp = '11BOHANDRO-ETIO'
left outer join sample_drugs sd_11_5a on sd_11_5a.hsn = sa.hsn and sd_11_5a.cmp = '11BOHANDR-5A'
left outer join sample_drugs sd_11_5b on sd_11_5b.hsn = sa.hsn and sd_11_5b.cmp = '11BOHANDR-5B'
left outer join analytical_results ar_erc on ar_erc.schedule_seq = sd_pd_a.schedule_seq and ar_erc.cmp_cond = 'E'
where w.athlete_id in (
select athlete_id
from wtc_steroids
where INSERT_DATE > sysdate - 1
and abs(STAT_WTC_TE_ZSCORE(cust_sample_id)) > 2.3)
and nvl(te_result,-1) > 0
and (select count(*) from wtc_steroids where athlete_id = w.athlete_id and nvl(te_result,-1) > 0) > 2
order by athlete_id, collect_date;
