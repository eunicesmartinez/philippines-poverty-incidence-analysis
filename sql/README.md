# SQL Database Design

## Database

PostgreSQL database: `philippines_poverty`

## Main Table: `poverty_incidence`

This table stores reported poverty incidence estimates for 138 geographic labels across three reference years: 2018, 2021, and 2023.

### Columns

- `geolocation` (TEXT): Geographic label provided by the source.
- `year` (INTEGER): Reference year.
- `poverty_incidence_pct` (NUMERIC): Reported poverty incidence percentage. Can be NULL when an estimate is unavailable.

## Keys and Constraints

- **Primary key:** Composite key consisting of `geolocation` and `year`.
- **Allowed years:** 2018, 2021, and 2023.
- **Valid percentages:** Poverty incidence must be between 0 and 100 when reported.
- **Required fields:** Geographic labels and years cannot be NULL.
- **Missing values:** Unavailable estimates are preserved as NULL.

## Database Objects

- `v_national_poverty_trend`: View of national poverty incidence by year.
- `v_poverty_change_2018_2023`: View comparing poverty incidence between 2018 and 2023.
- `get_poverty_change(...)`: Function that calculates the percentage-point difference for a location between two years.

## Design Considerations

The source combines national, regional, provincial, and city-level geographic labels. Some province-level estimates explicitly exclude separately reported cities. Geographic labels are therefore preserved from the source rather than assigned to a hierarchy without verification.

The dataset contains three reference years, not continuous annual observations. Changes describe differences between reported estimates and do not establish causation.

## Setup and Execution

1. Create a PostgreSQL database named `philippines_poverty`.
2. Create the `poverty_incidence` table using the schema and constraints described above.
3. Import `data/processed/poverty_incidence_clean.csv` into the `poverty_incidence` table. Ensure the CSV columns map to `geolocation`, `year`, and `poverty_incidence_pct`.
4. Run `01_exploratory_analysis.sql` to explore the data.
5. Run `02_views_and_functions.sql` to create reusable views and the change-calculation function.
6. Run `03_data_quality_checks.sql` to validate data quality.
7. Run `04_location_change_analysis.sql` to compare reported poverty incidence between 2018 and 2023.

The SQL scripts assume the database and table have already been created and the cleaned CSV has been imported.

## SQL Analysis Files

### `01_exploratory_analysis.sql`

Contains exploratory queries for examining the dataset, summarizing poverty incidence, and identifying locations with high reported poverty incidence.

### `02_views_and_functions.sql`

Creates reusable database objects:

- `v_national_poverty_trend`: Summarizes national poverty incidence by reference year.
- `v_poverty_change_2018_2023`: Compares reported poverty incidence between 2018 and 2023.
- `get_poverty_change(...)`: Calculates the percentage-point difference for a selected location between two years.

### `03_data_quality_checks.sql`

Contains validation queries to examine missing estimates, duplicate location-year records, valid percentage ranges, and other potential data quality issues.

### `04_location_change_analysis.sql`

Compares reported poverty incidence by geographic label between 2018 and 2023.

- Uses common table expressions (CTEs) to organize the analysis into readable steps.
- Uses conditional aggregation to compare estimates across years.
- Calculates changes in percentage points.
- Uses window functions to rank increases and decreases.
- Flags locations with missing estimates and leaves their change rankings unassigned.

## Interpretation Notes

- An increase or decrease describes a difference between reported estimates; it does not establish why the change occurred.
- Rankings include different geographic levels and should not be interpreted as direct comparisons between equivalent geographic units.
- Large changes should be verified against the original source and its methodology before drawing conclusions.
- Missing estimates are preserved rather than imputed.
