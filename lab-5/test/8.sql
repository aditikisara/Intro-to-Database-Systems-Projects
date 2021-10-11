select count(distinct(s_name))
from supplier, part, partsupp
where
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey and
    p_type like '%POLISHED%' and
    (p_size = 3 or p_size = 23 or p_size = 36 or p_size = 49);