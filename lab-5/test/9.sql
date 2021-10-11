/*
Print the name of the parts supplied by suppliers from UNITED STATES that have total 
value in the top 1% total values across all the supplied parts. The total value is ps_
supplycost * ps_availqty. Hint: Use the LIMIT keyword.
*/

-- values aren't ordered right??

select p_name
from part, partsupp, supplier, nation
where
    p_partkey = ps_partkey and
    ps_suppkey = s_suppkey and
    s_nationkey = n_nationkey and
    n_name = 'UNITED STATES' and
    ps_supplycost * ps_availqty in (
        select (ps_supplycost * ps_availqty) as total_value
        from partsupp
        order by total_value desc
        limit (
            select count(*) * 0.01
            from partsupp
        )
    )
group by p_name;