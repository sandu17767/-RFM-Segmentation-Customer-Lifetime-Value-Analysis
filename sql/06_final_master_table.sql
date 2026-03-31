-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 6: Combined RFM + CLV Master Table
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- ============================================================
-- PURPOSE:
-- Single end-to-end query combining all previous steps:
--   → Data cleaning and base table
--   → Raw RFM calculation
--   → NTILE(5) scoring
--   → Segment classification
--   → CLV projection with reliability flag
--
-- Output: rfm_final.csv — 5,350 UK customers, fully profiled
-- This is the master dataset used for the Power BI dashboard
-- and all visualisations in this project.
-- ============================================================

WITH base AS (

  SELECT
    `Customer ID`                        AS customer_id,
    Invoice                              AS invoice,
    InvoiceDate                          AS invoice_date,
    Quantity * Price                     AS revenue

  FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.online_retail`

  WHERE
    Country = 'United Kingdom'
    AND `Customer ID` IS NOT NULL
    AND NOT STARTS_WITH(CAST(Invoice AS STRING), 'C')
    AND Quantity > 0
    AND Price > 0

),

raw_rfm AS (

  SELECT
    customer_id,
    MIN(DATE(invoice_date))                                        AS first_purchase_date,
    MAX(DATE(invoice_date))                                        AS last_purchase_date,
    DATE_DIFF(DATE('2011-12-11'), MAX(DATE(invoice_date)), DAY)   AS recency_days,
    COUNT(DISTINCT invoice)                                        AS frequency,
    ROUND(SUM(revenue), 2)                                         AS monetary_value
  FROM base
  GROUP BY customer_id

),

rfm_scored AS (

  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency_days   DESC)  AS r_score,
    NTILE(5) OVER (ORDER BY frequency      ASC)   AS f_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC)   AS m_score,
    NTILE(5) OVER (ORDER BY recency_days   DESC)
    + NTILE(5) OVER (ORDER BY frequency    ASC)
    + NTILE(5) OVER (ORDER BY monetary_value ASC)  AS rfm_total_score
  FROM raw_rfm

),

segmented AS (

  SELECT
    *,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
        THEN 'Champions'
      WHEN r_score >= 2 AND f_score >= 3 AND m_score >= 3
        AND NOT (r_score >= 4 AND f_score >= 4 AND m_score >= 4)
        THEN 'Loyal'
      WHEN r_score >= 3 AND f_score <= 3 AND m_score <= 3
        AND NOT (r_score >= 4 AND f_score >= 4 AND m_score >= 4)
        THEN 'Potential Loyalists'
      WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4
        THEN "Can't Lose Them"
      WHEN r_score <= 2 AND f_score >= 2 AND m_score >= 3
        THEN 'At Risk'
      WHEN r_score <= 2 AND f_score <= 2 AND m_score <= 2
        AND recency_days > 300
        THEN 'Lost'
      WHEN r_score <= 2 AND recency_days BETWEEN 200 AND 300
        THEN 'Hibernating'
      ELSE 'Lost'
    END AS segment
  FROM rfm_scored

)

SELECT
  s.customer_id,
  s.first_purchase_date,
  s.last_purchase_date,
  s.recency_days,
  s.frequency,
  s.monetary_value,
  s.r_score,
  s.f_score,
  s.m_score,
  s.rfm_total_score,
  s.segment,

  ROUND(s.monetary_value / NULLIF(s.frequency, 0), 2)             AS avg_order_value,

  GREATEST(
    DATE_DIFF(s.last_purchase_date, s.first_purchase_date, MONTH), 1
  )                                                                AS active_months,

  ROUND(
    s.monetary_value / GREATEST(
      DATE_DIFF(s.last_purchase_date, s.first_purchase_date, MONTH), 1
    ), 2
  )                                                                AS monthly_spend_rate,

  ROUND(
    s.monetary_value / GREATEST(
      DATE_DIFF(s.last_purchase_date, s.first_purchase_date, MONTH), 1
    ) * 12, 2
  )                                                                AS projected_12m_clv,

  CASE
    WHEN GREATEST(
      DATE_DIFF(s.last_purchase_date, s.first_purchase_date, MONTH), 1
    ) >= 3 THEN 'Reliable'
    ELSE 'Unreliable'
  END                                                              AS clv_reliability

FROM segmented s
ORDER BY projected_12m_clv DESC
