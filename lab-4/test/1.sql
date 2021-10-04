select
    c_name,
    sum(o_totalprice)
from
    orders,
    customer,
    nation
where
    o_custkey = c_custkey and
    c_nationkey = n_nationkey and
    n_name = 'FRANCE' and
    o_orderdate between '1995-01-01' and '1995-12-31'
group by c_name;