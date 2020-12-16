--select sa.hsn, sa.original_coc, sa.collect_date, c.disposal_date, c.actual_disposal, bs.batch_number
select sa.hsn, sa.original_coc, bs.batch_number, c.actual_disposal
from samples sa
left outer join schedules sc on sc.schedule_id = sa.hsn and sc.queue = 'GSCR' and nvl(sc.active_flag,'*') in ('A','*','F')
left outer join batch_schedules bs on bs.schedule_seq = sc.schedule_seq
inner join containers c on c.hsn = sa.hsn and c.container_type = 'A'
where sa.original_coc in (
'S008214900',
'S008243446',         
'S008214884',         
'S008215022',       
'S008248676',
'S008248684',
'S007679574',
'S008248668',
'S008248692',
'S007075575',
'S008276875',
'S008276867',         
'S008727430',
'S008226110',
'S008279580',
'S008208449',
'S008208456',
'S007606908',
'S007080872',
'S008473241',
'S008473134',
'S007485139',
'S008896771',
'S007101686',
'S008339855',
'S008256794',
'S008214736',
'S008741860',
'S008282014',
'S008487258',
'S008718413',
'S007555501',
'S008585184',
'S007504939',
'S008301392',
'S007019797',
'S007750029')
order by 3 desc