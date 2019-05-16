-- Step1: creating global temporary table

create global temporary table xx_global_temp
(username VARCHAR2(20), age NUMBER
);

--Step2: insert a record
insert into xx_global_temp
values ('User1', 30);

--Step3: check that record is available in GTT
select *
from xx_global_temp;

--Step4: commit transaction
COMMIT;

--Step5: check that GTT is empty
select *
from xx_global_temp;