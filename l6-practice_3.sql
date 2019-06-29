1. Create a new custom staging table
create table XX_ORDERS_HIST
(ORDER_ID NUMBER,
 CUSTOMER_ID NUMBER,
 STATUS VARCHAR2(1)
);

2. Create an after insert trigger, which will catch new inserted records to XX_ORDERS and populate data to XX_ORDERS_HIST with status 'N'
CREATE OR REPLACE TRIGGER XX_ORDERS_JOB_AI
AFTER INSERT
ON XX_ORDERS
FOR EACH ROW
DECLARE
BEGIN

    INSERT INTO XX_ORDERS_HIST
    VALUES (:NEW.ORDER_ID, :NEW.CUSTOMER_ID, 'N');
END;

3. Create a new procedure in XX_DB_COURSE in order to generate XML files (order per customer) for all cases in status 'N' in XX_ORDERS_HIST
PACKAGE HEADER:

create or replace PACKAGE XX_DB_COURSE
AS    
    PROCEDURE GENERATE_XML_FILE(p_dir VARCHAR2, p_file VARCHAR2);

    PROCEDURE GENERATE_XML_FILE_PER_ORDER(p_dir VARCHAR2, p_file VARCHAR2, p_customer_id NUMBER, p_order_id NUMBER, p_order_number VARCHAR2, p_total_amount NUMBER);

    PROCEDURE GENERATE_XML_FILE_USE_JOB;

END XX_DB_COURSE;
/

PACKAGE BODY:
create or replace PACKAGE BODY XX_DB_COURSE
AS
    C_MAX_LENGTH NUMBER:= 32767;
    
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
    l_file VARCHAR2(200);
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
    
END XX_DB_COURSE;

TEST SOLUTION:
insert into xx_orders
values (69, 'RI-ORDER-69', 1, SYSDATE, 'ORDERED', 500, 'EUR', 4, SYSDATE, SYSDATE, SYSDATE);

insert into xx_orders
values (70, 'RI-ORDER-70', 1, SYSDATE, 'ORDERED', 500, 'EUR', 4, SYSDATE, SYSDATE, SYSDATE);