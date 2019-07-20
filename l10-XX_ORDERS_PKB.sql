CREATE OR REPLACE PACKAGE BODY xx_orders_pkg AS

    c_max_length NUMBER := 32767;

    PROCEDURE main IS
    BEGIN
        generate_xml_file('XX_OUTPUT');
    END;

    PROCEDURE update_hist (
        p_order_id NUMBER
    ) IS
    BEGIN
        UPDATE xx_orders_hist
        SET
            status = 'S'
        WHERE
            order_id = p_order_id;

    END;

    PROCEDURE generate_xml_file (
        p_dir VARCHAR2
    ) IS

        CURSOR v_data (
            p_order_id NUMBER
        ) IS
        SELECT
            tbl.data_rec.getclobval() AS xml_data
        FROM
            (
                SELECT
                    XMLELEMENT(
                        "order", XMLELEMENT(
                            "orderNumber", o.order_number), XMLELEMENT(
                            "customerName", o.customer_name
                        ),
                    XMLELEMENT(
                            "shipmentDate", o.shipment_date
                        ), XMLELEMENT("status", o.status
                        ), XMLELEMENT(
                            "totalAmount", o.total_amount
                        ), XMLELEMENT(
                            "currency", o.currency
                        ), XMLELEMENT(
                            "orderedDate", o.ordered_date
                        )
                    ) AS data_rec
                FROM
                    orders o
                WHERE
                    id = p_order_id
            ) tbl;

        fhandle utl_file.file_type;
    BEGIN
        FOR v_new_order_rec IN (
            SELECT
                order_id
            FROM
                xx_orders_hist
            WHERE
                status = 'N'
        ) LOOP
            dbms_output.put_line(v_new_order_rec.order_id);
            dbms_output.put_line('XX_NEW_ORDER_'
                                 || v_new_order_rec.order_id
                                 || '_'
                                 || trunc(SYSDATE)
                                 || '.xml');

            fhandle := utl_file.fopen('XX_OUTPUT'     -- File location

            , 'XX_NEW_ORDER_'
                                                   || v_new_order_rec.order_id
                                                   || '_'
                                                   || TO_CHAR(SYSDATE, 'dd-mm-yyyy')
                                                   || '.xml' -- File name
                                                   , 'w' -- Open mode: w = write. 
                                                   , c_max_length);

            FOR v_data_rec IN v_data(v_new_order_rec.order_id) LOOP
              --  DBMS_OUTPUT.PUT_LINE(v_data_rec.xml_data);

             utl_file.put(fhandle, v_data_rec.xml_data || chr(10));
            END LOOP;

            update_hist(v_new_order_rec.order_id);
            utl_file.fclose(fhandle);
        END LOOP;
    END;

END xx_orders_pkg;