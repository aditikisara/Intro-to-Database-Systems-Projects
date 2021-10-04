select
    s_name,
    count(p_partkey)
from
    supplier,
    partsupp,
    part,
    nation
where
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    p_size < 20 and
    n_name = 'CANADA'
group by s_name;