select
    prod1.maker,
    PC.model as pc_model,
    Laptop.model as laptop_model,
    max(PC.price + Laptop.price) as max_price
from
    Product prod1,
    Product prod2,
    PC,
    Laptop
where
    prod1.maker = prod2.maker
    and prod1.model = pc_model
    and prod2.model = laptop_model
group by prod1.maker;