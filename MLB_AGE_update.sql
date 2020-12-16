declare

v_sample_age varchar2(10);
v_prelogin_age varchar2(10);
v_prelogin_seq sample_schedules.sample_schedule_seq%type;
v_sample_Hsn samples.hsn%type;

begin

for r_rec in (select a.*,'SAMPLE' "TYPE", sa.hsn "ID", ad.aux_data_seq, ad.aux_data
From prelogin_mlb_age a
inner join samples sa on sa.original_coc = a.original_coc
left outer join aux_Data ad on ad.aux_Data_id = sa.hsn and ad.aux_data_Type = 'S' and ad.aux_Data_format = 'AGE' and ad.aux_field = 1
UNION
select a.*, 'PRELOGIN' "TYPE", ss.sample_schedule_Seq "ID", ad.aux_data_seq, ad.aux_data
From prelogin_mlb_age a
inner join sample_schedules ss on ss.original_coc = a.original_coc
left outer join aux_Data ad on ad.aux_Data_id = ss.sample_schedule_seq and ad.aux_data_Type = 'L' and ad.aux_Data_format = 'AGE' and ad.aux_field = 1) loop

-- Assume we won't have both sample record and prelogin record
  if r_rec.aux_Data_seq is null then
    dbms_output.put_line('Aux data is missing for '||r_rec.type||' record with ID: '||r_rec.id);
    insert into aux_Data (aux_Data_id, aux_Data_format, aux_field, aux_data_type, aux_Data_seq, aux_Data)
    values (r_rec.id, 'AGE',1,decode(r_rec.type,'SAMPLE','S','L'),unique_id.nextval,r_Rec.age);
  else
    dbms_output.put_line('Age is: '||nvl(r_rec.aux_data,'MISSING')||' for '||r_rec.type||' record with ID: '||r_rec.id);
    update aux_Data
    set aux_data = r_rec.age
    where aux_data_type = decode(r_rec.type,'SAMPLE','S','L')
    and aux_data_format = 'AGE'
    and aux_Data_id = r_rec.id
    and aux_field = 1;
  end if;
end loop;

end;