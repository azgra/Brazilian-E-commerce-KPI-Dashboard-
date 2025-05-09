-- etl_clean_derive.sql (MySQL 8.0+) 最终修订 2025‑05‑07
-- ============================================================================
USE EcomSalesKPIDashboard;

/*------------------------------------------------------------
ALTER TABLE orders DROP COLUMN order_date;
ALTER TABLE orders DROP COLUMN order_year;
ALTER TABLE orders DROP COLUMN order_month;
ALTER TABLE orders DROP COLUMN is_returned;

ALTER TABLE order_items DROP COLUMN gross_value;
------------------------------------------------------------*/

/*------------------------------------------------------------
1. orders
------------------------------------------------------------*/
ALTER TABLE orders
ADD COLUMN order_date  DATE     GENERATED ALWAYS AS (DATE(order_purchase_timestamp)) VIRTUAL,
ADD COLUMN order_year  SMALLINT GENERATED ALWAYS AS (YEAR(order_purchase_timestamp)) VIRTUAL,
ADD COLUMN order_month TINYINT  GENERATED ALWAYS AS (MONTH(order_purchase_timestamp)) VIRTUAL,
ADD COLUMN is_returned TINYINT  GENERATED ALWAYS AS (
    CASE WHEN order_status IN ('canceled','unavailable','returned') THEN 1 ELSE 0 END
) VIRTUAL;

/*------------------------------------------------------------
2. order_items
------------------------------------------------------------*/
ALTER TABLE order_items
ADD COLUMN gross_value DECIMAL(10,2) GENERATED ALWAYS AS (
    CAST(price AS DECIMAL(10,2)) + CAST(freight_value AS DECIMAL(10,2))
) VIRTUAL;

/*------------------------------------------------------------
3.dim_date
------------------------------------------------------------*/
CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    year SMALLINT,
    quarter TINYINT,
    month TINYINT,
    month_name VARCHAR(10),
    week_of_year TINYINT,
    day_of_week TINYINT,
    day_of_month TINYINT,
    is_weekend TINYINT
);

-- 存储过程填充dim_date表
DELIMITER //
CREATE PROCEDURE fill_dim_date()
BEGIN
  DECLARE d DATE DEFAULT '2016-01-01';
  WHILE d <= '2018-12-31' DO
    INSERT INTO dim_date VALUES (
        d, YEAR(d), QUARTER(d), MONTH(d), MONTHNAME(d),
        WEEKOFYEAR(d), DAYOFWEEK(d), DAY(d),
        CASE WHEN DAYOFWEEK(d) IN (1,7) THEN 1 ELSE 0 END
    );
    SET d = DATE_ADD(d, INTERVAL 1 DAY);
  END WHILE;
END //
DELIMITER ;

CALL fill_dim_date();
DROP PROCEDURE fill_dim_date;

/*------------------------------------------------------------
4. fact_order_daily
------------------------------------------------------------*/
CREATE TABLE fact_order_daily ENGINE=InnoDB AS
SELECT
  o.order_date AS date_key,
  SUM(oi.gross_value) AS gmv,
  COUNT(DISTINCT o.order_id) AS orders_cnt,
  SUM(o.is_returned) AS returned_cnt
FROM orders o
JOIN order_items oi USING(order_id)
GROUP BY o.order_date;

CREATE INDEX idx_fact_day ON fact_order_daily(date_key);
