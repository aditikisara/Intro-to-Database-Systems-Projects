select
    r_name,
    s_name,
    max(s_acctbal)
from
    region,
    nation,
    supplier
where
    s_nationkey = n_nationkey and
    n_regionkey = r_regionkey
group by r_name;