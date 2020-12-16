select upper(sa.original_coc), 
case when ar1.cmp_result >= 2 then to_char(ar1.cmp_result)
   else 'N.D.' end "Letrozole (ng/mg Cr.)", 
case when decode(ar1.cmp_text,null,-1,'NC',-1,'N.D.',-1,ar1.cmp_text) >= 2 then ar1.cmp_text
  else 'N.D.' end "Letrozole (ng/mL)",
case when ar2.cmp_result >= 2 then to_char(ar2.cmp_result) 
    else 'N.D.' end "Anastrozole (ng/mg Cr.)", 
case when decode(ar2.cmp_text,null,-1,'NC',-1,'N.D.',-1,ar2.cmp_text) >= 2 then ar2.cmp_text
  else 'N.D.' end "Anastrozole (ng/mL)", 
case when ar3.cmp_result >= 2 then to_char(ar3.cmp_result) 
    else 'N.D.' end "Exemestane (ng/mg Cr.)",
case when decode(ar3.cmp_text,null,-1,'NC',-1,'N.D.',-1,ar3.cmp_text) >= 2 then ar3.cmp_text
  else 'N.D.' end "Exemestane (ng/mL)"
from samples sa
inner join schedules sc on sc.schedule_id = sa.hsn and sc.schedule_type = 'S'
inner join analytical_results ar1 on ar1.schedule_seq = sc.schedule_seq
inner join analytical_results ar2 on ar2.schedule_seq = sc.schedule_seq 
inner join analytical_results ar3 on ar3.schedule_seq = sc.schedule_seq
inner join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
where sa.wip_status = 'CO'
and sa.reqnbr = 1084
and bs.queue = 'RESR'
and ar1.cmp = 'LETROZOLE'
and ar1.status = 'F'
and ar2.cmp = 'ANASTROZOLE'
and ar2.status = 'F'
and ar3.cmp = 'EXEMESTANE'
and ar3.status = 'F'
and sc.active_flag = 'F'
and substr(sc.flags,2,1) = 'S'
order by 1;

