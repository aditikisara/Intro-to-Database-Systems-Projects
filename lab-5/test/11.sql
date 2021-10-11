/*
Find the lowest value line item(s) (l extendedprice*(1-l discount)) shipped after 
October 2, 1996. Print the name of the part corresponding to these line item(s).
*/

select p_name
from lineitem, part
where
    l_partkey = p_partkey and
    l_shipdate > '1996-10-03' and
    l_extendedprice * (1-l_discount) in (
        select min(l_extendedprice * (1-l_discount))
        from lineitem, part
        where
            l_partkey = p_partkey
    );