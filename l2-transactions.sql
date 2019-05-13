//Test that two transactions run in parallel do not violate data integrity

1. Open session 1 using IDE

//Create xx_balances table
create table xx_balances
(id NUMBER primary key,
 account_number VARCHAR2(200),
 amount NUMBER);

2. Open session 2 using IDE and check that table exists
select *
from xx_balances;

3. Insert data to xx_balances table using session 1
insert into xx_balances
values (1, 'Account A', 500);

insert into xx_balances
values (2, 'Account B', 500);

insert into xx_balances
values (3, 'Account C', 500);

4. Using session 2 check that inserted in step 3. data do not appear because transactions were not COMMITED (PERMANENTLY SAVED)
select *
from xx_balances;
-- 0 rows returned

5. COMMIT (permanently save) transactions using session 1
COMMIT;

6. Using session 2 check that now 3 records are visible
select *
from xx_balances;
-- 3 rows returned

7. Using session 1 run an update statement for 'Account A' and DO NOT COMMIT transaction
update xx_balances
set amount = 400
where account_number = 'Account A';
-- Transaction completed, but not saved

8. Using session 2 run an update statement for same 'Account A' record
update xx_balances
set amount = 300
where account_number = 'Account A';
-- Update is running and do not complete as record is locked by session 1 as there transaction is NOT SAVED

9. Commit (save) transaction using session 1
COMMIT;

10. Once transaction done by session 1 is commited(saved), transaction in session 2 is completed. Commit transaction done by session 2.
COMMIT;

11. Check that data is up to date in both sessions:
select *
from xx_balances;
-- Both sessions should return 300 amount for 'Account A'.
