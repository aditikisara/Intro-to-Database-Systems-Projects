select
    count(l_orderkey)
from
    lineitem,
    supplier,
    nation,
    region
where
    l_suppkey = s_suppkey
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = 'AFRICA'
    and l_orderkey in (select
                            l_orderkey
                        from
                            lineitem,
                            orders,
                            customer,
                            nation
                        where
                            l_orderkey = o_orderkey
                            and o_custkey = c_custkey
                            and c_nationkey = n_nationkey
                            and n_name = 'UNITED STATES');