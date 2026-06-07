-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 03_load_staging_tables.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Load raw CSVs into staging tables
-- Note    : Update file paths to match your local
--           folder before running
-- =============================================

USE OlistRetailDW;
GO

BULK INSERT stg_orders
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_orders_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_order_items
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_order_items_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_order_reviews
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_order_reviews_clean.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_customers
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_customers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_products
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_products_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_sellers
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_sellers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_geolocation
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\olist_geolocation_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);

BULK INSERT stg_product_category_translation
FROM 'C:\Users\USER\Desktop\Adedayo\Faruq Project\Retail customer analytics\product_category_name_translation.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);