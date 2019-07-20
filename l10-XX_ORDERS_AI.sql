CREATE OR REPLACE TRIGGER XX_ORDERS_AI
AFTER INSERT
ON orders
FOR EACH ROW
DECLARE
BEGIN

    INSERT INTO XX_ORDERS_HIST
    VALUES (:NEW.ID, 'N');
END;