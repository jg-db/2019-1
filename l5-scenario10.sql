1.
select xc.customer_name, xo.order_number, xw.warehouse_name 
from xx_customers xc,
     xx_orders xo,
     xx_warehouse xw
where xc.customer_id = xo.customer_id(+)
 and  xo.warehouse_id = xw.warehouse_id(+)
order by xc.customer_name;

2.
select xc.customer_name, xo.order_number, xw.warehouse_name
from xx_customers xc
LEFT JOIN xx_orders xo ON (xc.customer_id = xo.customer_id)
LEFT JOIN xx_warehouse xw ON (xo.warehouse_id = xw.warehouse_id)
ORDER BY xc.customer_name;
