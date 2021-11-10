import sqlite3
from sqlite3 import Error


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


def createTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create table")

    try:
        sql = """
                CREATE TABLE warehouse (
                    w_warehousekey decimal(9,0) not null,
                    w_name char(100) not null,
                    w_capacity decimal(6,0) not null,
                    w_suppkey decimal(9,0) not null,
                    w_nationkey decimal(2,0) not null
                )
            """
        
        _conn.execute(sql)
        _conn.commit()
        print("success")
    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def dropTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Drop tables")

    try:
        sql = """DROP TABLE warehouse"""

        _conn.execute(sql)
        _conn.commit()
        print("success")
    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def populateTable(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Populate table")

    try:
        cur = _conn.cursor()
        sql = "SELECT s_suppkey FROM supplier"
        cur.execute(sql)

        supplierkeys = cur.fetchall() # fetches the table from line above
        counter = 1 #keeps track of each duplicate

        for key in supplierkeys:
            #lineitems, supplier, nation, customer, part
            cur.execute(f"""
                SELECT
                    n_nationkey,
                    n_name,
                    s_suppkey,
                    s_name,
                    count (*) as cnt,
                    sum(p_size) as tot
                FROM
                    nation,
                    supplier,
                    part,
                    lineitem,
                    orders,
                    customer
                WHERE
                    n_nationkey = c_nationkey and
                    c_custkey = o_custkey and
                    o_orderkey = l_orderkey and
                    l_partkey = p_partkey and
                    l_suppkey = s_suppkey and
                    s_suppkey = {key[0]}
                GROUP BY n_nationkey
                ORDER BY cnt DESC, n_name
            """
            )
            result = cur.fetchall()
            nationkey1, cname1, suppkey1, sname1, _, _ = result[0]
            nationkey2, cname2, suppkey2, sname2, _, _ = result[1]

            wname1 = f"{sname1}___{cname1}"
            wname2 = f"{sname2}___{cname2}"
            cap = (max([i[-1] for i in result]))*2
            
            cur.execute(f"""INSERT INTO warehouse VALUES ({counter}, "{wname1}", {cap}, {suppkey1}, {nationkey1});""")
            cur.execute(f"""INSERT INTO warehouse VALUES ({counter+1}, "{wname2}", {cap}, {suppkey2}, {nationkey2});""")

            _conn.commit()
            counter += 2
        
        print("success")
    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q1(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q1")

    try:
        cur = _conn.cursor()
        sql = """
            SELECT *
            FROM warehouse
        """
        cur.execute(sql)
        rows = cur.fetchall()

        lines = "{:>3} {:>0} {:>45} {:>10} {:>10}"
        print(lines.format("wId", "wName", "wCap", "sId", "nId"))

        for i in rows:
            m = "{0:3} {1:40} {2:10} {3:10} {4:10}"
            print(m.format(i[0], i[1], i[2], i[3], i[4]))

    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q2(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q2")

    try:
        cur = _conn.cursor()
        sql = """
            SELECT
                n_name,
                COUNT (w_warehousekey) AS cnt,
                SUM(w_capacity) AS total
            FROM
                nation,
                warehouse
            WHERE
                w_nationkey = n_nationkey
            GROUP BY n_name
            ORDER BY cnt DESC, total DESC;
        """

        cur.execute(sql)
        rows = cur.fetchall()

        lines = "{0:21} {1:8} {2:10}"
        print(lines.format("nation", "numW", "totCap"))

        for i in rows:
            m = "{0:20} {1:5} {2:10}"
            print(m.format(i[0], i[1], i[2]))

    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q3(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q3")

    try:
        with open ("input/3.in", "r") as f:
            input = f.readline().strip()
        
        cur = _conn.cursor()

        cur.execute(f"""
            SELECT
                s_name,
                n1.n_name,
                w_name
            FROM
                supplier,
                nation n1,
                nation n2,
                warehouse
            WHERE
                s_nationkey = n1.n_nationkey and
                s_suppkey = w_suppkey and
                w_nationkey = n2.n_nationkey and
                n2.n_name = '{input}'
            GROUP BY s_name
            ORDER BY s_name ASC
        """)

        l = "{0:20} {1:20} {2:15}"
        print(l.format("supplier", "nation", "warehouse"))

        lines = cur.fetchall()
        for i in lines:
            m = "{0:20} {1:20} {2:15}"
            print(m.format(i[0], i[1], i[2]))
        
    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q4(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q4")

    try:
        with open ("input/4.in", "r") as f:
            region = f.readline().strip()
            threshold = f.readline().strip()
        
        cur = _conn.cursor()
        cur.execute(f"""
                    SELECT
                        w_name,
                        w_capacity
                    FROM
                        warehouse,
                        nation,
                        region
                    WHERE
                        w_nationkey = n_nationkey AND
                        n_regionkey = r_regionkey AND
                        r_name = '{region}' AND
                        w_capacity > {threshold}
                    GROUP BY w_name
                    ORDER BY w_capacity DESC
                    """)
        
        l = "{0:36} {1:10}"
        print(l.format("warehouse", "capacity"))

        tuples = cur.fetchall()
        for i in tuples:
            m = "{0:30} {1:10}"
            print(m.format(i[0], i[1]))
    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def Q5(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Q5")

    try:
        with open ("input/4.in", "r") as f:
            region = f.readline().strip()
        
        cur = _conn.cursor()
        cur.execute(f"""
                    """)
        
        temp1 = "{0:10} {1:10}"
        print(temp1.format("region", "capacity"))

        rows = cur.fetchall()
        for row in rows:
            temp2 = "{0:10} {1:10}"
            print(temp2.format(row[0], row[1]))

    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def main():
    database = r"tpch.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        dropTable(conn)
        createTable(conn)
        populateTable(conn)

        Q1(conn)
        Q2(conn)
        Q3(conn)
        Q4(conn)
        Q5(conn)

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
