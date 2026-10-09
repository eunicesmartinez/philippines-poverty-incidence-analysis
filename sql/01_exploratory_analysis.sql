
-- Philippines Poverty Incidence Analysis
-- Data source: Philippine Statistics Authority (PSA)
-- Years available: 2018, 2021, 2023


-- Query 1: Count total records
SELECT COUNT(*) AS total_rows
FROM public.poverty_incidence;


-- Query 2: Count locations and non-missing estimates by year
SELECT
    year,
    COUNT(*) AS total_locations,
    COUNT(poverty_incidence_pct) AS non_missing_estimates
FROM public.poverty_incidence
GROUP BY year
ORDER BY year;


-- Query 3: Identify missing poverty estimates
SELECT
    geolocation,
    year
FROM public.poverty_incidence
WHERE poverty_incidence_pct IS NULL
ORDER BY year, geolocation;


-- Query 4: Check for duplicate location-year combinations
SELECT
    geolocation,
    year,
    COUNT(*) AS row_count
FROM public.poverty_incidence
GROUP BY geolocation, year
HAVING COUNT(*) > 1;


-- Query 5: Find the 10 highest poverty-incidence estimates in 2023
SELECT
    geolocation,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE year = 2023
  AND poverty_incidence_pct IS NOT NULL
ORDER BY poverty_incidence_pct DESC
LIMIT 10;


-- Query 6: Find the 10 lowest poverty-incidence estimates in 2023
SELECT
    geolocation,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE year = 2023
  AND poverty_incidence_pct IS NOT NULL
ORDER BY poverty_incidence_pct ASC
LIMIT 10;



-- Query 7: Examine very low poverty-incidence estimates across years
SELECT
    geolocation,
    year,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE geolocation IN (
    'City of Muntinlupa',
    'City of Mandaluyong',
    'City of Baguio',
    'City of Marikina',
    'City of Las Piñas',
    'City of Makati',
    'City of Parañaque',
    'City of Valenzuela',
    'City of Angeles',
    'Ilocos Norte'
)
ORDER BY geolocation, year;



-- Query 8: Compare poverty incidence between 2018 and 2023
SELECT
    p2018.geolocation,
    p2018.poverty_incidence_pct AS poverty_2018,
    p2023.poverty_incidence_pct AS poverty_2023,
    p2023.poverty_incidence_pct
        - p2018.poverty_incidence_pct AS change_percentage_points
FROM public.poverty_incidence AS p2018
JOIN public.poverty_incidence AS p2023
    ON p2018.geolocation = p2023.geolocation
WHERE p2018.year = 2018
  AND p2023.year = 2023
  AND p2018.poverty_incidence_pct IS NOT NULL
  AND p2023.poverty_incidence_pct IS NOT NULL
ORDER BY change_percentage_points ASC;



-- Query 9: Find the 10 largest increases in poverty incidence from 2018 to 2023
SELECT
    p2018.geolocation,
    p2018.poverty_incidence_pct AS poverty_2018,
    p2023.poverty_incidence_pct AS poverty_2023,
    p2023.poverty_incidence_pct
        - p2018.poverty_incidence_pct AS change_percentage_points
FROM public.poverty_incidence AS p2018
JOIN public.poverty_incidence AS p2023
    ON p2018.geolocation = p2023.geolocation
WHERE p2018.year = 2018
  AND p2023.year = 2023
  AND p2018.poverty_incidence_pct IS NOT NULL
  AND p2023.poverty_incidence_pct IS NOT NULL
ORDER BY change_percentage_points DESC
LIMIT 10;


-- Query 10: Examine national poverty incidence across reference years
SELECT
    geolocation,
    year,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE geolocation = 'PHILIPPINES'
ORDER BY year;



-- Query 11: Calculate national poverty-incidence changes between reference years
SELECT
    MAX(CASE WHEN year = 2018 THEN poverty_incidence_pct END)
        AS poverty_2018,
    MAX(CASE WHEN year = 2021 THEN poverty_incidence_pct END)
        AS poverty_2021,
    MAX(CASE WHEN year = 2023 THEN poverty_incidence_pct END)
        AS poverty_2023,
    MAX(CASE WHEN year = 2021 THEN poverty_incidence_pct END)
        - MAX(CASE WHEN year = 2018 THEN poverty_incidence_pct END)
        AS change_2018_to_2021_pp,
    MAX(CASE WHEN year = 2023 THEN poverty_incidence_pct END)
        - MAX(CASE WHEN year = 2021 THEN poverty_incidence_pct END)
        AS change_2021_to_2023_pp,
    MAX(CASE WHEN year = 2023 THEN poverty_incidence_pct END)
        - MAX(CASE WHEN year = 2018 THEN poverty_incidence_pct END)
        AS change_2018_to_2023_pp
FROM public.poverty_incidence
WHERE geolocation = 'PHILIPPINES';

