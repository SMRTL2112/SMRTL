declare

vErrMsg varchar2(255);
vReturn number;
vSeq number;
vRC number;
vScheduleSeq number;
vMaxSort number;

begin


vReturn := Auditing.SetAuditType('Q',vErrMsg);
vReturn := Auditing.SetReason('LA',vErrMsg);
vReturn := Auditing.SetCreateReason('CR',vErrMsg);
vReturn := Auditing.SetUser('MMAD',vErrMsg);
vReturn := Auditing.SetTransaction('SQL Developer',vErrMsg);


vReturn := Auditing.SetComment('Add CC for state commission',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;

vReturn := Auditing.SetSequencer(vSeq, vErrMsg);

for r_samp in (Select sa.hsn, sa.wip_status
from samples sa
where sa.original_coc in ('S007232846')) loop

  -- Delete existing CC
  delete from footnotes where footnote_id = r_samp.hsn and footnote_type = 'S' and substr(flags,3,1) = 'C';
  
  select max(sort_item)
  into vMaxSort
  from footnotes 
  where footnote_id = r_samp.hsn
  and footnote_type = 'S';
  
  insert into footnotes (custom_comment, flags, footnote_id, footnote_type, footnote_seq, sort_item)
  values ('Arizona Boxing and MMA Commission','RNC.......',r_samp.hsn,'S', footnote_seq.nextval,vMaxSort+1);
  
  -- Optionally schedule REREPORT
  if r_samp.wip_status = 'RP' then
    vRC := schedule.schedule(r_samp.hsn, 'S', 'REREPORT', 1, 'MMAD', null, 0, vScheduleSeq, 'N', null, sysdate, verrmsg);
    dbms_output.put_line('Return code: ' || vRC || ' - Schedule Seq: ' || vScheduleSeq);
  end if;
end loop;


vReturn := Auditing.SetAuditType('N',vErrMsg);
end;
/
