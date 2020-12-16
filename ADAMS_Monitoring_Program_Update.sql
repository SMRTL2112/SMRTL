select 
'A' "sampleAB",
pi.cust_sample_id "sample_code",
pi.lab_sample_id "lin",
'urine' "sample_type",
to_char(sa.receive_date,'YYYY-MM-DD HH24:MI:SS') "date_received",
'y' "monitoring",
ar1.cmp "monitored_substance1", 
ar2.cmp "monitored_substance2",
ar3.cmp "monitored_substance3",
ar4.cmp "monitored_substance4",
ar5.cmp "monitored_substance5",
ar6.cmp "monitored_substance6",
'ng/mL' "monitored_substance_unit1",
'ng/mL' "monitored_substance_unit2",
'ng/mL' "monitored_substance_unit3",
'ng/mL' "monitored_substance_unit4",
'ng/mL' "monitored_substance_unit5",
'ng/mL' "monitored_substance_unit6",
ar1.cmp_result "monitored_substance_value1",
ar2.cmp_result "monitored_substance_value2",
ar3.cmp_result "monitored_substance_value3",
ar4.cmp_result "monitored_substance_value4",
ar5.cmp_result "monitored_substance_value5",
ar6.cmp_result "monitored_substance_value6"
From samples sa
inner join permanent_ids pi on pi.hsn=sa.hsn
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
inner join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
inner join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
left outer join schedules sc1 on sc1.schedule_id = sa.hsn and sc1.queue = 'STIM' and sc1.active_flag = 'F'
left outer join analytical_results ar1 on ar1.schedule_seq = sc1.schedule_seq and ar1.cmp = 'bupropion'
left outer join analytical_results ar2 on ar2.schedule_seq = sc1.schedule_seq and ar2.cmp = 'caffeine'
left outer join analytical_results ar3 on ar3.schedule_seq = sc1.schedule_seq and ar3.cmp = 'nicotine'
left outer join analytical_results ar4 on ar4.schedule_seq = sc1.schedule_seq and ar4.cmp = 'pseudoephedrine'
left outer join schedules sc2 on sc2.schedule_id = sa.hsn and sc2.queue in ('LSCR','SSCR') and sc2.active_flag = 'F'
left outer join analytical_results ar5 on ar5.schedule_seq = sc2.schedule_seq and ar5.cmp = 'mitragynine'
left outer join analytical_results ar6 on ar6.schedule_seq = sc2.schedule_seq and ar6.cmp = 'tramadol'
where substr(c.flags,1,1) = 'W'
and sa.wip_status = 'RP'
and sa.cancel_code is null
and sa.receive_date >= '01/01/2015'
and sa.receive_date < '01/01/2016'
and exists (Select 1 from schedules sc inner join analytical_results ar on ar.schedule_seq = sc.schedule_seq where sc.schedule_id = sa.hsn 
and ar.cmp in ('bupropion','caffeine','nicotine','mitragynine','tramadol','pseudoephedrine'));