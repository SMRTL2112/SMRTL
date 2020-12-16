declare

vErrMsg varchar2(255);
vReturn number;
vSeq number;

begin


vReturn := Auditing.SetAuditType('Q',vErrMsg);
vReturn := Auditing.SetReason('LA',vErrMsg);
vReturn := Auditing.SetUser('MBOO',vErrMsg);
vReturn := Auditing.SetTransaction('SQL Developer',vErrMsg);

vReturn := Auditing.SetComment('Put change notes here',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;


vReturn := Auditing.SetSequencer(vSeq, vErrMsg);


-- Put SQL to audit here


dbms_output.put_line('Updated '||SQL%ROWCOUNT||' record(s).');

vReturn := Auditing.SetAuditType('N',vErrMsg);
end;
/