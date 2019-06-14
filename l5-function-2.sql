CREATE OR REPLACE FUNCTION xx_check
RETURN NUMBER
IS

BEGIN
    return 1;
END;

select xx_warehouse_name(xo.warehouse_id), xo.*
from xx_orders xo
where 1 = xx_check;