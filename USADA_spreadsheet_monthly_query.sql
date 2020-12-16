-- USADA spreadsheet query for Toni
select c.cust_name, 
p.profile_name,
pid.cust_sample_id,
pid.lab_sample_id, 
ac.charge_date, 
ac.part, 
sa.receive_date,
i.cutoff_date
from accumulated_charges ac
inner join samples sa on sa.hsn = ac.hsn
inner join permanent_ids pid on pid.hsn = sa.hsn
inner join profiles p on p.reqnbr = sa.reqnbr
inner join customers c on c.cust_id = p.cust_id
inner join invoices i on i.invoice_seq = ac.invoice_seq
where i.addr_Seq in (66,496)
and trunc(i.cutoff_date) = trunc(sysdate,'MONTH') - 1
order by 1, 4, 6;