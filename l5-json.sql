SELECT JSON_OBJECT ('id' VALUE customer_id,
                     'name' VALUE customer_name,
                     'number' VALUE account_number,
                     'email' VALUE email,
                     'phone' VALUE phone_number) FROM xx_customers;
 
 SELECT JSON_ARRAY (customer_id, customer_name, account_number, email, phone_number) FROM xx_customers;
                     
SELECT JSON_ARRAYAGG( JSON_OBJECT ('id' VALUE customer_id,
                     'name' VALUE customer_name,
                     'number' VALUE account_number,
                     'email' VALUE email,
                     'phone' VALUE phone_number)) FROM xx_customers WHERE customer_id < 5;

SELECT JSON_OBJECTAGG(to_char(account_number) VALUE customer_name) FROM xx_customers;