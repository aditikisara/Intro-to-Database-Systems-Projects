/*
Find the region where customers spend the smallest amount of 
money (l extendedprice) buying items from suppliers in the same 
region.
*/

-- takes some time, but works

-- gives the region with the smallest min price
SELECT r_name
FROM (
    -- Table with r_name and the min price. Grouping by region will
    -- give us the min price of each region
    SELECT r_name, min(price)
    FROM (
        -- Table with r_name and sum of price. This is where the
        -- min is selected in the select statement above.
        SELECT r_name, sum(l_extendedprice) as price
        FROM
            customer,
            lineitem,
            nation n1,
            nation n2,
            region,
            supplier
        WHERE
            c_nationkey = n1.n_nationkey AND
            n1.n_regionkey = r_regionkey AND
            
            -- suppliers in the same region
            l_suppkey = s_suppkey AND
            s_nationkey = n2.n_nationkey AND
            n2.n_regionkey = r_regionkey
        group by r_name
        )
    );
