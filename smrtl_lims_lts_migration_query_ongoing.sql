INSERT INTO smrtl_lims.longterm_storage(
  longterm_storage_id
, sample_id
, specimen_id
, container_type_id
, store_by_date
, discard_date
, horizon_cust_id
, horizon_reqnbr
, sample_report_date
) 
SELECT DISTINCT NULL
     , sa.hsn
     , sa.original_coc
     , ct.container_type_id
     , c.disposal_date
     , c.actual_disposal
     , p.cust_id
     , sa.reqnbr
     , sa.report_date
  FROM samples@munch_db_link sa
    JOIN profiles@munch_db_link p on p.reqnbr = sa.reqnbr
    JOIN containers@munch_db_link c ON sa.hsn = c.hsn
    JOIN transfer_containers@munch_db_link tc ON c.container_seq = tc.container_seq
    JOIN smrtl_lims.container_type ct ON c.container_type = ct.code
 WHERE c.container_type IN ('A','B','EDTA-A','EDTA-B','SERUM-A','SERUM-B')
   AND actual_disposal IS NULL
   AND tc.transfer_seq IN (SELECT max(transfer_seq) max_trans_seq
                             FROM transfer_containers@munch_db_link
                            WHERE container_seq = tc.container_seq)
   AND original_coc IS NOT NULL
   AND substr(sa.flags,17,1) IN ('I','Y')
   AND disposal_date > (sysdate + 60)
MINUS
SELECT NULL
     , sample_id
     , specimen_id
     , container_type_id
     , store_by_date
     , discard_date
     , horizon_cust_id
     , horizon_reqnbr
     , sample_report_date
  FROM smrtl_lims.longterm_storage;