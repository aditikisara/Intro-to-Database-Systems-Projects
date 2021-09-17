SELECT
    l_receiptdate,
    count(l_receiptdate)
FROM
    lineitem,
    customer
WHERE
    c_custkey = '000000010' AND
    l_receiptdate LIKE '1993-%'
GROUP BY
    l_receiptdate;