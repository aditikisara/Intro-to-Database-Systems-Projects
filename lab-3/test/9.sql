select 
    n_name,
    count(s_name),
    max(s_acctbal)
from 
    nation,
    supplier
where
    n_nationkey = s_nationkey
group by n_name
having count(s_name) > 5;