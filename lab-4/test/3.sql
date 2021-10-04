select
    n_name,
    count(o_orderkey)
from
    orders,
    customer,
    nation,
    region
where
    o_custkey = c_custkey and
    c_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    r_name = 'AMERICA'
group by n_name;