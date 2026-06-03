USE funnel_analysis;


-- A. Baseline funnel + revenue parameters (nested)
WITH baseline AS (
    SELECT
        COUNT(*) AS landed,
        SUM(CASE WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0) OR PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS engaged_browse,
        SUM(CASE WHEN PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS checkout_intent,
        SUM(Revenue) AS purchased,
        SUM(CASE WHEN Revenue = 1 THEN PageValues ELSE 0 END) AS total_revenue_proxy,
        ROUND(AVG(CASE WHEN Revenue = 1 THEN PageValues END), 2) AS avg_revenue_per_purchase
    FROM sessions
)
SELECT * FROM baseline;

-- B. Counterfactual: improve each stage by 10pp
WITH baseline AS (
    SELECT
        COUNT(*) AS landed,
        SUM(CASE WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0) OR PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS engaged_browse,
        SUM(CASE WHEN PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS checkout_intent,
        SUM(Revenue) AS purchased,
        ROUND(AVG(CASE WHEN Revenue = 1 THEN PageValues END), 2) AS avg_rev_per_purchase
    FROM sessions
),
rates AS (
    SELECT
        landed, engaged_browse, checkout_intent, purchased, avg_rev_per_purchase,
        1.0 * engaged_browse / landed AS r1,
        1.0 * checkout_intent / engaged_browse AS r2,
        1.0 * purchased / checkout_intent AS r3
    FROM baseline
)
SELECT
    'Stage 1->2 (Landed to Engaged)' AS intervention,
    purchased AS baseline_purchases,
    ROUND(landed * LEAST(r1 + 0.10, 1.0) * r2 * r3, 0) AS modeled_purchases,
    ROUND(landed * LEAST(r1 + 0.10, 1.0) * r2 * r3 - purchased, 0) AS additional_purchases,
    ROUND((landed * LEAST(r1 + 0.10, 1.0) * r2 * r3 - purchased) * avg_rev_per_purchase, 0) AS recoverable_revenue
FROM rates
UNION ALL
SELECT
    'Stage 2->3 (Engaged to Checkout Intent)',
    purchased,
    ROUND(landed * r1 * LEAST(r2 + 0.10, 1.0) * r3, 0),
    ROUND(landed * r1 * LEAST(r2 + 0.10, 1.0) * r3 - purchased, 0),
    ROUND((landed * r1 * LEAST(r2 + 0.10, 1.0) * r3 - purchased) * avg_rev_per_purchase, 0)
FROM rates
UNION ALL
SELECT
    'Stage 3->4 (Checkout Intent to Purchase)',
    purchased,
    ROUND(landed * r1 * r2 * LEAST(r3 + 0.10, 1.0), 0),
    ROUND(landed * r1 * r2 * LEAST(r3 + 0.10, 1.0) - purchased, 0),
    ROUND((landed * r1 * r2 * LEAST(r3 + 0.10, 1.0) - purchased) * avg_rev_per_purchase, 0)
FROM rates;