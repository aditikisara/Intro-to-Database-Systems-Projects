SELECT
    strftime('%Y-%m', l_receiptdate),
    count(*)
FROM
    lineitem,
    orders,
    customer
WHERE
    l_orderkey = o_orderkey
    and o_custkey = c_custkey
    and c_custkey = '000000010'
    and l_receiptdate between '1993-01-01' and '1994-01'
GROUP BY strftime('%Y-%m', l_receiptdate);