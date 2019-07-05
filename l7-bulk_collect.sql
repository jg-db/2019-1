CREATE TABLE XX_STUDENTS (STUDENT_ID NUMBER, STUDENT_NAME VARCHAR2(45), STUDENT_EMAIL VARCHAR2(100));

declare
    TYPE student_det IS RECORD
    ( STUDENT_ID NUMBER,
      STUDENT_NAME VARCHAR2(45),
      STUDENT_EMAIL VARCHAR2(100)
    );
    TYPE student_det_tbl IS TABLE of student_det;
    javaGuru_student_rec student_det_tbl;
begin
    INSERT INTO XX_STUDENTS VALUES (1, 'John', 'john@gmail.com');
    INSERT INTO XX_STUDENTS VALUES (2, 'Mike', 'john@gmail.com');
    INSERT INTO XX_STUDENTS VALUES (3, 'Penny', 'john@gmail.com');

    SELECT student_id, student_name, student_email 
    BULK COLLECT INTO javaGuru_student_rec
    FROM XX_STUDENTS;
    
    FOR i in javaGuru_student_rec.FIRST..javaGuru_student_rec.LAST LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || javaGuru_student_rec(i).student_id);
        DBMS_OUTPUT.PUT_LINE('NAME: ' || javaGuru_student_rec(i).student_name);
        DBMS_OUTPUT.PUT_LINE('EMAIL: ' || javaGuru_student_rec(i).student_email);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
end;