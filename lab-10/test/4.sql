/*
Create triggers that update the attribute o orderpriority to HIGH every time a new lineitem tuple
is added to or deleted from that order. Delete all the line items corresponding to orders from December
1995. Write a query that returns the number of HIGH priority orders in the fourth trimester of 1995.
Put all the SQL statements in file test/4.sql.
*/

CREATE TRIGGER t4 INSERT on lineitem
BEGIN
    UPDATE orders
    SET o_orderpriority = "2-HIGH"
    WHERE o_orderkey IN (
        SELECT o_orderkey
        FROM orders, lineitem
        WHERE o_orderkey = new.l_orderkey
    );                   
END;

DELETE FROM lineitem
WHERE l_orderkey IN (
    SELECT o_orderkey
    FROM orders
    WHERE
        o_orderdate >= "1995-12-01" AND
        o_orderdate <= "1995-12-31"
);

Select COUNT(o_orderpriority)
FROM orders
WHERE
    o_orderpriority = "2-HIGH" AND
    o_orderdate >= "1995-08-07" AND
    o_orderdate <= "1995-12-31";