# ECON 490 Data Lab: County Health Data

This folder has the data and the R script for the data lab. The goal of the data lab is to produce neatly formatted data analysis output. This will prepare you for producing your capstone outlines and final papers. The exact requirements for your submissions are described in the R script. You can find an example of what your submission should look like in `Sample-Data-Analysis-Output.docx`, available above (click download to view/edit in Word).

| File | Description |
|---|---|
| `ECON-490-Data-Lab-Activity.R` | R script for the lab activity with submission guidelines. |
| `ECON-490-county-health-data.csv` | County-level data set we'll analyze using the R script above. |
| `Sample-Data-Analysis-Output.docx` | Sample file displaying neatly formatted graphs and tables. |

## Data Source

The data comes from County Health Rankings & Roadmaps (CHR), a program of the University of Wisconsin Population Health Institute. Each year, CHR collects county health measures from federal data sources and publishes them in one file.

For this lab, we'll use the 2025 release of the data. It is important to note that different variables come from different sources and years, depending on how quickly each source releases its records. You can see this in the table below; as an example, flu shot rates come from Medicare records for 2022, while doctor counts come from American Medical Association records for 2021.

**Citation:** University of Wisconsin Population Health Institute. *County Health Rankings & Roadmaps 2025.* www.countyhealthrankings.org.

### *Changes to the Original Data*

I've edited the original CHR data to make it easier to work with for this activity; the original data contains more columns/variables. Additionally, the data contains aggregate US- and state-level rows, which I've dropped. I've also dropped counties with missing values, as well as Connecticut because of a change in its county boundaries. Separately, CHR leaves the doctor rate blank for counties with more than 2,000 people and no primary care physicians. The original file still records a count of zero doctors for these counties, so I've set their doctor rate to zero instead of dropping them.

The final working data set we'll use for the activity contains information on 3,116 counties in 49 states.

## Variables

| Variable | Definition | Units | Source | Year |
|---|---|---|---|---|
| `state` | State abbreviation | Text | | |
| `county` | County name | Text | | |
| `fips` | Five-digit county FIPS code | Text | | |
| `population` | Total population | People | Census Population Estimates Program | 2023 |
| `pct.rural` | Percent of the population that lives in rural areas | Percent (0 to 100) | Decennial Census | 2020 |
| `flu.shot.rate` | Percent of fee-for-service Medicare enrollees with an annual flu shot | Percent (0 to 100) | CMS Mapping Medicare Disparities Tool | 2022 |
| `doctors.per.10k` | Primary care physicians per 10,000 people | Doctors per 10,000 people | Area Health Resources Files and American Medical Association | 2021 |
| `pct.uninsured` | Percent of people under age 65 without health insurance | Percent (0 to 100) | Census Small Area Health Insurance Estimates | 2022 |
| `pct.65.older` | Percent of the population age 65 or older | Percent (0 to 100) | Census Population Estimates Program | 2023 |
| `median.income` | Median household income | Dollars | Census Small Area Income and Poverty Estimates | 2023 |

## Notes

- Most fee-for-service Medicare enrollees are age 65 or older. Thus, `flu.shot.rate` does not describe flu shots for younger people.
- Primary care physicians include M.D.s and D.O.s. The count does not include nurse practitioners or physician assistants.
- In total, 224 counties have zero primary care physicians. Nine small counties have more than 25 per 10,000 people.
