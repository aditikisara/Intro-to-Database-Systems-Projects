/*
Find the supplier-customer pair(s) with the least expensive 
(o totalprice) order(s) completed (F in o orderstatus). 
Print the supplier name, the customer name, and the total 
price.
*/

SELECT
    s_name,
    c_name,
    o_totalprice
from
    supplier,
    customer,
    orders,
    lineitem
WHERE
    s_suppkey = l_suppkey and
    l_orderkey = o_orderkey and
    o_custkey = c_custkey and
    o_totalprice = (
        select min(o_totalprice)
        from orders
        where o_orderstatus = 'F'
    );
    