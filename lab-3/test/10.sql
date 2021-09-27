SELECT
    sum(o_totalprice)
FROM
    region,
    nation,
    customer,
    orders
WHERE
    o_custkey = c_custkey AND
    c_nationkey = n_nationkey AND
    n_regionkey = r_regionkey AND
    r_name = "AMERICA" AND
    o_orderdate between "1996-01-01" and "1996-12-31"; --inclusive
