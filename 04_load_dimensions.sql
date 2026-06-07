-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 04_load_dimensions.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Clean and load star schema dimensions
-- =============================================

USE OlistRetailDW;
GO

-- dim_date
INSERT INTO dim_date (date_key, full_date, year, month, month_name, quarter, week_of_year)
SELECT DISTINCT
    CAST(FORMAT(CAST(order_purchase_timestamp AS DATE), 'yyyyMMdd') AS INT)     AS date_key,
    CAST(order_purchase_timestamp AS DATE)                                       AS full_date,
    YEAR(CAST(order_purchase_timestamp AS DATE))                                 AS year,
    MONTH(CAST(order_purchase_timestamp AS DATE))                                AS month,
    DATENAME(MONTH, CAST(order_purchase_timestamp AS DATE))                      AS month_name,
    DATEPART(QUARTER, CAST(order_purchase_timestamp AS DATE))                    AS quarter,
    DATEPART(WEEK, CAST(order_purchase_timestamp AS DATE))                       AS week_of_year
FROM stg_orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_purchase_timestamp != '';

-- dim_customer
INSERT INTO dim_customer (customer_key, customer_unique_id, city, state)
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    TRIM(customer_city)     AS city,
    TRIM(customer_state)    AS state
FROM stg_customers
WHERE customer_id IS NOT NULL;

-- dim_product
INSERT INTO dim_product (product_key, category_name_english, product_weight_g, photos_qty)
SELECT
    p.product_id,
    ISNULL(t.product_category_name_english, 'Unknown')  AS category_name_english,
    TRY_CAST(p.product_weight_g AS DECIMAL(10,2))        AS product_weight_g,
    TRY_CAST(p.product_photos_qty AS INT)                AS photos_qty
FROM stg_products p
LEFT JOIN stg_product_category_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_id IS NOT NULL;

-- dim_seller
INSERT INTO dim_seller (seller_key, seller_city, seller_state)
SELECT DISTINCT
    seller_id,
    TRIM(seller_city)   AS seller_city,
    TRIM(seller_state)  AS seller_state
FROM stg_sellers
WHERE seller_id IS NOT NULL;

-- dim_geography
INSERT INTO dim_geography (geo_key, zip_code_prefix, latitude, longitude, city, state)
SELECT
    geolocation_zip_code_prefix                         AS geo_key,
    geolocation_zip_code_prefix                         AS zip_code_prefix,
    AVG(TRY_CAST(geolocation_lat AS DECIMAL(10,6)))     AS latitude,
    AVG(TRY_CAST(geolocation_lng AS DECIMAL(10,6)))     AS longitude,
    MAX(geolocation_city)                               AS city,
    MAX(geolocation_state)                              AS state
FROM stg_geolocation
WHERE geolocation_zip_code_prefix IS NOT NULL
GROUP BY geolocation_zip_code_prefix;