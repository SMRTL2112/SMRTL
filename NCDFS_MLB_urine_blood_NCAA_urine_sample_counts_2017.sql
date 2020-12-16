-- DFS MLB blood sample count
select count(distinct s.hsn), trunc(s.collect_date,'MONTH') from samples s
inner join profiles p on p.REQNBR = s.REQNBR
where s.collect_date >= to_date('01/25/2017','mm/dd/yyyy')
and s.collect_date < to_date('01/01/2018','mm/dd/yyyy')
and p.CUST_ID = 'MLB-Blood'
and s.MATRIX = 'B'
and s.sample_type = 'PS'
--and s.ORIGINAL_COC not like 'G%'
group by trunc(s.collect_date,'MONTH')
order by 2
;

-- DFS NCAA urine sample count
select count(distinct s.hsn), trunc(s.collect_date,'MONTH') from samples s
inner join profiles p on p.reqnbr = s.reqnbr
where s.collect_date >= to_date('01/25/2017','mm/dd/yyyy')
and s.collect_date < to_date('01/01/2018','mm/dd/yyyy')
and p.CUST_ID = 'NCAA-DFS'
--and s.ORIGINAL_COC not like 'S00%'
and s.MATRIX = 'U'
and s.sample_type = 'PS'
group by trunc(s.collect_date,'MONTH')
order by 2
;

-- DFS MLB urine sample count
select count(distinct s.hsn), trunc(s.collect_date,'MONTH') from samples s
inner join profiles p on p.REQNBR = s.REQNBR
where s.collect_date >= to_date('01/25/2017','mm/dd/yyyy')
and s.collect_date < to_date('01/01/2018','mm/dd/yyyy')
and p.REQNBR in
  (select reqnbr from profiles
  where CUST_ID in ('MLB','MLB-DFS')
  and PROFILE_NAME not like '%CDT%'
  and EXPIRE_DATE is null
)
--and s.ORIGINAL_COC like 'S00%'
and s.MATRIX = 'U'
and s.location NOT LIKE '%MLBTEAMS%'
group by trunc(s.collect_date,'MONTH')
order by 2
;
