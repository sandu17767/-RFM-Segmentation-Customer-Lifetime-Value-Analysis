-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 2: RFM NTILE Scoring
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- ============================================================
-- PURPOSE:
-- Assign each customer an RFM score from 1 (worst) to 5 (best)
-- using NTILE(5) window functions across all 5,350 customers.
--
-- Scoring logic:
--   R score → ORDER BY recency_days DESC
--             (lower days = more recent = better = higher score)
--   F score → ORDER BY frequency ASC
--             (higher order count = better = higher score)
--   M score → ORDER BY monetary_value ASC
--             (higher spend = better = higher score)
--
-- Result: each customer gets an R, F, and M score (1–5)
-- and a combined rfm_total_score (3–15)
-- ============================================================

WITH raw_rfm AS (

  -- Paste Query 1 here as a CTE, or reference your saved table
  SELECT * FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.rfm_raw`

)

SELECT
  customer_id,
  first_purchase_date,
  last_purchase_date,
  recency_days,
  frequency,
  monetary_value,

  NTILE(5) OVER (ORDER BY recency_days   DESC)  AS r_score,
  NTILE(5) OVER (ORDER BY frequency      ASC)   AS f_score,
  NTILE(5) OVER (ORDER BY monetary_value ASC)   AS m_score,

  NTILE(5) OVER (ORDER BY recency_days   DESC)
  + NTILE(5) OVER (ORDER BY frequency    ASC)
  + NTILE(5) OVER (ORDER BY monetary_value ASC)  AS rfm_total_score

FROM raw_rfm
ORDER BY rfm_total_score DESC
