# Manning Article Data

## Source

Data comes from the replication package for:

> Manning, Alan. "The Elusive Employment Effect of the Minimum Wage." *Journal of Economic Perspectives* 35, no. 1 (2021): 3-26.

The full replication package is available from the AEA at [openicpsr.org/openicpsr/project/122964](https://www.openicpsr.org/openicpsr/project/122964). The underlying data sources are:

- **Employment data**: IPUMS Current Population Survey, Basic Monthly Files 1979-2019 (Flood et al., 2020)
- **Minimum wage data**: Vaghul and Zipperer (2019), "Historical State and Sub-state Minimum Wages," v1.2.0

## File: `manning-teen-employment.csv`

A cleaned extract used for the ECON 490 minimum wages coding activity. Contains state-quarter observations for **teens (ages 16-19)** across all 50 states plus DC, 1979-2019.

| Variable | Description |
|---|---|
| `year` | Survey year (1979-2019) |
| `quarter` | Quarter (1-4) |
| `state.fips` | State FIPS code |
| `teen.emp.rate` | Employment-to-population ratio for 16-19 year olds |
| `min.wage` | State minimum wage in dollars |

**How it was constructed**: Starting from the processed analysis file `ManningElusiveEmployment.dta` (produced by Manning's `DataPreparationCPS.do` script), filtered to teens (`agecat == 1`), converted log employment ratio to levels (`exp(ln)`), converted log minimum wage in cents to dollars (`exp(lmin) / 100`), and exported to CSV. See `create_csv.R` in the full replication package for the exact script.

## Other files in this folder

The full replication package (Stata `.do` files, documentation, raw/processed `.dta` files) is stored locally but not tracked in git due to file size. Only `manning-teen-employment.csv` and this README are committed.
