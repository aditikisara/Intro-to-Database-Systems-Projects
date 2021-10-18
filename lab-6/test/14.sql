/*
Compute, for every country, the value of economic exchange, 
i.e., the difference between the number of items from 
suppliers in that country sold to customers in other 
countries and the number of items bought by local customers 
from foreign suppliers in 1994 (l shipdate).
*/

SELECT
    n1,
    count1 - count2
FROM 
    (
        SELECT 
            n_name AS n1,
            count(l_quantity) AS count1
        FROM 
            nation,
            orders,
            customer,
            supplier,
            lineitem
        WHERE
            c_custkey = o_custkey AND
            o_orderkey = l_orderkey AND
            l_suppkey = s_suppkey AND
            s_nationkey = n_nationkey AND
            n_nationkey != c_nationkey AND
            l_shipdate BETWEEN '1994-01-01' and '1994-12-31'
        GROUP BY n_name
    ),
    (
        SELECT
            n_name AS n2,
            count(l_quantity) AS count2
        FROM
            nation,
            orders,
            customer,
            supplier,
            lineitem
        WHERE
            n_nationkey = c_nationkey AND
            c_custkey = o_custkey AND
            o_orderkey = l_orderkey AND
            l_suppkey = s_suppkey AND
            s_nationkey != n_nationkey AND
            l_shipdate BETWEEN '1994-01-01' AND '1994-12-31'
        GROUP BY n_name
    )
WHERE
    n1 = n2;