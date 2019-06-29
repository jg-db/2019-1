1. Create a package procedure,which would generate *.csv files using ref cursor and dynamic query. Pass only select and from part of a query hardcoded in a procedure body:
create or replace PACKAGE XX_DB_COURSE
AS
    PROCEDURE MAIN;
    
    PROCEDURE GENERATE_XML_FILE(p_dir VARCHAR2, p_file VARCHAR2);

    PROCEDURE GENERATE_XML_FILE_PER_ORDER(p_dir VARCHAR2, p_file VARCHAR2, p_customer_id NUMBER, p_order_id NUMBER, p_order_number VARCHAR2, p_total_amount NUMBER);

    PROCEDURE GENERATE_XML_FILE_USE_JOB;

    PROCEDURE GENERATE_DYNAMIC_TXT(p_where_clause VARCHAR2);

END XX_DB_COURSE;
/

create or replace PACKAGE BODY XX_DB_COURSE
AS
    C_MAX_LENGTH NUMBER:= 32767;

    PROCEDURE MAIN
    IS
    BEGIN
        NULL;
    END;
    
    PROCEDURE GENERATE_XML_FILE(p_dir VARCHAR2, p_file VARCHAR2)
    IS
    cursor v_data
    is
    SELECT t.data_rec.getClobVal() as xml_data 
    FROM (
    SELECT
    XMLELEMENT(
        "customers", XMLAGG(XMLELEMENT(
            "customer", XMLFOREST(xc.account_number AS "customer_number", xc.customer_name AS "customer_name", xc.customer_id AS "customer_id"
            ,(
                SELECT
                    XMLAGG(XMLELEMENT(
                        "order", XMLFOREST(xo.order_id AS "order_id", xo.order_number AS "order_number", xo.total_amount AS "total_amount",(
                            SELECT
                                XMLAGG(XMLELEMENT(
                                    "lines", XMLFOREST(xl.line_id AS "line_id", xl.line_number AS "line_number", xi.name AS "item", xl.unit_price * quantity AS "price", xl.status AS "status")
                                ))
                            FROM
                                xx_order_lines xl,
                                xx_items xi
                            WHERE
                                xo.order_id = xl.order_id
                                and xi.item_id = xl.item_id
                        ) "lines")
                    ))
                FROM   xx_orders xo
                WHERE
                    xo.customer_id = xc.customer_id
            ) "orders")
        ))
    ) as data_rec
    FROM
    xx_customers xc) t;
    
    fhandle  utl_file.file_type;
    BEGIN
          fhandle := utl_file.fopen(
                p_dir     -- File location
              , p_file -- File name
              , 'w' -- Open mode: w = write. 
              , C_MAX_LENGTH );
    
        FOR v_data_rec in v_data LOOP
             utl_file.put(fhandle, v_data_rec.xml_data || CHR(10));
        END LOOP;
    
         utl_file.fclose(fhandle);
    END;

    PROCEDURE GENERATE_XML_FILE_PER_ORDER(p_dir VARCHAR2, p_file VARCHAR2, p_customer_id NUMBER, p_order_id NUMBER, p_order_number VARCHAR2, p_total_amount NUMBER)
    IS
    cursor v_data(p_order_id NUMBER)
    is
    SELECT t.data_rec.getClobVal() as xml_data 
    FROM (
    SELECT
    XMLELEMENT(
        "customers", XMLAGG(XMLELEMENT(
            "customer", XMLFOREST(xc.account_number AS "customer_number", xc.customer_name AS "customer_name", xc.customer_id AS "customer_id"
            ,(
                SELECT
                    XMLAGG(XMLELEMENT(
                        "order", XMLFOREST(xo.order_id AS "order_id", xo.order_number AS "order_number", xo.total_amount AS "total_amount",(
                            SELECT
                                XMLAGG(XMLELEMENT(
                                    "lines", XMLFOREST(xl.line_id AS "line_id", xl.line_number AS "line_number", xi.name AS "item", xl.unit_price * quantity AS "price", xl.status AS "status")
                                ))
                            FROM
                                xx_order_lines xl,
                                xx_items xi
                            WHERE
                                xo.order_id = xl.order_id
                                and xi.item_id = xl.item_id
                        ) "lines")
                    ))
                FROM  (select p_order_id order_id, p_customer_id customer_id, p_order_number order_number, p_total_amount total_amount from dual) xo
                WHERE
                    xo.customer_id = xc.customer_id
                and xo.order_id = p_order_id
            ) "orders")
        ))
    ) as data_rec
    FROM
    xx_customers xc
    where xc.customer_id = p_customer_id) t;  
    
    fhandle  utl_file.file_type;
    BEGIN
          DBMS_OUTPUT.PUT_LINE('p_order_id: ' || p_order_id);
          
          fhandle := utl_file.fopen(
                p_dir     -- File location
              , p_file -- File name
              , 'w' -- Open mode: w = write. 
              , C_MAX_LENGTH );
    
        FOR v_data_rec in v_data(p_order_id) LOOP
              DBMS_OUTPUT.PUT_LINE(v_data_rec.xml_data);
             utl_file.put(fhandle, v_data_rec.xml_data || CHR(10));
        END LOOP;
    
         utl_file.fclose(fhandle);
    END;
    
    PROCEDURE UPDATE_HIST(p_order_id NUMBER, p_customer_id NUMBER)
    IS
    BEGIN
      UPDATE xx_orders_hist
      SET status = 'S'
      WHERE order_id = p_order_id
       AND customer_id = p_customer_id;
    END;
    
    PROCEDURE GENERATE_XML_FILE_USE_JOB
    IS
    cursor v_data(p_order_id NUMBER, p_customer_id NUMBER)
    is
    SELECT t.data_rec.getClobVal() as xml_data 
    FROM (
    SELECT
    XMLELEMENT(
        "customers", XMLAGG(XMLELEMENT(
            "customer", XMLFOREST(xc.account_number AS "customer_number", xc.customer_name AS "customer_name", xc.customer_id AS "customer_id"
             ,(
                SELECT
                    XMLAGG(XMLELEMENT(
                        "order", XMLFOREST(xo.order_id AS "order_id", xo.order_number AS "order_number", xo.total_amount AS "total_amount",(
                            SELECT
                                XMLAGG(XMLELEMENT(
                                    "lines", XMLFOREST(xl.line_id AS "line_id", xl.line_number AS "line_number", xi.name AS "item", xl.unit_price * quantity AS "price", xl.status AS "status")
                                ))
                            FROM
                                xx_order_lines xl,
                                xx_items xi
                            WHERE
                                xo.order_id = xl.order_id
                                and xi.item_id = xl.item_id
                        ) "lines")
                    ))
                FROM   xx_orders xo
                WHERE
                    xo.customer_id = xc.customer_id
                    and xo.order_id = p_order_id
            ) "orders")
        ))
    ) as data_rec
   FROM
    xx_customers xc
    where xc.customer_id = p_customer_id) t;  
    
    fhandle  utl_file.file_type;
    BEGIN
        FOR v_new_order_rec in (SELECT order_id, customer_id from XX_ORDERS_HIST WHERE status = 'N') LOOP

          fhandle := utl_file.fopen(
                'XX_OUTPUT'     -- File location
              , 'XX_NEW_ORDER_' || v_new_order_rec.order_id || '_' || SYSDATE || '.xml' -- File name
              , 'w' -- Open mode: w = write. 
              , C_MAX_LENGTH );

            FOR v_data_rec in v_data(v_new_order_rec.order_id, v_new_order_rec.customer_id) LOOP
                DBMS_OUTPUT.PUT_LINE(v_data_rec.xml_data);
                utl_file.put(fhandle, v_data_rec.xml_data || CHR(10));
            END LOOP;
            update_hist(v_new_order_rec.order_id, v_new_order_rec.customer_id);
            utl_file.fclose(fhandle);
        END LOOP;
    END;
   
   PROCEDURE GENERATE_DYNAMIC_TXT(p_where_clause VARCHAR2)
   IS
   TYPE cur_type IS REF CURSOR;
   TYPE row_type IS RECORD (order_id NUMBER, order_number VARCHAR2(100), total_amount NUMBER);
   v_cursor cur_type;
   l_sql VARCHAR2(3000):= 'SELECT order_id, order_number, total_amount FROM xx_orders ';
   l_row_type row_type;

   fhandle  utl_file.file_type;
   BEGIN
        l_sql := l_sql || p_where_clause;
        
        OPEN v_cursor FOR l_sql;
        LOOP
        FETCH v_cursor into l_row_type;
        EXIT WHEN v_cursor%notfound;

          fhandle := utl_file.fopen(
                'XX_OUTPUT'     -- File location
              , 'XX_DYN_ORDER_' || l_row_type.order_id || '_' || SYSDATE || '.csv' -- File name
              , 'w' -- Open mode: w = write. 
              , C_MAX_LENGTH );
           
          utl_file.put(fhandle, l_row_type.order_id || ',' || l_row_type.order_number || ',' || l_row_type.total_amount || CHR(10));
          utl_file.fclose(fhandle);
        
        END LOOP;
        
        CLOSE v_cursor;
    END;
    
END XX_DB_COURSE;
/

2. Create a declare statement to run new created procedure and pass WHERE clause as a parameter:
DECLARE

BEGIN
   -- XX_DB_COURSE.GENERATE_XML_FILE_USE_JOB;
    XX_DB_COURSE.GENERATE_DYNAMIC_TXT('where order_id in (1,2)');
END;