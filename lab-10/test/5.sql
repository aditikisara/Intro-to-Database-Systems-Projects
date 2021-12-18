/*
Create a trigger t5 that removes all the tuples from partsupp and lineitem corresponding to a part
being deleted. Delete all the parts supplied by suppliers from UNITED STATES or CANADA. Write a query
that returns the number of parts supplied by every supplier in AMERICA grouped by their country in
increasing order. Put all the SQL statements in file test/5.sql.
*/

CREATE TRIGGER t5 AFTER DELETE ON part
FOR EACH ROW
BEGIN
    DELETE FROM partsupp
    WHERE ps_partkey = old.p_partkey;

    DELETE FROM lineitem
    WHERE l_partkey = old.p_partkey;
END;

DELETE FROM part
WHERE p_partkey IN (
    SELECT p_partkey
    FROM
        part,
        partsupp,
        supplier,
        nation
    WHERE
        p_partkey = ps_partkey AND
        ps_suppkey = s_suppkey AND
        s_nationkey = n_nationkey AND
        n_name = 'UNITED STATES'
);

DELETE FROM part
WHERE p_partkey IN (
    SELECT p_partkey
    FROM
        part,
        partsupp,
        supplier,
        nation
    WHERE
        p_partkey = ps_partkey AND
        ps_suppkey = s_suppkey AND
        s_nationkey = n_nationkey AND
        n_name = 'CANADA'
);

SELECT n_name, COUNT(*)
FROM
    partsupp,
    supplier,
    nation,
    region
WHERE
    ps_suppkey = s_suppkey AND
    s_nationkey = n_nationkey AND
    n_regionkey = r_regionkey AND
    r_name = 'AMERICA'
GROUP BY n_name;