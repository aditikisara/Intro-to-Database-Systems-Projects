/*
For the line items ordered in October 1996 (o orderdate), find 
the smallest discount that is larger than the average discount 
among all the orders.
*/

select min(l_discount)
from
    lineitem,
    orders
where
    l_orderkey = o_orderkey and
    o_orderdate between '1996-10-01' and '1996-10-31' AND
    l_discount > (
        select avg(l_discount)
        from lineitem, orders
        where
            l_orderkey = o_orderkey and
            o_orderdate between '1996-10-01' and '1996-10-31'
    );