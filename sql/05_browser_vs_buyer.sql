USE funnel_analysis;

-- A. Get the median ProductRelated_Duration to define "engaged"
--    MySQL doesn't have MEDIAN(), so we approximate using percentile via window function
WITH ranked AS (
    SELECT 
        ProductRelated_Duration,
        ROW_NUMBER() OVER (ORDER BY ProductRelated_Duration) AS rn,
        COUNT(*) OVER () AS total_count
    FROM sessions
    WHERE ProductRelated_Duration > 0
)
SELECT ProductRelated_Duration AS median_engaged_duration
FROM ranked
WHERE rn = FLOOR(total_count / 2) + 1;

-- B. Behavioral comparison: engaged buyers vs engaged non-buyers
--    "Engaged" = ProductRelated_Duration > 600 seconds (~10 min)
--    Adjust the 600 threshold based on Step A's median if very different
WITH engaged_sessions AS (
    SELECT *
    FROM sessions
    WHERE ProductRelated_Duration > 600
)
SELECT
    CASE WHEN Revenue = 1 THEN 'Bought' ELSE 'Did Not Buy' END AS outcome,
    COUNT(*) AS session_count,
    ROUND(AVG(ProductRelated), 1) AS avg_product_pages,
    ROUND(AVG(ProductRelated_Duration), 0) AS avg_seconds_on_products,
    ROUND(AVG(BounceRates) * 100, 2) AS avg_bounce_rate_pct,
    ROUND(AVG(ExitRates) * 100, 2) AS avg_exit_rate_pct,
    ROUND(AVG(PageValues), 2) AS avg_page_value,
    ROUND(AVG(Administrative), 1) AS avg_admin_pages,
    ROUND(AVG(Informational), 1) AS avg_info_pages
FROM engaged_sessions
GROUP BY outcome
ORDER BY outcome;

-- C. PageValue bucket analysis: how does conversion change as PageValue rises?
SELECT
    CASE
        WHEN PageValues = 0 THEN '0 (No value pages)'
        WHEN PageValues > 0 AND PageValues < 10 THEN '0-10'
        WHEN PageValues >= 10 AND PageValues < 50 THEN '10-50'
        WHEN PageValues >= 50 AND PageValues < 100 THEN '50-100'
        ELSE '100+'
    END AS page_value_bucket,
    COUNT(*) AS sessions,
    SUM(Revenue) AS purchases,
    ROUND(100.0 * SUM(Revenue) / COUNT(*), 2) AS conversion_pct
FROM sessions
GROUP BY page_value_bucket
ORDER BY 
    CASE page_value_bucket
        WHEN '0 (No value pages)' THEN 1
        WHEN '0-10' THEN 2
        WHEN '10-50' THEN 3
        WHEN '50-100' THEN 4
        ELSE 5
    END;