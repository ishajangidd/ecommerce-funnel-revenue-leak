USE funnel_analysis;

-- A. Headline comparison: special-day proximity vs normal
SELECT
    CASE 
        WHEN SpecialDay > 0 THEN 'Near Special Day'
        ELSE 'Normal Day'
    END AS day_category,
    COUNT(*) AS total_sessions,
    SUM(Revenue) AS purchases,
    ROUND(100.0 * SUM(Revenue) / COUNT(*), 2) AS conversion_pct
FROM sessions
GROUP BY day_category
ORDER BY conversion_pct DESC;

-- B. Granular breakdown by SpecialDay intensity
SELECT
    SpecialDay,
    COUNT(*) AS total_sessions,
    SUM(Revenue) AS purchases,
    ROUND(100.0 * SUM(Revenue) / COUNT(*), 2) AS conversion_pct,
    ROUND(AVG(PageValues), 2) AS avg_page_value,
    ROUND(AVG(BounceRates) * 100, 2) AS avg_bounce_rate_pct
FROM sessions
GROUP BY SpecialDay
ORDER BY SpecialDay;

-- C. Compute the practical-significance metric:
--    What's the relative difference between the two groups?
WITH grouped AS (
    SELECT
        CASE WHEN SpecialDay > 0 THEN 'Near Special Day' ELSE 'Normal Day' END AS day_category,
        COUNT(*) AS n,
        SUM(Revenue) AS conversions
    FROM sessions
    GROUP BY day_category
)
SELECT
    day_category,
    n,
    conversions,
    ROUND(100.0 * conversions / n, 2) AS conversion_pct
FROM grouped;