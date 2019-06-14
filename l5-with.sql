1.
WITH warehouses AS
(select warehouse_id, warehouse_name
 from xx_warehouse)
select wr.warehouse_name, xo.*
from xx_orders xo,
     warehouses wr
where wr.warehouse_id = xo.warehouse_id;

2.
WITH availabilities AS
(
select warehouse_id, item_id, quantity
from xx_availability
where quantity > 100
),
warehouses AS
(select warehouse_name, warehouse_id
 from xx_warehouse
)
select xi.name, av.quantity, wr.warehouse_name
from xx_items xi,
    availabilities av,
    warehouses wr
where xi.item_id = av.item_id
 and av.warehouse_id = wr.warehouse_id;

3.
WITH
  function add_fnc(p_id number) return number
  is
  begin
    return p_id * 1000; 
  end;
select add_fnc(address_id), xa.* from xx_address xa;