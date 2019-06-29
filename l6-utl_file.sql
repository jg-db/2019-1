declare 
  fhandle  utl_file.file_type;
begin
  fhandle := utl_file.fopen(
                'XX_OUTPUT'     -- File location
              , 'test_file1.txt' -- File name
              , 'w' -- Open mode: w = write. 
                  );

  utl_file.put(fhandle, 'Record 1 !'
                      || CHR(10));
  utl_file.put(fhandle, 'Record 2!');

  utl_file.fclose(fhandle);
exception
  when others then 
    dbms_output.put_line('ERROR: ' || SQLCODE 
                      || ' - ' || SQLERRM);
    raise;
end;
/