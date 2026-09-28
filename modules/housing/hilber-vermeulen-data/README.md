# Hilber and Vermeulen Article Data

Source: Hilber, Christian A. L., and Wouter Vermeulen. "The Impact of Supply Constraints on House Prices in England." *Economic Journal* 126(591), 2016, 358–405. [Replication supplement](https://onlinelibrary.wiley.com/doi/10.1111/ecoj.12213).

`housing-panel.csv` contains 12,355 observations: 353 local planning authorities, annually from 1974 through 2008.

| Variable | Description |
|---|---|
| place.id | ONS local authority code |
| place.name | Local authority name |
| county | County under pre-1996 boundaries |
| year | Calendar year |
| log.price | Log real mix-adjusted house price index (1974 = 100) |
| log.earnings | Log real average gross male weekly earnings, in 2008 pounds |
| refusal.rate | Average refusal rate for major projects, 1979–2008 (0–1) |

**Construction:** From `datasets.zip/dta files/data LPA.dta`, retained `lpa_code`, `lpa_name`, `county_pre_96`, `year`, `lrindex2`, `lmale_earn_real`, and `refusal_maj_7908`, respectively. Excluded the Council of the Isles of Scilly, following the original analysis. No further transformations or exclusions; all selected fields are complete.

The price index measures appreciation since 1974, not comparable prices in pounds. Earnings before 1996 are measured at county level. Refusal rates are constant within place.

The original ZIP and preparation script are stored locally in `archive/housing-data-preparation/` (not tracked in git).
