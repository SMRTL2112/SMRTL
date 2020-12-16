SELECT sa.hsn
     , sa.original_coc
     , decode(ar.cmp,'igf-1','igf-1-t2',ar.cmp) cmp
     , ar.cmp_result
     , ad_gdr.aux_data gender
     , ad_age.aux_data age
     , pr.cust_id
  FROM samples sa
    JOIN profiles pr ON sa.reqnbr = pr.reqnbr
    JOIN schedules sc ON sa.hsn = sc.schedule_id
    JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
    JOIN aux_data ad_gdr ON sa.hsn = ad_gdr.aux_data_id
    JOIN aux_data ad_age ON sa.hsn = ad_age.aux_data_id
 WHERE pr.cust_id LIKE '%USADA%'
   AND upper(pr.profile_name) = 'HGH BIOMARK'
   AND ar.cmp IN ('igf-1','gh-2000','piiinp')
   AND ad_gdr.aux_field = 2
   AND ad_gdr.aux_data_format = 'WAD2'
   AND ad_age.aux_data_format = 'AGE'
   AND ad_age.aux_field = 1
ORDER BY sa.hsn DESC,ar.cmp;