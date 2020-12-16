-- USADA spreadsheet query for Toni
SELECT c.cust_name
--     , invd.detail_name
     , pid.cust_sample_id
     , pid.lab_sample_id
     , invd.inv_detail_date --ac.charge_date
     , invd.detail_name --ac.part
     , sa.receive_date
     , (trunc(inv.invoice_date,'MONTH')-(1/86400)) cutoff_date
  FROM invoice_detail invd--accumulated_charges ac
    JOIN samples@munch_db_link sa ON sa.hsn = invd.sample_id
    JOIN permanent_ids@munch_db_link pid ON pid.hsn = sa.hsn
--    JOIN profiles@munch_db_link p ON p.cust_id = c.cust_id
    JOIN customers@munch_db_link c ON c.cust_id = invd.horizon_cust_id
    JOIN invoice inv ON inv.invoice_id = invd.invoice_id
 WHERE inv.invoicee_id IN (9,83)
   AND trunc(inv.invoice_date,'MONTH') = trunc(sysdate,'MONTH')
   AND invd.detail_void_date IS NULL
order by 1, 3, 5;