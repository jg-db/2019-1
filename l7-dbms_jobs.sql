DECLARE
  l_job NUMBER := 0;
BEGIN
  DBMS_JOB.SUBMIT(l_job,'XX_DB_COURSE.GENERATE_XML_FILE_USE_JOB;',sysdate,'trunc(sysdate+5/1440,''MI'')');
END;

SELECT job, what, next_date, next_sec FROM user_jobs;

EXEC dbms_job.run(1);

EXEC DBMS_JOB.REMOVE(1);