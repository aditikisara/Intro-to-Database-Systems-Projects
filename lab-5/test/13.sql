/*
Count the number of orders made in the fourth quarter of 1997 in which at least one 
lineitem was received by a customer earlier than its commit date. List the count of 
such orders for every order priority.
*/

select
    o_orderpriority,
    count(distinct(o_orderkey))
from
    orders,
    lineitem
where
    o_orderkey = l_orderkey and
    o_orderdate between '1997-10-01' and '1997-12-31' and
    l_receiptdate < l_commitdate
group by o_orderpriority;