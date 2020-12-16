select pi.lab_sample_id
     , pi.cust_sample_id
--     , a.addr_seq
     , ad1.aux_data
--     , sa.hsn
--     , p.cust_id
--     , sa.wip_status
     , sa.report_date
     , (select nvl(sd.result_text,sd.result_nbr) from sample_drugs sd where sd.hsn = sa.hsn and sd.cmp = 'dhea' and substr(sd.flags,1,1) = 'S') dhea_result
     , (select nvl(sd.result_text,sd.result_nbr) from sample_drugs sd where sd.hsn = sa.hsn and sd.cmp = 'lh' and substr(sd.flags,1,1) = 'S') lh_result
     , (select nvl(sd.result_text,sd.result_nbr) from sample_drugs sd where sd.hsn = sa.hsn and sd.cmp = 'ethylglucuronid' and substr(sd.flags,1,1) = 'S') etg_result
     , (select (CASE when substr(sa.flags,1,1) >= substr(sd.flags,7,1) THEN sigfig(sd.result_nbr,substr(sd.flags,4,1)) ELSE NULL END) from sample_drugs sd
                                                                                    inner join schedules s2 on s2.schedule_seq = sd.schedule_seq 
                                                                                    inner join containers c1 on c1.container_seq = s2.container_seq 
                                                                                    inner join containers c2 on c2.container_seq = c1.parent_seq
                                                                                    left outer join containers c3 on c3.container_seq = c2.parent_seq
                                                                                    left outer join footnotes f on f.footnote_id = sd.schedule_seq and f.footnote_type = 'C' and f.qualifier = sd.cmp and substr(f.flags,1,1) = 'R'
                                                                                    inner join choice_lists u on u.legal_value = substr(sd.flags,2,1)
                                                                                      and u.code_type = 'UNITS'
                                                                                      and substr(u.flags,1,1) = 'A'
                                                                                    inner join compounds c on c.cmp = sd.cmp
                                                                                    inner join map_to_runs mtr on mtr.schedule_seq = sd.schedule_seq
                                                                                    left outer join choice_lists col_desc on col_desc.legal_value = mtr.COLUMN_ID and col_desc.code_type = 'COLUMN' and substR(col_desc.flags,1,1) = 'A'
                                                                                    inner join choice_lists instr on instr.legal_value = mtr.run_instru and substr(instr.flags,1,1) = 'A' and instr.code_type = 'INSTRU'
                                                                                    inner join choice_lists call on call.legal_value = sd.result_call and substr(call.flags,2,1) = substr(sd.flags,6,1) and substr(call.flags,1,1) = 'A'
                                                                                    where sd.hsn = sa.hsn
                                                                                    and substr(sa.flags,1,1) >= substr(sd.flags,7,1)
                                                                                    and (c2.container_type IN ('SERUM-A','SERUM-B') or c3.container_type IN ('SERUM-A','SERUM-B'))
                                                                                    and exists (select 1 from sample_drugs where hsn = sd.hsn and substr(flags,1,1) = 'D' and sd.cmp_class = 'GHBM' and cmp_class = sd.cmp_class and decode(substr(flags,7,1),'.',sd.result_call,'N',null,'P') = sd.result_call)) gh_score
     , (select custom_comment from footnotes where footnote_id = sa.hsn and footnote_type = 'S' and lower(custom_comment) LIKE '%epo bands%') epo_comment
     , (select custom_comment from footnotes where footnote_id = sa.hsn and footnote_type = 'S' and lower(custom_comment) LIKE '%monitor%') tmon_comment
from samples sa
inner join permanent_ids pi on pi.hsn = sa.hsn
inner join schedules s on s.schedule_id = sa.hsn and s.schedule_type = 'S' and s.proc_code = 'REPORT' and s.schedule_seq = (select max(schedule_seq) from schedules where s.proc_code = 'REPORT' and schedule_id = sa.hsn)-- and s.open_queue = '*REP'
inner join hv$sample_type st on st.sample_type = sa.sample_type and st.reporting_flag = '.'
inner join profiles p on p.reqnbr = sa.reqnbr
inner join map_to_addrs mta on nvl(mta.reqnbr,p.reqnbr) = p.reqnbr and mta.cust_id = p.cust_id and substr(mta.flags,5,1) = 'R'
inner join addresses a on a.addr_seq = mta.addr_seq
inner join aux_data ad1 on ad1.aux_data_id = sa.hsn and ad1.aux_data_type = 'S' and ad1.aux_data_format in ('USAD','WADA','WAD2') and ad1.aux_field = 1
where substr(sa.flags,8,1) IN ('C','U')
and /*(sa.wip_status IN ('CO')--= decode(s.proc_code,'REREPORT','RP','CO')
 or  */trunc(sa.report_date) = trunc(sysdate-25)
and ad1.aux_data IN ('OOC','IC')
and (substr(mta.delivery_methods,11,1) = 'W'
 or  substr(mta.delivery_methods,1,1) = 'P')
and a.addr_seq = 99
ORDER BY pi.cust_sample_id;
--and sa.final_result = 'N';