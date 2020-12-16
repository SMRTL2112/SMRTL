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

vReturn := Auditing.SetComment('Adjust Age, gh score',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;

vReturn := Auditing.SetSequencer(vSeq, vErrMsg);

for r_rec in (select sa.hsn, sa.original_coc,ad.aux_Data_Seq, ad.aux_data, ar.schedule_seq, ar.cmp, ar.cmp_result
from samples sa
inner join schedules sc on sc.schedule_id = sa.hsn and sc.queue = 'IGF1'
inner join analytical_results ar on ar.schedule_seq = sc.schedule_seq and ar.cmp = 'gh-2000'
inner join batch_schedules bs on bs.schedule_seq = ar.schedule_seq
left outer join aux_data ad on ad.aux_data_id = sa.hsn and ad.aux_data_type = 'S' and ad.aux_data_format = 'AGE'
where bs.queue = 'IGF1' and bs.batch_number = 1011
) loop

if r_rec.aux_data_seq is null then
  insert into aux_Data (aux_data_format,aux_Data_type, aux_data_id, aux_field, aux_Data_seq, aux_data)
  values ('AGE','S',r_Rec.hsn, 1, unique_id.nextval,'99.1');
elsif r_rec.aux_Data is null then
  update aux_data
  set aux_data = '99.1'
  where aux_Data_Seq = r_rec.aux_Data_Seq;
end if;

gh2000(r_rec.schedule_seq,'S',r_Rec.hsn,vCC,'gh-2000',vErrMsg);

end loop;

vReturn := Auditing.SetAuditType('N',vErrMsg);
end;
/
