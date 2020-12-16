declare

vErrMsg varchar2(255);
vReturn number;
vSeq number;
vRC number;
vScheduleSeq number;
vCount number :=0;

begin


vReturn := Auditing.SetAuditType('Q',vErrMsg);
vReturn := Auditing.SetReason('LA',vErrMsg);
vReturn := Auditing.SetCreateReason('CR',vErrMsg);
vReturn := Auditing.SetUser('MMAD',vErrMsg);
vReturn := Auditing.SetTransaction('SQL Developer',vErrMsg);

vReturn := Auditing.SetComment('Schedule IRMS, ESA',vErrMsg);

select audit_sequencer.nextval
into vSeq
from dual;

vReturn := Auditing.SetSequencer(vSeq, vErrMsg);

for r_samp in (
select sa.hsn, c.container_seq, sa.wip_status
from samples sa
inner join containers c on c.hsn = sa.hsn and c.container_type = 'A'
where not exists (Select 1 from schedules where schedule_id = sa.hsn and queue = 'IRMS')
and sa.original_coc in (
'S008417206',
'S009006313',
'S006593990',
'S005753181',
'S005753199',
'S009364506',
'S005753173',
'S009059700',
'S007646599',
'S009273657',
'S009268780',
'S007018468',
'S008954828',
'S008870628',
'S009389917',
'S007646573',
'S008256018',
'S009173121',
'S007481450',
'S008500027',
'S007646417',
'S007018294',
'S009440983',
'S008500050',
'S008998528',
'S009440959',
'S007442304',
'S009058140',
'S008500035',
'S007573447',
'S008792186',
'S007646516',
'S007518749',
'S009025685',
'S009321068',
'S007518756',
'S008816340',
'S009361395',
'S009234345',
'S009234402',
'S007037385',
'S009303595',
'S007056302',
'S009144460',
'S008654618',
'S009415696',
'S007646607',
'S008716037',
'S008716128',
'S008870743',
'S005753207',
'S009293754',
'S009487726',
'S009330184',
'S008870917',
'S008855249',
'S009378977',
'S008808446',
'S008955528',
'S008870685',
'S009487753',
'S008381915',
'S009308966',
'S008870925',
'S009376351',
'S008808545',
'S009472661',
'S009293705',
'S009234436',
'S008716235',
'S008763542',
'S007054851',
'S009308743',
'S009379017',
'S007410277',
'S008955502',
'S009379074',
'S007410269',
'S006716831',
'S008295669',
'S008870669',
'S009234410',
'S009321035',
'S008870701',
'S008870735',
'S008648826',
'S009108689',
'S009058280',
'S009289240',
'S009139551',
'S008955270',
'S009215674',
'S009391632',
'S009330309',
'S008745606',
'S009358334',
'S009378985',
'S008763567',
'S009269259',
'S009376294',
'S009417015',
'S009161076',
'S009234089',
'S007018369',
'S006570790',
'S008716110',
'S007700446',
'S007410293',
'S009379025',
'S009234360',
'S009005158',
'S008808560',
'S009424102',
'S008808453',
'S009415738',
'S009026527',
'S008848582',
'S007518640',
'S007518616',
'S009361437',
'S007646490',
'S007037401',
'S009041518',
'S009358458',
'S009234394',
'S007646656',
'S008500183',
'S008855215',
'S009058256',
'S006593768',
'S008500175',
'S009387952',
'S008870776',
'S007646508',
'S009441353',
'S009376369')
) loop
  
  if r_samp.wip_status in ('RP','CO') then
    update samples
    set wip_status = 'WP', charge_trigger = -2, report_Date = null, comp_Date = null, final_result = null, open_wip_status = 'WP'
    where hsn = r_samp.hsn;
    
    dbms_output.put_line('Returning sample '||r_Samp.hsn||' to WP state.');
  end if;
  
  update samples
  set reqnbr = 1492
  where reqnbr = 641
  and hsn = r_samp.hsn;
  
  vRC := schedule.scheduling(r_samp.hsn, 'S', 'IRMS STER', 1, 'MMAD', null, 10, vScheduleSeq, 'N', 'Y', sysdate, 0, vErrmsg);
  
  if vRC = 0 then
    dbms_output.put_line('Successfully scheduled IRMS on sample '||r_samp.hsn);
    vcount := vcount + 1;
  else
    dbms_output.put_line('Error scheduling IRMS on sample '||r_samp.hsn||': '||sqlerrm);
  end if;

  -- Update Containers
  update schedules
  set container_seq = r_samp.container_Seq
  where schedule_seq = vScheduleSeq;

  update schedules
  set container_seq = r_samp.container_Seq
  where schedule_seq in (select schedule_seq from schedules where thread = vScheduleSeq);

  end loop;
  
dbms_output.put_line('Scheduled IRMS on '||vcount||' samples');  
vReturn:= Auditing.SetAuditType('N',vErrMsg);

end;
/
