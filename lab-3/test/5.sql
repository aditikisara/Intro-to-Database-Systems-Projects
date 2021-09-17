SELECT
    c_mktsegment,
    MIN(c_acctbal),
    MAX(c_acctbal),
    SUM(c_acctbal)
FROM customer
group by c_mktsegment;