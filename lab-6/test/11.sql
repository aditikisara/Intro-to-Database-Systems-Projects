/*
Find the nation(s) with the smallest number of customers.
*/

select n_name
from
    nation,
    customer
where
    c_nationkey = n_nationkey
group by n_name having count(*) = (
    select min(cust_count)
    from (
        SELECT n_name, count(c_custkey) as cust_count
        FROM customer, nation
        where
            c_nationkey = n_nationkey
        group by n_name
    )
);
