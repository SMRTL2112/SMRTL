select a4.code "OLD", a2.code "NEW"
from ct$analyte_lists al1
inner join ct$analytes a1 on a1.id = al1.anlist_id
inner join ct$analytes a2 on a2.id = al1.analyte_id
left outer join ct$analytes a3 on a3.code = :oldlist
left outer join ct$analyte_lists al2 on al2.anlist_id = a3.id and al2.analyte_id = al1.analyte_id
left outer join ct$analytes a4 on a4.id = al2.analyte_id and a4.id = a2.id
where a1.code = :newlist
and a4.code is null
UNION
select a2.code "OLD", a4.code "NEW"
from ct$analyte_lists al1
inner join ct$analytes a1 on a1.id = al1.anlist_id
inner join ct$analytes a2 on a2.id = al1.analyte_id
left outer join ct$analytes a3 on a3.code = :newlist
left outer join ct$analyte_lists al2 on al2.anlist_id = a3.id and al2.analyte_id = al1.analyte_id
left outer join ct$analytes a4 on a4.id = al2.analyte_id and a4.id = a2.id
where a1.code = :oldlist
and a4.code is null
order by 2;