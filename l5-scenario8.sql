select *
from xx_customers xc
where NOT EXISTS
(select customer_id 
 from xx_orders
 where customer_id = xc.customer_id 
);
