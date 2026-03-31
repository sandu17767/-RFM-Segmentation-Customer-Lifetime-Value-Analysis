-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 3: Segment Classification
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- ============================================================
-- PURPOSE:
-- Classify each customer into one of 7 business segments
-- based on their R, F, and M scores using CASE logic.
--
-- Segment definitions:
--   Champions         → High recency, high frequency, high spend
--   Loyal             → Regular buyers, strong frequency and spend
--   Potential Loyalists → Recent buyers, not yet habitual
--   At Risk           → Previously strong, now going silent
--   Can't Lose Them   → Very high value, very low recency
--   Hibernating       → Low engagement across all dimensions
--   Lost              → Lowest recency, low value — disengaged
--
-- Known limitation:
--   Wholesale/B2B buyers (low F, high M) may be misclassified
--   as Lost. Customer 16446 (£168K, 2 orders) is a clear example.
-- ============================================================

WITH rfm_scored AS (

  -- Paste Query 2 here as a CTE, or reference your saved table
  SELECT * FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.rfm_scores`

)

SELECT
  customer_id,
  first_purchase_date,
  last_purchase_date,
  recency_days,
  frequency,
  monetary_value,
  r_score,
  f_score,
  m_score,
  rfm_total_score,

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
ORDER BY rfm_total_score DESC
