1. Create a database directory:
CREATE [OR REPLACE] DIRECTORY directory_name AS 'path_name';

2. Create a database package, which would have a procedure to generate XML file containing information about customers and their orders using a cursor.
create or replace PACKAGE XX_DB_COURSE
AS
    PROCEDURE GENERATE_XML_FILE(p_dir VARCHAR2, p_file VARCHAR2);
END XX_DB_COURSE;
/

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
    
END XX_DB_COURSE;

3. create a declare statement to call package and check generated files
DECLARE

BEGIN
	XX_DB_COURSE.GENERATE_XML_FILE;	
END;