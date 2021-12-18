/*
Create a trigger t2 that sets a warning Negative balance!!! in the comment attribute of the
customer table every time c acctbal is updated to a negative value from a positive one. Write a
SQL statement that sets the balance to -100 for all the customers in AMERICA. Write a query that
returns the number of customers with negative balance from CANADA. Put all the SQL statements in
file test/2.sql. 
*/

CREATE TRIGGER t2 UPDATE OF c_acctbal ON customer
BEGIN
    UPDATE customer
    SET c_comment = "Negative balance!!!"
    WHERE 
        new.c_acctbal < 0 AND
        c_custkey = new.c_custkey;
END;

UPDATE customer
SET c_acctbal = -100
WHERE c_nationkey IN (
    SELECT c_nationkey
    FROM
        customer,
        nation,
        region
    WHERE 
        c_nationkey = n_nationkey AND
        n_regionkey = r_regionkey AND
        r_name = "AMERICA"
);


SELECT COUNT(c_custkey)
FROM customer, nation
WHERE
    c_nationkey = n_nationkey AND
    n_name = "CANADA" AND
    c_acctbal < 0;
