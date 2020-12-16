select 
'A' "sampleAB",
pi.cust_sample_id "sample_code",
pi.lab_sample_id "lin",
'urine' "sample_type",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD HH24:MI:SS') "date_received",
'y' "monitoring",
ar.cmp "monitored_substance1", 
'ng/mL' "monitored_substance_unit1"
from samples sa
inner join permanent_ids pi on pi.hsn = sa.hsn
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_Id = p.cust_id
inner join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
inner join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
inner join schedules sc on sc.schedule_id = sa.hsn
inner join analytical_results ar on ar.schedule_seq = sc.schedule_seq
where ar.cmp in ('tramadol','hydrocodone','mitragynine','tapentadol')
and ar.cmp_cond = 'MP'
and get_ic_ooc(sa.hsn) = 'IC'
and sa.receive_date >='01/01/2018'
and sa.receive_date <'01/01/2019'
and substr(c.flags,1,1) = 'W';


-- Update monitored status
-- By receipt date method 1
select 
'A' "sampleAB",
pi.cust_sample_id "sample_code",
pi.lab_sample_id "lin",
'urine' "sample_type",
to_char(sa.receive_date,'YYYY-MM-DD HH24:MI:SS') "date_received",
--to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD HH24:MI:SS') "date_received",
'n' "monitoring"
from samples sa
inner join permanent_ids pi on pi.hsn = sa.hsn
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_Id = p.cust_id
inner join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
inner join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
where not exists (select 1 from analytical_results ar inner join schedules sc on sc.schedule_seq = ar.schedule_seq where sc.schedule_id = sa.hsn and ar.cmp in ('tramadol','hydrocodone','mitragynine','tapentadol'))
and sa.receive_date >='01/01/2015'
and sa.receive_date <'01/01/2016'
and substr(c.flags,1,1) = 'W'
and sa.sample_type = 'PS'
and sa.matrix = 'U'
and get_ic_ooc(sa.hsn) = 'OOC'
and sa.cancel_code is null;


-- BY receipt date method 2
select 
'A' "sampleAB",
pi.cust_sample_id "sample_code",
pi.lab_sample_id "lin",
'urine' "sample_type",
--to_char(sa.receive_date,'YYYY-MM-DD HH24:MI:SS') "date_received",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD HH24:MI:SS') "date_received",
'n' "monitoring"
from samples sa
inner join permanent_ids pi on pi.hsn = sa.hsn
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_Id = p.cust_id
inner join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
inner join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
where sa.receive_date >='01/01/2015'
and sa.receive_date <'01/01/2016'
and substr(c.flags,1,1) = 'W'
and sa.sample_type = 'PS'
and nvl(a.receive_date,sysdate) <> sa.receive_date
and sa.matrix = 'U'
and get_ic_ooc(sa.hsn) = 'OOC'
and sa.cancel_code is null
order by 5;

-- BY explicit list from Thierry
select 
'A' "sampleAB",
pi.cust_sample_id "sample_code",
pi.lab_sample_id "lin",
'urine' "sample_type",
--to_char(sa.receive_date,'YYYY-MM-DD HH24:MI:SS') "date_received",
to_char(nvl(a.receive_date,sa.receive_date),'YYYY-MM-DD HH24:MI:SS') "date_received",
'n' "monitoring"
from samples sa
inner join permanent_ids pi on pi.hsn = sa.hsn
left outer join airbills a on rtrim(a.original_coc,'_!') = sa.original_coc
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_Id = p.cust_id
inner join aux_data ad1 on ad1.aux_data_id = c.cust_seq and ad1.aux_data_type = 'C' and ad1.aux_data_format = 'ADMS' and ad1.aux_field = 1
inner join aux_data ad2 on ad2.aux_data_id = c.cust_seq and ad2.aux_data_type = 'C' and ad2.aux_data_format = 'ADMS' and ad2.aux_field = 2
where sa.original_coc in (
'1569724',
'1570964',
'1571938',
'1571413',
'2902697',
'1570337',
'2902683',
'2840988',
'1571896',
'1571702',
'1569735',
'1570191',
'2902680',
'1571705',
'1571121',
'1571408',
'1573079',
'1569732',
'1567129',
'1572382',
'1572388',
'1572384',
'1573089',
'1575487',
'1576038',
'1574421',
'1574454',
'1573941',
'3695297',
'1574425',
'1575428',
'1573144',
'1574495',
'1573715',
'1571147',
'1576938',
'1574818',
'1574309',
'1573924',
'1574820',
'1574317',
'1571149',
'3851267',
'1576063',
'1576032',
'1572813',
'1577418',
'1567615',
'1577420',
'2949488',
'3865448',
'3865443',
'3865281',
'2902739',
'2902755',
'2949537',
'3865444',
'1576060',
'1576059',
'1575369',
'1576314',
'1575199',
'3865312',
'3865348',
'1567332',
'2949526',
'3851287',
'2722657',
'2722659',
'3851284',
'3865399',
'3865405',
'2902686',
'3865391',
'3851285',
'3851286',
'1575994',
'1571599',
'1577175',
'1575210',
'1570397',
'1575562',
'1571140',
'1572916',
'1574532',
'1571601',
'1572453',
'1573925',
'1571241',
'1573051',
'3850995',
'1569715',
'1575606',
'1575217',
'1572400',
'1575971',
'1575169',
'1577359',
'2949487',
'2949534',
'3865442',
'2949479',
'1574537',
'1576714',
'1576708',
'1573917',
'1577385',
'1576719',
'2949536',
'3865446',
'1579431',
'1576751',
'1577266',
'1582283',
'1577613',
'1576744',
'1582287',
'1574425',
'1576722',
'1576706',
'1576704',
'1581376',
'1580817',
'3865273',
'1574445',
'3865349',
'1571135',
'1581030',
'3865278',
'2722549',
'2902682',
'1564460',
'1577178',
'2674783',
'2674775',
'3065057',
'2902691',
'3865410',
'2902679',
'1572304',
'1575566',
'1570111',
'2949483',
'3865450',
'3865447',
'2902698',
'2902685',
'1573368',
'1575730',
'1577229',
'1575626',
'1566648',
'6176789',
'1575490',
'3851268',
'3865274',
'1572799',
'2674776',
'2674777',
'2674782',
'1571659',
'1575285',
'1575371',
'1574526',
'1574484',
'1575974',
'1575420',
'1573058',
'1577280',
'1577282',
'1577225',
'1578449',
'1580986',
'1573302',
'1583201',
'1578455',
'1581113',
'1580905',
'1581299',
'1571676',
'1575867',
'1575962',
'1582006',
'1581241',
'1571944')