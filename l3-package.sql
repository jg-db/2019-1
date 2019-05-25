CREATE OR REPLACE PACKAGE xx_first_package
AS
    PROCEDURE MAIN(l_hello VARCHAR2);
    FUNCTION to_sum(l_val_1 NUMBER, l_val_2 NUMBER)
    RETURN NUMBER;

END xx_first_package;
/

CREATE OR REPLACE PACKAGE BODY xx_first_package
AS
    PROCEDURE MAIN(l_hello VARCHAR2)
    IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(l_hello);
    END;
    
    FUNCTION to_sum(l_val_1 NUMBER, l_val_2 NUMBER)
    RETURN NUMBER
    IS
        l_return NUMBER;
    BEGIN
        l_return := l_val_1 + l_val_2;
        
        RETURN l_return;
    END;

END xx_first_package;