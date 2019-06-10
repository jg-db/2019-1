1. Add a new ACTIVE_FLAG VARCHAR2(1) column to xx_customers table

ALTER TABLE xx_customers
ADD active_flag VARCHAR2(1);

2. Check that new column ACTIVE_FLAG added to xx_customers and has null value

select *
from xx_customers

3. Update xx_customers.active_flag, set 'Y' if customer has at least one order and 'N' if no orders 

update xx_customers xc
set xc.active_flag = 'Y'
where EXISTS
(
select 1
from xx_orders
where customer_id = xc.customer_id
);

4. COMMIT changes
COMMIT;

5. Check that update was successfully done.