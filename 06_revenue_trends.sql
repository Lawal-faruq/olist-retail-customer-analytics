-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 06_revenue_trends.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Month-over-month revenue trend analysis
-- =============================================

USE OlistRetailDW;
GO

WITH monthly_revenue AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        SUM(f.order_value)              AS total_revenue,
        COUNT(DISTINCT f.order_id)      AS total_orders,
        COUNT(DISTINCT f.customer_key)  AS unique_customers,
        AVG(f.order_value)              AS avg_order_value
    FROM fact_orders f
    INNER JOIN dim_date d ON f.date_key = d.date_key
    WHERE f.order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY d.year, d.month, d.month_name
),
revenue_with_growth AS (
    SELECT
        year,
        month,
        month_name,
        total_revenue,
        total_orders,
        unique_customers,
        avg_order_value,
        LAG(total_revenue) OVER (ORDER BY year, month)      AS prev_month_revenue,
        LAG(total_orders)  OVER (ORDER BY year, month)      AS prev_month_orders,
        ROUND(
            (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month))
            / NULLIF(LAG(total_revenue) OVER (ORDER BY year, month), 0) * 100
        , 2)                                                AS revenue_growth_pct,
        ROUND(
            (total_orders - LAG(total_orders) OVER (ORDER BY year, month))
            / NULLIF(CAST(LAG(total_orders) OVER (ORDER BY year, month) AS FLOAT), 0) * 100
        , 2)                                                AS order_growth_pct
    FROM monthly_revenue
)
SELECT
    year,
    month,
    month_name,
    total_revenue,
    total_orders,
    unique_customers,
    ROUND(avg_order_value, 2)                               AS avg_order_value,
    prev_month_revenue,
    revenue_growth_pct,
    order_growth_pct,
    SUM(total_revenue) OVER (
        PARTITION BY year
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    )                                                       AS cumulative_revenue_ytd
FROM revenue_with_growth
ORDER BY year, month;