select customer_id, LISTAGG(order_number, ',') WITHIN GROUP (order by order_number)
from xx_orders xo
group by customer_id;

select LISTAGG(warehouse_name, ', ') WITHIN GROUP (ORDER BY warehouse_name)
from xx_warehouse
where warehouse_id in
( select warehouse_id
  from xx_orders
);