SELECT "1----------";
.headers on
--put your code here

CREATE TABLE Classes (
    class           CHAR(50) NOT NULL,
    type            CHAR(2) NOT NULL,
    country         CHAR(50) NOT NULL,
    numGuns         INTEGER NOT NULL,
    bore            INTEGER NOT NULL,
    displacement    INTEGER NOT NULL
);

CREATE TABLE Ships (
    name            CHAR(50) NOT NULL,
    class           CHAR(50) NOT NULL,
    launched        DATE
);

CREATE TABLE Battles (
    name            CHAR(50) NOT NULL,
    date            DATE
);

CREATE TABLE Outcomes (
    ship            CHAR(50) NOT NULL,
    battle          CHAR(50) NOT NULL,
    result          CHAR(50) NOT NULL
);

.headers off

SELECT "2----------";
.headers on
--put your code here

INSERT INTO Classes VALUES('Bismarck', 'bb', 'Germany', 8, 15, 42000);
INSERT INTO Classes VALUES('Iowa', 'bb', 'USA', 9, 16, 46000);
INSERT INTO Classes VALUES('Kongo', 'bc', 'Japan', 8, 14, 32000);
INSERT INTO Classes VALUES('North Carolina', 'bb', 'USA', 9, 16, 37000);
INSERT INTO Classes VALUES('Renown', 'bc', 'Britain', 6, 15, 32000);
INSERT INTO Classes VALUES('Revenge', 'bb', 'Britain', 8, 15, 29000);
INSERT INTO Classes VALUES('Tennessee', 'bb', 'USA', 12, 14, 32000);
INSERT INTO Classes VALUES('Yamato', 'bb', 'Japan', 9, 18, 65000);

INSERT INTO Ships VALUES('California', 'Tennessee', '1915');
INSERT INTO Ships VALUES('Haruna', 'Kongo', '1915');
INSERT INTO Ships VALUES('Hiei', 'Kongo', '1915');
INSERT INTO Ships VALUES('Iowa', 'Iowa', '1933');
INSERT INTO Ships VALUES('Kirishima', 'Kongo', '1915');
INSERT INTO Ships VALUES('Kongo', 'Kongo', '1913');
INSERT INTO Ships VALUES('Missouri', 'Iowa', '1935');
INSERT INTO Ships VALUES('Mushashi', 'Yamato', '1942');
INSERT INTO Ships VALUES('New Jersey', 'Iowa', '1936');
INSERT INTO Ships VALUES('North Carolina', 'North Carolina', '1941');
INSERT INTO Ships VALUES('Ramillies', 'Revenge', '1917');
INSERT INTO Ships VALUES('Renown', 'Renown', '1916');
INSERT INTO Ships VALUES('Repulse', 'Renown', '1916');
INSERT INTO Ships VALUES('Resolution', 'Revenge', '1916');
INSERT INTO Ships VALUES('Revenge', 'Revenge', '1916');
INSERT INTO Ships VALUES('Royal Oak', 'Revenge', '1916');
INSERT INTO Ships VALUES('Royal Sovereign', 'Revenge', '1916');
INSERT INTO Ships VALUES('Tennessee', 'Tennessee', '1915');
INSERT INTO Ships VALUES('Washington', 'North Carolina', '1941');
INSERT INTO Ships VALUES('Wisconsin', 'Iowa', '1940');
INSERT INTO Ships VALUES('Yamato', 'Yamato', '1941');

INSERT INTO Battles VALUES('Denmark Strait', '1941-05-24');
INSERT INTO Battles VALUES('Guadalcanal', '1942-11-15');
INSERT INTO Battles VALUES('North Cape', '1943-12-26');
INSERT INTO Battles VALUES('Surigao Strait', '1944-10-25');

INSERT INTO Outcomes VALUES('California', 'Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Kirishima', 'Guadalcanal', 'sunk');
INSERT INTO Outcomes VALUES('Resolution', 'Denmark Strait', 'ok');
INSERT INTO Outcomes VALUES('Wisconsin', 'Guadalcanal', 'damaged');
INSERT INTO Outcomes VALUES('Tennessee', 'Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Washington', 'Guadalcanal', 'ok');
INSERT INTO Outcomes VALUES('New Jersey', 'Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Yamato', 'Surigao Strait', 'sunk');
INSERT INTO Outcomes VALUES('Wisconsin', 'Surigao Strait', 'damaged');

