-- EDGE10 to the Edge10 SharePoint and to MLB Sharepoint
select a.subject_key, a.sample_id,a.collect_date,b.receive_date,b.report_date,a.panel_test_type, b.test_result from
(select sample_id,subject_key, panel_test_type,collection_date as collect_date,reported_indicator from SMRTL_PRELOGIN.PRELOGIN_MASTER) a,
(select receive_date, report_date,original_coc,  
decode(final_result,'N','Not Detected','P','Detected') test_result, final_result, wip_status from samples@horizon
where reqnbr in (3103,3150)) b
where a.SAMPLE_ID = b.ORIGINAL_COC
and b.test_result is not null
and b.report_date >=  trunc(sysdate) 
and a.subject_key <> -1 and a.subject_key is not null and length(a.subject_key) <> 5;

select a.sample_id,a.patient_last_name, a.patient_middle_initial,a.PATIENT_first_NAME,a.patient_dob,a.patient_age,a.patient_sex,
a.patient_street_address,patient_city,patient_county,patient_state,patient_zip_code,patient_phone_number,patient_email,patient_race,patient_ethnicity,
a.team,a.staffing_role,a.collection_date as collect_date,b.receive_date,b.report_date,a.panel_test_type, b.test_result from
SMRTL_PRELOGIN.PRELOGIN_MASTER a,
(select receive_date, report_date,original_coc,  
decode(final_result,'N','Not Detected','P','Detected') test_result, final_result, wip_status from samples@horizon
where reqnbr in (3169)) b
where a.SAMPLE_ID = b.ORIGINAL_COC
and b.test_result is not null
and b.report_date >=  trunc(sysdate) -1;

-- sql to create a string to use as a file name for the result file
SELECT TO_CHAR(cast(SYSDATE as timestamp) at time zone 'UTC', 'YYYY-MM-DD"T"HH24-MI-SS"Z"') || '.csv' as ResultFileName FROM DUAL;

-- Thane report sql - generate excel spreadsheet, mail to him

select original_coc as sample_id,final_result,report_date 
from lims.samples@horizon where reqnbr in (3103,3150) and report_date >=  trunc(sysdate) and final_result is not null;

--Please save this file as “MLB Monitor Results 07232020”

select original_coc as sample_id,final_result,report_date 
from lims.samples@horizon where reqnbr in (3139) and report_date >=  trunc(sysdate) and final_result is not null;

--Please save this file as “MLB Facilities Results 07232020”
