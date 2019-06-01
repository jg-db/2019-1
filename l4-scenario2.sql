1.
select *
from xx_orders
where order_id = 1
or (total_amount > 350
 and STATUS NOT IN ('ORDERED', 'CANCELLED'));

2.
select *
from xx_address
where NOT country = 'Latvia';