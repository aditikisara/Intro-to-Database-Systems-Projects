SELECT COUNT(*)
FROM lineitem
WHERE
    l_shipdate < l_commitdate;