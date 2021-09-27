select count(distinct(c_name))
from customer, lineitem, orders
where
    c_custkey = o_custkey and
    o_orderkey = l_orderkey and
    l_discount >= 0.1;