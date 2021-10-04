select
    p_type,
    min(l_discount),
    max(l_discount)
from
    part,
    lineitem
where
    l_partkey = p_partkey and
    p_type like '%ECONOMY%' and
    p_type like '%COPPER%'
group by p_type;