-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 01_create_schema.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Star schema DDL for Power BI reporting
-- =============================================

USE OlistRetailDW;
GO

CREATE TABLE dim_customer (
    customer_key        VARCHAR(50)     PRIMARY KEY,
    customer_unique_id  VARCHAR(50)     NOT NULL,
    city                VARCHAR(100),
    state               VARCHAR(10)
);

CREATE TABLE dim_product (
    product_key             VARCHAR(50)     PRIMARY KEY,
    category_name_english   VARCHAR(100),
    product_weight_g        DECIMAL(10,2),
    photos_qty              INT
);

CREATE TABLE dim_seller (
    seller_key      VARCHAR(50)     PRIMARY KEY,
    seller_city     VARCHAR(100),
    seller_state    VARCHAR(50)
);

CREATE TABLE dim_date (
    date_key        INT             PRIMARY KEY,
    full_date       DATE            NOT NULL,
    year            INT             NOT NULL,
    month           INT             NOT NULL,
    month_name      VARCHAR(20)     NOT NULL,
    quarter         INT             NOT NULL,
    week_of_year    INT             NOT NULL
);

CREATE TABLE dim_geography (
    geo_key             VARCHAR(20)     PRIMARY KEY,
    zip_code_prefix     VARCHAR(10),
    latitude            DECIMAL(10,6),
    longitude           DECIMAL(10,6),
    city                VARCHAR(100),
    state               VARCHAR(50)
);

CREATE TABLE fact_orders (
    order_id        VARCHAR(50)     NOT NULL,
    order_item_id   INT             NOT NULL,
    customer_key    VARCHAR(50)     NOT NULL REFERENCES dim_customer(customer_key),
    product_key     VARCHAR(50)     NOT NULL REFERENCES dim_product(product_key),
    seller_key      VARCHAR(50)     NOT NULL REFERENCES dim_seller(seller_key),
    date_key        INT             NOT NULL REFERENCES dim_date(date_key),
    geo_key         VARCHAR(20)     NOT NULL REFERENCES dim_geography(geo_key),
    order_value     DECIMAL(10,2),
    freight_value   DECIMAL(10,2),
    review_score    INT,
    order_status    VARCHAR(30),
    CONSTRAINT PK_fact_orders PRIMARY KEY (order_id, order_item_id)
);