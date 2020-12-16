Select 
(select bs2.batch_number from batch_schedules bs2 
  join schedules sc2 on Sc2.Schedule_Seq = Bs2.Schedule_Seq 
  where Sc2.Schedule_Id = Sc.Schedule_Id
and Sc2.Proc_Code = 'IRMS STER'
and Sc2.Cond_Code is null
                 ) "IRMS Batch Number",
Bs.Batch_Number "GSCR Batch Number", Sc.Schedule_Id, Co.Name, Ar.Cmp_Result, 
  (Select Bs3.Batch_Pos From Batch_Schedules bs3 
  join Schedules sc3 on sc3.schedule_seq = bs3.schedule_seq
  where sc3.schedule_id = sc.schedule_id
  and Sc3.Proc_Code = 'IRMS STER'
  and Sc3.Cond_Code is null
                 ) "IRMS Sample Position"
From Analytical_Results ar
join Schedules sc on Sc.Schedule_Seq = Ar.Schedule_Seq
join Batch_Schedules bs on Bs.Schedule_Seq = Ar.Schedule_Seq
join Compounds co on Co.Cmp = ar.cmp
where Sc.Schedule_Id in (Select distinct sc.schedule_id from schedules sc
                        join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
                        where bs.queue = 'IRMS'
                        and bs.batch_number in (2316,2317)
                        )
and Co.Name in ('5a-Androstanediol','5b-Androstanediol','Androsterone','Etiocholanolone','Testosterone','5b-Pregnanediol')
order by 1,"IRMS Sample Position",Sc.Schedule_Id, Co.Name
;