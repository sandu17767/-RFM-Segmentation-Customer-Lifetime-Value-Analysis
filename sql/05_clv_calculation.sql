-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 5: Customer Lifetime Value Calculation
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- ============================================================
-- PURPOSE:
-- Calculate projected 12-month CLV for each customer using:
--   AOV               = total revenue / number of orders
--   active_months     = months between first and last purchase
--   monthly_spend     = total revenue / active_months
--   projected_12m_clv = monthly_spend × 12
--
-- Reliability filter:
--   Customers with fewer than 3 active months are flagged as
--   'Unreliable' — a single large order can produce a
--   misleadingly inflated 12-month projection.
-- ============================================================

WITH segmented AS (

  -- Paste Query 3 here as a CTE, or reference your saved table
  SELECT * FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.rfm_segments`

),

clv_calc AS (

  SELECT
    customer_id,
    segment,
    first_purchase_date,
    last_purchase_date,
    recency_days,
    frequency,
    monetary_value,

    ROUND(monetary_value / NULLIF(frequency, 0), 2)                   AS avg_order_value,

    GREATEST(
      DATE_DIFF(last_purchase_date, first_purchase_date, MONTH), 1
    )                                                                   AS active_months,

    ROUND(
      monetary_value / GREATEST(
        DATE_DIFF(last_purchase_date, first_purchase_date, MONTH), 1
      ), 2
    )                                                                   AS monthly_spend_rate

  FROM segmented

)

SELECT
  customer_id,
  segment,
  first_purchase_date,
  last_purchase_date,
  recency_days,
  frequency,
  monetary_value,
  avg_order_value,
  active_months,
  monthly_spend_rate,

  ROUND(monthly_spend_rate * 12, 2)                                    AS projected_12m_clv,

  CASE
    WHEN active_months >= 3 THEN 'Reliable'
    ELSE 'Unreliable'
  END                                                                   AS clv_reliability

FROM clv_calc
ORDER BY projected_12m_clv DESC
