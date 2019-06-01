select order_id,
    CASE when total_amount < 100 THEN 'CHEAP'
         when total_amount >100 and total_amount < 400 THEN 'MEDIUM'
         else 'EXPENSIVE'
    END amount_description,
    total_amount
from xx_orders
order by order_id asc;