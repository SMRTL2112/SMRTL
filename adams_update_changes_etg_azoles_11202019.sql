select 
case when nvl(ab.receive_date,s.receive_date) > to_date('03/16/2016','MM/DD/YYYY') then 'Yes' ELSE 'No' END "ADAMS411",
ta.aux_data "TA_CODE",
sca.aux_data "SCA_CODE",
smrtl_adams_comments(s.hsn) "analysis_details",
smrtl_irms_comment(s.hsn,'A') "irms_comments",
pid.cust_sample_id "sample_code",
cl_matrix.choice_desc "sample_type", 
to_char(nvl(ab.receive_date,s.receive_date),'YYYY-MM-DD') "date_received",
(select aux_data from aux_data where aux_data_id = c.cust_seq and aux_data_format = 'ADMS' and aux_field = 3) "cust_rma_code",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format = 'RMA' and aux_field = 1) "sample_rma_code",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format in ('WADA','WAD2') and aux_field = 1) "test_type",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format = 'WADA' and aux_field = 3) "sport_code",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format = 'WADA' and aux_field = 4) "discipline_code",
(select substr(aux_data,1,instr(aux_data,'|')-1) from aux_data where aux_data_id = s.hsn and aux_data_format = 'WAD2' and aux_field = 3) "sport_code_2",
(select substr(aux_data,instr(aux_data,'|')+1) from aux_data where aux_data_id = s.hsn and aux_data_format = 'WAD2' and aux_field = 3) "discipline_code_2",
decode(s.final_result,'N','Negative','A','Negative','P','AAF','3','AAF','4','AAF','I','Negative')  "test_result",
decode(sc.proc_code,'REPORT-B','B','A') "sampleAB",
null "analysis_details",
pid.lab_sample_id "lin",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format in ('WADA','WAD2') and aux_field = 5) "mo_number",
to_char(s.collect_date,'YYYY-MM-DD') "sample_collection_date",
to_char(nvl(s.report_date,sysdate),'YYYY-MM-DD') "analysis_report_date",
null "country",
null "region",
null "city", 
(select count(*) from schedules where schedule_id = s.hsn and queue = 'IRMS' and cond_code in ('N','N!') and active_flag = 'F') "IRMS",
(select count(*) from schedules where schedule_id = s.hsn and queue = 'EPO' and cond_code in ('N','N!') and active_flag = 'F') "EPO",
--(select count(*) from schedules where schedule_id = s.hsn and queue = 'GHRP' and cond_code in ('N','N!') and active_flag = 'F') "GHRP",
(select count(*) from sample_drugs sd where sd.hsn = s.hsn and sd.cmp_class in ('GHRP','GHS') and sd.result_call in ('N','P')) "GHRP",
(select count(*) from sample_drugs sd where sd.hsn = s.hsn and sd.cmp_class = 'GNRH' and sd.result_call in ('N','P')) "GNRH",
(select count(*) from sample_drugs sd where sd.hsn = s.hsn and sd.cmp_class = 'GHRH' and sd.result_call in ('N','P')) "GHRH",
(select count(*) from sample_drugs sd where sd.hsn = s.hsn and sd.cmp = 'ratio hGH') "ISOFORM",
(select count(*) from sample_drugs sd where sd.hsn = s.hsn and sd.cmp = 'gh-2000') "BIOMARK",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format in ('WADA','WAD2') and aux_field = 2) "gender",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 't/e' and substr(flags,1,1) = 'S') "te_ratio",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'testosterone' and substr(flags,1,1) = 'S') "test",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'epitestosterone' and substr(flags,1,1) = 'S') "epi",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'androsterone' and substr(flags,1,1) = 'S') "andro",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'etiocholanolone' and substr(flags,1,1) = 'S') "etio",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5a-androdiol' and substr(flags,1,1) = 'S') "diol_a",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5b-androdiol' and substr(flags,1,1) = 'S') "diol_b",
-- confirmed endogenous
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 't/e' and substr(flags,1,1) = 'C') "te_ratio_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'testosterone' and substr(flags,1,1) = 'C') "test_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'epitestosterone' and substr(flags,1,1) = 'C') "epi_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'androsterone' and substr(flags,1,1) = 'C') "andro_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'etiocholanolone' and substr(flags,1,1) = 'C') "etio_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5a-androdiol' and substr(flags,1,1) = 'C') "diol_a_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5b-androdiol' and substr(flags,1,1) = 'C') "diol_b_conf",
-- confirmed endogenous uncertainty
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = 't/e' and substr(flags,1,1) = 'C') "te_ratio_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = 'testosterone' and substr(flags,1,1) = 'C') "test_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = 'epitestosterone' and substr(flags,1,1) = 'C') "epi_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = 'androsterone' and substr(flags,1,1) = 'C') "andro_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = 'etiocholanolone' and substr(flags,1,1) = 'C') "etio_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = '5a-androdiol' and substr(flags,1,1) = 'C') "diol_a_conf_unc",
(select round(result_nbr*0.15,2) from sample_drugs where hsn = s.hsn and cmp = '5b-androdiol' and substr(flags,1,1) = 'C') "diol_b_conf_unc",

