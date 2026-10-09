-- Philippines Poverty Incidence Analysis
-- Reusable PostgreSQL views and function
-- Data source: Philippine Statistics Authority (PSA)
-- Available reference years: 2018, 2021, 2023

-- View 1: National poverty incidence by year
CREATE OR REPLACE VIEW public.v_national_poverty_trend AS
SELECT
    year,
    poverty_incidence_pct
FROM public.poverty_incidence
WHERE geolocation = 'PHILIPPINES';

-- View 2: Compare poverty incidence between 2018 and 2023
CREATE OR REPLACE VIEW public.v_poverty_change_2018_2023 AS
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
  AND p2023.poverty_incidence_pct IS NOT NULL;

-- Function: Calculate the change for a location between two years
CREATE OR REPLACE FUNCTION public.get_poverty_change(
    p_geolocation TEXT,
    p_start_year INTEGER,
    p_end_year INTEGER
)
RETURNS NUMERIC
LANGUAGE SQL
STABLE
AS $$
    SELECT
        end_year.poverty_incidence_pct
        - start_year.poverty_incidence_pct
    FROM public.poverty_incidence AS start_year
    JOIN public.poverty_incidence AS end_year
        ON start_year.geolocation = end_year.geolocation
    WHERE start_year.geolocation = p_geolocation
      AND start_year.year = p_start_year
      AND end_year.year = p_end_year
      AND start_year.poverty_incidence_pct IS NOT NULL
      AND end_year.poverty_incidence_pct IS NOT NULL;
$$;