.headers off

SELECT "3----------";
.headers on
--put your code here

select
    c.country,
    count(*)
from
    Ships s,
    Classes c
where
    s.class = c.class and
    s.launched between '1930' and '1940';
.headers off

SELECT "4----------";--------------------------------------------
.headers on
--put your code here

INSERT INTO Outcomes(ship, battle, result)
SELECT
    DISTINCT s.name,
    'Denmark Strait',
    'damaged'
FROM
    Outcomes o,
    Ships s
WHERE
    s.launched <= 1920 AND
    s.name NOT IN (
        SELECT o.ship
        FROM Outcomes o
        WHERE o.battle = 'Denmark Strait'
    );

;
.headers off

SELECT "5----------";
.headers on
--put your code here

select c.country, count(o.result)
from
    Outcomes o,
    Classes c,
    Ships s
where
    c.class = s.class and
    s.name = o.ship and
    o.result = 'damaged'
group by c.country;

.headers off

SELECT "6----------";
.headers on
--put your code here

select DISTINCT(c.country)
from
    Classes c,
    Ships s,
    Outcomes o
where
    c.class = s.class and
    s.name = o.ship and
    o.result = 'damaged'
group by c.country having count (*) = (
    select COUNT(*)
    from
        Outcomes o,
        Classes c,
        Ships s
    where
        c.class = s.class and
        s.name = o.ship and
        o.result = 'damaged'
    group by c.country
    order by count(*) asc
    LIMIT 1
    );

.headers off

SELECT "7----------";
.headers on
--put your code here

DELETE FROM Outcomes WHERE
    Outcomes.battle = 'Denmark Strait' and
    Outcomes.ship in (
        select s.name
        from Ships s, Classes c
        where
            s.class = c.class and
            c.country = 'Japan'
    );

.headers off

SELECT "8----------";
.headers on
--put your code here

select s.name
from
    Ships s,
    Outcomes o
where
    s.name = o.ship and
    o.result = 'damaged'
group by o.ship having count(o.ship) > 1;

.headers off

SELECT "9----------";
.headers on
--put your code here

select
    distinct(c1.country),
    count(c1.type),
    count(c2.type)
from
    Classes c1,
    Classes c2
where
    c1.type = 'bb' and
    c2.type = 'bc'
group by c1.country;

.headers off

SELECT "10---------";
.headers on
--put your code here

UPDATE Classes SET numGuns =  numGuns*2 WHERE (
    Classes.class in (
        SELECT s.class
        FROM
            Ships s
        WHERE
            s.launched >= 1940
    )
);

.headers off

SELECT "11---------";
.headers on
--put your code here

SELECT DISTINCT(c.class)
FROM
    Classes c,
    Ships s
WHERE
    c.class = s.class
GROUP BY s.class HAVING count(s.class) = 2;

.headers off

SELECT "12---------";
.headers on
--put your code here

SELECT DISTINCT(s.class)
FROM
    Ships s,
    Classes c,
    Outcomes o
WHERE
    c.class = s.class and
    s.name = o.ship and
    o.ship != 'sunk'
GROUP BY s.class HAVING count(s.class) = 2;

.headers off

SELECT "13---------";
.headers on
--put your code here

DELETE FROM Ships WHERE (
    Ships.name in (
        SELECT o.ship
        FROM 
            Outcomes o
        WHERE
            o.result = 'sunk'
    )
);

.headers off

SELECT "14---------";
.headers on
--put your code here

select c.country, s.name, sum(numGuns)
from
    Ships s,
    Classes c
where
    s.class = c.class
group by c.country, s.name;

.headers off

SELECT "15---------";
.headers on
--put your code here

select
    s.name,
    sum(numGuns)
from
    Ships s,
    Classes c
;
.headers off

SELECT "16---------";
.headers on
--put your code here
;
.headers off

SELECT "17---------";
.headers on
--put your code here
;
.headers off
