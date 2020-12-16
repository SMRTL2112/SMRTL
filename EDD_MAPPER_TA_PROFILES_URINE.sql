declare

v_count number;
v_seq number;
begin
for r_rec in (
select distinct substr(dbms_crypto.hash(to_clob(extractvalue(xml_doc,'*/TestingAuthority')),3),1,30) "HASH", ed1.horizon_value "CODE", extractvalue(xml_doc,'*/TestingAuthority'), ed2.QUAL_1, ed2.qual_2, ed2.horizon_value "PROFILE"
From prelogin_usada pu
inner join edd_mapper ed1 on ed1.EDD_VALUE = substr(dbms_crypto.hash(to_clob(extractvalue(xml_doc,'*/TestingAuthority')),3),1,30) and ed1.code_type = 'TA'
inner join edd_mapper ed2 on ed2.EDD_VALUE = substr(extractvalue(xml_doc,'*/TestingAuthority'),1,30) and ed2.code_type = 'U_PROFILE'
) loop


select count(*)
into v_count
from edd_mapper
where EDD_FORMAT = 'USADA'
and code_type = 'U_PROFILE'
and edd_value = r_rec.code
and qual_1 = r_rec.qual_1
and qual_2 = r_rec.qual_2;

if v_count = 0 then
  select ct$report_Datamap_seq.nextval
  into v_seq from dual;

  insert into ct$report_datamaps (id,map_id,code_type,edd_value,horizon_value,edit_state,QUAL_1,qual_2)
  values (-v_seq, 2044, 'U_PROFILE', r_rec.code, r_rec.profile, 'N',r_rec.qual_1,r_rec.qual_2);
end if;
end loop;
end;
