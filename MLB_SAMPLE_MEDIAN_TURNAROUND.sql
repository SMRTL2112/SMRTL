create table mlb_results as
(select a.subject_key, a.sample_id,a.collect_date,b.receive_date,b.report_date,a.panel_test_type, b.test_result, (b.report_date - b.receive_date) * 24 as turnaround_hours from
(select sample_id,subject_key, panel_test_type,collection_date as collect_date,reported_indicator from SMRTL_PRELOGIN.PRELOGIN_MASTER) a,
(select receive_date, report_date,original_coc,  
decode(final_result,'N','Not Detected','P','Detected') test_result, final_result, wip_status from samples@horizon
where reqnbr = 3103) b
where a.SAMPLE_ID = b.ORIGINAL_COC
and b.report_date is not null);

-- to get mean of all samples
select round(median(turnaround_hours),2) from mlb_results;
-- to get mean of all samples where daily count < 2k
select round(median(turnaround_hours),2) from mlb_results where to_char(trunc(receive_date)) <> '07-JUL-20';
-- to get mean of all samples received before 8 am
select round(median(turnaround_hours),2) from mlb_results where to_number(to_char(receive_date,'hh24')) <= 8;
--to get mean of all samples before 10:30 am
select round(median(turnaround_hours),2) from mlb_results where to_number(to_char(receive_date,'hh24')) < 11;
-- to get mean of all samples received before  8am and on days where total < 2K
select round(median(turnaround_hours),2) from mlb_results where to_number(to_char(receive_date,'hh24')) <= 8 AND to_char(trunc(receive_date)) <> '07-JUL-20';
-- to get mean of all samples received before 11 am and on days where total < 2K
select round(median(turnaround_hours),2) from mlb_results where to_number(to_char(receive_date,'hh24')) < 11 AND to_char(trunc(receive_date)) <> '07-JUL-20';
-- this gets sample counts by date
select trunc(receive_date), count(*) as sample_count from mlb_results
group by trunc(receive_date)
order by trunc(receive_date);
-- this gets percentage of samples completed on same day on samples recieved before 8am
select round(b.same_day_count / a.total_count,2) * 100 from
(select count(*) total_count from mlb_results where to_number(to_char(receive_date,'hh24')) <= 8) a,
(select count(*) same_day_count from mlb_results where trunc(receive_date) = trunc(report_date) and to_number(to_char(receive_date,'hh24')) <= 8) b;
-- this gets percentage of samples completed on same day on samples recieved before 11am
select round(b.same_day_count / a.total_count,2) * 100 from
(select count(*) total_count from mlb_results where to_number(to_char(receive_date,'hh24')) < 11) a,
(select count(*) same_day_count from mlb_results where trunc(receive_date) = trunc(report_date) and to_number(to_char(receive_date,'hh24')) < 11) b;
-- this gets percentage of samples completed on same day on days where sample count <= 2K and samples recieved before 11am
select round(same_day_count / total_count,2) * 100 from
(select count(*) total_count from mlb_results where to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) <= 8) a,
(select count(*) same_day_count from mlb_results where trunc(receive_date) = trunc(report_date) and to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) <= 8) b;
-- this gets percentage of samples completed on same day on days where sample count <= 2K and samples recieved before 11am
select round(same_day_count / total_count,2) * 100 from
(select count(*) total_count from mlb_results where to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) < 11) a,
(select count(*) same_day_count from mlb_results where trunc(receive_date) = trunc(report_date) and to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) < 11) b;

-- this gets percentage of samples completed within 24 hours on samples received befoe 8am
select round(less24 / (less24 + more24),2) * 100 as to_in_24_percent from
(select count(*) Less24 from mlb_results where turnaround_hours <= 24 and to_number(to_char(receive_date,'hh24')) <= 8) a,
(select count(*) more24 from mlb_results where turnaround_hours > 24 and to_number(to_char(receive_date,'hh24')) <= 8) b;
-- this gets percentage of samples completed within 24 hours on samples received befoe 11am
select round(less24 / (less24 + more24),2) * 100 as to_in_24_percent from
(select count(*) Less24 from mlb_results where turnaround_hours <= 24 and to_number(to_char(receive_date,'hh24')) < 11) a,
(select count(*) more24 from mlb_results where turnaround_hours > 24 and to_number(to_char(receive_date,'hh24')) < 11) b;
-- ths gets pecentage of samples completed within 24 hours on days where sample count <= 2k and sample received before 8am
select round(less24 / (less24 + more24),2) * 100 as to_in_24_percent from
(select count(*) Less24 from mlb_results where turnaround_hours <= 24 AND to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) <= 8) a,
(select count(*) more24 from mlb_results where turnaround_hours > 24 AND to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) <= 8 ) b;
-- ths gets pecentage of samples completed within 24 hours on days where sample count <= 2k and sample received before 11am
select round(less24 / (less24 + more24),2) * 100 as to_in_24_percent from
(select count(*) Less24 from mlb_results where turnaround_hours <= 24 AND to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) < 11) a,
(select count(*) more24 from mlb_results where turnaround_hours > 24 AND to_char(trunc(receive_date)) <> '07-JUL-20' and to_number(to_char(receive_date,'hh24')) < 11 ) b;
