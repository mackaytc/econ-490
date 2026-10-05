# Exploring Variation

For ECON 340, running 1-2 regressions is generally sufficient for a paper. In 490, the goal is to concretely answer a question or say something interesting, and the way to get there is by exploring variation in either (1) the level of one economic variable as a function of other variables, or (2) a relationship between economic variables.

This page shows four ways to do that in your 2nd stage. Each section starts with the general setting where the method fits, then walks through an example using data we've seen in class, with short R code examples. Throughout, assume your 1st stage looks something like this:

```r
model.1 <- lm_robust(Y ~ X1 + X2 + X3, data = my.data)
```

Remember: we want to include *all* reasonably available explanatory variables in your 1st stage, then run something substantively different in your 2nd stage. Adding one more control doesn't general define a new/distinct stage.

| Method | What it tells you | Works best with |
|---|---|---|
| [Interaction Terms](#interaction-terms) | Does the X-Y relationship differ across groups? | A grouping variable with a few levels |
| [TWFE Visualization](#twfe-visualization) | What variation is your FE estimate using? | Panel data (units observed over time) |
| [Regression Residuals](#regression-residuals) | Which observations over- or under-perform the model? | Units you know something about |
| [Oaxaca-Blinder Decomposition](#oaxaca-blinder-decomposition) | Why do two groups have different average Ys? | Two groups and individual-level Xs |

## Interaction Terms

**SETUP:** Your 1st stage estimates a relationship between Y and X, and you suspect that relationship is stronger for some groups than others (regions, time periods, types of people, etc.). An interaction term gives each group its own slope on X, so you can test whether the relationship actually differs across groups and by how much.

**EXAMPLE:** Suppose we've loaded the ACS data from [Coding Activity 2](../coding-activities/ECON-490-Coding-Activity-2.R), with household income, age, education, employment status, and state (California, Florida, or Texas) for each person. Our 1st stage regresses log household income on a college indicator plus controls. Is the college premium the same in all three states? We can use an *interaction term* to explore this in our 2nd stage.

- In `Y = β0 + β1X + u`, everyone shares the *same* β1. Interacting `college` with `state_name` gives each state its own college premium.
- Stick to a binary or "limited" factor variable, and make sure you have plenty of data in every group. Interactions increase the amount of data you need.

**Slides:** [Using Interaction Terms](../slides/ECON%20490%20Metrics%20Slides%20-%20Using%20Interaction%20Terms.pdf) · **Practice:** [Coding Activity 4](../coding-activities/ECON-490-Coding-Activity-4.R)

```r
# acs.data after the same cleaning as Coding Activity 2 (positive income, ages 20-60)
acs.data <- mutate(acs.data, log.hhincome = log(hhincome),
                   college = ifelse(education == 3, 1, 0))

model.1 <- lm_robust(log.hhincome ~ college + age + employed + state_name, data = acs.data)

# 2nd stage: let the college premium differ by state
model.2 <- lm_robust(log.hhincome ~ college + age + employed + state_name +
                       college:state_name, data = acs.data)

# College premium in California (the reference state): coef on college
# College premium in Florida: coef on college + coef on college:state_nameflorida
```

## TWFE Visualization

**SETUP:** You have panel data (the same units observed over multiple years), and your 1st stage compares pooled OLS to a TWFE regression with unit and year FE. Adding the FE changes your coefficient. You can plot the variation left over after removing the FE, and you can check which set of FE drove the change.

**EXAMPLE:** Suppose we've loaded the Hilber and Vermeulen (2016) housing panel from the [Housing Markets and Fixed Effects](../modules/housing/ECON%20490%20-%20Housing%20Markets%20and%20Fixed%20Effects.R) activity, with log house prices and log earnings for 353 places in England from 1974-2008. The earnings coefficient falls from about 1.33 in pooled OLS to about 0.43 with place and year FE. How should we interpret this change? What does it mean? We can use a *residualized scatterplot* and a breakdown of the coefficient change to explore this in our 2nd stage.

- **Residualized scatterplot:**
  - Run two regressions with only place and year FE as explanatory variables, one with log price as the outcome and one with log earnings. Save the residuals from each.
  - Plot the two sets of residuals against each other. The coefficient from this scatterplot's fitted line matches the TWFE coefficient.
  - Compare this to the raw scatterplot. What patterns disappear once we remove the FE?
  - Report the share of the variation in earnings absorbed by the FE. In the example below, this is about 94%, so the TWFE estimate relies on the remaining 6%.
- **Which FE drove the change?**
  - Save the estimated place and year FE from the TWFE model.
  - Regress each set of FE on log earnings. The two coefficients add up to the pooled coefficient minus the TWFE coefficient.
  - In the example below, the year FE account for nearly all of the 0.90 drop. The pooled estimate mostly reflects prices and earnings rising together over time, not permanent differences across places.
  - Both models need to use the same sample.

**Practice:** [Minimum Wages and TWFE](../modules/minimum-wages/ECON%20490%20-%20Minimum%20Wages%20and%20TWFE.R) (see "Going Further" for another residualized scatterplot)

```r
# housing.data has one row per place-year: log.price, log.earnings, place.id, year
# Drop NAs first so every model below uses the same rows

library(fixest)  # feols(y ~ x | place.id + year) is lm(y ~ x + factor(place.id) + factor(year))

m.pooled <- feols(log.price ~ log.earnings, data = housing.data)
m.twfe   <- feols(log.price ~ log.earnings | place.id + year, data = housing.data)

# (1) Residualized scatterplot: remove place + year FE from log price and log earnings
housing.data$y.resid <- resid(feols(log.price ~ 1 | place.id + year, data = housing.data))
housing.data$x.resid <- resid(feols(log.earnings ~ 1 | place.id + year, data = housing.data))

ggplot(housing.data, aes(x = x.resid, y = y.resid)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE)   # coefficient matches m.twfe

# Share of the variation in log earnings absorbed by the FE
1 - var(housing.data$x.resid) / var(housing.data$log.earnings)

# (2) Which FE drove the change in the coefficient?
fe <- fixef(m.twfe)
housing.data$fe.place <- fe$place.id[as.character(housing.data$place.id)]
housing.data$fe.year  <- fe$year[as.character(housing.data$year)]

coef(feols(fe.place ~ log.earnings, data = housing.data))["log.earnings"]  # from place FE
coef(feols(fe.year ~ log.earnings, data = housing.data))["log.earnings"]   # from year FE
# These two add up to coef(m.pooled) - coef(m.twfe)
```

If your models include other controls, add them to the right side of every regression above.

## Regression Residuals

**SETUP:** Your 1st stage gives you a predicted Y for every observation based on its Xs. Residuals tell you which observations have a higher or lower Y than we'd expect based on their Xs. This method works best when your observations are units you know something about from your own experience, like NBA players, cities, or neighborhoods, so you can talk about who stands out and why drawing on your background knowledge.

**EXAMPLE:** Suppose we've loaded the King County home sales data from the [Week 4 In-Class R Activity](../coding-activities/ECON-490-In-Class-R-Activity-Week-4.R), with price, square footage, bedrooms, bathrooms, year built, and zip code. We can start by estimating the relationship between log price and home characteristics. To extend this analysis, we can use the *regression residuals* method to explore what neighborhoods sell for more (or less) than we might expect based on their observable characteristics.

- $Residual = actual~Y − predicted~Y$: Positive residuals mean actual Y is *higher* than we'd expect based on the Xs, and negative residuals mean it's *lower*.
- Run the regression, store residuals as a new variable, sort, and look at the biggest and smallest values. Then apply background knowledge: what do the outliers share? You might not be able to measure it in a regression, but you can talk about the pattern in intuitive terms.
- You can present the results in a table, a scatterplot, or verbally.

**NOTE:** You'll want to keep in mind several points when working with this method.

- Residuals always have an average value of 0 whenever your regression has an intercept, so the focus is on outliers (observations with very high and very low values). 
- Residuals are always conditional on your Xs. If you change your Xs, you'll get different residuals.
- If your observations fall into groups, you can use `group_by()` and `summarize()` to compute the average residual for each group. This shows which groups do better or worse than expected overall.
  - For example, if each row is a state in a given year, grouping by state tells you which states have higher (or lower) Y than predicted across all years.
  - This only works if the group **isn't** in your regression. If you include `factor(state)`, residuals average exactly 0 within every state, so the state averages will all be 0.


**Slides:** [Using Regression Residuals](../slides/ECON%20490%20Metrics%20Slides%20-%20Using%20Residuals.pdf)

```r
# Use lm() here; lm_robust() doesn't store residuals
model.1 <- lm(log(price) ~ log(sqft_living) + bedrooms + bathrooms + yr_built,
              data = home.data)

home.data$resid.price <- resid(model.1)

# Individual sales furthest above the model's prediction
home.data %>%
  arrange(desc(resid.price)) %>%
  select(price, sqft_living, zipcode, resid.price) %>%
  head(10)

# Average residual by zip code: which neighborhoods consistently sell above or below?
home.data %>%
  group_by(zipcode) %>%
  summarize(mean.resid = mean(resid.price), n.sales = n()) %>%
  arrange(desc(mean.resid))
```

When we run this, the top zip codes are Medina, Bellevue, and Mercer Island, where homes sell for roughly 0.5-0.8 log points more than their size and features predict. At the bottom are Auburn, Federal Way, and Kent, at roughly 0.45 log points less. What do those groups have in common? Think about commutes to Seattle and Bellevue jobs, lake access, schools, etc. None of these are in the model.

## Oaxaca-Blinder Decomposition

**SETUP:** Your data has two groups with different average Ys, and you want to know why. Run your 1st stage separately for each group, and the Oaxaca-Blinder decomposition splits the gap into two parts: one explained by the groups having different Xs, and one left over because the same Xs are associated with different Ys in each group.

**EXAMPLE:** Suppose we've loaded the ACS data from [Coding Activity 2](../coding-activities/ECON-490-Coding-Activity-2.R) again. Homeowners have higher household income than renters, about 0.6 log points on average. Owners are also older and more likely to have a college degree. How much of the income gap comes from those differences, and how much is left over? We can use an **Oaxaca-Blinder decomposition** to explore this in our 2nd stage.

- The **explained** part comes from the groups having different average Xs (owners are older and more educated). The **unexplained** part comes from the same Xs being associated with different incomes across groups (different coefficients).
- Report the explained share, e.g., "Differences in age, education, and employment account for X% of the raw gap." Be careful with the unexplained part. It's everything your model doesn't capture, omitted variables included. The split also depends on which group's coefficients you use as the benchmark, so try it both ways.

Think of this as the interaction model taken all the way: every X gets its own slope for each group.

```r
# acs.data with log.hhincome and college created as in the interaction example

m.owners  <- lm(log.hhincome ~ college + age + employed, data = filter(acs.data, renter == 0))
m.renters <- lm(log.hhincome ~ college + age + employed, data = filter(acs.data, renter == 1))

# Average X values in each group (the leading 1 is for the intercept)
x.owners  <- colMeans(model.matrix(m.owners))
x.renters <- colMeans(model.matrix(m.renters))

raw.gap     <- sum(x.owners * coef(m.owners)) - sum(x.renters * coef(m.renters))  # = gap in mean log.hhincome
explained   <- sum((x.owners - x.renters) * coef(m.owners))                       # different Xs
unexplained <- sum(x.renters * (coef(m.owners) - coef(m.renters)))                # different coefficients

explained / raw.gap   # share of the gap explained by differences in Xs
```

When we run this, differences in age, education, and employment explain only about 6% of the owner-renter income gap (7% using renters' coefficients as the benchmark). What else might matter? Think about the number of earners in the household, wealth, etc.

If you use factor controls, every level needs to show up in both groups or the coefficients won't line up. This by-hand version doesn't give you SEs. The `oaxaca` package does, if you need them.
