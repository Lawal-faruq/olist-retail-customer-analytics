-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 05_load_fact.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Load fact_orders from staging tables
-- =============================================

USE OlistRetailDW;
GO

INSERT INTO fact_orders (
    order_id,
    order_item_id,
    customer_key,
    product_key,
    seller_key,
    date_key,
    geo_key,
    order_value,
    freight_value,
    review_score,
    order_status
)
SELECT
    o.order_id,
    i.order_item_id,
    o.customer_id                                                               AS customer_key,
    i.product_id                                                                AS product_key,
    i.seller_id                                                                 AS seller_key,
    CAST(FORMAT(CAST(o.order_purchase_timestamp AS DATE), 'yyyyMMdd') AS INT)   AS date_key,
    c.customer_zip_code_prefix                                                  AS geo_key,
    TRY_CAST(i.price AS DECIMAL(10,2))                                          AS order_value,
    TRY_CAST(i.freight_value AS DECIMAL(10,2))                                  AS freight_value,
    r.review_score                                                              AS review_score,
    o.order_status
FROM stg_orders o
INNER JOIN stg_order_items i
    ON o.order_id = i.order_id
LEFT JOIN (
    SELECT
        order_id,
        MAX(TRY_CAST(review_score AS INT)) AS review_score
    FROM stg_order_reviews
    GROUP BY order_id
) r ON o.order_id = r.order_id
INNER JOIN stg_customers c
    ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp IS NOT NULL
  AND o.order_purchase_timestamp != ''
  AND i.product_id IN (SELECT product_key FROM dim_product)
  AND i.seller_id  IN (SELECT seller_key  FROM dim_seller)
  AND c.customer_zip_code_prefix IN (SELECT geo_key FROM dim_geography);