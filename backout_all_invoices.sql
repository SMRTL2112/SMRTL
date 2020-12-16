begin

for r_inv in (select * from invoices where ACTUAL_DATE >= trunc(sysdate,'MONTH')) loop

dbms_output.put_line('Rolling back accumulated_charges entries for customer '||r_inv.cust_id||' and invoice '||r_inv.invoice_seq);
update accumulated_charges
set INVOICE_SEQ = -1
where invoice_seq = r_inv.invoice_seq;
dbms_output.put_line(sql%rowcount || ' rows affected');

dbms_output.put_line('Deleting invoice '||r_inv.invoice_seq);
delete from invoices where invoice_Seq = r_inv.invoice_seq;
dbms_output.put_line(sql%rowcount || ' rows affected');

end loop;
end;
