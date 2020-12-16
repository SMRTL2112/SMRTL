
--SMRTL LIMS:

select co.company_name, co.first_name, co.last_name, em.email  from contact co
join email em on em.contact_id = co.contact_id
and co.company_name <> 'SMRTL'
order by 1,2
;

--Horizon LIMS:
select distinct cu.cust_name, addr.first_name, addr.last_name, addr.e_mail from customers cu
join map_to_addrs mta on mta.cust_id = cu.cust_id
join addresses addr on addr.addr_seq = mta.addr_seq
where substr(mta.flags,5,1) = 'R'
and addr.e_mail is not null
--and addr.last_name not like 'ADAMS%'
order by cu.cust_name
;