-- ddl_create_tables.sql  (MySQL 8.0+)
-- schema: EcomSalesKPIDashboard
-- ---------------------------------------------------------------------------
-- Re‑create all core tables for the Olist e‑commerce dataset
-- Run in a DEV / SANDBOX database only — existing data will be dropped!
-- ---------------------------------------------------------------------------

/*==========================================================================*/
/*  Customers                                                               */
/*==========================================================================*/
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id              CHAR(32)    NOT NULL,
    customer_unique_id       CHAR(32)    NOT NULL,
    customer_zip_code_prefix CHAR(8),
    customer_city            VARCHAR(64),
    customer_state           CHAR(2),
    PRIMARY KEY (customer_id),
    INDEX idx_customers_zip (customer_zip_code_prefix)
);

/*==========================================================================*/
/*  Geolocation                                                             */
/*==========================================================================*/
DROP TABLE IF EXISTS geolocation;
CREATE TABLE geolocation (
    geolocation_zip_code_prefix CHAR(8)   NOT NULL,
    geolocation_lat             DECIMAL(9,6),
    geolocation_lng             DECIMAL(9,6),
    geolocation_city            VARCHAR(64),
    geolocation_state           CHAR(2),
    PRIMARY KEY (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng)
);

/*==========================================================================*/
/*  Orders (master)                                                         */
/*==========================================================================*/
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id                      CHAR(32)   NOT NULL,
    customer_id                   CHAR(32),
    order_status                  VARCHAR(32),
    order_purchase_timestamp      DATETIME,
    order_approved_at             DATETIME,
    order_delivered_carrier_date  DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    PRIMARY KEY (order_id),
    INDEX idx_orders_customer     (customer_id),
    INDEX idx_orders_purchase_ts  (order_purchase_timestamp)
);

/*==========================================================================*/
/*  Order Items (detail)                                                    */
/*==========================================================================*/
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
    order_id            CHAR(32)   NOT NULL,
    order_item_id       SMALLINT   NOT NULL,
    product_id          CHAR(32)   NOT NULL,
    seller_id           CHAR(32)   NOT NULL,
    shipping_limit_date DATETIME,
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id),
    INDEX idx_oi_product (product_id),
    INDEX idx_oi_seller  (seller_id)
);

/*==========================================================================*/
/*  Order Payments                                                          */
/*==========================================================================*/
DROP TABLE IF EXISTS order_payments;
CREATE TABLE order_payments (
    order_id             CHAR(32)   NOT NULL,
    payment_sequential   SMALLINT   NOT NULL,
    payment_type         VARCHAR(32),
    payment_installments SMALLINT,
    payment_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    INDEX idx_op_order (order_id)
);

/*==========================================================================*/
/*  Order Reviews                                                           */
/*==========================================================================*/
DROP TABLE IF EXISTS order_reviews;
CREATE TABLE order_reviews (
    review_id               CHAR(32)   NOT NULL,
    order_id                CHAR(32),
    review_score            TINYINT,
    review_comment_title    VARCHAR(255),
    review_comment_message  TEXT,
    review_creation_date    DATETIME,
    review_answer_timestamp DATETIME,
    PRIMARY KEY (review_id),
    INDEX idx_or_order (order_id)
);

/*==========================================================================*/
/*  Products                                                                */
/*==========================================================================*/
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id                 CHAR(32)    NOT NULL,
    product_category_name      VARCHAR(100),
    product_name_length        SMALLINT,
    product_description_length SMALLINT,
    product_photos_qty         SMALLINT,
    product_weight_g           INT,
    product_length_cm          INT,
    product_height_cm          INT,
    product_width_cm           INT,
    PRIMARY KEY (product_id),
    INDEX idx_products_category (product_category_name)
);

/*==========================================================================*/
/*  Product Category Translation (EN)                                       */
/*==========================================================================*/
DROP TABLE IF EXISTS product_category_translation;
CREATE TABLE product_category_translation (
    product_category_name         VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100),
    PRIMARY KEY (product_category_name)
);

/*==========================================================================*/
/*  Sellers                                                                */
/*==========================================================================*/
DROP TABLE IF EXISTS sellers;
CREATE TABLE sellers (
    seller_id              CHAR(32)   NOT NULL,
    seller_zip_code_prefix CHAR(8),
    seller_city            VARCHAR(64),
    seller_state           CHAR(2),
    PRIMARY KEY (seller_id),
    INDEX idx_sellers_zip (seller_zip_code_prefix)
);
