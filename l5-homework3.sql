Create SQL query, which returns item name (xx_items) with maximum ordered quantity (xx_order_lines) which have available quantities (xx_availability) in any of warehouses. Should be returned only 1 record 
  

select *
 from (
 select xi.name, sum(xol.quantity)
 from xx_order_lines xol,
      xx_items xi
 where xol.item_id = xi.item_id
 AND  EXISTS
 (select 1
  from xx_availability xa
  where xa.item_id = xi.item_id
 )
  group by xi.name 
 order by sum(xol.quantity) desc)
 where rownum = 1;