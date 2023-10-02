use portfolioprojects;

select * from fatalities;

-- 1. the number of reported incidents
select count(*) as total_incidents from fatalities;

-- 2. calculating the year-to-year change in the number of fatal incidents, excluding the year 2022
SELECT 
    YEAR(incident_date) AS incident_year,
    COUNT(*) AS fatalities,
    ROUND(((COUNT(*) - LAG(COUNT(*)) OVER (ORDER BY YEAR(incident_date))) * 100.0 / LAG(COUNT(*)) OVER (ORDER BY YEAR(incident_date))), 0) AS year_to_year_change
FROM 
    fatalities
WHERE 
    YEAR(incident_date) != 2022
GROUP BY 
    YEAR(incident_date)
ORDER BY
    YEAR(incident_date);

-- 3. the total number of fatalities that received a citation
SELECT COUNT(*) AS fatalities_with_citation
FROM fatalities
WHERE citation != 'unknown';

-- 4. the day of the week with the most fatalities
SELECT
Top 1
    day_of_week,
    COUNT(*) AS fatalities_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fatalities)), 2) AS overall_percentage
FROM 
    fatalities
GROUP BY 
    day_of_week
ORDER BY 
    fatalities_count DESC;

-- 5. the total number of fatalities involving welding
SELECT COUNT(*) AS welding_fatalities
FROM fatalities
WHERE description LIKE '%welding%';

-- 6. calculates the last 5 fatalities during welding.
SELECT *
FROM (
    SELECT TOP 5 *
    FROM fatalities
    WHERE description LIKE '%welding%'
    ORDER BY incident_date DESC
) AS subquery
ORDER BY incident_date ASC;

-- 7. the top 5 states with the most fatal incidents
SELECT 
Top 5
state, COUNT(*) AS total_fatalities
FROM fatalities
GROUP BY state
ORDER BY total_fatalities DESC;

-- 8. the top 5 states that had the most workplace fatalities from stabbings
SELECT
Top 5
state, COUNT(*) AS total_fatalities
FROM fatalities
WHERE description LIKE '%stab%'
GROUP BY state
ORDER BY total_fatalities DESC;

-- 9. the top 10 states that had the most workplace fatalities from shootings
SELECT
Top 10
state, COUNT(*) AS total_fatalities
FROM fatalities
WHERE description LIKE '%shoot%'
GROUP BY state
ORDER BY total_fatalities DESC;

-- 10. the total number of shooting deaths per year
SELECT 
    YEAR(incident_date) AS incident_year,
    COUNT(*) AS shooting_deaths
FROM 
    fatalities
WHERE 
    description LIKE '%shooting%'
GROUP BY 
    YEAR(incident_date)
ORDER BY 
    shooting_deaths DESC;