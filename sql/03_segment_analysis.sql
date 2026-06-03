USE funnel_analysis;

-- ============================================================
-- 03_segment_analysis.sql (v2 - strictly nested stages)
-- ============================================================

-- A. By VisitorType
WITH funnel_by_visitor AS (
    SELECT
        VisitorType,
        COUNT(*) AS landed,
        SUM(CASE WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0) OR PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS engaged_browse,
        SUM(CASE WHEN PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS checkout_intent,
        SUM(Revenue) AS purchased
    FROM sessions
    GROUP BY VisitorType
)
SELECT
    VisitorType, landed, purchased,
    ROUND(100.0 * engaged_browse / landed, 2) AS rate_landed_to_engaged,
    ROUND(100.0 * checkout_intent / engaged_browse, 2) AS rate_engaged_to_intent,
    ROUND(100.0 * purchased / checkout_intent, 2) AS rate_intent_to_purchase,
    ROUND(100.0 * purchased / landed, 2) AS overall_conversion
FROM funnel_by_visitor
ORDER BY overall_conversion DESC;

-- B. By Weekend
WITH funnel_by_weekend AS (
    SELECT
        CASE WHEN Weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
        COUNT(*) AS landed,
        SUM(CASE WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0) OR PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS engaged_browse,
        SUM(CASE WHEN PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS checkout_intent,
        SUM(Revenue) AS purchased
    FROM sessions
    GROUP BY Weekend
)
SELECT
    day_type, landed, purchased,
    ROUND(100.0 * engaged_browse / landed, 2) AS rate_landed_to_engaged,
    ROUND(100.0 * checkout_intent / engaged_browse, 2) AS rate_engaged_to_intent,
    ROUND(100.0 * purchased / checkout_intent, 2) AS rate_intent_to_purchase,
    ROUND(100.0 * purchased / landed, 2) AS overall_conversion
FROM funnel_by_weekend
ORDER BY overall_conversion DESC;

-- C. By Month
WITH funnel_by_month AS (
    SELECT
        Month,
        COUNT(*) AS landed,
        SUM(CASE WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0) OR PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS engaged_browse,
        SUM(CASE WHEN PageValues > 0 OR Revenue = 1 THEN 1 ELSE 0 END) AS checkout_intent,
        SUM(Revenue) AS purchased
    FROM sessions
    GROUP BY Month
)
SELECT
    Month, landed, purchased,
    ROUND(100.0 * engaged_browse / landed, 2) AS rate_landed_to_engaged,
    ROUND(100.0 * checkout_intent / engaged_browse, 2) AS rate_engaged_to_intent,
    ROUND(100.0 * purchased / checkout_intent, 2) AS rate_intent_to_purchase,
    ROUND(100.0 * purchased / landed, 2) AS overall_conversion
FROM funnel_by_month
ORDER BY 
    FIELD(Month, 'Jan','Feb','Mar','Apr','May','June','Jul','Aug','Sep','Oct','Nov','Dec');