/*
Find the total quantity (l quantity) of line items shipped 
per month (l shipdate) in 1995. Hint: check function 
strftime to extract the month/year from a date.
*/
select strftime('%m', l_shipdate), sum(l_quantity)
from lineitem
where
    strftime('%Y', l_shipdate) = '1995'
group by strftime('%m', l_shipdate);