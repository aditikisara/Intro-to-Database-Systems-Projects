select
    n_name,
    max(s_acctbal)
from
    nation,
    supplier
where
    s_nationkey = n_nationkey and
    s_acctbal > 9000
group by n_name;