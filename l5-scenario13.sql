1. Add a new DISCOUNT NUMBER column to xx_customers

ALTER table xx_customers 
ADD DISCOUNT number;

2. Update discount, set discount = 20 percents to each customer with at least one SHIPPED order

UPDATE xx_customers xc
set discount = 20
where EXISTS
(
 select 1
 from xx_orders
 where customer_id = xc.customer_id
   and status = 'SHIPPED'
);

3. Set discount = 0 for all other customers

UPDATE xx_customers
set discount = 0
where discount is null;

4. COMMIT changes
COMMIT;

5. Check that update was done correctly
select *
from xx_customers;


6. select all orders and show amounts with discount (if applicable) and without a discount (USING case)

select xc.customer_name, xo.order_number, xo.total_amount,
     CASE 
     WHEN (xc.discount = 0 ) THEN xo.total_amount
     ELSE xo.total_amount * ((100 - xc.discount) / 100) 
     END with_discount,
     xc.discount	
from xx_orders xo,
     xx_customers xc
where xo.customer_id = xc.customer_id;

7. select all orders and show amounts with discount (if applicable) and without a discount (USING DECODE)
select xc.customer_name, xo.order_number, xo.total_amount,
     DECODE(xc.discount,0, xo.total_amount, xo.total_amount * ((100 - xc.discount) / 100)) with_discount,
      xc.discount	
from xx_orders xo,
     xx_customers xc
where xo.customer_id = xc.customer_id;
