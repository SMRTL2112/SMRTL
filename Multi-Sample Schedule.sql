declare

v_rc number;
v_schedule number;
v_errmsg varchar2(2000);
begin

for r_samp in (
select sa.hsn, sa.original_coc, sa.wip_status, all_open_schedules(sa.hsn)
From samples sa
inner join aux_Data ad on ad.aux_Data_id = sa.hsn and ad.aux_Data_type = 'S' and ad.aux_field = 5
where ad.aux_Data in ('M-468894684','M-468891425')) loop

v_rc := schedule.schedule(r_samp.hsn, 'S', 'QTAFEE', 1, 'MMAD', null, 0, v_schedule, 'N', null, sysdate, v_errmsg);
dbms_output.put_line('Return code: ' || v_rc || ' - Schedule Seq: ' || v_schedule);

end loop;

end;