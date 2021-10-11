/*
How many customers from every region have never placed an order and have less than 
the average account balance?
*/

select
    r_name,
    count(c_custkey)
from
    customer,
    nation,
    region
where
    c_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    c_custkey not in (
        select o_custkey
        from orders
    ) and
    c_acctbal < (
        select avg(c_acctbal)
        from customer
    )
group by r_name;

