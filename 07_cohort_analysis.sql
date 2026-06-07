-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 07_cohort_analysis.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : Monthly customer cohort retention analysis
-- =============================================

USE OlistRetailDW;
GO

WITH customer_first_order AS (
    SELECT
        f.customer_key,
        MIN(d.year * 100 + d.month)         AS cohort_month_key,
        MIN(CAST(d.full_date AS DATE))       AS first_order_date
    FROM fact_orders f
    INNER JOIN dim_date d ON f.date_key = d.date_key
    WHERE f.order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY f.customer_key
),
customer_orders AS (
    SELECT
        f.customer_key,
        d.year * 100 + d.month              AS order_month_key,
        CAST(d.full_date AS DATE)           AS order_date,
        c.cohort_month_key,
        c.first_order_date,
        DATEDIFF(
            MONTH,
            c.first_order_date,
            CAST(d.full_date AS DATE)
        )                                   AS month_number
    FROM fact_orders f
    INNER JOIN dim_date d ON f.date_key = d.date_key
    INNER JOIN customer_first_order c ON f.customer_key = c.customer_key
    WHERE f.order_status NOT IN ('cancelled', 'unavailable')
),
cohort_size AS (
    SELECT
        cohort_month_key,
        COUNT(DISTINCT customer_key)        AS cohort_customers
    FROM customer_first_order
    GROUP BY cohort_month_key
),
cohort_retention AS (
    SELECT
        co.cohort_month_key,
        co.month_number,
        COUNT(DISTINCT co.customer_key)     AS active_customers
    FROM customer_orders co
    GROUP BY co.cohort_month_key, co.month_number
)
SELECT
    cr.cohort_month_key,
    cs.cohort_customers                     AS cohort_size,
    cr.month_number,
    cr.active_customers,
    ROUND(
        cr.active_customers * 100.0
        / NULLIF(cs.cohort_customers, 0)
    , 2)                                    AS retention_rate_pct
FROM cohort_retention cr
INNER JOIN cohort_size cs ON cr.cohort_month_key = cs.cohort_month_key
WHERE cr.month_number <= 12
ORDER BY cr.cohort_month_key, cr.month_number;