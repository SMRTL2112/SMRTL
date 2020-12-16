SELECT *
  FROM (
SELECT DISTINCT C.Location, Tc.Sublocation, regexp_replace(Tc.Sublocation,'(^[[:alpha:]]{2})','\10') adjusted_sublocation, C.Hsn, Sa.Original_Coc, substr(sa.flags, 17, 1) AS lts_flag, c.container_type, C.Disposal_Date, 
p.cust_id, sa.reqnbr FROM containers c
JOIN samples sa on sa.hsn = c.hsn
JOIN profiles p on p.reqnbr = sa.reqnbr
JOIN customers cu on cu.cust_id = p.cust_id
JOIN transfer_containers tc on c.container_seq = tc.container_seq
WHERE c.actual_disposal is null
AND c.location = 'LT USADA 2'
AND (regexp_like(tc.sublocation,('BA[[:digit:]]_')) 
or regexp_like(tc.sublocation,('BA[[:digit:]]-')))
AND sa.sample_type = 'PS'
AND sa.wip_status = 'RP'
AND c.container_type IN ('A','B','EDTA-A','EDTA-B','SERUM-A','SERUM-B')
AND tc.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq FROM transfer_containers WHERE container_seq = tc.container_seq)
UNION
SELECT DISTINCT C.Location, Tc.Sublocation, Tc.Sublocation adjusted_sublocation, C.Hsn, Sa.Original_Coc, substr(sa.flags, 17, 1) AS lts_flag, c.container_type, C.Disposal_Date, 
p.cust_id, sa.reqnbr FROM containers c
JOIN samples sa on sa.hsn = c.hsn
JOIN profiles p on p.reqnbr = sa.reqnbr
JOIN customers cu on cu.cust_id = p.cust_id
JOIN transfer_containers tc on c.container_seq = tc.container_seq
WHERE c.actual_disposal is null
AND c.location = 'LT USADA 2'
AND (regexp_like(tc.sublocation,('BA[[:digit:]]{2}_')) 
or regexp_like(tc.sublocation,('BA[[:digit:]]{2}-')))
AND sa.sample_type = 'PS'
AND sa.wip_status = 'RP'
AND c.container_type IN ('A','B','EDTA-A','EDTA-B','SERUM-A','SERUM-B')
AND tc.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq FROM transfer_containers WHERE container_seq = tc.container_seq)
)
order by to_number(substr(adjusted_sublocation,3,2)),to_number(substr(adjusted_sublocation,6,2))
;