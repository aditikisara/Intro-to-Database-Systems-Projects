select
    n_name,
    count(distinct(c_custkey)),
    count(distinct(s_suppkey))
from
    customer,
    supplier,
    nation,
    region
where
    c_nationkey = s_nationkey and
    s_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    r_name = 'AFRICA'
group by n_name;