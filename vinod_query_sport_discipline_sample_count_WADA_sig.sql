SELECT sd.cmp_class--ad.aux_data sport_discipline
     , count(DISTINCT sd.hsn)
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN customers cu ON pr.cust_id = cu.cust_id
    JOIN sample_drugs sd ON sa.hsn = sd.hsn
--    LEFT JOIN aux_data ad ON sa.hsn = ad.aux_data_id AND ad.aux_data_format = 'WAD2' AND ad.aux_field = 3
 WHERE substr(cu.flags,1,1) = 'W'
   AND sa.receive_date >= to_date('01/01/2016','mm/dd/yyyy')
   AND sa.receive_date < to_date('01/01/2019','mm/dd/yyyy')
   AND sa.sample_type = 'PS'
   AND sa.matrix IN ('B','U')
--   AND sd.cmp_class
GROUP BY sd.cmp_class--ad.aux_data
ORDER BY sd.cmp_class;


SELECT ad.aux_data sport_discipline
     , count(*)
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN customers cu ON pr.cust_id = cu.cust_id
    LEFT JOIN aux_data ad ON sa.hsn = ad.aux_data_id AND ad.aux_data_format = 'WAD2' AND ad.aux_field = 3
 WHERE substr(cu.flags,1,1) = 'W'
   AND sa.receive_date >= to_date('01/01/2016','mm/dd/yyyy')
   AND sa.sample_type = 'PS'
   AND sa.matrix IN ('B','U')
GROUP BY ad.aux_data
ORDER BY count(*) DESC;


SELECT ad.aux_data sport_discipline
     , count(distinct sd.hsn)
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN customers cu ON pr.cust_id = cu.cust_id
    JOIN sample_drugs sd ON sa.hsn = sd.hsn AND sd.cmp_class IN ('GHBM')
    LEFT JOIN aux_data ad ON sa.hsn = ad.aux_data_id AND ad.aux_data_format = 'WAD2' AND ad.aux_field = 3
 WHERE substr(cu.flags,1,1) = 'W'
   AND sa.receive_date >= to_date('01/01/2016','mm/dd/yyyy')
   AND sa.sample_type = 'PS'
   AND sa.matrix IN ('B','U')
GROUP BY ad.aux_data
ORDER BY count(distinct sd.hsn) DESC;