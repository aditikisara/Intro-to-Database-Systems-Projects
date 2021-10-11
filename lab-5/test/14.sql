/*
For any two regions, find the gross discounted revenue (l extendedprice*(1-l discount)) derived from line items 
in which parts are shipped from a supplier in the first region to a customer in the second region in 1996 and 1997. 
List the supplier region, the customer region, the year (l shipdate), and the revenue from shipments that took 
place in that year.
*/

select
    rs.r_name,
    rc.r_name,
    strftime('%Y', l_shipdate),
    sum(l_extendedprice * (1 - l_discount))
from
    region rs,
    region rc,
    nation ns,
    nation nc,
    supplier,
    customer,
    orders,
    lineitem
where
    l_orderkey = o_orderkey and
    o_custkey = c_custkey and
    c_nationkey = nc.n_nationkey and
    nc.n_regionkey = rc.r_regionkey and

    l_suppkey = s_suppkey and
    s_nationkey = ns.n_nationkey and
    ns.n_regionkey = rs.r_regionkey and

    strftime('%Y', l_shipdate) in ('1996', '1997')

group by rs.r_name, rc.r_name, strftime('%Y', l_shipdate)
order by rs.r_name, rc.r_name, strftime('%Y', l_shipdate);