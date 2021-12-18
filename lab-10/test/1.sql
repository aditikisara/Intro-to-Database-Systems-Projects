/*
Create a trigger t1 that for every new order entry automatically fills the o orderdate attribute with
the date 2021-12-01. Insert into orders all the orders from December 1996, paying close attention
on how the o orderkey attribute is set. Write a query that returns the number of orders from 2021.
Put all the three SQL statements in file test/1.sql.
*/

CREATE TRIGGER t1 AFTER INSERT ON orders
BEGIN
    UPDATE orders 
    SET o_orderdate = DATE("2021-12-01") 
    WHERE o_orderkey = new.o_orderkey;
END;

INSERT INTO orders
SELECT
    o_orderkey,
    o_custkey,
    o_orderstatus,
    o_totalprice,
    o_orderdate,
    o_orderpriority,
    o_clerk,
    o_shippriority,
    o_comment
FROM orders
WHERE
    o_orderdate >= DATE("1996-12-01") AND
    o_orderdate <= DATE("1996-12-31");

SELECT COUNT(DISTINCT(o_orderkey))
FROM orders
WHERE
    orders.o_orderdate >= DATE("2021-12-01") AND
    orders.o_orderdate <= DATE("2021-12-31");