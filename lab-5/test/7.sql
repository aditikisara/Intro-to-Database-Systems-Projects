/*
For every order priority, count the number of parts ordered in 1997 
and received later (l_receiptdate) than the commit date (l_commitdate).
*/

select
    o_orderpriority,
    count(p_partkey)
from
    part, lineitem, orders
where
    p_partkey = l_partkey and
    l_orderkey = o_orderkey and
    o_orderdate between '1997-01-01' and '1997-12-31' and
    l_receiptdate > l_commitdate
group by o_orderpriority;