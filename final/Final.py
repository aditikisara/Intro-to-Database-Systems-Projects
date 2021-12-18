import sqlite3
from sqlite3 import Error
from typing import final


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

def T1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T1")
    c = _conn.cursor()
    sql = (""" SELECT count(DISTINCT o_orderkey) 
    FROM orders, supplier, lineitem l1, lineitem l2, part p1, part p2
    WHERE o_orderkey = l1.l_orderkey
    AND o_orderkey = l2.l_orderkey

    AND l1.l_partkey = p1.p_partkey
    AND l2.l_partkey = p2.p_partkey

    AND l1.l_suppkey = s_suppkey 
    AND l2.l_suppkey = s_suppkey 
    AND p1.p_partkey != p2.p_partkey;

    """) 

    content = c.fetchall()
    c.execute(sql)
    ##_conn.execute(sql)

    with open("output/1.out", "w") as file:
        header = "{:>10}\n".format("orders")
        file.write(header)
        for i in content:
            file.write("{:>10}".format(str(i[0])))


    print("++++++++++++++++++++++++++++++++++")

def T1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T1")

    """
    T1 finds the number of orders on which two different parts are provided as separate line items by the
    same supplier. Make sure to count an order only once. As shown in the code, the query result has to
    be written in file output/1.out. 
    """

    cur = _conn.cursor()
    sql = ("""
        SELECT COUNT(DISTINCT(o_orderkey))
        FROM
            orders,
            lineitem l1,
            lineitem l2,
            supplier,
            part p1,
            part p2
        WHERE
            o_orderkey = l1.l_orderkey AND
            o_orderkey = l2.l_orderkey AND
            l1.l_partkey = p1.p_partkey AND
            l2.l_partkey = p2.p_partkey AND
            l1.l_suppkey = s_suppkey AND
            l2.l_suppkey = s_suppkey AND
            p1.p_partkey != p2.p_partkey
    """)

    cur.execute(sql)
    content = cur.fetchall()

    with open("output/1.out", "w") as file:
        header = "{:>10}\n".format("orders")
        file.write(header)
        for i in content:
            file.write("{:>10}".format(str(i[0])))

    print("++++++++++++++++++++++++++++++++++")


def T2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T2")
    
    """
    T2 finds the orders on which at least two line items are provided by the same supplier. Group the
    orders by the nation of the supplier and compute the number of distinct orders per supplier nation.
    As shown in the code, the query result has to be written in file output/2.out.
    """

    cur = _conn.cursor()
    sql = ("""
        SELECT
            n_name,
            COUNT(DISTINCT(o_orderkey))
        FROM
            nation,
            orders,
            lineitem,
            supplier
        WHERE
            o_orderkey = l_orderkey AND
            l_suppkey = s_suppkey AND
            s_nationkey = n_nationkey
        GROUP BY n_name HAVING COUNT(l_partkey) >= 2
        """)
    
    cur.execute(sql)
    content = cur.fetchall()
    
    with open("output/2.out", "w") as file:
        header = "{:<40} {:>10}\n".format("nation", "orders")
        file.write(header)
        for i in content:
            file.write("{:<40} {:>10}".format(str(i[0]), str(i[1]) + '\n'))

    cur.execute(sql)

    print("++++++++++++++++++++++++++++++++++")


