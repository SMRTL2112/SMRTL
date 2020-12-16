Select distinct sa.hsn
     , Sa.Original_Coc
     , Sa.Report_Date
     , Sa.Collect_Date
     , Sd.Cmp
     , Sd.Result_Call
     , Sd.Result_Nbr
     , decode(substr(Sd.Flags,1,1),'C','CONF','S','SCREEN') "CONF or SCREEN"
     , (Select acode
          from sample_acodes
         where hsn = sa.hsn
           and acode = 'IRMS STER')
     , C.Container_Type
     , decode(c.actual_disposal,null,'In House',c.actual_disposal) "In House or Disposal Date"
     , (SELECT DISTINCT ar.cmp_result
          FROM schedules sc
            JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
         WHERE sc.schedule_id = sa.hsn
           AND sc.queue = 'GSCR'
           AND ar.status = 'F'
           AND ar.cmp = '5a-dione/andro'
           AND ar.cmp_result >= 0.1) "5a-dione/andro result"
     , (SELECT DISTINCT ar.cmp_result
          FROM schedules sc
            JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
         WHERE sc.schedule_id = sa.hsn
           AND sc.queue = 'GSCR'
           AND ar.status = 'F'
           AND ar.cmp = '5b-dione/etio'
           AND ar.cmp_result >= 0.1) "5b-dione/etio result"
     , (SELECT ar.cmp_cond
          FROM schedules sc
            JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
         WHERE sc.queue = 'IMUN'
           AND sc.schedule_id = sa.hsn
           AND ar.cmp IN ('ethylglucuronid')
           AND ar.status = 'C'
           AND ar.cmp_cond = 'HI') "EtG HI"
     , (SELECT ar.cmp_cond
          FROM schedules sc
            JOIN analytical_results ar ON sc.schedule_seq = ar.schedule_seq
         WHERE sc.queue = 'HILC'
           AND sc.schedule_id = sa.hsn
           AND ar.cmp IN ('ethylglucuronid')
           AND ar.status = 'F'
           AND ar.cmp_cond = 'P') "EtG Positive"
  From Samples sa
    join profiles p on P.Reqnbr = Sa.Reqnbr
    join Sample_Drugs sd on sd.hsn = sa.hsn
    join containers c on c.hsn = sa.hsn
 where P.Cust_Id = 'MLB'
   and Sa.Reqnbr = 49
   and Sa.Report_Date >= '05/10/2016'
   and Sd.Cmp = 't/e'
   and Sd.Result_Nbr >= 4
   and C.Container_Type in ('A','B')
order by sa.hsn, C.Container_Type
;