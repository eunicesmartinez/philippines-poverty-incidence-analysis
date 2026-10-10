-- Data Quality Checks
-- Philippines Poverty Incidence Analysis

-- Check 1: Verify the total number of records
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) = 414 AS passed
FROM public.poverty_incidence;


-- Check 2: Verify the expected reference years
SELECT
    ARRAY_AGG(DISTINCT year ORDER BY year) AS reference_years,
    COUNT(DISTINCT year) = 3 AS passed
FROM public.poverty_incidence;


-- Check 3: Check for duplicate location-year combinations
SELECT
    geolocation,
    year,
    COUNT(*) AS duplicate_count
FROM public.poverty_incidence
GROUP BY geolocation, year
HAVING COUNT(*) > 1;


-- Check 4: Check for percentages outside the valid range
SELECT
    geolocation,
    year,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE poverty_incidence_pct < 0
   OR poverty_incidence_pct > 100;


-- Check 5: Report missing poverty estimates
SELECT
    year,
    COUNT(*) FILTER (
        WHERE poverty_incidence_pct IS NULL
    ) AS missing_estimates,
    COUNT(*) AS total_locations
FROM public.poverty_incidence
GROUP BY year
ORDER BY year;
