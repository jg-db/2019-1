CREATE OR REPLACE FUNCTION xx_warehouse_name(p_org_id NUMBER)
RETURN VARCHAR2
IS

 l_org_name VARCHAR2(150);
BEGIN
    select warehouse_name
    into l_org_name
    from xx_warehouse
    where warehouse_id = p_org_id;
    
    return l_org_name;
END;

select xx_warehouse_name(xo.warehouse_id), xo.*
from xx_orders xo;