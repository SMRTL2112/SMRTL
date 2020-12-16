SELECT DISTINCT
       sa.hsn
     , sa.final_result
     , c.disposal_date
     , c.container_type
     , tc.sublocation
     , c.location
     , sa.original_coc
--     , sa.report_date
--     , substr(sa.flags, 17, 1) AS lts_flag
     , p.cust_id
--     , sa.reqnbr
       FROM containers c
    JOIN samples sa on sa.hsn = c.hsn
    JOIN profiles p on p.reqnbr = sa.reqnbr
    JOIN customers cu on cu.cust_id = p.cust_id
    JOIN transfer_containers tc on c.container_seq = tc.container_seq
WHERE c.actual_disposal is null
   AND tc.sublocation = 'CONF BIN'
   AND sa.sample_type = 'PS'
   AND c.container_type IN ('A','B','EDTA-A','EDTA-B','SERUM-A','SERUM-B')
   AND tc.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq
                             FROM transfer_containers
                            WHERE container_seq = tc.container_seq)
UNION
SELECT DISTINCT
       sa2.hsn
     , sa2.final_result
     , c2.disposal_date
     , c2.container_type
     , tc2.sublocation
     , c2.location
     , sa2.original_coc
--     , sa2.report_date
--     , substr(sa2.flags, 17, 1) AS lts_flag
     , p2.cust_id
--     , sa2.reqnbr
       FROM containers c2
    JOIN samples sa2 on sa2.hsn = c2.hsn
    JOIN profiles p2 on p2.reqnbr = sa2.reqnbr
    JOIN customers cu2 on cu2.cust_id = p2.cust_id
    JOIN transfer_containers tc2 on c2.container_seq = tc2.container_seq
WHERE sa2.hsn in 
    (select distinct sa3.hsn FROM containers c3
    JOIN samples sa3 on sa3.hsn = c3.hsn
    JOIN profiles p3 on p3.reqnbr = sa3.reqnbr
    JOIN customers cu3 on cu3.cust_id = p3.cust_id
    JOIN transfer_containers tc3 on c3.container_seq = tc3.container_seq
WHERE c3.actual_disposal is null
   AND tc3.sublocation = 'CONF BIN'
   AND sa3.sample_type = 'PS'
   AND c3.container_type IN ('A','B','EDTA-A','EDTA-B','SERUM-A','SERUM-B')
   AND tc3.transfer_seq IN (SELECT max(tc4.transfer_seq) max_trans_seq
                             FROM transfer_containers tc4
                            WHERE tc4.container_seq = tc3.container_seq))
   AND c2.ACTUAL_DISPOSAL is null
   AND sa2.sample_type = 'PS'
   AND c2.container_type IN ('B','EDTA-B','SERUM-B')
   AND tc2.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq
                             FROM transfer_containers
                            WHERE container_seq = tc2.container_seq)
order by 1,5
;