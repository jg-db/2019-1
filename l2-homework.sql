CREATE TABLE xx_warehouse (
    warehouse_id       NUMBER PRIMARY KEY,
    warehouse_name     VARCHAR2(200),
    capacity           NUMBER,
    unit               VARCHAR2(50),
    creation_date      DATE,
    last_update_date   DATE
);
/

CREATE TABLE xx_address (
    address_id     NUMBER PRIMARY KEY,
    address_name   VARCHAR2(200) UNIQUE,
    street_name    VARCHAR2(150),
    building_nr    VARCHAR2(50),
    office_nr      VARCHAR2(50),
    country        VARCHAR2(100),
    city           VARCHAR2(100),
    postal_code    VARCHAR2(25)
);
/

CREATE TABLE xx_customers (
    customer_id        NUMBER PRIMARY KEY,
    customer_name      VARCHAR2(150) UNIQUE,
    account_number     NUMBER NOT NULL,
    status             VARCHAR2(25),
    address_id         NUMBER,
    email              VARCHAR2(200),
    phone_number       VARCHAR2(200),
    creation_date      DATE,
    last_update_date   DATE,
    
    CONSTRAINT kf_address
    FOREIGN KEY (address_id)
    REFERENCES xx_address (address_id)
);
/

CREATE TABLE xx_orders (
    order_id           NUMBER PRIMARY KEY,
    order_number       VARCHAR2(50) NOT NULL,
    customer_id        NUMBER,
    shipment_date      DATE,
    status             VARCHAR2(100) DEFAULT 'ENTERED',
    total_amount       NUMBER,
    currency           VARCHAR2(3),
    warehouse_id       NUMBER,
    order_date         DATE,
    creation_date      DATE,
    last_update_date   DATE,
    
    CONSTRAINT kf_customer
    FOREIGN KEY (customer_id)
    REFERENCES xx_customers (customer_id),
    
    CONSTRAINT kf_warehouse
    FOREIGN KEY (warehouse_id)
    REFERENCES xx_warehouse (warehouse_id)
);
/

CREATE TABLE xx_items (
    item_id            NUMBER PRIMARY KEY,
    description        VARCHAR2(500),
    name               VARCHAR2(75),
    weight             NUMBER,
    volume             NUMBER,
    inventory_status   VARCHAR2(50),
    sellable_status    VARCHAR2(50),
    creation_date      DATE,
    last_update_date   DATE
);
/

CREATE TABLE xx_availability (
    warehouse_id       NUMBER,
    item_id            NUMBER,
    quantity           NUMBER,
    creation_date      DATE,
    last_update_date   DATE,
    
    CONSTRAINT kf_warehouse_avail
    FOREIGN KEY (warehouse_id)
    REFERENCES xx_warehouse (warehouse_id),
    
    CONSTRAINT kf_item
    FOREIGN KEY (item_id)
    REFERENCES xx_items (item_id)
);
/

CREATE TABLE xx_order_lines (
    line_id       NUMBER PRIMARY KEY,
    order_id      NUMBER,
    line_number   NUMBER,
    item_id       NUMBER,
    unit_price    NUMBER,
    quantity      NUMBER,
    status        VARCHAR2(50) DEFAULT 'ENTERED',
    uom           VARCHAR2(50),
    
    CONSTRAINT kf_order
    FOREIGN KEY (order_id)
    REFERENCES xx_orders (order_id),
    
    CONSTRAINT kf_item_ol
    FOREIGN KEY (item_id)
    REFERENCES xx_items (item_id)    
);
/