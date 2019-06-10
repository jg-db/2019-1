select customer_id
from xx_customers
MINUS
select customer_id
from xx_orders;