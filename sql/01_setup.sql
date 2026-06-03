USE funnel_analysis;

CREATE TABLE sessions;

CREATE TABLE sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    Administrative INT,
    Administrative_Duration DECIMAL(12, 6),
    Informational INT,
    Informational_Duration DECIMAL(12, 6),
    ProductRelated INT,
    ProductRelated_Duration DECIMAL(12, 6),
    BounceRates DECIMAL(12, 10),
    ExitRates DECIMAL(12, 10),
    PageValues DECIMAL(12, 6),
    SpecialDay DECIMAL(3, 2),
    Month VARCHAR(10),
    OperatingSystems INT,
    Browser INT,
    Region INT,
    TrafficType INT,
    VisitorType VARCHAR(30),
    Weekend VARCHAR(5),
    Revenue VARCHAR(5)
);

USE funnel_analysis;

-- Verify the load first
SELECT COUNT(*) AS total_rows FROM sessions;

-- See sample values in Weekend/Revenue
SELECT Weekend, Revenue, COUNT(*) AS cnt
FROM sessions
GROUP BY Weekend, Revenue;

-- Now convert text to boolean
ALTER TABLE sessions
    MODIFY COLUMN Weekend BOOLEAN,
    MODIFY COLUMN Revenue BOOLEAN;
-- This auto-converts 'TRUE' → 1 and 'FALSE' → 0 in modern MySQL

-- Verify the conversion
SELECT 
    COUNT(*) AS total_sessions,
    SUM(Revenue) AS purchases,
    ROUND(100.0 * SUM(Revenue) / COUNT(*), 2) AS conversion_rate_pct
FROM sessions;

-- Added one row manually
INSERT INTO sessions (Administrative, Administrative_Duration, Informational, Informational_Duration, ProductRelated, ProductRelated_Duration, BounceRates, ExitRates, PageValues, SpecialDay, Month, OperatingSystems, Browser, Region, TrafficType, VisitorType, Weekend, Revenue)
   VALUES (0, 0, 0, 0, 1, 0, 0.2, 0.2, 0, 0, 'Feb', 1, 1, 1, 1, 'Returning_Visitor', 'FALSE', 'FALSE');

USE funnel_analysis;

-- Workbench's safe update mode blocks UPDATE without primary-key WHERE.
-- Disable it temporarily for the conversion.
SET SQL_SAFE_UPDATES = 0;

-- 1. Delete the manual test row
DELETE FROM sessions WHERE session_id = 1;

-- 2. Convert text 'TRUE'/'FALSE' to '1'/'0' first 
--    (safer than relying on auto-cast during ALTER)
UPDATE sessions SET Weekend = '1' WHERE Weekend = 'TRUE';
UPDATE sessions SET Weekend = '0' WHERE Weekend = 'FALSE';
UPDATE sessions SET Revenue = '1' WHERE Revenue = 'TRUE';
UPDATE sessions SET Revenue = '0' WHERE Revenue = 'FALSE';

-- 3. Now safely convert the column types
ALTER TABLE sessions
    MODIFY COLUMN Weekend BOOLEAN,
    MODIFY COLUMN Revenue BOOLEAN;

-- Re-enable safe updates
SET SQL_SAFE_UPDATES = 1;

-- 4. Final verification
SELECT COUNT(*) AS total_rows FROM sessions;

SELECT 
    COUNT(*) AS total_sessions,
    SUM(Revenue) AS purchases,
    ROUND(100.0 * SUM(Revenue) / COUNT(*), 2) AS conversion_rate_pct
FROM sessions;

SELECT Month, COUNT(*) AS sessions
FROM sessions
GROUP BY Month
ORDER BY sessions DESC;

SELECT VisitorType, COUNT(*) AS sessions
FROM sessions
GROUP BY VisitorType;



