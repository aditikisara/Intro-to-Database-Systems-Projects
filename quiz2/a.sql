/*
1: What makers produce Laptops cheaper than $2000 with a screen 
larger than 16?
*/

select maker
from Product P, Laptop L
where
    P.model = L.model and
    L.price < '2000' and
    L.screen > 16;

-- 2: What makers produce PCs but do not produce Laptops?

select distinct(maker)
from Product
where
    maker in (select maker from Product where type = 'pc') and
    maker not in (select maker from Product where type = 'laptop');

/*
3: For every maker that sells both PCs and Printers, find the 
combination of PC and Printer that has maximum price. Print the 
maker, the PC model, Printer model, and the combination price (PC 
price + Printer price).
*/

select
    P1.maker,
    PC.model,
    Printer.model,
    max(PC.price + Printer.price) as max_price
from
    Product P1,
    Product P2,
    PC,
    Printer
where
    P1.maker = P2.maker
    and P1.model = PC.model
    and P2.model = Printer.model
group by P1.maker;

--4: What Laptop hd sizes are offered in at least 2 different models?
select hd
from Laptop
group by hd having count(*) >= 2;

/*
5: What PCs are less expensive than all the Laptops? Print the 
model and the price.
*/

select
    PC.model,
    PC.price
from
    Laptop,
    PC
group by PC.model having PC.price < min(Laptop.price);

-- 6: What makers produce at least a Laptop model and at least 2 Printer models?
select distinct(maker)
from Product
where (type = 'laptop') and
    maker in (
        select maker
        from Product
        where type = 'printer'
        group by maker having count(*) >= 2);