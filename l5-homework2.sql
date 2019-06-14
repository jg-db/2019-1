SELECT
    *
FROM
    xx_items xi
WHERE
    2 <= (
        SELECT
            COUNT(xa.warehouse_id)
        FROM
            xx_availability xa
        WHERE
            xa.item_id = xi.item_id
    )
ORDER BY xi.item_id;