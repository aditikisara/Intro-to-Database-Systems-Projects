SELECT
    s_name,
    s_acctbal
FROM
    region,
    nation,
    supplier
WHERE
    s_nationkey = n_nationkey
    AND n_regionkey = r_regionkey
    AND s_acctbal > '5000'
    AND r_name = 'AMERICA'
ORDER BY s_name asc;