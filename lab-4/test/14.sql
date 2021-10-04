select
    rs.r_name,
    rc.r_name,
    max(o_totalprice)
from
    customer,
    supplier,
    orders,
    nation,
    lineitem,
    region rs,
    region rc,
    nation ns,
    nation nc
where
    c_nationkey = nc.n_nationkey and
    nc.n_regionkey = rc.r_regionkey and
    s_nationkey = ns.n_nationkey and
    ns.n_regionkey = rs.r_regionkey and
    c_custkey = o_custkey and
    o_orderkey = l_orderkey and
    l_suppkey = s_suppkey
group by rs.r_name, rc.r_name;