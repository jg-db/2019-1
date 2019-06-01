1.
select *
from xx_orders
where total_amount > 350;

2.
select *
from xx_orders
where status != 'CLOSED';

3.
select *
from xx_address
where address_id BETWEEN 10 and 20;

4.
select *
from xx_customers
where customer_name like '%Corp.';

5.
select *
from xx_orders
where warehouse_id in (1,2);