SELECT sa.hsn
     , sa.original_coc
     , sa.receive_date
     , sa.report_date
     , sa.wip_status
     , sa.final_result
     , sa.sample_type
     , pr.cust_id
     , pr.profile_name
     , src.rec_code
     , sa.cancel_code
     , ac.part
     , ac.charge
     , ac.charge_date
     , ac.invoice_seq
     , ac.order_date
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN sample_receiving_codes src ON sa.hsn = src.hsn
    LEFT JOIN accumulated_charges ac ON sa.hsn = ac.hsn
 WHERE sa.report_date >= '05/01/2017'
   AND sa.report_date <= '05/01/2019'
   AND pr.cust_id != 'QC ACCOUNT'
   AND sa.sample_type = 'PS'
   AND ac.charge_date IS NULL
   AND sa.final_result != 'F'
--   AND (src.rec_code != 'XXX'
--    OR  sa.cancel_code IS NULL)
ORDER BY sa.report_date DESC