declare

-- Insert new codes into WADDIS: discipline descriptions; used for description mapping only
-- Insert new codes into WADSPT: sport descriptions; used for description mapping only
-- Insert new codes in SPORT: this is what people pick from;
---- Update SPORT list with TDSSA compliance flag: Yes/No

v_wadspt_id number;
v_waddis_id number;
v_sport_id number;

begin

begin
  select id
  into v_wadspt_id
  from ctv$choicelists where code = 'WADSPT';
  
  select id
  into v_waddis_id
  from ctv$choicelists where code = 'WADDIS';

  select id
  into v_sport_id
  from ctv$choicelists where code = 'SPORT';

exception when no_Data_found then
  null;
end;

for r_sport in (Select a.*, cl1.id "SPORT_ID", cl2.id "DISC_ID", cl3.id "BOTH_ID",
  100*(ascii(substr(upper(sport_code),1,1))-55)+(ascii(substr(upper(sport_code),2,1))-55) "SORT_ITEM"
  from adams_sport_codes a
  left outer join ctv$choicelist_entries cl1 on cl1.value = a.sport_code||'|'||a.discipline_code and cl1.list_code = 'WADSPT' and substr(cl1.flags,1,1) = 'A' and cl1.edit_state = 'P'
  left outer join ctv$choicelist_entries cl2 on cl2.value = a.sport_code||'|'||a.discipline_code and cl2.list_code = 'WADDIS' and substr(cl2.flags,1,1) = 'A' and cl2.edit_state = 'P'
  left outer join ctv$choicelist_entries cl3 on cl3.value = a.sport_code||'|'||a.discipline_code and cl3.list_code = 'SPORT' and substr(cl3.flags,1,1) = 'A' and cl3.edit_state = 'P'
  ) loop
  if r_sport.sport_id is null then
    -- Insert new entry into WADSPT list
    insert into ct$choicelist_entries    
    select -(ct$choicelist_entry_seq.nextval), v_wadspt_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.sport_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
    from dual;
--  else
    --insert into ct$choicelist_entries    
--    select -(r_sport.sport_id), v_wadspt_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.sport_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
--    from dual;  
  end if;
  
  if r_sport.disc_id is null then
    -- Insert new entry into WADSPT list
    insert into ct$choicelist_entries    
    select -(ct$choicelist_entry_seq.nextval), v_waddis_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.discipline_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
    from dual;
--  else
    --insert into ct$choicelist_entries    
--    select -(r_sport.sport_id), v_wadspt_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.sport_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
--    from dual;  
  end if;

  if r_sport.both_id is null then
    insert into ct$choicelist_entries    
    select -(ct$choicelist_entry_seq.nextval), v_sport_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.sport_desc ||' - '||r_sport.discipline_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
    from dual;
--  else
    --insert into ct$choicelist_entries    
--    select -(r_sport.sport_id), v_wadspt_id, substr(r_sport.sport_code||'|'||r_sport.discipline_code,1,12), substr(r_sport.sport_desc,1,30), 'U',r_sport.sort_item, 'A.........',null,'N'
--    from dual;  
  end if;
  
end loop;

end;