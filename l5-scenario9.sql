1.
select xc.customer_name, xw.warehouse_name, xo.*
from xx_customers xc
INNER JOIN xx_orders xo ON (xc.customer_id = xo.customer_id)
INNER JOIN xx_warehouse xw ON (xw.warehouse_id = xo.warehouse_id);

2.
select xc.customer_name, xw.warehouse_name, xo.*
from xx_customers xc,
     xx_orders xo,
    xx_warehouse xw
where xc.customer_id = xo.customer_id
 and xo.warehouse_id = xw.warehouse_id;

3.
select xo.order_number, xol.*
from xx_orders xo
INNER JOIN xx_order_lines xol ON (xo.order_id = xol.order_id)
where xo.status = 'ORDERED';

4.
select xo.order_number, xol.*
from xx_orders xo,
     xx_order_lines xol
where xo.order_id = xol.order_id
 and xo.status = 'ORDERED';
