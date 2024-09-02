/*
Productivity and Compensation Trends

Skills used: Aggregate Functions: Used to compute overall statistics, Filtering: Applied conditions to narrow down the data, 
Logical Operators, CASE Statement, Subqueries, CTEs 

*/

SELECT 
    MAX(net_productivity_per_hour_worked) AS max_productivity,
    MIN(net_productivity_per_hour_worked) AS min_productivity,
    AVG(net_productivity_per_hour_worked) AS avg_productivity,
    MAX(average_compensation) AS max_compensation,
    MIN(average_compensation) AS min_compensation,
    AVG(average_compensation) AS avg_compensation
FROM 
    productivity_n_hourly_compensation;

--This query calculates the maximum, minimum, and average values for net productivity per hour worked and average compensation.

SELECT 
    year,
    net_productivity_per_hour_worked,
    average_compensation
FROM 
    productivity_n_hourly_compensation
WHERE 
    net_productivity_per_hour_worked > 80
    AND average_compensation < 45;

--This query retrieves records where net productivity per hour worked is greater than 80 and average compensation is less than 45.

SELECT 
    year,
    net_productivity_per_hour_worked,
    CASE
        WHEN net_productivity_per_hour_worked > avg_productivity THEN 'High Productivity'
        WHEN net_productivity_per_hour_worked BETWEEN avg_productivity * 0.9 AND avg_productivity * 1.1 THEN 'Average Productivity'
        ELSE 'Low Productivity'
    END AS productivity_category
FROM 
    productivity_n_hourly_compensation,
    (SELECT AVG(net_productivity_per_hour_worked) AS avg_productivity FROM productivity_n_hourly_compensation) AS subquery;

--This query categorizes each year’s productivity into 'High', 'Average', or 'Low' based on the overall average productivity.

SELECT 
    year,
    average_compensation
FROM 
    productivity_n_hourly_compensation
WHERE 
    average_compensation > (
        SELECT AVG(average_compensation)
        FROM productivity_n_hourly_compensation
        WHERE year BETWEEN 2012 AND 2021
    );

--This query Retrieves records where the average compensation is greater than the average compensation from 2012 to 2021.
