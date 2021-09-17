SELECT
    DISTINCT(n_name)
FROM orders, customer, nation
WHERE
    o_custkey = c_custkey AND
    c_nationkey = n_nationkey AND
    o_orderdate BETWEEN '1996-09-10' AND '1996-09-12'
ORDER BY
    n_name ASC;