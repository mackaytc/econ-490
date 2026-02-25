################################################################################
# ECON 490: Minimum Wages and Two-Way Fixed Effects
################################################################################

# In this activity, we'll cover:

#   - Working with state-year panel data
#   - Demeaning data to remove group-level variation
#   - Understanding what fixed effects regressions actually do
#   - Running a two-way fixed effects (TWFE) model

# This is a follow-up to the MW and OVB activity. We'll use the same Manning
# (2021) data, but now work with the state-level panel instead of national
# averages.

################################################################################
# Setup
################################################################################

library(tidyverse)

################################################################################
#
# Loading and Cleaning the Data
#
################################################################################

# Teen employment rates and minimum wages by state and quarter, 1979-2019:

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/econ-490/",
                   "refs/heads/main/modules/minimum-wages/",
                   "manning-article-data/manning-teen-employment.csv")

mw.data <- read_csv(data.url)

# Now, we'll aggregate to a state-by-year panel instead of collapsing to
# national averages. This gives us cross-state variation within each year:

state.data <- mw.data %>%
  group_by(year, state.fips) %>%
  summarize(teen.emp.rate = mean(teen.emp.rate),
            min.wage = mean(min.wage),
            .groups = "drop")

# We now have ~2,000 observations: 51 states x 41 years.

nrow(state.data)

################################################################################
# Question 1: Naive Regression and Raw Scatterplot
################################################################################

# As a starting point, run a pooled OLS regression of teen employment on
# minimum wages - no controls, just like the OVB activity.

naive.model <- lm(teen.emp.rate ~ min.wage, data = state.data)

summary(naive.model)

# The coefficient is about -0.032, similar to what we found in the OVB activity
# with national averages. This estimate pools all variation - across states and
# across time - into a single number.

# Here's a scatterplot of the raw data:

ggplot(state.data, aes(x = min.wage, y = teen.emp.rate)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Minimum Wage ($)",
       y = "Teen Employment Rate",
       title = "Teen Employment vs. Minimum Wage (Raw Data)") +
  theme_minimal()

# The downward slope is clear. But from the OVB activity, we know both
# variables are trending over time. What does omitting time as an explanatory
# variable do to our estimate of the effect of the MW on employment?




################################################################################
# Question 2: Demeaning — What Fixed Effects Actually Do
################################################################################

# Fixed effects work by removing group-level averages from the data. We can
# do this by hand using group_by() and mutate().

# Step 1: Remove state-level means. For each state, we subtract its average
# employment rate and average MW across all years. After this, a state's
# value tells us how far it is from its OWN average - we've removed permanent
# cross-state differences (cost of living, industry mix, etc.).

state.data <- state.data %>%
  group_by(state.fips) %>%
  mutate(emp.demean = teen.emp.rate - mean(teen.emp.rate),
         mw.demean = min.wage - mean(min.wage)) %>%
  ungroup()

# Step 2: Remove year-level means from the already state-demeaned data. This
# strips out common time shocks (recessions, federal MW changes, nationwide
# demographic trends).

# In the space below, use group_by(year) and mutate() to subtract the year
# mean of emp.demean and mw.demean from themselves. Overwrite the existing
# emp.demean and mw.demean variables.

# HINT: The structure is the same as Step 1, but grouped by year instead of
# state.fips.




# After double-demeaning, the remaining variation in each variable is "within
# state, within year" - variation that can't be explained by either permanent
# state characteristics or common national trends. This is the variation that a
# two-way fixed effects regression uses.



################################################################################
# Question 3: Regression on Demeaned Data
################################################################################

# In the space below, run a regression of emp.demean on mw.demean. Save
# the output as demeaned.model and use summary() to view the results.




# How does the coefficient compare to our naive model from Question 1?
# Write a comment below.





################################################################################
# Question 4: Two-Way Fixed Effects with factor()
################################################################################

# In practice, we don't have to demean by hand - R can include fixed effects
# directly in a regression using factor(). The regression below includes a
# separate intercept for each state and each year:

twfe.model <- lm(teen.emp.rate ~ min.wage + factor(state.fips) + factor(year),
                 data = state.data)

# The output includes lots of FE coefficients. We only care about min.wage:

summary(twfe.model)$coefficients["min.wage", ]

# In the space below, compare this coefficient to your demeaned regression
# from Question 3. Are they the same? Write a comment explaining why.




# The TWFE estimate is about -0.012 - roughly 60% smaller than the naive
# -0.032. Most of the apparent negative relationship between minimum wages
# and teen employment was driven by cross-state differences and shared time
# trends, not by within-state changes in MW.



################################################################################
# Going Further: What Happens with Richer Controls?
################################################################################

# Manning's paper doesn't stop at basic TWFE. He adds state-specific time
# trends - allowing each state to have its own linear trajectory over time,
# on top of the state and year FE.

# We can do this by interacting each state's fixed effect with year:

trend.model <- lm(teen.emp.rate ~ min.wage + factor(state.fips) + factor(year) +
                    factor(state.fips):year, data = state.data)

summary(trend.model)$coefficients["min.wage", ]

# With state-specific trends, the coefficient is essentially zero and
# statistically insignificant. This is Manning's core finding; the negative
# association between minimum wages and teen employment disappears once you
# allow for the fact that different states were on different employment
# trajectories for reasons unrelated to their minimum wage policies.

# That's what makes the employment effect "elusive" - it only shows up
# in specifications that don't adequately control for these trends.

# We can see this visually by extracting the residuals from the trend model.
# Residuals are the variation in each variable that's left over after
# removing state FE, year FE, and state-specific trends:

state.data$emp.resid <- residuals(lm(teen.emp.rate ~ factor(state.fips) +
                                       factor(year) + factor(state.fips):year,
                                     data = state.data))

state.data$mw.resid <- residuals(lm(min.wage ~ factor(state.fips) +
                                      factor(year) + factor(state.fips):year,
                                    data = state.data))

ggplot(state.data, aes(x = mw.resid, y = emp.resid)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Minimum Wage (Residualized)",
       y = "Teen Employment Rate (Residualized)",
       title = "Teen Employment vs. Minimum Wage (After Removing FE + Trends)") +
  theme_minimal()

# Compare this to the raw scatterplot from Question 1. The strong negative
# slope is gone - once we strip out state effects, common time shocks, and
# state-specific trends, there's no clear relationship between minimum wages
# and teen employment.

################################################################################
# End of Activity
################################################################################
