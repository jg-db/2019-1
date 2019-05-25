declare
    l_function_result NUMBER;
begin
    xx_first_procedure;
    
    l_function_result := xx_first_function(1,5);
    DBMS_OUTPUT.PUT_LINE(l_function_result);
    
    xx_first_package.main('Lecture 3');
    
    l_function_result := xx_first_package.to_sum(10,10);
    DBMS_OUTPUT.PUT_LINE(l_function_result);
end;