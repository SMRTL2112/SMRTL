SELECT sa.hsn
     , sa.original_coc
     , cn.container_type
     , sa.report_date
     , pr.cust_id
     , cn.location
     , tc.sublocation
     , cn.disposal_date
     , listagg(sd.cmp,',') WITHIN GROUP (ORDER BY sd.cmp) pos_cmps
  FROM samples sa
    JOIN containers cn ON sa.hsn = cn.hsn
    JOIN transfer_containers tc ON cn.container_seq = tc.container_seq
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN sample_drugs sd ON sa.hsn = sd.hsn
 WHERE cn.container_type IN ('A','B','SERUM-A','SERUM-B','EDTA-A','EDTA-B','ALIQ-SER')
   AND sa.report_date >= sysdate - 3
   AND sa.sample_type = 'PS'
   AND sa.final_result IN ('P','3','4')
   AND tc.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq
                             FROM transfer_containers
                            WHERE container_seq = tc.container_seq)
   AND sd.result_call IN ('P','3','4')
   AND sd.cmp IS NOT NULL
GROUP BY sa.hsn,sa.original_coc,cn.container_type,sa.report_date,pr.cust_id,cn.location,tc.sublocation,cn.disposal_date
ORDER BY sa.report_date DESC, sa.hsn, cn.container_type;