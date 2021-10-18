/*
Find how many parts are supplied by exactly two suppliers 
from UNITED STATES.
*/

SELECT count(distinct(p_partkey))
FROM
    part,
    partsupp,
    supplier,
    nation,
    (
        SELECT p_partkey as p
        from
            part,
            partsupp,
            supplier,
            nation
        where
            p_partkey = ps_partkey and
            ps_suppkey = s_suppkey and
            s_nationkey = n_nationkey and
            n_name = 'UNITED STATES'
        group by p_partkey having count(s_name) = 2
    ) sq
WHERE
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    sq.p = p_partkey;