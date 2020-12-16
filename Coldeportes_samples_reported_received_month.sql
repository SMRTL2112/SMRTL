SELECT sa.hsn
     , sa.original_coc
     , ab.receive_date
     , sa.report_date
     , pr.cust_id
     , formatname(mta.addr_seq) invoicee
     , pr.profile_name
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN airbills ab ON sa.original_coc = ab.original_coc
    JOIN map_to_addrs mta ON pr.cust_id = mta.cust_id
 WHERE (pr.cust_id LIKE '%COLD%'
    OR  pr.cust_id LIKE '%COLN%'
    OR  pr.cust_id LIKE '%COL-N%')
   AND sa.report_date BETWEEN to_date('12/01/2018','mm/dd/yyyy') AND sysdate
   AND substr(mta.flags,2,1) = 'I'
UNION
SELECT sa.hsn
     , sa.original_coc
     , ab.receive_date
     , sa.report_date
     , pr.cust_id
     , formatname(mta.addr_seq) invoicee
     , pr.profile_name
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN airbills ab ON sa.original_coc = ab.original_coc
    JOIN map_to_addrs mta ON pr.cust_id = mta.cust_id
 WHERE (pr.cust_id LIKE '%COLD%'
    OR  pr.cust_id LIKE '%COLN%'
    OR  pr.cust_id LIKE '%COL-N%')
   AND ab.receive_date BETWEEN to_date('12/01/2018','mm/dd/yyyy') AND sysdate
   AND substr(mta.flags,2,1) = 'I'
ORDER BY 1;