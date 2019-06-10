1.
select xc.customer_name, xo.order_number, xw.warehouse_name 
from xx_customers xc,
     xx_orders xo,
     xx_warehouse xw
where xo.customer_id(+) = xc.customer_id
 and  xo.warehouse_id = xw.warehouse_id(+)
order by xc.customer_name;

2.
select xc.customer_name, xo.order_number, xw.warehouse_name
from xx_orders xo
RIGHT JOIN xx_customers xc ON (xc.customer_id = xo.customer_id)
LEFT JOIN xx_warehouse xw ON (xo.warehouse_id = xw.warehouse_id)
ORDER BY xc.customer_name;