def T3(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T3")

    with open("input/3.in", "r") as file:
        k = int(file.readline().strip())
    
    """
    T3 finds the orders on which k line items are provided by the same supplier. k is an argument read from
    the input file input/3.in. Group the orders by the nation of the supplier and compute the number
    of distinct orders per supplier nation. As shown in the code, the query result has to be written in file
    output/3.out.
    """

    cur = _conn.cursor()

    sql = (f"""
        SELECT
            n_name,
            COUNT(DISTINCT(o_orderkey))
        FROM
            lineitem,
            supplier,
            nation,
            orders
        WHERE
            o_orderkey = l_orderkey AND
            l_suppkey = s_suppkey AND
            s_nationkey = n_nationkey
        GROUP BY n_name HAVING COUNT(l_orderkey = {k})
    """)

    cur.execute(sql)
    content = cur.fetchall()

    with open("output/3.out", "w") as file:
        header = "{:<40} {:>10}\n".format("nation", "orders")
        file.write(header)
        for i in content:
            file.write("{:<40} {:>10}".format(str(i[0]), str(i[1]) + '\n'))

    print("++++++++++++++++++++++++++++++++++")


def T4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T4")
    
    """
    T4 creates a materialized view RegionItems(supReg, custReg, itemNo) that stores the number of
    line items supplied by suppliers in supReg on orders made by customers in custReg. supReg and
    custReg are the names of the regions as stored in r name. RegionItems stores the number of line
    items for every two regions in the database. The output generated by T4 consists of all the tuples in
    RegionItems. As shown in the code, the query result has to be written in file output/4.out.
    """

    cur = _conn.cursor()
    view = ("""
        CREATE VIEW RegionItems(supReg, custReg, itemNo) AS
        SELECT
            rs.r_name,
            rc.r_name,
            COUNT(l_linenumber)
        FROM
            lineitem,
            orders,
            nation ns,
            nation nc,
            region rs,
            region rc,
            supplier,
            customer
        WHERE
            o_custkey = c_custkey AND
            c_nationkey = nc.n_nationkey AND
            nc.n_regionkey = rc.r_regionkey AND
            l_orderkey = o_orderkey AND
            l_suppkey = s_suppkey AND
            s_nationkey = ns.n_nationkey AND
            ns.n_regionkey = rs.r_regionkey
        GROUP BY rs.r_name, rc.r_name
    """)

    _conn.commit()
    cur.execute(view)

    sql = ("""
        SELECT *
        FROM RegionItems
    """)

    cur.execute(sql)
    content = cur.fetchall()

    with open("output/4.out", "w") as file:
        header = "{:<40} {:<40} {:>10}\n".format("supReg", "custReg", "items")
        file.write(header)
        for i in content:
            file.write("{:<40} {:<40} {:>10}".format(str(i[0]), str(i[1]), str(i[2]) + '\n'))

    print("++++++++++++++++++++++++++++++++++")


def T5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T5")

    with open("input/5.in", "r") as file:
        nation = file.readline().strip()
    
    """
    T5 deletes the line items supplied by suppliers from nation nat, where nat is read from the input file
    input/5.in. The content of the materialized view RegionItems has to be updated accordingly. The
    output generated by T5 consists of all the tuples in the updated RegionItems. As shown in the code,
    the query result has to be written in file output/5.out.
    """

    cur = _conn.cursor()
    statement = (f"""
        DELETE FROM lineitem WHERE l_suppkey IN (
            SELECT l_suppkey
            FROM
                lineitem,
                supplier,
                nation
            WHERE
                l_suppkey = s_suppkey AND
                s_nationkey = n_nationkey AND
                n_name = '{nation}'
        )
    """)

    cur.execute(statement)

    sql = ("""
        SELECT *
        FROM RegionItems;
    """)

    cur.execute(sql)
    content = cur.fetchall()

    with open("output/5.out", "w") as file:
        header = "{:<40} {:<40} {:>10}\n".format("supReg", "custReg", "items")
        file.write(header)
        for i in content:
            file.write("{:<40} {:<40} {:>10}".format(str(i[0]), str(i[1]), str(i[2]) + '\n'))

    print("++++++++++++++++++++++++++++++++++")


def T6(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("T6")

    with open("input/6.in", "r") as file:
        oldNation = file.readline().strip()
        newNation = file.readline().strip()
    
    """
    T6 updates the nation of all the customers from nation nat 1 to nation nat 2, where nat 1 and nat 2
    are read from the input file input/6.in. The content of the materialized view RegionItems has to be
    updated accordingly. The output generated by T6 consists of all the tuples in the updated RegionItems.
    As shown in the code, the query result has to be written in file output/6.out.
    """

    cur = _conn.cursor()
    statement = (f"""
        UPDATE customer
        SET c_nationkey = (
            SELECT c_nationkey
            FROM
                customer,
                nation
            WHERE
                c_nationkey = n_nationkey AND
                n_name = '{newNation}'
        )
        WHERE (
            c_nationkey = (
                SELECT c_nationkey
                FROM
                    customer,
                    nation
                WHERE
                    c_nationkey = n_nationkey AND
                    n_name = '{oldNation}'
            )   
        )
    """)
    
    cur.execute(statement)

    sql = ("""
        SELECT *
        FROM RegionItems
    """)

    cur.execute(sql)
    content = cur.fetchall()

    with open("output/6.out", "w") as file:
        header = "{:<40} {:<40} {:>10}\n".format("supReg", "custReg", "items")
        file.write(header)
        for i in content:
            file.write("{:<40} {:<40} {:>10}".format(str(i[0]), str(i[1]), str(i[2]) + '\n'))

    print("++++++++++++++++++++++++++++++++++")


def main():
    database = r"tpch.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        T1(conn)
        T2(conn)
        T3(conn)
        T4(conn)
        T5(conn)
        T6(conn)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
