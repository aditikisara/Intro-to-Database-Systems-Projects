select p_mfgr
from (
    select p_mfgr, min(ps_availqty)
    from part, partsupp, supplier
    where
        s_suppkey = ps_suppkey and
        ps_partkey = p_partkey and
        s_name = 'Supplier#000000010'
);