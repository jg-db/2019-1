1.
select (select customer_name from xx_customers where customer_id = xo.customer_id) customer_name, xo.order_number 
from xx_orders xo;

2.
select *
from xx_customers
where customer_id in 
  ( select customer_id 
    from xx_orders
  );
