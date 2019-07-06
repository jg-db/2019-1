1. Explain plain could be run from a IDE GUI or using below SQL statements:
EXPLAIN PLAN FOR
SELECT * FROM XX_INDEX_CUST_1
where LOWER(first_name) like 'fi%60%'
    and LOWER(last_name) like 'fi%60%';
  
SELECT
    PLAN_TABLE_OUTPUT
FROM
    TABLE(DBMS_XPLAN.DISPLAY());


1. Create a new table
CREATE TABLE XX_INDEX_CUST_1
(CUSTOMER_ID NUMBER, CUSTOMER_NAME VARCHAR2(100), EMAIL VARCHAR2(100), ENABLED_FLAG VARCHAR2(1), FIRST_NAME VARCHAR2(100), LAST_NAME VARCHAR2(100));

2. Run a script to fill table data
declare
 CUSTOMER_ID NUMBER :=1;
 CUSTOMER_NAME VARCHAR2(100):='ORDER NUMBER';
 EMAIL VARCHAR2(100):='DESCRIPTION';
 ENABLED_FLAG VARCHAR2(1);
 FIRST_NAME VARCHAR2(100);
 LAST_NAME VARCHAR2(100);
begin
    FOR i in 1..100000 LOOP
    
        CUSTOMER_ID :=  i;
        CUSTOMER_NAME := i;
        EMAIL := i;
        FIRST_NAME := i;
        LAST_NAME := i;
        
        select CASE 
               WHEN i < 50000 THEN 'Y'
               WHEN i > 50000 THEN 'N'
               END
        into ENABLED_FLAG
        from DUAL;
        
        INSERT INTO XX_INDEX_CUST_1
        VALUES (CUSTOMER_ID, CUSTOMER_NAME, EMAIL, ENABLED_FLAG, FIRST_NAME, LAST_NAME);
    END LOOP;
end;

3. Update fields
UPDATE XX_INDEX_CUST_1
SET CUSTOMER_NAME = 'CUSTOMER NAME_' || CUSTOMER_NAME, EMAIL = 'CUSTOMER_EMAIL_' || EMAIL || '@gmail.com', FIRST_NAME = 'FIRST_NAME_' || FIRST_NAME, LAST_NAME = 'LAST_NAME_' || LAST_NAME;

4. Run a query, measure explain plan cost
select *
from XX_INDEX_CUST_1
where first_name like 'FI%60%' and last_name like 'LA%60%';
cost: 480

5. Create an index
CREATE INDEX xx_index_1 ON XX_INDEX_CUST_1(FIRST_NAME, LAST_NAME);

5. Run a query, measure explain plan cost
cost: 23 (about 95% improvement)

6. Run a query passing only first_name, measure explain plan cost

7. Add a lower function to first_name and last_name, measure explain plan cost
select *
from XX_INDEX_CUST_1
where LOWER(first_name) like 'fi%60%'
    and LOWER(last_name) like 'fi%60%';
cost: 481

8. Create a function based index
CREATE INDEX cust_function_based ON XX_INDEX_CUST_1(LOWER(first_name), LOWER(LAST_NAME));

9. Run a query with lower functions and measure explain plan cost
EXPLAIN PLAN FOR
SELECT * FROM XX_INDEX_CUST_1
where LOWER(first_name) like 'fi%60%'
    and LOWER(last_name) like 'fi%60%';
 
SELECT
    PLAN_TABLE_OUTPUT
FROM
    TABLE(DBMS_XPLAN.DISPLAY());
cost: 23

Bitmap indexes
10. Run a following query and measure explan plan cost
select *
from XX_INDEX_CUST_1
where enabled_flag = 'Y';
cost: 480

11. Create a Bitmap index on enabled_flag
CREATE BITMAP INDEX xx_cust_bitmap
ON XX_INDEX_CUST_1(enabled_flag);

12. Run previous query and measure explain plan cost
select *
from XX_INDEX_CUST_1
where enabled_flag = 'Y';
cost: 169
