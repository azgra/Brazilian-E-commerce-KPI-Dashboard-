-- views_kpi.sql  (MySQL 8.0+)  — Plan A · 全量 KPI 视图
-- =====================================================================
USE EcomSalesKPIDashboard;

/*-----------------------------------------------------------
1️⃣  v_monthly_gmv  — GMV + MoM + YoY（自动补月缺口）
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_monthly_gmv;
CREATE VIEW v_monthly_gmv AS
WITH months AS (
    SELECT DATE_FORMAT(date_key,'%Y-%m-01') AS ym
    FROM   dim_date
    WHERE  date_key BETWEEN '2016-01-01' AND '2018-08-31'
    GROUP  BY ym
),
gmv_raw AS (
    SELECT DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m-01') AS ym,
           SUM(oi.gross_value) AS gmv
    FROM   orders o
    JOIN   order_items oi USING(order_id)
    GROUP  BY ym
),
gmv_fill AS (
    SELECT m.ym,
           COALESCE(r.gmv,0) AS gmv
    FROM   months m
    LEFT   JOIN gmv_raw r USING(ym)
)
SELECT *
FROM (
    SELECT
        ym,
        gmv,
        LAG(gmv)    OVER (ORDER BY ym)      AS gmv_prev_month,
        LAG(gmv,12) OVER (ORDER BY ym)      AS gmv_prev_year,
        ROUND(
          CASE WHEN LAG(gmv) OVER (ORDER BY ym)=0
               THEN NULL
               ELSE (gmv-LAG(gmv) OVER (ORDER BY ym))/LAG(gmv) OVER (ORDER BY ym)*100
          END,2) AS mom_pct,
        ROUND(
          CASE WHEN LAG(gmv,12) OVER (ORDER BY ym)=0
               THEN NULL
               ELSE (gmv-LAG(gmv,12) OVER (ORDER BY ym))/LAG(gmv,12) OVER (ORDER BY ym)*100
          END,2) AS yoy_pct
    FROM gmv_fill
) t
WHERE ym BETWEEN '2016-09-01' AND '2018-08-01'
ORDER BY ym;

/*-----------------------------------------------------------
2️⃣  v_monthly_orders  — 订单数 + AOV + MoM
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_monthly_orders;
CREATE VIEW v_monthly_orders AS
SELECT
    DATE_FORMAT(date_key,'%Y-%m-01')                       AS ym,
    SUM(orders_cnt)                                        AS orders_cnt,
    ROUND(SUM(gmv)/SUM(orders_cnt),2)                      AS aov,
    LAG(SUM(orders_cnt)) OVER (ORDER BY DATE_FORMAT(date_key,'%Y-%m-01'))
                                                           AS orders_prev_month,
    ROUND(
      CASE WHEN LAG(SUM(orders_cnt)) OVER (ORDER BY DATE_FORMAT(date_key,'%Y-%m-01'))=0
           THEN NULL
           ELSE (SUM(orders_cnt)-LAG(SUM(orders_cnt)) OVER (ORDER BY DATE_FORMAT(date_key,'%Y-%m-01')))
                /LAG(SUM(orders_cnt)) OVER (ORDER BY DATE_FORMAT(date_key,'%Y-%m-01'))*100
      END,2)                                               AS orders_mom_pct
FROM fact_order_daily
GROUP BY ym
ORDER BY ym;

/*-----------------------------------------------------------
3️⃣  v_monthly_return_rate  — 退货率
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_monthly_return_rate;
CREATE VIEW v_monthly_return_rate AS
SELECT
    DATE_FORMAT(date_key,'%Y-%m-01')           AS ym,
    ROUND( LEAST(SUM(returned_cnt)/NULLIF(SUM(orders_cnt),0),1) * 100 ,2) AS return_rate_pct
FROM fact_order_daily
GROUP BY ym
ORDER BY ym;
/*-----------------------------------------------------------
4️⃣  v_monthly_core_kpi  — 单表汇总 GMV/订单/AOV/退货率/MoM/YoY
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_monthly_core_kpi;
CREATE VIEW v_monthly_core_kpi AS
SELECT g.ym,
       g.gmv,
       o.orders_cnt,
       o.aov,
       r.return_rate_pct,
       g.mom_pct       AS gmv_mom_pct,
       g.yoy_pct       AS gmv_yoy_pct,
       o.orders_mom_pct
FROM   v_monthly_gmv    g
JOIN   v_monthly_orders o USING(ym)
JOIN   v_monthly_return_rate r USING(ym)
ORDER  BY g.ym;

/*-----------------------------------------------------------
5️⃣  v_category_gmv  — 品类 GMV & 订单
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_category_gmv;
CREATE VIEW v_category_gmv AS
SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m-01') AS ym,
    pct.product_category_name_english                  AS category_en,
    SUM(oi.gross_value)                                AS gmv,
    COUNT(DISTINCT o.order_id)                         AS orders_cnt
FROM   orders o
JOIN   order_items  oi  USING(order_id)
JOIN   products     p   USING(product_id)
LEFT   JOIN product_category_translation pct
       ON p.product_category_name = pct.product_category_name
GROUP  BY ym, category_en;

/*-----------------------------------------------------------
6️⃣  v_state_gmv  — 地区 GMV & 订单
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_state_gmv;
CREATE VIEW v_state_gmv AS
SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m-01') AS ym,
    c.customer_state,
    SUM(oi.gross_value)                                AS gmv,
    COUNT(DISTINCT o.order_id)                         AS orders_cnt
FROM   orders o
JOIN   order_items oi USING(order_id)
JOIN   customers   c USING(customer_id)
GROUP  BY ym, c.customer_state;

/*-----------------------------------------------------------
7️⃣  v_customer_segment_monthly  — 新客 vs 回头客
-----------------------------------------------------------*/
DROP VIEW IF EXISTS v_customer_segment_monthly;
CREATE VIEW v_customer_segment_monthly AS
WITH first_order AS (
  SELECT customer_id,
         DATE_FORMAT(MIN(order_purchase_timestamp),'%Y-%m') AS first_ym
  FROM   orders
  GROUP  BY customer_id
)
SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS ym,
    CASE WHEN DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') = f.first_ym
         THEN 'New' ELSE 'Repeat' END                AS segment,
    COUNT(DISTINCT o.order_id)                       AS orders_cnt,
    SUM(oi.gross_value)                              AS gmv
FROM   orders o
JOIN   first_order f USING(customer_id)
JOIN   order_items oi USING(order_id)
GROUP  BY ym, segment
ORDER  BY ym, segment;

