1.
SELECT
    xi.item_id,
    xi.name,
    xa.quantity,
    nvl(SUM(xol.quantity), 0)
FROM
    xx_items          xi,
    xx_availability   xa,
    xx_warehouse      xw,
    xx_order_lines    xol
WHERE
    xi.item_id = xa.item_id
    AND xw.warehouse_id = xa.warehouse_id
    AND xol.item_id (+) = xi.item_id
    AND xw.warehouse_name = 'Riga Warehouse'
GROUP BY
    xi.item_id,
    xi.name,
    xa.quantity
ORDER by
    xi.item_id;
     
2.     
SELECT
    xi.item_id,
    xi.name,
    NVL((
        SELECT
            xa.quantity
        FROM
            xx_availability   xa,
            xx_warehouse      xw
        WHERE
            xa.item_id = xi.item_id
            AND xw.warehouse_id = xa.warehouse_id
            AND xw.warehouse_name = 'Riga Warehouse'
    ),0) availability,
    nvl(SUM(xol.quantity), 0)
FROM
    xx_items         xi,
    xx_order_lines   xol
WHERE
    xi.item_id = xol.item_id (+)
GROUP BY
    xi.item_id,
    xi.name
ORDER by
    xi.item_id ASC;

3.
SELECT
    xi.item_id,
    xi.name,
    nvl(xa.quantity, 0) avail_in_riga,
    nvl(SUM(xol.quantity), 0) total_amount
FROM
    xx_items          xi,
    xx_availability   xa,
    xx_warehouse      xw,
    xx_order_lines    xol
WHERE
    xi.item_id = xa.item_id (+)
    AND xa.warehouse_id (+) = xw.warehouse_id
    AND upper(xw.warehouse_name) = 'RIGA WAREHOUSE'
    AND xi.item_id = xol.item_id (+)
GROUP BY
    xi.item_id,
    xi.name,
    nvl(xa.quantity, 0)
ORDER BY ITEM_ID;

3.
SELECT
    xi.item_id,
    xi.name,
    nvl(xa.quantity, 0) quantity,
    nvl(SUM(xol.quantity), 0) total_amount
FROM
    xx_items          xi,
    xx_availability   xa,
    xx_warehouse      xw,
    xx_order_lines    xol
WHERE
    xi.item_id = xa.item_id (+)
    AND xa.warehouse_id (+) = xw.warehouse_id
    AND upper(xw.warehouse_name) = 'RIGA WAREHOUSE'
    AND xi.item_id = xol.item_id (+)
GROUP BY
    xi.item_id,
    xi.name,
    nvl(xa.quantity, 0)
ORDER BY ITEM_ID;