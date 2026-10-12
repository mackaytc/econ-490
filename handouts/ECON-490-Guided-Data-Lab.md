# ECON 490 Capstone Lab Activity 1

## Building a Working Data Set

Tonight we build a data set from scratch and turn it into paper-ready output. We all use the same data so we can work through it together. Next week you do the same thing with your own data.

You will submit two files before you leave.

---

## The Data

We use the Current Population Survey. The CPS is a monthly survey run by the Census Bureau and the BLS. It produces the official unemployment rate. It also covers earnings, education, health insurance, poverty, and migration.

A lot of capstone projects end up using CPS data. Learn it now.

Download two files from Canvas.

- `individual-level-CPS-data.Rds` is the data
- `Individual-Level CPS Data Documentation (PDF)` describes every variable

The data covers 2018 through 2022. Each row is a person. There are 834,419 rows and 34 variables.

Keep the documentation open while you work.

---

## What You Will Produce

Three pieces of output.

1. A summary statistics table showing poverty rates by Census region
2. A figure showing the national poverty rate over time
3. A regression of poverty rates on Census region

The R script walks you through each one. Work through it in order and answer the questions as you go.

---

## Getting Output Out of R

Never paste raw console output into Word. Console output is for you. Tables are for your reader.

You have two options. Pick one.

### Option 1. Type the numbers

Print the object in R. Read the numbers off the screen. Type them into a table you built in Word.

This is slower. It also works every time and forces you to look at each number.

### Option 2. Export to Excel

Write the object to a spreadsheet.

```r
write_csv(region.summary, "region-summary-table.csv")
```

Open that file in Excel. Round the numbers. Kill the scientific notation. Then build a blank table in Word and paste the cleaned columns across.

You can copy a whole column at once. Highlight all the cells first.

For regression output, run it through `tidy()` before exporting.

```r
write_csv(tidy(poverty.model), "regression-output.csv")
```

### Figures

Save the figure straight from R.

```r
ggsave("poverty-over-time.png", poverty.plot, width = 7, height = 4.5)
```

Then insert the image into Word.

---

## Formatting Rules

These apply to everything you submit this semester.

**Use real labels.** No R variable names anywhere. Write "Poverty Rate" instead of `poverty.rate`. Write "Employment Status" instead of `emp.indicator`. Nobody knows what your variable names mean.

**Round.** Poverty rates need three decimals at most. Dollar figures need none. Extra decimals are noise.

**Title everything.** Every table and figure gets a title. "Summary Statistics for Poverty Rates by Census Region" works. "Table 1" does not.

**Add notes.** One or two sentences under each table and figure. State the data source. Add anything a reader needs to understand what they are looking at.

**Interpret your regression.** Two to three sentences. Is the coefficient statistically significant at the 5 percent level? Is it large enough to matter? Compare it to the average value of your outcome.

---

## Submission Checklist

Check each of these before you upload.

- [ ] Your `.R` file has your name in the file name
- [ ] Every question in the script has an answer
- [ ] Your Word document holds one summary table, one figure, and your regression results
- [ ] Every table and figure has a title and notes
- [ ] No R variable names appear anywhere in the Word document
- [ ] Numbers are rounded
- [ ] You wrote two to three sentences interpreting the regression

Write the interpretation yourself. I can tell when it came from a chatbot, and it is painful to read.
