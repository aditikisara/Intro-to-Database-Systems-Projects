select strftime('%Y', o_orderdate), count(*)
from orders, lineitem, nation, supplier
where
    o_orderkey = l_orderkey and
    l_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    o_orderpriority = '3-MEDIUM' and
    n_name = 'CANADA'
group by strftime('%Y', o_orderdate);
