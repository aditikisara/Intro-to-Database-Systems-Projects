select
    n_name,
    o_orderstatus,
    count(o_orderkey)
from
    nation,
    orders,
    customer,
    region
where
    c_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = 'AMERICA'
    and c_custkey = o_custkey
group by n_name, o_orderstatus;