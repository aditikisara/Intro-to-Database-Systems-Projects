/*
Find the number of customers who had at least three orders 
in November 1995 (o orderdate).
*/

SELECT COUNT(DISTINCT c_custkey) 
FROM 
    customer,
    orders,
    (
        SELECT c_custkey AS cust_count
            FROM customer,
                orders
        WHERE c_custkey = o_custkey AND 
                o_orderdate BETWEEN '1995-11-01' AND '1995-11-30'
        GROUP BY c_custkey HAVING COUNT(c_custkey) >= 3
    ) sq
WHERE 
    sq.cust_count = c_custkey;