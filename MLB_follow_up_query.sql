select sa.hsn, sa.report_date, sa.original_coc, sa.collect_date, s1.cond_code, ar1.cmp, ar1.cmp_result, s2.cond_code, ar2.cmp, ar2.cmp_result, ar2.cmp_cond, s2.active_flag
from samples sa
left outer join schedules s1 on s1.schedule_id = sa.hsn and s1.queue = 'GSCR' and s1.proc_code = 'GC SCREEN'
left outer join analytical_results ar1 on ar1.schedule_seq = s1.schedule_seq and ar1.cmp = 't/e'
left outer join schedules s2 on s2.schedule_id = sa.hsn and s2.queue = 'GSCR' and s2.proc_code <> 'GC SCREEN'
left outer join analytical_results ar2 on ar2.schedule_seq = s2.schedule_seq and ar2.cmp = 't/e'
where sa.reqnbr = 49
and exists (select 1 from schedules where schedule_id = sa.hsn and proc_code = 'REREPORT' and comp_date > sysdate - 1)

