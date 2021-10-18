/*
Find how many distinct customers have at least one order 
supplied exclusively by suppliers from AMERICA.
*/

SELECT
    COUNT(DISTINCT c_custkey)
FROM
    orders,
    customer
WHERE
    c_custkey = o_custkey AND
    o_orderkey NOT IN
                    (
                        SELECT
                            DISTINCT o_orderkey
                        FROM
                            nation,
                            region,
                            supplier,
                            lineitem,
                            orders
                        WHERE
                            o_orderkey = l_orderkey AND
                            l_suppkey = s_suppkey AND
                            s_nationkey = n_nationkey AND
                            n_regionkey = r_regionkey AND
                            r_name != 'AMERICA'
                    );