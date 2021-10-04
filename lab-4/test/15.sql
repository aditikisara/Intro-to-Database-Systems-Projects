select
    count (distinct o_orderkey)
from
    orders
where
    o_orderkey in (select o_orderkey
                    from
                        orders,
                        customer
                    where
                        o_custkey = c_custkey
                        and c_acctbal > 0)
    and o_orderkey in (select o_orderkey
                        from
                            orders,
                            lineitem,
                            supplier
                        where
                            o_orderkey = l_orderkey
                            and l_suppkey = s_suppkey
                            and s_acctbal < 0);