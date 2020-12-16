select sa.receive_user,
get_container_type(sa.hsn),
count(*), 
trunc(median(time_to_accession(sa.hsn)),2) "MEDIAN",
trunc(median(time_to_accession(sa.hsn))*count(*)/60,2) "TOTAL_HOURS"
from samples sa
where time_to_accession(sa.hsn) < 10
and sa.receive_date > sysdate - 14
and sa.matrix = 'U'
and sa.reqnbr not in (574,1058,1142)
and sa.sample_type = 'PS'
group by get_container_type(sa.hsn), sa.receive_user
order by 1,2;


-- Per user, per day
select sa.receive_user,
count(*),
to_char(min(sa.receive_date),'HH24:MI'),
to_char(max(sa.receive_date),'HH24:MI'),
to_char(trunc(sa.receive_date),'MM/DD/YYYY')
from samples sa
where sa.receive_date > trunc(sysdate) - 30
and sa.matrix = 'U'
and sa.reqnbr not in (574,1058,1142)
and sa.sample_type = 'PS'
group by sa.receive_user, trunc(sa.receive_date)
order by 1,3;

-- Per Day
select trunc(sa.receive_date), to_char(sa.receive_date,'Day'),
count(*)
from samples sa
where sa.receive_date > trunc(sysdate) - 14
and sa.matrix = 'U'
and sa.reqnbr not in (574,1058,1142)
and sa.sample_type = 'PS'
group by trunc(sa.receive_date), to_char(sa.receive_date,'Day')
order by 1;

--