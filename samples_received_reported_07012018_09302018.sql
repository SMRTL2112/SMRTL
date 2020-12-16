SELECT pr.cust_id
     , count(*)
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN airbills ab ON sa.original_coc = ab.original_coc
 WHERE ab.receive_date BETWEEN to_date('07/01/2018','mm/dd/yyyy') AND to_date('10/01/2018','mm/dd/yyyy')
   AND sa.sample_type = 'PS'
   AND (pr.cust_id LIKE '%DFS%'
    OR  pr.cust_id LIKE '%USADA'
    OR  pr.cust_id LIKE '%MLB%'
    OR  pr.cust_id LIKE '%MiLB'
    OR  pr.cust_id IN ('NFL','NASCAR'))
GROUP BY pr.cust_id
ORDER BY pr.cust_id;



SELECT pr.cust_id
     , count(*)
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
 WHERE sa.report_date BETWEEN to_date('07/01/2018','mm/dd/yyyy') AND to_date('10/01/2018','mm/dd/yyyy')
   AND sa.sample_type = 'PS'
   AND (pr.cust_id LIKE '%DFS%'
    OR  pr.cust_id LIKE '%USADA'
    OR  pr.cust_id LIKE '%MLB%'
    OR  pr.cust_id LIKE '%MiLB'
    OR  pr.cust_id IN ('NFL','NASCAR'))
GROUP BY pr.cust_id
ORDER BY pr.cust_id;