-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 02_create_staging_tables.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Raw landing tables for Olist CSVs
-- =============================================

USE OlistRetailDW;
GO

CREATE TABLE stg_orders (
    order_id                        VARCHAR(50),
    customer_id                     VARCHAR(50),
    order_status                    VARCHAR(30),
    order_purchase_timestamp        VARCHAR(30),
    order_approved_at               VARCHAR(30),
    order_delivered_carrier_date    VARCHAR(30),
    order_delivered_customer_date   VARCHAR(30),
    order_estimated_delivery_date   VARCHAR(30)
);

CREATE TABLE stg_order_items (
    order_id            VARCHAR(50),
    order_item_id       INT,
    product_id          VARCHAR(50),
    seller_id           VARCHAR(50),
    shipping_limit_date VARCHAR(30),
    price               DECIMAL(10,2),
    freight_value       DECIMAL(10,2)
);

CREATE TABLE stg_order_reviews (
    review_id       VARCHAR(50),
    order_id        VARCHAR(50),
    review_score    INT
);

CREATE TABLE stg_customers (
    customer_id                 VARCHAR(50),
    customer_unique_id          VARCHAR(50),
    customer_zip_code_prefix    VARCHAR(10),
    customer_city               VARCHAR(100),
    customer_state              VARCHAR(50)
);

CREATE TABLE stg_products (
    product_id                  VARCHAR(50),
    product_category_name       VARCHAR(100),
    product_name_lenght         INT,
    product_description_lenght  INT,
    product_photos_qty          INT,
    product_weight_g            DECIMAL(10,2),
    product_length_cm           DECIMAL(10,2),
    product_height_cm           DECIMAL(10,2),
    product_width_cm            DECIMAL(10,2)
);

CREATE TABLE stg_sellers (
    seller_id               VARCHAR(50),
    seller_zip_code_prefix  VARCHAR(10),
    seller_city             VARCHAR(100),
    seller_state            VARCHAR(50)
);

CREATE TABLE stg_geolocation (
    geolocation_zip_code_prefix VARCHAR(10),
    geolocation_lat             DECIMAL(10,6),
    geolocation_lng             DECIMAL(10,6),
    geolocation_city            VARCHAR(100),
    geolocation_state           VARCHAR(50)
);

CREATE TABLE stg_product_category_translation (
    product_category_name           VARCHAR(100),
    product_category_name_english   VARCHAR(100)
);