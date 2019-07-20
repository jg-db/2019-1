BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'Generate_Order_XML',
    job_type        => 'STORED_PROCEDURE',
    job_action      => 'XX_ORDERS_PKG.MAIN',
    start_date      => SYSTIMESTAMP,
    repeat_interval => 'freq=minutely; interval=5',
    end_date        => NULL,
    enabled         => TRUE,
    comments        => 'Job to generate XML files');
END;

EXEC dbms_scheduler.run_job('Generate_Order_XML');

SELECT owner, job_name, job_type, job_action, start_date, repeat_interval, state, last_start_date, next_run_date  
FROM dba_scheduler_jobs 
WHERE lower(job_name) = lower('Generate_Order_XML');

EXEC DBMS_SCHEDULER.DROP_JOB('generate_order_xml');
