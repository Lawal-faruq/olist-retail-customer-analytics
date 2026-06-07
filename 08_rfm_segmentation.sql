-- =============================================
-- Project : Olist Retail Customer Analytics
-- Script  : 08_rfm_segmentation.sql
-- Author  : Lawal Faruq Damilola
-- Purpose : RFM customer segmentation
-- =============================================

USE OlistRetailDW;
GO

WITH rfm_base AS (
    SELECT
        f.customer_key,
        MAX(CAST(d.full_date AS DATE))      AS last_order_date,
        COUNT(DISTINCT f.order_id)          AS frequency,
        SUM(f.order_value)                  AS monetary
    FROM fact_orders f
    INNER JOIN dim_date d ON f.date_key = d.date_key
    WHERE f.order_status NOT IN ('cancelled', 'unavailable')
    GROUP BY f.customer_key
),
rfm_scores AS (
    SELECT
        customer_key,
        last_order_date,
        frequency,
        ROUND(monetary, 2)                  AS monetary,
        DATEDIFF(
            DAY,
            last_order_date,
            CAST('2018-10-01' AS DATE)
        )                                   AS recency_days,
        NTILE(5) OVER (
            ORDER BY DATEDIFF(DAY, last_order_date,
                CAST('2018-10-01' AS DATE)) ASC
        )                                   AS recency_score,
        NTILE(5) OVER (
            ORDER BY frequency ASC
        )                                   AS frequency_score,
        NTILE(5) OVER (
            ORDER BY monetary ASC
        )                                   AS monetary_score
    FROM rfm_base
),
rfm_segments AS (
    SELECT
        customer_key,
        last_order_date,
        recency_days,
        frequency,
        monetary,
        recency_score,
        frequency_score,
        monetary_score,
        recency_score + frequency_score + monetary_score    AS rfm_total,
        CASE
            WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4  THEN 'Champions'
            WHEN recency_score >= 3
             AND frequency_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 4
             AND frequency_score <= 2 THEN 'Recent Customers'
            WHEN recency_score <= 2
             AND frequency_score >= 3 THEN 'At Risk'
            WHEN recency_score = 1
             AND frequency_score = 1  THEN 'Lost Customers'
            ELSE                           'Potential Loyalists'
        END                                                 AS segment
    FROM rfm_scores
)
SELECT
    segment,
    COUNT(customer_key)                                     AS customer_count,
    ROUND(AVG(recency_days), 0)                             AS avg_recency_days,
    ROUND(AVG(CAST(frequency AS FLOAT)), 2)                 AS avg_frequency,
    ROUND(AVG(monetary), 2)                                 AS avg_monetary_value,
    ROUND(SUM(monetary), 2)                                 AS total_revenue_contribution
FROM rfm_segments
GROUP BY segment
ORDER BY total_revenue_contribution DESC;