SELECT
    s_name,
    s_acctbal
FROM
    supplier, nation
WHERE
    n_nationkey = 'UNITED STATES' AND
    s_acctbal > 5000;