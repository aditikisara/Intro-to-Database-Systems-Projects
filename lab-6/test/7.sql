/***********
Find how many suppliers have less than 50 distinct orders 
from customers in GERMANY and FRANCE together.
*/

select count(distinct(s_suppkey))
from
    supplier,
    orders,
    nation,
    lineitem,
    customer,
    (
        SELECT s_suppkey s
        from
            supplier,
            orders,
            nation,
            lineitem,
            customer
        where -- Link customer to nation
            c_custkey = o_custkey and
            o_orderkey = l_orderkey AND
            l_suppkey = s_suppkey AND
            c_nationkey = n_nationkey AND
            (n_name = 'GERMANY' or n_name = 'FRANCE')
        group by s_name having count(distinct(o_orderkey)) < 50
    ) sq
where
    c_custkey = o_custkey and
    o_orderkey = l_orderkey AND
    l_suppkey = s_suppkey AND
    c_nationkey = n_nationkey AND
    sq.s = s_suppkey;