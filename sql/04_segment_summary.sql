-- ============================================================
-- PROJECT 2: RFM Segmentation & Customer Lifetime Value
-- Query 4: Segment Summary Table
-- Dataset: UCI Online Retail (UK customers only)
-- Tool: BigQuery Standard SQL
-- ============================================================
-- PURPOSE:
-- Aggregate all customers by segment to produce the high-level
-- summary table used in the executive summary and dashboard.
--
-- Output includes per-segment:
--   - Customer count and % of total customers
--   - Total revenue and % of total revenue
--   - Average revenue per customer
--   - Average recency, frequency, and order value
--
-- This is the table behind the key findings:
--   → Champions: 22% of customers, 66.8% of revenue
--   → At Risk: £2.2M at risk, Champion-level AOV (£420 vs £421)
-- ============================================================

WITH segmented AS (

  -- Paste Query 3 here as a CTE, or reference your saved table
  SELECT * FROM `project-8290c7a9-d26b-4112-9b1.ecommerce.rfm_segments`

),

totals AS (
  SELECT
    COUNT(DISTINCT customer_id)  AS total_customers,
    SUM(monetary_value)          AS total_revenue
  FROM segmented
)

SELECT
  seg.segment,
  COUNT(seg.customer_id)                                              AS customer_count,
  ROUND(
    COUNT(seg.customer_id) / tot.total_customers * 100, 1
  )                                                                   AS pct_of_customers,
  ROUND(SUM(seg.monetary_value), 0)                                   AS total_revenue,
  ROUND(
    SUM(seg.monetary_value) / tot.total_revenue * 100, 1
  )                                                                   AS pct_of_revenue,
  ROUND(AVG(seg.monetary_value), 0)                                   AS avg_revenue_per_customer,
  ROUND(AVG(seg.recency_days), 0)                                     AS avg_recency_days,
  ROUND(AVG(seg.frequency), 1)                                        AS avg_frequency,
  ROUND(AVG(seg.monetary_value / NULLIF(seg.frequency, 0)), 0)        AS avg_order_value

FROM segmented seg
CROSS JOIN totals tot
GROUP BY seg.segment, tot.total_customers, tot.total_revenue
ORDER BY total_revenue DESC
