declare

vErrMsg varchar2(255);
vReturn number;
vSeq number;
vRC number;
vScheduleSeq number;

begin


vReturn := Auditing.SetAuditType('Q',vErrMsg);
vReturn := Auditing.SetReason('LA',vErrMsg);
vReturn := Auditing.SetCreateReason('CR',vErrMsg);
vReturn := Auditing.SetUser('MMAD',vErrMsg);
vReturn := Auditing.SetTransaction('SQL Developer',vErrMsg);

vReturn := Auditing.SetComment('Reschedule MLB RCPT',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;

vReturn := Auditing.SetSequencer(vSeq, vErrMsg);

for r_samp in (
select sa.hsn, sa.reqnbr, sa.receive_date, sa.wip_status
from samples sa
where sa.original_coc in (
'S006907257',
'S009488798',
'S009489047',
'S009108317')) loop
  
  if r_samp.wip_status in ('RP','CO') then
    update samples
    set wip_status = 'WP', charge_trigger = -2, report_Date = null, comp_Date = null, final_result = null, open_wip_status = 'WP'
    where hsn = r_samp.hsn;
    
    dbms_output.put_line('Returning sample '||r_Samp.hsn||' to WP state.');
  end if;
  
  vRC := schedule.scheduling(r_samp.hsn, 'S', 'MLB_RCPT', 1, 'MMAD', null, 10, vScheduleSeq, 'N', 'Y', sysdate, 0, vErrmsg);
  
  if vRC = 0 then
    dbms_output.put_line('Successfully scheduled MLB_RCPT on sample '||r_samp.hsn);
  else
    dbms_output.put_line('Error scheduling MLB_RCPT on sample '||r_samp.hsn||': '||sqlerrm);
  end if;

  -- Update Containers
/*
  update schedules
  set container_seq = r_samp.container_Seq
  where schedule_seq = vScheduleSeq;

  update schedules
  set container_seq = r_samp.container_Seq
  where schedule_seq in (select schedule_seq from schedules where thread = vScheduleSeq);
*/
  end loop;
  
vReturn:= Auditing.SetAuditType('N',vErrMsg);

end;
/
