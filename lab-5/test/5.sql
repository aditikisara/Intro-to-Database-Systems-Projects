select
    s_name,
    p_size,
    min(ps_supplycost) as min_cost
from
    supplier,
    part,
    partsupp,
    nation,
    region
where
    ps_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    ps_partkey = p_partkey and
    p_type like '%STEEL%' and
    r_name = 'ASIA'
group by p_size
order by s_name;