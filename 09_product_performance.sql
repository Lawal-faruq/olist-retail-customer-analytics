-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 09_product_performance.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Product and category performance analysis
-- =============================================

USE OlistRetailDW;
GO

WITH category_metrics AS (
    SELECT
        p.category_name_english                         AS category,
        COUNT(DISTINCT f.order_id)                      AS total_orders,
        COUNT(DISTINCT f.customer_key)                  AS unique_customers,
        SUM(f.order_value)                              AS total_revenue,
        ROUND(AVG(f.order_value), 2)                    AS avg_order_value,
        ROUND(AVG(CAST(f.review_score AS FLOAT)), 2)    AS avg_review_score
    FROM fact_orders f
    INNER JOIN dim_product p ON f.product_key = p.product_key
    WHERE f.order_status NOT IN ('cancelled', 'unavailable')
      AND p.category_name_english IS NOT NULL
    GROUP BY p.category_name_english
),
category_ranked AS (
    SELECT
        category,
        total_orders,
        unique_customers,
        ROUND(total_revenue, 2)                         AS total_revenue,
        avg_order_value,
        avg_review_score,
        DENSE_RANK() OVER (ORDER BY total_revenue DESC)     AS revenue_rank,
        DENSE_RANK() OVER (ORDER BY total_orders DESC)      AS orders_rank,
        DENSE_RANK() OVER (ORDER BY avg_review_score DESC)  AS satisfaction_rank,
        ROUND(
            total_revenue * 100.0 / SUM(total_revenue) OVER ()
        , 2)                                            AS revenue_share_pct
    FROM category_metrics
)
SELECT
    category,
    total_orders,
    unique_customers,
    total_revenue,
    avg_order_value,
    avg_review_score,
    revenue_rank,
    orders_rank,
    satisfaction_rank,
    revenue_share_pct,
    SUM(revenue_share_pct) OVER (
        ORDER BY revenue_rank
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                   AS cumulative_revenue_share_pct
FROM category_ranked
ORDER BY revenue_rank;