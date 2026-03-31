-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 1: Raw RFM Values
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- Reference date: 2011-12-11
-- ============================================================
-- PURPOSE:
-- Calculate the three core RFM components for every customer:
--   Recency    → days since last purchase
--   Frequency  → number of distinct orders
--   Monetary   → total revenue generated
-- This is the foundation every subsequent query builds on.
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
    AND NOT STARTS_WITH(CAST(Invoice AS STRING), 'C')  -- exclude cancellations
    AND Quantity > 0
    AND Price > 0

)

SELECT
  customer_id,
  MIN(DATE(invoice_date))                                         AS first_purchase_date,
  MAX(DATE(invoice_date))                                         AS last_purchase_date,
  DATE_DIFF(DATE('2011-12-11'), MAX(DATE(invoice_date)), DAY)    AS recency_days,
  COUNT(DISTINCT invoice)                                         AS frequency,
  ROUND(SUM(revenue), 2)                                          AS monetary_value

FROM base
GROUP BY customer_id
ORDER BY monetary_value DESC
