declare
 lScheduleSeq number := 3775109;
 lRelease number := 1; /* 0 = no release 1 = release */
 lCompdate varchar2(14);
 lErrorMessage varchar2(2000);
 lCC varchar2(3) := 'OK';
 rc number;
 UserInfo varchar2(2000);
begin

dbms_output.put_line('Hey');
--  for r_schedule in (Select schedule_seq, cond_code from schedules where queue = '*QPD' and active_flag = '*') loop  
for r_schedule in (
  select sc.*
  from schedules sc
  where schedule_seq = lScheduleSeq) loop
  
 lCC := r_schedule.cond_code;
 lScheduleSeq := r_schedule.schedule_seq;
 lCompdate := to_char(sysdate,'MM/DD/RR HH24:MI');
 rc := posting.post_schedule(lScheduleSeq,'MMAD',lCompDate,lCC,0,lRelease,0,lErrorMessage);
 dbms_output.put_line('Return Code from post schedule: ' || rc);
 dbms_output.put_line('Return Message: ' || lErrorMessage); 

end loop;
 
 exception when others then
   dbms_output.put_line('***** Release1 terminated with an error.');
end;
/
