import sqlite3
from sqlite3 import Error

"""
DROP VIEW V1;
DROP VIEW V2;
DROP VIEW V5;
DROP VIEW V10;
DROP VIEW V151;
DROP VIEW V152;
"""

def openConnection(_dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Open database: ", _dbFile)

    conn = None
    try:
        conn = sqlite3.connect(_dbFile)
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")

    return conn

def closeConnection(_conn, _dbFile):
    print("++++++++++++++++++++++++++++++++++")
    print("Close database: ", _dbFile)

    try:
        _conn.close()
        print("success")
    except Error as e:
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def create_View1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V1")

    """
    Create a view V1(c_custkey, c_name, c_address, c_phone, c_acctbal, c_mktsegment, c_comment, c_nation,
    c_region) that appends the country and region name to every customer. Rewrite Q1 from Lab 4 with
    view V1.
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V1 (c_custkey, c_name, c_address, c_phone, c_acctbal, c_mktsegment, c_comment, c_nation, c_region) AS
            SELECT c_custkey, c_name, c_address, c_phone, c_acctbal, c_mktsegment, c_comment, n_name, r_name
            FROM
                customer,
                nation,
                region
            WHERE
                c_nationkey = n_nationkey and
                n_regionkey = r_regionkey
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def create_View2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V2")

    """
    Create a view V2(s_suppkey, s_name, s_address, s_phone, s_acctbal, s_comment, s_nation, s_region) that
    appends the country and region name to every supplier. 
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V2 (s_suppkey, s_name, s_address, s_phone, s_acctbal, s_comment, s_nation, s_region) AS
        SELECT s_suppkey, s_name, s_address, s_phone, s_acctbal, s_comment, n_name, r_name
        FROM
            supplier,
            nation,
            region
        WHERE
            s_nationkey = n_nationkey and
            n_regionkey = r_regionkey
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def create_View5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V5")

    """
    Create a view V5(o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderyear, o_orderpriority, o_clerk,
    o_shippriority, o_comment) that replaces o_orderdate with the year o_orderyear and contains all the
    other attributes in orders.
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V5 (o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderyear, o_orderpriority, o_clerk, o_shippriority, o_comment) AS
        SELECT o_orderkey, o_custkey, o_orderstatus, o_totalprice, strftime('%Y', o_orderdate), o_orderpriority, o_clerk, o_shippriority, o_comment
        FROM orders
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def create_View10(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V10")

    """
    Create a view V10(p_type, min_discount, max_discount) that computes the minimum and maximum
    discount for every type of part.
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V10 (p_type, min_discount, max_discount) AS
        SELECT p_type, min(l_discount), max(l_discount)
        FROM part, lineitem
        WHERE
            p_partkey = l_partkey
        GROUP BY p_type
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def create_View151(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V151")

    """
    Create a view V151(c_custkey, c_name, c_nationkey, c_acctbal) that contains the customers with positive balance.
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V151 (c_custkey, c_name, c_nationkey, c_acctbal) AS
        SELECT c_custkey, c_name, c_nationkey, c_acctbal
        FROM customer
        WHERE c_acctbal > 0
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def create_View152(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create V152")

    """
    Create a view V152(s_suppkey, s_name, s_nationkey, s_acctbal) that contain the suppliers with negative balance. 
    """

    cur = _conn.cursor()
    sql = ("""
        CREATE VIEW V152 (s_suppkey, s_name, s_nationkey, s_acctbal) AS
        SELECT s_suppkey, s_name, s_nationkey, s_acctbal
        FROM supplier
        WHERE s_acctbal < 0
    """)

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def Q1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q1")

    out = open ("output/1.out", "w")

    """
    --Use V1
    select c_name, sum(o_totalprice)
    from orders, customer, nation
    where o_custkey = c_custkey and
        n_nationkey = c_nationkey and
        n_name = 'FRANCE' AND
        o_orderdate like '1995-__-__'
    group by c_name;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V1.c_name, sum(o_totalprice)
        FROM V1, orders
        WHERE
            V1.c_custkey = o_custkey and
            V1.c_nation = "FRANCE" and
            o_orderdate LIKE '1995%'
        GROUP BY V1.c_name
    """

    cur.execute(sql)
    rows = cur.fetchall()

    for i in rows:
        out.write(str(i[0]) + "|" + str(round(i[1],2)) + '\n')
    
    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q2")

    out = open("output/2.out", "w")

    """
    --Use V2
    select r_name, count(*)
    from supplier, nation, region
    where s_nationkey = n_nationkey
        and n_regionkey = r_regionkey
    group by r_name;
    """

    cur = _conn.cursor()
    sql = ("""
        SELECT V2.s_region, COUNT(*)
        FROM V2
        GROUP BY V2.s_region
    """)

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q3(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q3")

    out = open("output/3.out", "w")

    """
    --Use V1
    select n_name, count(*)
    from orders, nation, region, customer
    where c_custkey = o_custkey
        and c_nationkey = n_nationkey
        and n_regionkey = r_regionkey
        and r_name='AMERICA'
    group by n_name;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V1.c_nation, count(*)
        FROM V1, orders
        WHERE
            V1.c_custkey = o_custkey and
            V1.c_region = 'AMERICA'
        GROUP BY V1.c_nation
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q4")

    out = open("output/4.out", "w")

    """
    --Use V2
    select s_name, count(ps_partkey)
    from partsupp, supplier, nation, part
    where p_partkey = ps_partkey
        and ps_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'CANADA'
        and p_size < 20
    group by s_name;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V2.s_name, count(ps_partkey)
        FROM V2, partsupp, part
        WHERE
            V2.s_suppkey = ps_suppkey and
            ps_partkey = p_partkey and
            V2.s_nation = 'CANADA' and
            p_size < 20
        GROUP BY V2.s_name
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q5")

    out = open("output/5.out", "w")

    """
    --Use V1 and V5
    select c_name, count(*)
    from orders, customer, nation
    where o_custkey = c_custkey
        and c_nationkey = n_nationkey
        and n_name = 'GERMANY'
        and o_orderdate like '1993-__-__'
    group by c_name;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V1.c_name, count(*)
        FROM V1, V5
        WHERE
            V1.c_custkey = V5.o_custkey and
            V1.c_nation = 'GERMANY' and
            V5.o_orderyear LIKE '%1993'
        GROUP BY V1.c_name
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q6(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q6")

    out = open("output/6.out", "w")

    """
    --Use V5
    select s_name, o_orderpriority, count(distinct ps_partkey)
    from partsupp, orders, lineitem, supplier, nation
    where l_orderkey = o_orderkey
        and l_partkey = ps_partkey
        and l_suppkey = ps_suppkey
        and ps_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'CANADA'
    group by s_name, o_orderpriority;
    """

    cur = _conn.cursor()
    sql = """
        SELECT s_name, V5.o_orderpriority, count(distinct(ps_partkey))
        FROM V5, supplier, partsupp, lineitem, nation
        WHERE
            l_orderkey = V5.o_orderkey and
            l_partkey = ps_partkey and
            l_suppkey = ps_suppkey and
            ps_suppkey = s_suppkey and
            s_nationkey = n_nationkey and
            n_name = 'CANADA'
        GROUP BY s_name, V5.o_orderpriority
    """
    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q7(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q7")

    out = open("output/7.out", "w")

    """
    --Use V1 and V5
    select n_name, o_orderstatus, count(*)
    from orders, customer, nation, region
    where o_custkey = c_custkey
        and c_nationkey = n_nationkey
        and n_regionkey = r_regionkey
        and r_name='AMERICA'
    group by n_name, o_orderstatus;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V1.c_nation, V5.o_orderstatus, count(*)
        FROM V1, V5
        WHERE
            V1.c_custkey = V5.o_custkey and
            V1.c_region = 'AMERICA'
        GROUP BY V1.c_nation, V5.o_orderstatus
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q8(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q8")

    out = open("output/8.out", "w")

    """
    --Use V2 and V5
    select n_name, count(distinct l_orderkey) as co
    from orders, nation, supplier, lineitem
    where o_orderkey = l_orderkey
        and l_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and o_orderstatus = 'F'
        and o_orderdate like '1995-__-__'
    group by n_name
    having co > 50;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V2.s_nation, count(distinct(l_orderkey)) as co
        FROM V2, V5, lineitem
        WHERE
            V5.o_orderkey = l_orderkey and
            l_suppkey = V2.s_suppkey and
            V5.o_orderstatus = 'F' and
            V5.o_orderyear LIKE '%1995'
        GROUP BY V2.s_nation HAVING co > 50
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q9(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q9")

    out = open("output/9.out", "w")

    """
    --Use V2 and V5
    select count(distinct o_clerk)
    from orders, supplier, nation, lineitem
    where o_orderkey = l_orderkey
        and l_suppkey = s_suppkey
        and s_nationkey = n_nationkey
        and n_name = 'UNITED STATES';
    """

    cur = _conn.cursor()
    sql = """
        SELECT count(distinct(V5.o_clerk))
        FROM V2, V5, lineitem
        WHERE
            V5.o_orderkey = l_orderkey and
            l_suppkey = V2.s_suppkey and
            V2.s_nation = 'UNITED STATES'
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q10(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q10")

    out = open("output/10.out", "w")

    """
    --Use V10
    select p_type, min(l_discount), max(l_discount)
    from lineitem, part
    where l_partkey = p_partkey
        and p_type like '%ECONOMY%'
        and p_type like '%COPPER%'
    group by p_type;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V10.p_type, V10.min_discount, V10.max_discount
        FROM V10
        WHERE
            V10.p_type LIKE '%ECONOMY%' and
            V10.p_type LIKE '%COPPER%'
        GROUP BY V10.p_type
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q11(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q11")

    out = open("output/11.out", "w")

    """
    --Use V2
    select r.r_name, s.s_name, s.s_acctbal
    from supplier s, nation n, region r
    where s.s_nationkey = n.n_nationkey
            and n.n_regionkey = r.r_regionkey
            and s.s_acctbal = (select max(s1.s_acctbal)
                                from supplier s1, nation n1, region r1
                                where s1.s_nationkey = n1.n_nationkey
                                    and n1.n_regionkey = r1.r_regionkey
                                    and r.r_regionkey = r1.r_regionkey
                            );

    """

    cur = _conn.cursor()
    sql = """
        SELECT s.s_region, s.s_name, s.s_acctbal
        FROM V2 s
        WHERE s.s_acctbal = (
            SELECT max(s1.s_acctbal)
            FROM V2 s1
            WHERE
                s.s_region = s1.s_region
        )
        GROUP BY s.s_region
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q12(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q12")

    out = open("output/12.out", "w")

    """
    --Use V2
    select n_name, max(s_acctbal) as mb
    from supplier, nation
    where s_nationkey = n_nationkey
    group by n_name
    having mb > 9000;
    """

    cur = _conn.cursor()
    sql = """
        SELECT s_nation, max(s_acctbal) as mb
        FROM V2
        GROUP BY s_nation HAVING mb > 9000
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q13(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q13")

    out = open("output/13.out", "w")

    """
    --Use V1 and V2
    select count(*)
    from orders, lineitem, customer, supplier, nation n1, region, nation n2
    where o_orderkey = l_orderkey
        and o_custkey = c_custkey
        and l_suppkey = s_suppkey
        and s_nationkey = n1.n_nationkey
        and n1.n_regionkey = r_regionkey
        and c_nationkey = n2.n_nationkey
        and r_name = 'AFRICA'
        and n2.n_name = 'UNITED STATES';
    """
    
    cur = _conn.cursor()
    sql = """
        SELECT count(*)
        FROM V1, V2, lineitem, orders
        WHERE
            o_orderkey = l_orderkey and
            o_custkey = V1.c_custkey and
            l_suppkey = V2.s_suppkey and
            V1.c_nation = 'UNITED STATES' and
            V2.s_region = 'AFRICA'
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q14(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q14")

    out = open("output/14.out", "w")

    """
    --Use V1 and V2
    select r1.r_name as suppRegion, r2.r_name as custRegion, max(o_totalprice)
    from lineitem, supplier, orders, customer, nation n1, region r1, nation n2, region r2
    where l_suppkey = s_suppkey
        and s_nationkey = n1.n_nationkey
        and n1.n_regionkey = r1.r_regionkey
        and l_orderkey = o_orderkey
        and o_custkey = c_custkey
        and c_nationkey = n2.n_nationkey
        and n2.n_regionkey = r2.r_regionkey
    group by r1.r_name, r2.r_name;
    """

    cur = _conn.cursor()
    sql = """
        SELECT V2.s_region, V1.c_region, max(o_totalprice)
        FROM V1, V2, orders, lineitem
        WHERE
            l_suppkey = V2.s_suppkey and
            l_orderkey = o_orderkey and
            o_custkey = V1.c_custkey
        GROUP BY V2.s_region, V1.c_region
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + "|" + str(i[1]) + "|" + str(i[2]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def Q15(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q15")

    out = open("output/15.out", "w")

    """
    --Use V151 and V152
    select count(distinct l_orderkey)
    from lineitem, supplier, orders, customer
    where l_suppkey = s_suppkey
        and l_orderkey = o_orderkey
        and o_custkey = c_custkey
        and c_acctbal > 0
        and s_acctbal < 0;
    """

    cur = _conn.cursor()
    sql = """
        SELECT count(distinct(l_orderkey))
        FROM lineitem, V151, V152, orders
        WHERE
            l_suppkey = V152.s_suppkey and
            l_orderkey = o_orderkey and
            o_custkey = V151.c_custkey and
            V151.c_acctbal > 0 and
            V152.s_acctbal < 0
    """

    cur.execute(sql)

    rows = cur.fetchall()
    for i in rows:
        out.write(str(i[0]) + '\n')

    out.close()

    print("++++++++++++++++++++++++++++++++++")


def main():
    database = r"tpch.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        create_View1(conn)
        Q1(conn)

        create_View2(conn)
        Q2(conn)

        Q3(conn)
        Q4(conn)

        create_View5(conn)
        Q5(conn)

        Q6(conn)
        Q7(conn)
        Q8(conn)
        Q9(conn)

        create_View10(conn)
        Q10(conn)

        Q11(conn)
        Q12(conn)
        Q13(conn)
        Q14(conn)

        create_View151(conn)
        create_View152(conn)
        Q15(conn)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
