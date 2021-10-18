/*
Find the nation(s) with the most developed industry, i.e., selling 
items totaling the largest amount of money (l_exendedprice) in 1994 
(l_shipdate).
*/

SELECT
    n_name
FROM
    (
        SELECT
            n_name,
            MAX(price)
        FROM
            (
                SELECT
                    n_name,
                    SUM(l_extendedprice) AS price
                FROM
                    nation,
                    lineitem,
                    supplier
                WHERE
                    l_suppkey = s_suppkey AND
                    s_nationkey = n_nationkey AND
                    l_shipdate BETWEEN '1994-01-01' AND '1994-12-31'
                GROUP BY n_name
            )
    );