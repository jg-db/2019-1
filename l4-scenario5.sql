select *
from xx_orders
where status = 'ORDERED'
union all
select *
from xx_orders
where status = 'SHIPPED';