/*
What is the total supply cost (ps supplycost) for parts less expensive than $1000 
(p retailprice) shipped in 1997 (l shipdate) by suppliers who did not supply any 
lineitem with an extended price less than 2000 in 1996?
*/

-- can't link parts and lineitems

select sum(ps_supplycost)
from 
    supplier,
    part,
    partsupp,
    lineitem
where
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey AND
    p_partkey = l_partkey and
    p_retailprice < 1000 and
    l_shipdate between '1997-01-01' and '1997-12-31' and
    s_name not in (
        select s_name
        from supplier, lineitem
        where
            s_suppkey = l_suppkey and
            l_extendedprice < 2000 and
            l_shipdate between '1996-01-01' and '1996-12-31'
    );
