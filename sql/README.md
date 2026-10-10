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
