1.
select customer_id, count(*)
from xx_orders
group by customer_id
order by customer_id asc;

2.
select customer_id, count(*)
from xx_orders
having count(*) >=2
group by customer_id;

3.
select customer_id, sum(total_amount)
from xx_orders
group by customer_id
order by customer_id asc;