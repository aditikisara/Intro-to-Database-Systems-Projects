select
    count(distinct(o_clerk))
from
    nation,
    supplier,
    lineitem,
    orders
where
    n_nationkey = s_nationkey and
    s_suppkey = l_suppkey and
    l_orderkey = o_orderkey and
    n_name = 'UNITED STATES';