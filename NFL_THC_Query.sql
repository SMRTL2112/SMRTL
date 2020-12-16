select sa.original_coc, sa.collect_date, sa.hsn, b.batch_number, sc.cond_code, ai.receive_date, sa.report_date, ad.aux_data from schedules sc
join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
join batches b on b.queue = bs.queue and b.batch_number = bs.batch_number
join samples sa on sa.hsn = sc.schedule_id
join airbills ai on ai.original_coc = sa.original_coc
join aux_data ad on ad.aux_data_id = sa.hsn
where sa.original_coc in (
'S011823945',
'S011823960',
'S012280434',
'S012106506',
'S010511640',
'S012106571',
'S012280426',
'S011431756',
'S012282331',
'S012396321',
'S011042801',
'S012000857',
'S011823929',
'S011198538',
'S011431640',
'S012000410',
'S011911450',
'S011198777',
'S011917457',
'S012428157',
'S011372125',
'S012166104',
'S011941671',
'S012428124',
'S012282398',
'S011372158',
'S011941689',
'S011498045',
'S012105029',
'S010511772',
'S012000980',
'S011372174',
'S011372224',
'S012360418',
'S012360020',
'S011372257',
'S010511780',
'S011405958',
'S012176186',
'S012360053',
'S010748598',
'S012196424',
'S012176202',
'S011372265',
'S011300423',
'S011498060',
'S012428140',
'S011826682',
'S012105094',
'S011372299',
'S011943107',
'S012396370',
'S011576121',
'S011405974',
'S011911435',
'S012280582',
'S012360087',
'S011911427',
'S012396354',
'S012280525',
'S011826732',
'S011840006',
'S011042603',
'S012218467',
'S011431590',
'S011751914',
'S011911401',
'S012105110',
'S012280517',
'S012360335',
'S012105128',
'S011372406',
'S011405990',
'S011826740',
'S012280459',
'S011840170',
'S011498102',
'S012105151',
'S012176277',
'S012360145',
'S011943123',
'S011431624',
'S012196390',
'S012360160',
'S011840071',
'S010511871',
'S012350146',
'S011823861',
'S012282463',
'S012196382',
'S011372489',
'S010511889',
'S011372505',
'S010511897',
'S012106605',
'S011823853',
'S012106613',
'S011840105',
'S012350161',
'S010911345',
'S012196374',
'S011823820',
'S012106811',
'S011710696',
'S011710704',
'S010911402',
'S011710654',
'S012210159',
'S011023892',
'S012210175',
'S011823747',
'S012360822',
'S011823614',
'S012282489',
'S012360798',
'S012210027',
'S010511913',
'S011023645',
'S011823739',
'S011911310',
'S012360848',
'S011372349',
'S012210217',
'S011372356',
'S011023769',
'S012210225',
'S012360939',
'S011825023',
'S011941721',
'S012218517',
'S012160669',
'S011198520',
'S011023694',
'S012055000',
'S011911369',
'S011431806',
'S011493319',
'S011023702',
'S011911351',
'S009796624',
'S009796704',
'S011372547',
'S011911344',
'S012282547',
'S011023793',
'S009796642',
'S011372588',
'S011372604',
'S011372612',
'S012003299',
'S011372653',
'S012350179',
'S011941762',
'S011431822',
'S012105243',
'S012176343',
'S009796660',
'S011431830',
'S011840253',
'S012055091',
'S012176376',
'S011826823',
'S011095734',
'S012396495',
'S011431871',
'S011372752',
'S011826849',
'S012055133',
'S011911237',
'S011431905',
'S011840303',
'S012350526',
'S011840311',
'S011826856',
'S011911211',
'S012350518',
'S011431954',
'S012105284',
'S012176459',
'S012282349',
'S011823697',
'S009796740',
'S011840386',
'S011498144',
'S011840394',
'S011498136',
'S011498177',
'S011498193',
'S012436002',
'S011493285',
'S011710720',
'S012106829',
'S008811804',
'S011710712',
'S011576675',
'S011576691',
'S011576725',
'S011493293',
'S011710522',
'S011710779',
'S011844487',
'S012161626',
'S012055232',
'S012282570',
'S011844495',
'S012360178',
'S012360186',
'S011844529',
'S009796768',
'S011944055',
'S012396529',
'S011198603',
'S012003331',
'S011944089',
'S011825114',
'S012055281',
'S011023827',
'S012360350',
'S012350369',
'S012055299',
'S012360285',
'S009796848',
'S011198967',
'S012360343',
'S010165801',
'S011710498',
'S012210068',
'S012055315',
'S012436077',
'S010165819',
'S012055323',
'S012254017',
'S011911500',
'S011861606',
'S012176467',
'S012161865',
'S011941796',
'S011710985',
'S012055356',
'S012436119',
'S012003372',
'S012260303',
'S010165850',
'S012254025',
'S012260311',
'S011861630',
'S012106860',
'S011861655',
'S009796875',
'S012436135',
'S011861663',
'S011944196',
'S012254173',
'S010165868',
'S012350534',
'S012254181',
'S012055190',
'S009796928',
'S011818960',
'S011861671',
'S012106514',
'S009796991',
'S011826971',
'S011861689',
'S012254215',
'S012176541',
'S012350567',
'S011826930',
'S012055380',
'S012254090',
'S012330890',
'S012330999',
'S012350708',
'S012436259',
'S012360392',
'S012436291',
'S011146032',
'S012260329',
'S012436317',
'S012254231',
'S011944220',
'S012380671',
'S011911294',
'S012055505',
'S011941937',
'S012161980',
'S011146057',
'S011944246',
'S012436309',
'S012003471',
'S011023967',
'S009797035',
'S012161725',
'S011844990',
'S012330833',
'S011944295',
'S011844644',
'S011498433',
'S011023595',
'S011844651',
'S012055554',
'S011944303',
'S011023603',
'S011023611',
'S012350229',
'S012055588',
'S011861374',
'S012350013',
'S009797071',
'S012350039',
'S011941960',
'S011944329',
'S011751724',
'S012055612',
'S009797106',
'S009616490',
'S011751757',
'S012396644',
'S011751740',
'S011576584',
'S012055620',
'S011825171',
'S011944360',
'S012055646',
'S012280756',
'S012350278',
'S012055653',
'S012350054',
'S011944394',
'S011944410',
'S011844750',
'S009797151',
'S012350641',
'S011710829',
'S012436390',
'S012436408',
'S011095783',
'S011576600',
'S012330106',
'S011710886',
'S011861275',
'S012330007',
'S012254371',
'S012254447',
'S011941903',
'S012146015',
'S012003497',
'S012330726',
'S012254462',
'S011941770',
'S012003505',
'S012330965',
'S012003513',
'S012146031',
'S012396693',
'S012254520',
'S012003547',
'S011944493',
'S011944527',
'S012350724',
'S011944568',
'S011944584',
'S011944600',
'S011576790',
'S012146056',
'S011861317',
'S011095809',
'S011576774',
'S012350773',
'S009592684',
'S011861366',
'S011861358',
'S012108239',
'S012108270',
'S011840956',
'S011095817',
'S012108189',
'S012146296',
'S012146361',
'S011576097',
'S011576105',
'S011095890',
'S011095882',
'S011826633',
'S011826658',
'S012176608',
'S012176616',
'S011576758',
'S012003646',
'S012146379',
'S012146437',
'S012146445',
'S012146452',
'S009797197',
'S012350781',
'S012108304',
'S012108320',
'S012330148',
'S012396792',
'S011576022',
'S010574069',
'S012338075'
)
and b.queue = 'GSCR'
and ad.aux_data_format = 'SV'
and ad.aux_field = 1
order by 1
;