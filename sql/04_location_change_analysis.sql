
-- Compare reported poverty incidence in 2018 and 2023.
-- Change is measured in percentage points.
-- Locations missing either estimate are not ranked.

WITH location_changes AS (
    SELECT
        geolocation,
        MAX(poverty_incidence_pct)
            FILTER (WHERE year = 2018) AS incidence_2018,
        MAX(poverty_incidence_pct)
            FILTER (WHERE year = 2023) AS incidence_2023
    FROM poverty_incidence
    WHERE year IN (2018, 2023)
    GROUP BY geolocation
),
changes AS (
    SELECT
        geolocation,
        incidence_2018,
        incidence_2023,
        incidence_2023 - incidence_2018 AS change_pp
    FROM location_changes
)
SELECT
    geolocation,
    incidence_2018,
    incidence_2023,
    ROUND(change_pp, 2) AS change_percentage_points,
    CASE
        WHEN change_pp IS NULL THEN NULL
        ELSE RANK() OVER (
            ORDER BY change_pp DESC NULLS LAST
        )
    END AS increase_rank,
    CASE
        WHEN change_pp IS NULL THEN NULL
        ELSE RANK() OVER (
            ORDER BY change_pp ASC NULLS LAST
        )
    END AS decrease_rank,
    CASE
        WHEN incidence_2018 IS NULL
          OR incidence_2023 IS NULL
            THEN 'Missing estimate'
        WHEN change_pp > 0 THEN 'Increased'
        WHEN change_pp < 0 THEN 'Decreased'
        ELSE 'No change'
    END AS change_status
FROM changes
ORDER BY change_pp DESC NULLS LAST, geolocation;
