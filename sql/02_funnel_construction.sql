USE funnel_analysis;



WITH funnel AS (
    SELECT
        COUNT(*) AS landed,
        SUM(CASE 
            WHEN (ProductRelated >= 2 OR ProductRelated_Duration > 0)
              OR PageValues > 0 
              OR Revenue = 1
            THEN 1 ELSE 0 
        END) AS engaged_browse,
        SUM(CASE 
            WHEN PageValues > 0 OR Revenue = 1
            THEN 1 ELSE 0 
        END) AS checkout_intent,
        SUM(Revenue) AS purchased
    FROM sessions
)
SELECT
    landed,
    engaged_browse,
    checkout_intent,
    purchased,
    ROUND(100.0 * engaged_browse / landed, 2) AS rate_landed_to_engaged,
    ROUND(100.0 * checkout_intent / engaged_browse, 2) AS rate_engaged_to_intent,
    ROUND(100.0 * purchased / checkout_intent, 2) AS rate_intent_to_purchase,
    ROUND(100.0 * purchased / landed, 2) AS overall_conversion
FROM funnel;