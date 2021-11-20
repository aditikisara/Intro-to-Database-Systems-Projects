.eqp on
.timer on
.output out.res.index

-- 1
CREATE INDEX customer_idx_c_name ON customer(c_name);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select c_address, c_phone, c_acctbal
from customer
where c_name='Customer#000000010'; */

--2
CREATE INDEX supplier_idx_s_nationkey_s_acctbal ON supplier(s_acctbal);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select min(s_acctbal)
from supplier; */

--3
CREATE INDEX lineitem_idx_l_returnflag_l_receiptdate ON lineitem(l_returnflag, l_receiptdate);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select l_receiptdate, l_returnflag, l_extendedprice, l_tax
from lineitem
where l_returnflag = 'R' and l_receiptdate = '1993-08-22'; */

--4 -------------------------------------------------------------

/* 
.eqp on
.timer on
.output out.res.index

.expert
select count(*)
from lineitem
where l_shipdate < l_commitdate; */
-----------------------------------------------------------------

--5
CREATE INDEX customer_ixd_c_mktsegment ON customer(c_mktsegment);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select c_mktsegment, min(c_acctbal) as min, max(c_acctbal) as max, sum(c_acctbal) as total
from customer
group by c_mktsegment; */

--6
CREATE INDEX customer_idx_c_custkey ON customer(c_custkey);
CREATE INDEX nation_idx_n_nationkey_n_name ON nation(n_nationkey, n_name);
CREATE INDEX orders_idx_o_orderdate ON orders(o_orderdate, o_orderdate);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select distinct n_name
from customer, nation, orders
where
    c_nationkey=n_nationkey 
    and c_custkey=o_custkey
    and o_orderdate>='1996-09-10' 
    and o_orderdate<='1996-09-12'
order by n_name; */

--7
CREATE INDEX lineitem_idx_l_orderkey_l_suppkey ON lineitem(l_orderkey);
CREATE INDEX orders_idx_o_custkey_o_orderkey ON orders(o_custkey, o_orderkey);
CREATE INDEX customer_idx_c_name_c_custkey ON customer(c_name, c_custkey);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select substr(o_orderdate, 1, 4) as year, count(*)
from orders, nation, supplier, lineitem
where l_orderkey = o_orderkey
    and l_suppkey = s_suppkey
    and n_nationkey = s_nationkey
    and o_orderpriority='3-MEDIUM'
    and n_name = 'CANADA'
group by year; */

--8
CREATE INDEX supplier_idx_s_nationkey_s_acctbal ON supplier(s_nationkey,s_acctbal);
CREATE INDEX nation_idx_n_regionkey_n_nationkey ON nation(n_regionkey, n_nationkey);
CREATE INDEX region_idx_r_name_r_regionkey ON region(r_name, r_regionkey);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select s_name, s_acctbal
from supplier, nation, region
where 
    n_regionkey=r_regionkey 
    and s_nationkey=n_nationkey
    and r_name='AMERICA' 
    and s_acctbal>5000; */

--9
CREATE INDEX supplier_idx_s_nationkey_s_acctbal ON supplier(s_nationkey, s_acctbal);
CREATE INDEX nation_idx_n_name ON nation(n_name);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select n_name, count(*) as cnt, max(s_acctbal)
from supplier, nation 
where s_nationkey = n_nationkey
group by n_name
having cnt > 5; */

--10
CREATE INDEX orders_idx_o_custkey_o_orderdate ON orders(o_custkey, o_orderdate);
CREATE INDEX customer_idx_c_nationkey_c_custkey ON customer(c_nationkey, c_custkey);
CREATE INDEX nation_idx_n_regionkey_n_nationkey ON nation(n_regionkey, n_nationkey);
CREATE INDEX region_idx_r_name_r_regionkey ON region(r_name, r_regionkey);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select sum(o_totalprice)
from orders, customer, nation, region
where o_custkey=c_custkey and
    c_nationkey=n_nationkey and
    r_regionkey=n_regionkey and
    r_name='AMERICA' and
    o_orderdate>='1996-01-01' and
    o_orderdate<='1996-12-31'; */

--11
CREATE INDEX orders_idx_o_orderkey ON orders(o_orderkey);
CREATE INDEX lineitem_idx_l_discount ON lineitem(l_discount);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select count(distinct o_custkey)
from lineitem, orders
where 
    l_orderkey = o_orderkey 
    and l_discount >= 0.1; */

--12
CREATE INDEX orders_idx_o_orderstatus ON orders(o_orderstatus);
CREATE INDEX customer_idx_c_custkey ON customer(c_custkey);
CREATE INDEX nation_idx_n_nationkey_n_name ON nation(n_nationkey);
CREATE INDEX region_idx_r_regionkey_r_name ON region(r_regionkey, r_name);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select r_name, count(*) as cnt_ord
from orders, customer, nation, region
where o_custkey=c_custkey
    and c_nationkey=n_nationkey
    and n_regionkey=r_regionkey
    and o_orderstatus='F'
group by r_name; */

--13 -------------------------------------------------------------
/* 
.eqp on
.timer on
.output out.res.index

.expert
select sum(c_acctbal)
from customer, region, nation
where 
    c_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = 'EUROPE'
    and c_mktsegment = 'MACHINERY'; */
-----------------------------------------------------------------

--14
CREATE INDEX orders_idx_o_orderpriority_o_orderdate ON orders(o_orderpriority, o_orderdate, o_orderdate);
CREATE INDEX nation_idx_n_name ON nation(n_name);
CREATE INDEX customer_idx_c_nationkey_c_custkey ON customer(c_nationkey, c_custkey);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select count(o_orderkey)
from orders, customer, nation
where 
    c_custkey=o_custkey
    and c_nationkey=n_nationkey
    and n_name='BRAZIL'
    and o_orderpriority='1-URGENT'
    and o_orderdate >= '1994-01-01' 
    and o_orderdate <= '1997-12-31'; */

--15
CREATE INDEX orders_idx_o_orderpriority_o_orderkey ON orders(o_orderpriority, o_orderkey);
CREATE INDEX nation_idx_n_name ON nation(n_name);
CREATE INDEX supplier_idx_s_nationkey_s_suppkey ON supplier(s_nationkey, s_suppkey);
CREATE INDEX lineitem_idx_l_orderkey_l_suppkey ON lineitem(l_orderkey, l_suppkey);

/* 
.eqp on
.timer on
.output out.res.index

.expert
select substr(o_orderdate, 1, 4) as year, count(*)
from orders, nation, supplier, lineitem
where 
    l_orderkey = o_orderkey
    and l_suppkey = s_suppkey
    and n_nationkey = s_nationkey
    and o_orderpriority='3-MEDIUM'
    and n_name = 'CANADA'
group by year; */