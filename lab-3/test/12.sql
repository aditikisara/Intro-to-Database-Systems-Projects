SELECT
    r_name,
    count(o_orderstatus)
FROM
    orders,
    region,
    nation,
    customer
WHERE
    o_custkey = c_custkey AND
    c_nationkey = n_nationkey AND
    n_regionkey = r_regionkey AND
    o_orderstatus = 'F'
GROUP by
    r_name;
