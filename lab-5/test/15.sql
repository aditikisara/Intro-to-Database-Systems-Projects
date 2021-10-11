/*
The market share for a given nation within a given region is defined as 

the fraction of the revenue from the line items ordered 
by 
customers in the given region that are supplied by suppliers from the given nation. 

The revenue of a line item is defined as l extendedprice*(1-l discount). Determine 
the market share of UNITED STATES in ASIA in 1997 (l shipdate).
*/

select
    (
        select
            sum(l_extendedprice * (1 - l_discount))
        from
            nation ns,
            nation nc,
            region r,
            orders,
            supplier,
            customer,
            lineitem
        where
            ns.n_nationkey = c_nationkey AND
            ns.n_regionkey = r.r_regionkey AND
            nc.n_nationkey = s_nationkey AND
            o_orderkey = l_orderkey AND
            o_custkey = c_custkey AND
            l_suppkey = s_suppkey AND
            r.r_name = 'ASIA' AND
            nc.n_name = 'UNITED STATES' AND
            STRFTIME('%Y', l_shipdate) = '1997'
    ) / 
    (
        select
            sum(l_extendedprice * (1 - l_discount))
        from
            nation ns,
            region r,
            orders,
            customer,
            lineitem
        where
            ns.n_regionkey = r.r_regionkey AND
            ns.n_nationkey = c_nationkey AND
            o_orderkey = l_orderkey AND
            o_custkey = c_custkey AND
            r.r_name = 'ASIA' AND
            STRFTIME('%Y', l_shipdate) = '1997'
    );