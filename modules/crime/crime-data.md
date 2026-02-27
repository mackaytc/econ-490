# Crime Data Sources

Below, I've listed several of the most widely-used data sets that cover crime and crime-related outcomes. For each data set, I've provided instructions on how to access the data as well as things to look out for including coding issues, file sizes, etc.

## FBI Uniform Crime Report (UCR) — Estimated Crimes, 1979–2024

The FBI's Summary Reporting System (SRS) provides state-level counts of reported crimes from 1979 through 2024. It covers violent crime (homicide, rape, robbery, aggravated assault) and property crime (burglary, larceny, motor vehicle theft), along with state population figures for computing per-capita rates. This is the standard source for tracking long-run national crime trends and cross-state comparisons.

The data are available from the FBI's Crime Data Explorer. Note that these are *reported* crimes only; they don't capture unreported offenses, so the true incidence of crime is higher than what appears in the data.

- **Download:** Go to [Crime Data Explorer — Downloads](https://cde.ucr.cjis.gov/LATEST/webapp/#/pages/downloads), scroll to "Summary Reporting System (SRS)," and download `estimated_crimes_1979_2024.csv`.
- **File size:** Small (~200 KB, 2,388 rows).
- **Documentation:** The [FBI UCR Program page](https://www.fbi.gov/how-we-can-help-you/more-fbi-services-and-information/ucr) has details on reporting methodology and definitions.
- **Getting started:** Try computing violent crime rates per 100,000 population by state and year. Compare trends across states or look at the property-vs.-violent crime split over time.

**Data Flags:**

A couple of things to look out for while working with this data:
- **Number formatting.** Recent years (roughly 2020+) have commas and whitespace embedded in numeric columns (e.g., `" 3,148 "`). The tidyverse `read_csv()` function handles this automatically, but `read.csv()` (base R) won't — you'll get character columns instead of numbers.
- **National rows mixed with state data.** Rows with an empty `state_abbr` are national aggregates. Filter them out before doing state-level analysis. Also: there are no national aggregate rows for 2017–2020, so you'll need to sum state totals yourself for those years.
- **Two rape definitions.** The FBI changed its rape definition in 2013. `rape_legacy` covers 1979–2016; `rape_revised` covers 2013–2024, with an overlap from 2013–2016. Don't combine them without accounting for this.
- **Caveats column.** About 70 state-year rows have a `caveats` field flagging data quality issues (e.g., Illinois couldn't provide forcible rape data for 1985–2013). Check this column before treating all state-years as comparable.

---

## LAPD Calls for Service (2024–Present)

Calls for Service (CFS) data record every dispatch made by LAPD — not just crimes, but all calls: traffic stops, welfare checks, noise complaints, trespassing reports, etc. This dataset has 3.2 million records from January 2024 through February 2026, with fields for the dispatch date/time, LAPD division, reporting district, and call type. It's useful for studying police resource allocation, call volume patterns by area or time of day, and the composition of police activity.

CFS data are different from crime data. Most calls don't result in a crime report — the single most common call type is "CODE 6" (a field investigation), which accounts for about 46% of all dispatches.

- **Download:** Go to [LAPD Calls for Service 2024 to Present](https://data.lacity.org/Public-Safety/LAPD-Calls-for-Service-2024-to-Present/xjgu-z4ju/about_data) and click "Export" → CSV. The file is ~280 MB.
- **Reporting district definitions:** [LAPD Reporting Districts (LA GeoHub)](https://geohub.lacity.org/datasets/lapd-reporting-districts) — maps and shapefiles for the ~1,135 reporting districts.
- **Call type codes:** [LAPD Calls for Service Legend (Internet Archive)](https://archive.org/details/lapdcallsforservicelegend) — PDF with column definitions and call type code meanings.
- **Getting started:** Look at call volume by LAPD division or by hour of day. The `Call_Type_Text` column has human-readable descriptions. Try tabulating the top 20 call types and categorizing them as criminal vs. non-criminal.

**Data Flags:**

A couple of things to look out for while working with this data:
- **File size.** At 280+ MB and 3.2M rows, this data set can take a little while to load using `read_csv()`. Be patient, and don't try to `View()` the whole thing.
  - To speed up analysis, consider looking at specific call categories or reporting districts using `filter()`.
- **Date format.** `Dispatch_Date` looks like `"2024 May 30 12:00:00 AM"` — the midnight timestamp is a dummy value. The actual dispatch time is in the separate `Dispatch_Time` column. Parse the date with `as.Date(Dispatch_Date, format = "%Y %b %d %I:%M:%S %p")`.
- **"Outside" calls.** About 23% of records have `Area_Occ = "Outside"` with no reporting district. These are out-of-jurisdiction dispatches; filter them out if you're doing geographic analysis within LAPD divisions.
- **CFS ≠ crime.** Don't treat call counts as crime counts. Many call types are non-criminal (traffic stops, ambulance requests, "unknown trouble"). The data reflect police workload, not crime incidence.

---

## General Social Survey (GSS) 2024

The GSS is a nationally representative survey of U.S. adults conducted by NORC at the University of Chicago. The 2024 wave (3,309 respondents, 813 variables) includes questions on attitudes toward the death penalty, court harshness, gun control, marijuana legalization, fear of crime, and police use of force. It complements "hard" crime statistics with measures of social attitudes towards crime and punishment, and lets you examine how those attitudes vary by demographics.

The data file is in Stata (.dta) format. To open it in R, you'll need the `haven` package; it installs alongside tidyverse, but you need a separate `library(haven)` call to load it. Use `read_dta()` to import the file.

- **Download:** Go to [GSS Data — Stata Format](https://gss.norc.org/get-the-data/stata.html) and download the 2024 individual year file.
- **Documentation:** The [GSS Data Explorer](https://gssdataexplorer.norc.org/) lets you search variables by keyword. The codebook PDF is included in the download.
- **Key crime/punishment variables:** `cappun` (death penalty), `courts` (court harshness), `fear` (afraid to walk at night), `grass` (marijuana legalization), `gunlaw` (gun permits), `owngun`/`pistol` (gun ownership), `polhitok`/`polabuse`/`polmurdr`/`polescap`/`polattak` (police use of force).
- **Getting started:** Cross-tabulate `cappun` or `gunlaw` by `region`, `race`, or `degree` to see how crime attitudes vary across groups. Use `haven::as_factor()` to convert the Stata value labels into readable R factors.

**Data Flags:**

A couple of things to look out for while working with this data:
- **Stata format.** The `.dta` file requires `haven::read_dta()`. If you try `read_csv()`, it won't work.
- **Labelled vectors.** `haven` imports Stata value labels as a special "labelled" class. Run `as_factor()` from haven to convert them to standard R factors, or `as.numeric()` if you want the underlying codes. If you see output like `<dbl+lbl>`, that's the labelled class.
- **Split-ballot design.** The GSS only asks each question to a random subset of respondents (typically 1/3). This means many variables will be NA for 60–75% of observations — that's by design, not a data problem. For example, `courts` is missing for 76% of respondents because it was only on one ballot.
