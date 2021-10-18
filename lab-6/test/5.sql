/*
Find how many suppliers supply the most expensive part 
(p retailprice).
*/

SELECT count(distinct(s_name))
FROM
    supplier,
    part,
    partsupp
WHERE
    s_suppkey = ps_suppkey and
    ps_partkey = p_partkey and
    p_retailprice = (
        select max(p_retailprice)
        from part
    );