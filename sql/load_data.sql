-- load_data.sql  (MySQL 8.0 / Windows)
-- ---------------------------------------------------------------------------
-- Bulk‑load all Olist CSV files with one script.
-- Prereqs
--   1. SET GLOBAL local_infile = 1;   -- once per MySQL service
--   2. Put all CSVs under D:/py/Github/EcomSalesKPIDashboard/data/
--   3. Each file is UTF‑8 with header row.
-- ---------------------------------------------------------------------------

USE EcomSalesKPIDashboard;
SET GLOBAL local_infile = 'ON';
/*------------------------------------------------------------
1. customers  (≈ 99 k rows)
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_customers_dataset.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id,
 customer_unique_id,
 customer_zip_code_prefix,
 customer_city,
 customer_state);

/*------------------------------------------------------------
2. geolocation  (≈ 1 M rows)
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_geolocation_dataset.csv'
INTO TABLE geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix,
 geolocation_lat,
 geolocation_lng,
 geolocation_city,
 geolocation_state);

/*------------------------------------------------------------
3. orders  (≈ 99 k)
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_orders_dataset.csv'
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 customer_id,
 order_status,
 order_purchase_timestamp,
 order_approved_at,
 order_delivered_carrier_date,
 order_delivered_customer_date,
 order_estimated_delivery_date);

/*------------------------------------------------------------
4. order_items
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_order_items_dataset.csv'
INTO TABLE order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 order_item_id,
 product_id,
 seller_id,
 shipping_limit_date,
 price,
 freight_value);

/*------------------------------------------------------------
5. order_payments
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_order_payments_dataset.csv'
INTO TABLE order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id,
 payment_sequential,
 payment_type,
 payment_installments,
 payment_value);

/*------------------------------------------------------------
6. order_reviews
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(review_id,
 order_id,
 review_score,
 review_comment_title,
 review_comment_message,
 review_creation_date,
 review_answer_timestamp);

/*------------------------------------------------------------
7. products
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_products_dataset.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id,
 product_category_name,
 product_name_length,
 product_description_length,
 product_photos_qty,
 product_weight_g,
 product_length_cm,
 product_height_cm,
 product_width_cm);

/*------------------------------------------------------------
8. sellers
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/olist_sellers_dataset.csv'
INTO TABLE sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(seller_id,
 seller_zip_code_prefix,
 seller_city,
 seller_state);

/*------------------------------------------------------------
9. product category translation
------------------------------------------------------------*/
LOAD DATA LOCAL INFILE 'D:/py/Github/EcomSalesKPIDashboard/data/product_category_name_translation.csv'
INTO TABLE product_category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_category_name,
 product_category_name_english);