-- microbial ratios
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5a-dione/andro' and substr(flags,1,1) = 'S') "dione_andro",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5b-dione/etio' and substr(flags,1,1) = 'S') "dione_etio",
-- confirmed microbial ratios
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5a-dione/andro' and substr(flags,1,1) = 'C') "dione_andro_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5b-dione/etio' and substr(flags,1,1) = 'C') "dione_etio_conf",
--IRMS
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'andro-delta-C') as "andro_delta_c",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'etio-delta-C') as "etio_delta_c",
(select decode(ar.cmp_cond,'E',sd.result_nbr,-1) from sample_drugs sd inner join analytical_results ar on ar.schedule_Seq = sd.schedule_seq and ar.cmp = sd.cmp where sd.hsn = s.hsn and sd.cmp = 'pregnaned-d-C') as "pregnaned_delta_c",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'test-delta-C') as "test_delta_c",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'epi-delta-C') as "epi_delta_c",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5a-diol-delta-C') as "diol5a_delta_c",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = '5b-diol-delta-C') as "diol5b_delta_c",
(select decode(ar.cmp_cond,'E',sd.result_nbr,-1) from sample_drugs sd inner join analytical_results ar on ar.schedule_Seq = sd.schedule_seq and ar.cmp = sd.cmp where sd.hsn = s.hsn and sd.cmp = '11bOHandro-d-C') as "BOHA_delta_c",
--IRMS uncertainty
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = '5a-diol-delta-C') "diol5a_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = '5b-diol-delta-C') "diol5b_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = 'andro-delta-C') "andro_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = 'etio-delta-C') "etio_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = 'epi-delta-C') "epi_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = 'pregnaned-d-C') "pd_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = '11bOHandro-d-C') "BOHA_unc",
(select trunc(idl_mdl,2) From idls i inner join idl_cmps ic on ic.idl_seq = i.idl_seq where i.method = 'IR' and i.record_type = 'K' and nvl(i.stop_date,s.receive_date+1) > s.receive_date and i.effective_Date < s.receive_date and ic.cmp = 'test-delta-C') "test_unc",
-- steroid profile Confounding factors
(select cmp_result from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp = 'ethylglucuronid' and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "etg_result",
(select cmp_result from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp = 'ETHYLGLUCURONID' and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "etg_conf_result",
(select ar.cmp_result from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and cmp = 'ethylglucuronid' and sc.proc_code = 'ETG RESCR' and sc.active_flag = 'F') "etg_conf_result",
(select cl.choice_desc from choice_lists cl inner join sample_drugs sd on cl.legal_value = substr(sd.flags,2,1) where sd.hsn = s.hsn and sd.cmp = 'ethylglucuronid' and substr(sd.flags,1,1) = 'S' and cl.code_type = 'UNITS' and substr(cl.flags,1,1) = 'A') "etg_units",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp = 'coohfinast' and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "finasteride",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp = 'carboxy-finaste' and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "finasteride_conf",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('ketoconazole','miconazole','fluconazole') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "ketoconazole",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('KETOCONAZOLE','MICONAZOLE','FLUCONAZOLE') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "ketoconazole_conf",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('aminogluteth','anastrozole','androstatriened','arimistane','exemestane','formestane','letrozole','testolactone','6-oxo') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "aromatase",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('AMINOGLUTETH','ANASTROZOLE','ANDROSTATRIENED','ARIMISTANE','EXEMESTANE','FORMESTANE','LETROZOLE','TESTOLACTONE','6-OXO') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "aromatase_conf",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('clomiphene','cyclofenil','fulvestrant') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "anti_estrogens",
(select count(*) from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('CLOMIPHENE','CYCLOFENIL','FULVESTRANT') and ar.cmp_cond <> 'N' and sc.active_flag = 'F') "anti_estrogens_conf",
(select count(*) from sample_drugs where hsn = s.hsn and cmp_class in ('DIUR','MA') and result_call = 'P' and substr(flags,1,1) = 'D') "masking",
(select count(*) from sample_drugs where hsn = s.hsn and cmp_class in ('AAS') and result_call = 'P' and substr(flags,1,1) = 'D') "anabolics",
(select count(*) from sample_drugs where hsn = s.hsn and cmp = 'intact hcg' and result_call = 'P') "intact_hcg",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'dhea') "dhea",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'pH') "ph_result",
(select result_nbr from sample_drugs where hsn = s.hsn and substr(flags,1,1) = 'S' and cmp = 'spgr') as "specific_gravity",
(select result_nbr from sample_drugs where hsn = s.hsn and substr(flags,1,1) = 'C' and cmp = 'spgr') as "sg_conf",
(select result_nbr from sample_drugs where hsn = s.hsn and cmp = 'ratio hGH') as "hgh_ratio",
(decode((select cond_code from schedules where schedule_id = s.hsn and proc_code = 'IRMS STER' and substr(flags,1,1) = 'F'),'N','Negative','P','AAF')) as "irms_conclusion",
(select ar.cmp from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('ketoconazole','miconazole','fluconazole') and ar.cmp_cond <> 'N' and sc.active_flag = 'F' and rownum = 1) as "azole_cmp",
(select ar.cmp from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where schedule_id = s.hsn and sc.schedule_type = 'S' and ar.cmp IN ('KETOCONAZOLE','MICONAZOLE','FLUCONAZOLE') and ar.cmp_cond <> 'N' and sc.active_flag = 'F' and rownum = 1) "azole_conf_cmp"
from samples s
inner join schedules sc on sc.schedule_seq = :pScheduleSeq
inner join permanent_ids pid on pid.hsn = s.hsn
inner join profiles p on p.reqnbr = s.reqnbr
inner join choice_lists cl_matrix on cl_matrix.legal_value = s.matrix and cl_matrix.code_type = 'MATRIX' and substr(cl_matrix.flags,1,1) = 'A'
inner join customers c on c.cust_id = p.cust_id
inner join map_to_addrs mta on nvl(mta.reqnbr,s.reqnbr) = s.reqnbr and mta.cust_id = p.cust_id
inner join aux_data ta on ta.aux_data_id = c.cust_seq and ta.aux_data_format = 'ADMS' and ta.aux_field = 1
inner join aux_data sca on sca.aux_data_id = c.cust_seq and sca.aux_data_format = 'ADMS' and sca.aux_field = 2
left outer join airbills ab on rtrim(ab.original_coc,'_!') = s.original_coc and ab.airbill = s.airbill and s.carrier = ab.carrier
where substr(s.flags,8,1) = 'C'
and substr(mta.flags,5,1) = 'R'
and substr(mta.delivery_methods,6,1) = 'W'
and s.wip_status in ('RP','CO')
and s.hsn = :pADAMSHSN
and mta.addr_seq = :pADAMSAddrSeq