select
    n_name, count(distinct(o_orderkey))
from
    supplier,
    nation,
    orders,
    lineitem
where
    n_nationkey = s_nationkey and
    s_suppkey = l_suppkey and
    l_orderkey = o_orderkey and
    o_orderdate between '1995-01-01' and '1995-12-31' and
    o_orderstatus = 'F'
group by n_name
having count(distinct(o_orderkey)) > 50;