select s.hsn, s.original_coc, ab.receive_date, s.wip_status, s.location, s.reqnbr, p.profile_name, p.profile_desc
  from samples s
    join profiles p on p.REQNBR = s.REQNBR
    left join MAP_TO_ADDRS mta on mta.CUST_ID = p.CUST_ID
    left join addresses addr on addr.ADDR_SEQ = mta.ADDR_SEQ
    join PROFILE_LINE_ITEMS pli on pli.reqnbr = p.reqnbr
    join airbills ab on s.original_coc = ab.original_coc
 where p.EXPIRE_DATE is null
   and substr(mta.flags,2,1) = 'I'
   and addr.ADDR_SEQ = 592 -- This is Michelle Dorsey, Invoice person at DFS
   and ab.RECEIVE_DATE >= to_date('11/01/2019','mm/dd/yyyy')
   and ab.RECEIVE_DATE < to_date('12/01/2019','mm/dd/yyyy')
   and s.WIP_STATUS <> 'RP'
order by s.hsn
;