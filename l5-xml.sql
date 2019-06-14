select XMLELEMENT("customer", 
                  XMLATTRIBUTES(
                    xc.account_number,
                    xc.customer_name),
                XMLELEMENT ("phone", xc.phone_number),
                XMLELEMENT("email", xc.email))
from xx_customers xc;

select XMLELEMENT("customer", 
                  XMLATTRIBUTES(
                    xc.account_number,
                    xc.customer_name),
                XMLFOREST (xc.phone_number,
                           xc.email))
from xx_customers xc;


select 
XMLELEMENT("customers",
XMLAGG(
XMLELEMENT("customer", 
                  XMLATTRIBUTES(
                    xc.account_number,
                    xc.customer_name),
                XMLFOREST (xc.phone_number,
                           xc.email))))
from xx_customers xc;


select 
XMLELEMENT("customers",
XMLAGG(
XMLELEMENT("customer", 
                  XMLATTRIBUTES(
                    xc.account_number,
                    xc.customer_name),
                XMLFOREST (xc.phone_number,
                           XMLCDATA(xc.email) as email))))
from xx_customers xc;

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
    )
FROM
    xx_customers xc;