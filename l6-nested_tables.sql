1. Create an object:
CREATE OR REPLACE TYPE xx_address_type AS OBJECT
( Street       VARCHAR2(80),
  City         VARCHAR2(80),
  Country        VARCHAR(25),
  Zip          VARCHAR2(10) );

2. Create a type
CREATE OR REPLACE TYPE xx_add_type_tab AS TABLE OF xx_address_type; 

3. Create a table
CREATE TABLE xx_nested_test
(
 id NUMBER,
 customer_name VARCHAR2(200),
 address xx_add_type_tab,
 active_flag VARCHAR2(1)
) NESTED TABLE address STORE AS address_tab;

4. Insert data to our tables
INSERT INTO xx_nested_test 
VALUES (1, 'JavaGuru', xx_add_type_tab(xx_address_type('Brivibas iela', 'Riga', 'Latvia', 'LV-1010')), 'Y');

INSERT INTO xx_nested_test 
VALUES (2, 'JavaGuru 2', xx_add_type_tab(xx_address_type('Tallinas iela', 'Riga', 'Latvia', 'LV-1012')), 'Y');


5. Commit transaction
commit;

6. select everything from xx_nested_test
select *
from xx_nested_test;

7. select nested table columns from xx_nested_test
select t1.id, t2.*
from xx_nested_test t1,
     TABLE(t1.address) t2;

8. update nested table record
UPDATE TABLE 
(SELECT t1.address
 FROM xx_nested_test t1
 WHERE id = 2
) tbl
SET tbl.country = 'Estonia';

9. commit transaction

10. insert into nested table for existing record
INSERT INTO TABLE 
(SELECT t1.address
 FROM xx_nested_test t1
 WHERE id = 2
)
VALUES ('Merkela', 'Riga', 'Finland', 'LV-1050');

11. commit transaction

12. select that insert was done successfully
select t1.id, t2.*
from xx_nested_test t1,
     TABLE(t1.address) t2;

13. delete latest created nested table record
DELETE FROM TABLE
(SELECT t1.address
 FROM xx_nested_test t1
 WHERE id = 2
)
WHERE street = 'Merkela';

14. commit transaction

15. select that delete was done successfully;
select t1.id, t2.*
from xx_nested_test t1,
     TABLE(t1.address) t2;

select *
from dba_nested_tables
where lower(table_name) = 'address_tab';