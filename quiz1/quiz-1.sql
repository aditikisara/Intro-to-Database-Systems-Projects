-- SQLite
.headers on

--1
select maker
from Printer, Product
where 
    Product.model = Printer.model and
    Printer.color = true and
    Printer.price < 120;

--2
select distinct(maker)
from Product
where
    maker not in (select maker from Product where type = 'laptop') and
    maker not in (select maker from Product where type = 'printer');

--3
select
    distinct maker,
    PC.model as pc_model,
    Laptop.model as laptop_model,
    max(PC.price + Laptop.price) as max_price
from
    Product,
    PC,
    Laptop
where
    exists
        (select model, max_price
        from PC)
    and exists
        (select model
        from Laptop)
    and maker not in (select maker from Product where type = 'printer')
group by maker;

--4
select screen
from Laptop
group by screen having count(*) >= 2;

--5
select
    Laptop.model as l_model,
    Laptop.price as l_price
from
    Laptop,
    PC
group by l_model
having l_price > MAX(PC.price);

--6
select distinct(maker)
from Product
where (type = 'pc' or 'laptop') and
    maker in (
        select maker
        from Product
        where type = 'printer'
        group by maker having count(*) >= 2);