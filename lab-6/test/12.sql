/*
Find the nation(s) having customers that spend the smallest 
amount of money (o totalprice).
*/

SELECT
    n_name
FROM
    (
        SELECT
            n_name,
            MIN(AMTSPT)
        FROM
            (
                SELECT
                    n_name,
                    SUM(o_totalprice) AS AMTSPT
                FROM
                    orders,
                    nation,
                    customer
                WHERE
                    c_nationkey = n_nationkey AND
                    c_custkey = o_custkey
                GROUP BY n_name
            )
    );
