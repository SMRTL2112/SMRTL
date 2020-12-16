SELECT *
  FROM samples sa
    JOIN sample_drugs sd ON sa.hsn = sd.hsn
 WHERE sd.cmp IN ('16-ENE-5A','16-ENE-5B','16-ENE-ETIO',
                  '16-ENE-ANDRO','16-ENE-TEST','PREGNANED-5A',
                  'PREGNANED-5B','PREGNANED-ETIO','PREGNANED-ANDRO',
                  'PREGNANED-TEST')
   AND sd.result_call = 'N'
   AND sa.report_date >= to_date('01/01/2018','mm/dd/yyyy')
ORDER BY sa.report_date,sa.hsn,sd.cmp;