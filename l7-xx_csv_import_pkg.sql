CREATE OR REPLACE PACKAGE BODY XX_CSV_IMPORT_PKG
IS
    C_ORDER_HEADER VARCHAR2(10):='ORDERS';
    C_ORDER_LINES VARCHAR2(10):='LINES';

    PROCEDURE log_error(p_msg VARCHAR2)
    IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(p_msg);
    END;

    PROCEDURE insert_header(p_header_rec xx_orders%ROWTYPE)
    IS
    BEGIN
        INSERT INTO xx_orders
        VALUES p_header_rec;
    END;

    PROCEDURE insert_line(p_line_rec xx_order_lines%ROWTYPE)
    IS
    BEGIN
        INSERT INTO xx_order_lines
        VALUES p_line_rec;
    END;

    PROCEDURE IMPORT_CSV(p_file_name VARCHAR2, p_dir VARCHAR2)
    IS
    fhandle  utl_file.file_type;
    l_rec VARCHAR2(2000);
    l_header VARCHAR2(10);
    l_header_record xx_orders%ROWTYPE;
    l_line_record xx_order_lines%ROWTYPE;
    BEGIN
          fhandle := utl_file.fopen(
                p_dir     -- File location
              , p_file_name
              , 'r' -- Open mode: w = write. 
              );

    LOOP
    BEGIN
        l_header_record := null;
        l_line_record := null;
        UTL_FILE.GET_LINE(fhandle,l_rec); 
        dbms_output.put_line(l_rec);
        
        SELECT SUBSTR(l_rec, 0, INSTR(l_rec, ';')-1) 
        INTO l_header
        FROM DUAL;       
        
        IF l_header = C_ORDER_HEADER THEN
            SELECT (select max(order_id)+1 from xx_orders) ID,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 2) ORDER_NUMBER,
                   (select customer_id from xx_customers where customer_name = REGEXP_SUBSTR(l_rec, '[^;]+', 1, 3)) CUSTOMER_ID,
                   TO_DATE(REGEXP_SUBSTR(l_rec, '[^;]+', 1, 4), 'dd.mm.yyyy') SHIPMENT_DATE,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 5) STATUS,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 6) TOTAL_AMOUNT,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 7) CURRENCY,
                   (select warehouse_id from xx_warehouse where warehouse_name = REGEXP_SUBSTR(l_rec, '[^;]+', 1, 8)) WAREHOUSE_ID,
                   TO_DATE(REGEXP_SUBSTR(l_rec, '[^;]+', 1, 9),'dd.mm.yyyy') ORDER_DATE,
                   TO_DATE(REGEXP_SUBSTR(l_rec, '[^;]+', 1, 10), 'dd.mm.yyyy') CREATION_DATE,
                   TO_DATE(REGEXP_SUBSTR(l_rec, '[^;]+', 1, 11), 'dd.mm.yyyy') LAST_UPDATE_DATE
            INTO l_header_record       
            FROM DUAL t;
            
            IF l_header_record.customer_id is not null and l_header_record.warehouse_id is not null then
                insert_header(l_header_record);
            ELSE
                log_error('ERROR: CUSTOMER OR WAREHOUSE NOT FOUND');
            END IF;
            
            
        ELSIF l_header = C_ORDER_LINES THEN
            SELECT (select max(line_id)+1 from xx_order_lines) ID,
                   (select order_id from xx_orders where order_number = REGEXP_SUBSTR(l_rec, '[^;]+', 1, 2)) ORDER_ID,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 3) LINE_NUMBER,
                   (select item_id from xx_items where name = REGEXP_SUBSTR(l_rec, '[^;]+', 1, 4)) ITEM_ID,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 5) UNIT_PRICE,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 6) QUANTITY,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 7) STATUS,
                   REGEXP_SUBSTR(l_rec, '[^;]+', 1, 8) UOM
            INTO l_line_record       
            FROM DUAL t;
            
            IF l_line_record.order_id is not null and l_line_record.item_id is not null then
                insert_line(l_line_record);
            ELSE
                log_error('ERROR: ORDER OR ITEM NOT FOUND');
            END IF;
        END IF;
 
    EXCEPTION WHEN No_Data_Found THEN EXIT; END;
    END LOOP;
    UTL_FILE.FCLOSE(fhandle);	
    
    COMMIT;
    END;
END;    