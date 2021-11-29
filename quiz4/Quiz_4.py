import sqlite3
from sqlite3 import Error
from typing import ValuesView


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


def createPriceRange(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Create PriceRange")

    try:
        #Beginning of query
        sql = """
            CREATE VIEW PriceRange (maker, type, minPrice, maxPrice) AS
                -- min and max for pc
                SELECT
                    P.maker,
                    P.type,
                    min(price),
                    max(price)
                FROM
                    Product P,
                    PC
                WHERE
                    P.model = PC.model
                GROUP BY P.maker, P.type

                UNION
                
                -- min and max for printer
                SELECT
                    P.maker,
                    P.type,
                    min(price),
                    max(price)
                FROM
                    Product P,
                    Printer Pr
                WHERE
                    P.model = Pr.model
                GROUP BY P.maker, P.type

                UNION

                -- min and max for laptop
                SELECT
                    P.maker,
                    P.type,
                    min(price),
                    max(price)
                FROM
                    Product P,
                    Laptop L
                WHERE
                    P.model = L.model
                GROUP BY P.maker, P.type
        """

        _conn.execute(sql)
        _conn.commit()
        print("success")

    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def printPriceRange(_conn):
    print("++++++++++++++++++++++++++++++++++")
    print("Print PriceRange")

    try:
        cur = _conn.cursor()
        sql = """
            SELECT *
            FROM PriceRange
            
            -- already ordered by maker and type from CREATE VIEW
        """

        cur.execute(sql)

        l = '{:<10} {:<20} {:>20} {:>20}'
        print(l.format("maker", "product", "minPrice", "maxPrice"))
        
        tuples = cur.fetchall()
        for i in tuples:
            something = "{:<10} {:<20} {:>20} {:>20}"
            m = something.format(i[0], i[1], i[2], i[3])
            print(m)

    except Error as e:
        _conn.rollback()
        print(e)

    print("++++++++++++++++++++++++++++++++++")


def insertPC(_conn, _maker, _model, _speed, _ram, _hd, _price):
    print("++++++++++++++++++++++++++++++++++")

    #The main function already reads the input file and parses it

    sql = f"""
        Insert or Replace Into Product (maker, model, type)
        VALUES('{_maker}', {_model}, 'pc')
        """
    _conn.execute(sql)

    sql = f"""
        Insert or Replace Into PC (model, speed, ram, hd, price)
        VALUES({_model}, {_speed}, {_ram}, {_hd}, {_price})
        """
    _conn.execute(sql)
    _conn.commit()
    
    l = 'Insert PC ({}, {}, {}, {}, {}, {})'.format(_maker, _model, _speed, _ram, _hd, _price)
    print(l)

    print("success")

    print("++++++++++++++++++++++++++++++++++")


def updatePrinter(_conn, _model, _price):
    print("++++++++++++++++++++++++++++++++++")
    
    sql = f"""
        UPDATE Printer
        SET price = {_price}
        WHERE model = {_model}
    """
    _conn.execute(sql)
    _conn.commit()

    l = 'Update Printer ({}, {})'.format(_model, _price)
    print(l)

    print("success")

    print("++++++++++++++++++++++++++++++++++")


def deleteLaptop(_conn, _model):
    print("++++++++++++++++++++++++++++++++++")

    sql = f"""
        DELETE FROM Laptop
        WHERE model = {_model}
    """
    _conn.execute(sql)
    _conn.commit()

    l = 'Delete Laptop ({})'.format(_model)
    print(l)

    print("success")

    print("++++++++++++++++++++++++++++++++++")

def main():
    database = r"data.sqlite"

    # create a database connection
    conn = openConnection(database)
    with conn:
        createPriceRange(conn)
        printPriceRange(conn)

        file = open('input.in', 'r')
        lines = file.readlines()
        for line in lines:
            print(line.strip())

            tok = line.strip().split(' ')
            if tok[0] == 'I':
                insertPC(conn, tok[2], tok[3], tok[4], tok[5], tok[6], tok[7])
            elif tok[0] == 'U':
                updatePrinter(conn, tok[2], tok[3])
            elif tok[0] == 'D':
                deleteLaptop(conn, tok[2])

            printPriceRange(conn)

        file.close()

        conn.execute("DROP VIEW PriceRange")

    closeConnection(conn, database)


if __name__ == '__main__':
    main()
