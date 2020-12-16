select * 
from samples sa 
inner join profiles p on p.reqnbr = sa.reqnbr 
and p.cust_id = 'MLB' 
and sa.original_coc like 'S%';