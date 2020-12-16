declare

vErrMsg varchar2(255);
vReturn number;
vSeq number;
vRC number;
vScheduleSeq number;
vCC varchar2(3);

begin

vReturn := Auditing.SetAuditType('Q',vErrMsg);
vReturn := Auditing.SetReason('LA',vErrMsg);
vReturn := Auditing.SetCreateReason('CR',vErrMsg);
vReturn := Auditing.SetUser('MMAD',vErrMsg);
vReturn := Auditing.SetTransaction('SQL Developer',vErrMsg);

vReturn := Auditing.SetComment('Clear pre-2016 CADFs for disposal',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;

vReturn := Auditing.SetSequencer(vSeq, vErrMsg);

for r_rec in (
select sa.hsn, c.container_id, c.disposal_date, sa.final_result, sa.receive_date, c.container_seq, sa.report_date
from samples sa
inner join profiles p on p.reqnbr = sa.reqnbr
inner join smrtl$containers c on c.hsn = sa.hsn
where c.actual_disposal is null
and c.container_type in ('A','B')
and sa.final_result = 'N'
and p.cust_id like 'CADF%'
and sa.receive_date <'01/01/2016'
and sa.original_coc not in (
'1575880',
'1575890',
'3863833',
'3864045',
'3850742',
'1575949',
'1575937',
'1575927',
'3863739',
'2998083',
'1699444',
'1576174',
'3850745',
'3871755',
'3863736',
'3864044',
'3850739',
'3863771',
'895026',
'3863740',
'3864040',
'2960806',
'3863780',
'3863746',
'2895287',
'3863844',
'894723',
'2928985',
'2928983',
'2928991',
'1575428',
'1575924',
'1575934',
'1575938',
'1575941',
'3863745',
'3863775',
'3850763')) loop

  dbms_output.put_line('Updating disposal date on sample '||r_Rec.hsn||' (result: '||r_Rec.final_result||')');
  update containers
  set disposal_date = r_Rec.report_date + 90
  where container_seq = r_rec.container_seq;

end loop;

dbms_output.put_line(SQL%ROWCOUNT || ' row(s) updated');

vReturn := Auditing.SetAuditType('N',vErrMsg);
end;
/
