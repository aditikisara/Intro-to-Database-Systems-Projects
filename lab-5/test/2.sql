/*
How many suppliers in every region have less balance in their 
account than the average account balance of their own region?
*/

select
    R1.r_name,
    count(S1.s_name)
from
    supplier S1,
    nation N1,
    region R1,
    (select
        r_name,
        avg(s_acctbal) as average
    from
        supplier,
        nation,
        region
    where
        s_nationkey = n_nationkey
        and n_regionkey = r_regionkey
    group by r_name
    ) SQ1
where
    S1.s_nationkey = N1.n_nationkey
    and N1.n_regionkey = R1.r_regionkey
    and R1.r_name = SQ1.r_name
    and S1.s_acctbal < SQ1.average
group by R1.r_name;