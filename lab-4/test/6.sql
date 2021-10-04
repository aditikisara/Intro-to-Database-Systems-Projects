select
    s_name,
    o_orderpriority,
    count(distinct(p_partkey))
from
    supplier,
    orders,
    part,
    nation,
    lineitem
where
    s_nationkey = n_nationkey
    and s_suppkey = l_suppkey
    and l_orderkey = o_orderkey
    and l_partkey = p_partkey
    and n_name = 'CANADA'
group by s_name, o_orderpriority;