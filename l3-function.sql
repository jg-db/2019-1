CREATE OR REPLACE FUNCTION xx_first_function(l_val_1 NUMBER, l_val_2 NUMBER)
RETURN NUMBER
IS
 l_result NUMBER;
BEGIN
    l_result := l_val_1 + l_val_2;
    
    RETURN l_result;
END;
/
exit;