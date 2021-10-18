/*
Find how many suppliers from UNITED STATES supply more than 
40 different parts.
*/

SELECT count(distinct(s_name))
FROM
    supplier,
    nation,
    part,
    partsupp,
    (
        SELECT s_name s
        FROM 
            supplier,
            nation,
            part,
            partsupp
        WHERE
            p_partkey = ps_partkey and
            ps_suppkey = s_suppkey and
            s_nationkey = n_nationkey and
            n_name = 'UNITED STATES'
        GROUP BY s_name having count(p_name) > 40
    ) sq
WHERE
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    sq.s = s_name;