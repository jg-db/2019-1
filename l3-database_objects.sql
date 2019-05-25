Step 1: Create table in WORKING schema
create table xx_cars 
(id NUMBER primary key,  manufacturer VARCHAR2(75), model VARCHAR2(75), issue_year NUMBER, availability_flag VARCHAR2(1));
/ 

Step 2: Create s xx_cars_seq sequence to store ID value
create sequence xx_cars_seq
MINVALUE 1
MAXVALUE 999999999
START WITH 1
INCREMENT BY 1
CYCLE;
/

Step 3: test sequence with currval and nextval
select xx_cars_seq.nextval
from dual;

select xx_cars_seq.currval
from dual;

Step 4: create before update trigger with automatic ID value population and default availability_flag setting to 'Y'
CREATE OR REPLACE TRIGGER xx_cars_bi
BEFORE INSERT ON xx_cars
FOR EACH ROW
DECLARE

BEGIN
   select xx_cars_seq.nextval
   into :NEW.ID
   from dual;

   :NEW.AVAILABILITY_FLAG := 'Y';

END;

Step 5: Test trigger execution by inserting new records to xx_cars
insert into xx_cars (manufacturer, model, issue_year)
values ('BMW', 'X5', '2019');

insert into xx_cars (manufacturer, model, issue_year)
values ('Toyota', 'RAV4', '2019');

insert into xx_cars (manufacturer, model, issue_year)
values ('KIA', 'Sportage', '2019');

Step 6: Commit transaction
COMMIT;

Step 7: Check that trigger worked successfully 
select *
from xx_cars;

Step 8: Login to SYSTEM schema and try to select records from xx_cars
ORA-00942: table or view does not exist

Step 9: Get back to WORKING schema and grant xx_cars reading rights to xx_cars
GRANT SELECT ON xx_cars to SYSTEM;

Step 10: run a select statement of xx_cars in SYSTEM schema without providing schema prefix
select *
from xx_cars;
ORA-00942: table or view does not exist

Step 11: ... and now with prefix
select *
from working.xx_cars;
-- 3 records received

Step 12: Create a synonym of xx_cars in SYSTEM schema
CREATE OR REPLACE SYNONYM xx_cars FOR working.xx_cars;

Step 13: Run xx_cars select statement without providing prefix
select *
from xx_cars
-- 3 records received



 