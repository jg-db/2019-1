-- Commands to be run in IDE
alter session set "_ORACLE_SCRIPT"=true;
create user working identified by working;
grant connect to working
grant connect, resource, dba to working;
grant create session to working;
grant unlimited tablespace to working;
