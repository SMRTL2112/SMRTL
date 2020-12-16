select a.code, bp.pricesheet_id, bp.effective_date, bp.stop_date, bp.edit_state
from ct$billing_baseprices bp
inner join ct$acodes a on a.id = bp.acode_id
where effective_date <> trunc(effective_date)
order by 1;

update ct$billing_baseprices
set stop_date = null
where stop_date < effective_date;

commit;


select * from ct$billing_baseprices where stop_date < effective_Date;

--update ct$billing_baseprices set effective_date = trunc(effective_date)
--select * from ct$billing_baseprices
where acode_id in (
select acode_id from ct$billing_baseprices where effective_date <> trunc(Effective_date));

delete ct$billing_baseprices where id = 570;


commit;

select * from ct$acode_xlinks where effective_date <> trunc(Effective_date);
select * from ct$acode_drugs where effective_date <> trunc(Effective_date);
select * from ct$acode_tasks where effective_date <> trunc(Effective_date);


select id, pricesheet_id, acode, effective_date, stop_date, edit_state, flags from ctv$billing_baseprices;

