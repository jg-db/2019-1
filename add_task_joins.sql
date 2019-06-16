1. SELECT address_name and customer_name from xx_address and xx_customers using join by address_id

select xa.customer_name, xa.address_name
from xx_address xa,
     xx_customers xc
where xa.address_id = xc.address_id;

2. SELECT order_number and line_number from xx_orders and xx_order_lines using join by order_id. Order by order_id

select xo.order_number, xol.line_number
from xx_orders xo,
     xx_order_lines xol
where xo.order_id = xol.order_id
order by xo.order_id;

3. SELECT warehouse_name, order_number and line_number from xx_warehouse, xx_orders and xx_order_lines using joins by warehouse_id and order_id. Order by warehouse_id

select xw.warehouse_name, xo.order_number, xol.line_number
from xx_warehouse xw,
     xx_orders xo,
     xx_order_lines xol
where xw.warehouse_id = xo.warehouse_id
 and xo.order_id = xol.order_id
order by xo.order_id;