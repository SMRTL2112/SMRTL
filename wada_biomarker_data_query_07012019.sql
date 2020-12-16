SELECT sa.hsn
     , sa.original_coc
     , pr.cust_id
     , sc.comp_date
     , ad_gdr.aux_data gender
     , ad_age.aux_data age
     , ad_sp_ds.aux_data sport_discipline
     , cmp.name
     , ar.cmp_result
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN batch_schedules bs ON sc.schedule_seq = bs.schedule_seq
    JOIN batches ba ON bs.queue = ba.queue AND bs.batch_number = ba.batch_number
    JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
    JOIN compounds cmp ON ar.cmp = cmp.cmp
    JOIN customers cu ON pr.cust_id = cu.cust_id
    LEFT JOIN aux_data ad_age ON sa.hsn = ad_age.aux_data_id AND ad_age.aux_data_format = 'AGE' AND ad_age.aux_field = 1 AND ad_age.aux_data_type = 'S'
    LEFT JOIN aux_data ad_sp_ds ON sa.hsn = ad_sp_ds.aux_data_id AND ad_sp_ds.aux_data_format = 'WAD2' AND ad_sp_ds.aux_field = 3 AND ad_sp_ds.aux_data_type = 'S'
    LEFT JOIN aux_data ad_gdr ON sa.hsn = ad_gdr.aux_data_id AND ad_gdr.aux_data_format = 'WAD2' AND ad_gdr.aux_field = 2 AND ad_gdr.aux_data_type = 'S'
 WHERE pr.profile_name LIKE 'HGH B%'
   AND sc.proc_code IN ('PIIINP','IGF-1')
   AND substr(cu.flags,1,1) = 'W'
   AND sa.sample_type = 'PS'
ORDER BY sa.hsn,cmp.name;