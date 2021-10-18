/*
Find the distinct parts (p name) ordered by customers from 
AMERICA that are supplied by exactly 3 suppliers from ASIA.
*/

select distinct(p_name)
from 
    customer,
    part,
    lineitem,
    nation,
    orders,
    region
where
    p_partkey = l_partkey and
    l_orderkey - o_orderkey and
    o_custkey = c_custkey and
    c_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    r_name = 'AMERICA' and
    p_name in (
        select p_name
        from
            part,
            lineitem,
            supplier,
            nation,
            region
        where
            p_partkey = l_partkey AND
            l_suppkey = s_suppkey AND
            s_nationkey = n_nationkey AND
            n_regionkey = r_regionkey AND
            r_name = 'ASIA'
        GROUP BY p_name having count(s_suppkey) = 3
    )
order by p_name;