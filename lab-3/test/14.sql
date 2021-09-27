SELECT
    count(o_orderpriority)
FROM
    orders,
    region,
    nation,
    customer
WHERE
    o_custkey = c_custkey AND
    c_nationkey = n_nationkey AND
    n_regionkey = r_regionkey AND
    o_orderpriority = '1-URGENT' AND
    n_name = 'BRAZIL' AND
    o_orderdate between '1994-01-01' and '1997-12-31';