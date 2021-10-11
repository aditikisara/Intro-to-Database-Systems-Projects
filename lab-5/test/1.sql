select count(c_custkey)
from 
    customer,
    nation,
    region
where
    c_nationkey = n_nationkey and
    n_regionkey = r_regionkey and
    r_name not in (
        select r_name
        from region
        where r_name = 'EUROPE'
    ) and
    r_name not in (
        select r_name
        from region
        where r_name = 'AFRICA'
    ) and
    r_name not in (
        select r_name
        from region
        where r_name = 'ASIA'
    );

