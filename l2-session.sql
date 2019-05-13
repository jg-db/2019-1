// Check all sessions currently established for SYSTEM user/schema
select *
from v$session
where username = 'SYSTEM';

ALTER SYSTEM KILL SESSION 'sid,serial#';
// Do not kill session you are working from :)