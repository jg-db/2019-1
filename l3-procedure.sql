CREATE OR REPLACE PROCEDURE xx_first_procedure
IS
 l_hello_stmt VARCHAR2(300):='Hello world!';
BEGIN
    DBMS_OUTPUT.PUT_LINE(l_hello_stmt);
END;
/
EXIT;