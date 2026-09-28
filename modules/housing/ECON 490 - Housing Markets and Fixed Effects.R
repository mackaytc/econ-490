################################################################################
# ECON 490: Housing Markets and Fixed Effects
################################################################################

# Hilber and Vermeulen (2016): local housing markets in England, 1974-2008.
# How are house prices related to local earnings?
# Write your code and answers in the spaces below.



################################################################################
# Setup
################################################################################

library(tidyverse)

# One row per local authority-year: 353 places, 1974-2008.

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/econ-490/",
                   "refs/heads/main/modules/housing/",
                   "hilber-vermeulen-data/housing-panel.csv")

housing.data <- read_csv(data.url)

# Variables (teaching extract):
#   place.id:      Local authority ID
#   place.name:    Local authority name
#   county:        County before the 1996 boundary changes
#   year:          Year
#   log.price:     Log real house price index
#   log.earnings:  Log real male weekly earnings
#   refusal.rate:  Average refusal rate, 1979-2008 (0-1; constant within place)

housing.data <- housing.data %>%
  drop_na(place.id, year, log.price, log.earnings)

str(housing.data)
summary(housing.data)

# The price index measures changes since 1974, not prices in pounds.
# Earnings are measured at county level before 1996.
# What identifies a row? How many places and years are represented?




################################################################################
# Question 1: Pooled OLS
################################################################################

pooled.model <- lm(log.price ~ log.earnings, data = housing.data)

summary(pooled.model)

ggplot(housing.data, aes(x = log.earnings, y = log.price)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Log Real Weekly Earnings",
       y = "Log Real House Price Index") +
  theme_minimal()

# Interpret the slope. Is this a causal estimate? Name a possible OV.




################################################################################
# Question 2: Variation over Time
################################################################################

national.data <- housing.data %>%
  group_by(year) %>%
  summarize(log.price = mean(log.price),
            log.earnings = mean(log.earnings),
            .groups = "drop")

# These are unweighted averages of logs across places.

ggplot(national.data, aes(x = year, y = log.price)) +
  geom_line(color = "steelblue") +
  labs(x = "Year", y = "Mean Log Real House Price Index") +
  theme_minimal()

# Plot average log earnings over time. Describe the two series briefly.




# Using housing.data, add year to the pooled regression. Save as time.model.
# Then replace year with factor(year). What restriction does numeric year impose?




################################################################################
# Question 3: Place Fixed Effects
################################################################################

# factor(place.id) adds indicators for places, with one reference category.
# Each place has its own intercept; the earnings slope is common.

place.model <- lm(log.price ~ log.earnings + factor(place.id),
                  data = housing.data)

summary(place.model)$coefficients["log.earnings", ]

# Compare the slope with pooled.model. What variation do place FEs absorb?
# Name one possible OV they absorb and one they do not.




################################################################################
# Question 4: Demeaning by Place
################################################################################

housing.data <- housing.data %>%
  group_by(place.id) %>%
  mutate(price.demean = log.price - mean(log.price),
         earnings.demean = log.earnings - mean(log.earnings)) %>%
  ungroup()

# Regress price.demean on earnings.demean. Save as demeaned.model.
# Compare its slope with place.model. Why should they match?




# Adapt the Question 1 scatterplot to use the demeaned variables.
# What does a negative value of earnings.demean mean?




################################################################################
# Question 5: Place and Year Fixed Effects
################################################################################

twfe.model <- lm(log.price ~ log.earnings + factor(place.id) + factor(year),
                 data = housing.data)

summary(twfe.model)$coefficients["log.earnings", ]

# Compare the pooled, place-FE, and two-way-FE slopes.
# What additional variation do year FEs absorb? What variation remains?




################################################################################
# Question 6: Residual Variation
################################################################################

# Remove the same place and year factors from BOTH variables.

price.fe <- lm(log.price ~ factor(place.id) + factor(year),
               data = housing.data)

earnings.fe <- lm(log.earnings ~ factor(place.id) + factor(year),
                  data = housing.data)

housing.data <- housing.data %>%
  mutate(price.resid = residuals(price.fe),
         earnings.resid = residuals(earnings.fe))

# Regress price.resid on earnings.resid. Compare its slope with twfe.model.
# Plot these residuals with a fitted regression line.




# The slopes match; default standard errors need not. Residualization uses
# degrees of freedom that the residual regression does not account for.
# The lm() standard errors also do not account for dependence within places.

# Does adding FEs establish causality here? Give a time-varying OV that remains.




################################################################################
# Optional: Housing Supply Constraints
################################################################################

# refusal.rate is constant within each place.
# Add it to twfe.model. Why can't its coefficient be estimated separately?




# From Glaeser and Gyourko: how might supply constraints change the price
# response to an increase in demand?




# Allow the earnings slope to differ with refusal.rate:
#   log.earnings:refusal.rate
# Add this interaction to the place/year FE model. Interpret its coefficient.
# Use the same nonmissing sample when comparing models.
# This is a descriptive exercise, not the paper's IV specification.




################################################################################
# End of Activity
################################################################################
