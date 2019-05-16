-- Step1: creating xx_course table
create table xx_courses(ID NUMBER primary key, course_name VARCHAR2(200), start_date DATE, language_code VARCHAR2(3));

-- Step2: inserting a couple of records with different language
insert into xx_courses
values (1, 'C#', SYSDATE-1, 'US');

insert into xx_courses
values (2, 'Oracle', SYSDATE, 'RU');

-- Step3: COMMIT updates in order to physically save changes in DB
COMMIT;

-- Step4: Creating a view (virtual table based on query statement) in order to show only those records, which corresponds to session language
create or replace view xx_courses_v
(course_name, 
 start_date, 
language_code)
AS
select course_name,
    start_date,
    language_code
from xx_courses
where language_code = userenv('LANG');

-- Step5: checking current session language
select userenv('LANG')
from dual;
-- Return: US

--Step6: checking view. Only US courses should be returned
select *
from xx_courses_v;

--Step7: setting current session language to RU
ALTER SESSION SET NLS_LANGUAGE = 'Russian';

--Step8: checking current session language
select userenv('LANG')
from dual;
-- Return: RU

--Step9: checking view. Only RU courses should be returned
select *
from xx_courses_v;