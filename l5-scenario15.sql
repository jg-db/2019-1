select xo.order_number, xl.line_number, xa.address_name, xc.customer_name, xi.name, xw.warehouse_name
from xx_orders xo,
     xx_order_lines xl,
     xx_address xa,
     xx_customers xc,
     xx_items xi,
     xx_warehouse xw
where xo.order_id = xl.order_id 
  and xo.customer_id = xc.customer_id
  and xc.address_id = xa.address_id
  and xl.item_id = xi.item_id
  and xo.warehouse_id = xw.warehouse_id;