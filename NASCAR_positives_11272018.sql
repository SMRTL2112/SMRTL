SELECT sa.hsn
     , sa.original_coc
     , sd.cmp
     , pr.cust_id
     , sa.final_result
     , sa.report_date
     , ad.aux_data member_id
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN sample_drugs sd ON sa.hsn = sd.hsn AND sd.cmp IS NOT NULL AND substr(sd.flags,1,1) = 'C'
    JOIN aux_data ad ON sa.hsn = ad.aux_data_id AND ad.aux_data_format = 'NSCR' AND ad.aux_field = 1
 WHERE pr.cust_id = 'NASCAR'
   AND sa.final_result IN ('P','A')
   AND sd.result_call IN ('P','A')
ORDER BY sa.hsn;