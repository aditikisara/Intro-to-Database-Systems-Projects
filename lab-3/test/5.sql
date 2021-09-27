SELECT
    c_mktsegment,
    MIN(c_acctbal),
    MAX(c_acctbal),
    SUM(c_acctbal)
FROM customer
GROUP BY c_mktsegment;