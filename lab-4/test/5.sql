select
    c_name,
    count(o_orderkey)
from
    nation,
    customer,
    orders
where
    o_custkey = c_custkey and
    c_nationkey = n_nationkey and
    n_name = 'GERMANY' and
    o_orderdate between '1993-01-01' and '1993-12-31'
group by c_name;