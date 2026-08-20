# ECON 490 Capstone Lab Activity 2

## Estimating Your Specification

Last week you ran the pipeline on CPS data. Tonight you run it on yours.

Everything you build tonight goes in your paper. This is not practice.

Bring your data file. Bring any code you have already written.

---

## Before You Arrive

You need a data file you can open in R. If your data is not ready, tell me at the start of class rather than halfway through.

If you are using CPS data for your project, you already have everything you need from last week.

---

## What You Will Produce

Four pieces of output.

1. A sample construction note
2. A summary statistics table
3. A three-column regression table
4. One figure

---

## The Sample Construction Note

Readers need to know how you got from the raw file to the rows you analyzed.

Track your counts as you filter.

```r
nrow(my.data)
nrow(my.sample)
```

Then write it as a sentence.

> The raw CPS file contains 834,419 person-year observations. I restrict the sample to adults aged 25 to 64, leaving 424,220 observations.

That sentence goes in the Data section of your paper. Most student papers leave it out. Yours will not.

Every restriction needs a reason. "Adults aged 25 to 64" is a choice. Defend it.

---

## The Three-Column Table

This is the heart of tonight.

You estimate the same relationship three times. Each model adds controls.

```r
model.1 <- lm_robust(my.outcome ~ my.x, data = my.sample)
model.2 <- lm_robust(my.outcome ~ my.x + age + sex, data = my.sample)
model.3 <- lm_robust(my.outcome ~ my.x + age + sex + as.factor(educ),
                     data = my.sample)
```

Export each one.

```r
write_csv(tidy(model.1), "model-1.csv")
```

Then build a Word table with one column per model. It looks like this.

| Variable | (1) | (2) | (3) |
|---|---|---|---|
| Main explanatory variable | 0.201 | 0.207 | 0.177 |
| | (0.002) | (0.002) | (0.002) |
| Demographic controls | No | Yes | Yes |
| Education controls | No | No | Yes |
| Observations | 424,220 | 424,220 | 424,220 |

Standard errors go in parentheses under each coefficient.

Now watch the coefficient move across the columns. In the example above it drops from 0.207 to 0.177 once education enters. Education was doing work that the first two models credited to the main variable.

That movement is omitted variable bias. You saw it on a slide in Week 4. Tonight you see it in your own data.

If your coefficient barely moves, say so. That is a result too. It means your controls were not absorbing much.

---

## Your Figure

Pick whichever fits your variables.

A scatter plot with a fitted line works for two continuous variables. A bar chart of group means works when your explanatory variable is categorical.

Label the axes in plain English. Give it a title. Name your data source in the caption.

---

## Interpretation

Answer four questions in your Word document.

1. What does the Model 3 coefficient mean? Give the units. Use the form "a one-unit increase in X is associated with a B-unit change in Y."
2. Is it statistically significant at the 5 percent level?
3. Is it large? Compare it to the mean of your outcome. A coefficient can be significant and still be too small to care about.
4. What is the most important variable you could not control for? Which way would it bias your estimate?

Question 4 is the one that makes your paper honest. Every capstone has an omitted variable. Name yours before a reader finds it.

---

## Finished Early?

Add a fourth model with an interaction term. Test whether your relationship differs across groups. You built these in Coding Activity 4.

```r
model.4 <- lm_robust(my.outcome ~ my.x * my.group + age + sex, data = my.sample)
```

---

## Submission Checklist

- [ ] Your `.R` file has your name in the file name
- [ ] Every question in the script has an answer
- [ ] Your Word document holds the sample construction note, summary statistics, the three-column table, and your figure
- [ ] Standard errors appear under each coefficient
- [ ] Every table and figure has a title and notes
- [ ] No R variable names appear anywhere in the Word document
- [ ] You answered all four interpretation questions in your own words
