1. In the same package create a procedure, which will create XML file with same information only for customer_id and order_id provided using incoming procedure parameters.

create or replace PACKAGE XX_DB_COURSE
AS    
    PROCEDURE GENERATE_XML_FILE(p_dir VARCHAR2, p_file VARCHAR2);

    PROCEDURE GENERATE_XML_FILE_PER_ORDER(p_dir VARCHAR2, p_file VARCHAR2, p_customer_id NUMBER, p_order_id NUMBER, p_order_number VARCHAR2, p_total_amount NUMBER);

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
    
END XX_DB_COURSE;
/

2. Create an after update trigger, which will call a procedure passing customer_id and order_id for new inserted orders, so files would be generated on event base.
CREATE OR REPLACE TRIGGER XX_ORDERS_AI
AFTER INSERT
ON XX_ORDERS
FOR EACH ROW
DECLARE
pragma autonomous_transaction;
BEGIN
    XX_DB_COURSE.GENERATE_XML_FILE_PER_ORDER('XX_OUTPUT', :NEW.order_number || '.xml',:NEW.customer_id, :NEW.order_id, :NEW.order_number, :NEW.total_amount);
END;
/

3. Insert a couple of orders and check generated files.
insert into xx_orders
values (68, 'RI-ORDER-68', 1, SYSDATE, 'ORDERED', 500, 'EUR', 4, SYSDATE, SYSDATE, SYSDATE);


insert into xx_orders
values (69, 'RI-ORDER-69', 1, SYSDATE, 'ORDERED', 500, 'EUR', 4, SYSDATE, SYSDATE, SYSDATE);
