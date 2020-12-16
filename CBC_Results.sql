select pid.cust_sample_id "sample_code",
pid.lab_sample_id "lin",
'blood_passport' "sample_type", 
to_char(s.receive_date,'YYYY-MM-DD') "date_received",
to_char(s.collect_date,'YYYY-MM-DD') "date_collection",
to_char((select mtr.run_date from map_to_runs mtr where mtr.schedule_seq = (select max(schedule_seq) from sample_drugs where hsn = s.hsn and method = 'FC' and cmp_class = 'CBC' and substr(flags,1,1) <> 'D')),'YYYY-MM-DD HH24:MI:SS') "analysis_date",
(select aux_data from aux_data where aux_data_id = c.cust_seq and aux_data_type = 'C' and aux_data_format = 'ADMS' and aux_field = 1) "ta",
(select aux_data from aux_data where aux_data_id = c.cust_seq and aux_data_type = 'C' and aux_data_format = 'ADMS' and aux_field = 2) "sca",
'LAB-UTAH-USA-SMRTL' "lab",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format in ('WADA','WAD2') and aux_field = 1) "test_type",
(select aux_data from aux_data where aux_data_id = s.hsn and aux_data_format in ('WADA','WAD2') and aux_field = 2) "gender",
(select substr(aux_data,1,instr(aux_data,'|')-1) from aux_data where aux_data_id = s.hsn and aux_data_format in ('WAD2') and aux_field = 3) "sport_code",
(select substr(aux_data,instr(aux_data,'|')+1) from aux_data where aux_data_id = s.hsn and aux_data_format in ('WAD2') and aux_field = 3) "discipline_code",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'RBC') "RBC",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'HGB') "HGB",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'HCT') "HCT",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'MCV') "MCV",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'MCH') "MCH",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'MCHC') "MCHC",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'RET%') "RET%",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'RET#') "RET#",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'IRF') "IRF",
(select ar.cmp_result from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'RDW-SD') "RDW-SD",
(select trunc(ar.cmp_result,1) from analytical_results ar where ar.schedule_seq = sc.schedule_seq and ar.cmp = 'Off-Score') "OFF-Score"
from samples s
inner join schedules sc on sc.schedule_id = s.hsn and sc.proc_code = 'CBCM'
inner join batch_schedules bs on bs.schedule_seq = sc.schedule_seq 
inner join permanent_ids pid on pid.hsn = s.hsn
inner join profiles p on p.reqnbr = s.reqnbr
inner join customers c on c.cust_id = p.cust_id
where bs.queue = 'CBC'
and s.original_coc ='063765'
order by bs.batch_pos;


