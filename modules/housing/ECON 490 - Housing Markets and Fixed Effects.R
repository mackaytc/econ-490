################################################################################
# ECON 490: Housing Markets and Fixed Effects
################################################################################

# For this R activity, we'll use data from Hilber and Vermeulen (2016). This
# paper uses data on local housing markets in England from 1974-2008 to understand
# how home prices are related to local earnings. The idea is that higher local
# earnings can increase demand for housing, raising prices when housing supply
# does not expand enough to meet that demand.

# Work through the questions below. Write your code in the space provided.
# Once you're finished with the activity, I will review your code in class.


################################################################################
# Setup
################################################################################

# We'll use library() to make sure we can access tidyverse package functions

library(tidyverse)

# Display numbers without scientific notation:

options(scipen = 999)

# The data combines house price and earnings measures for local government
# areas in England. Each row represents one local authority in one year,
# covering 353 places from 1974-2008.

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/econ-490/",
                   "refs/heads/main/modules/housing/",
                   "hilber-vermeulen-data/housing-panel.csv")

housing.data <- read_csv(data.url)

# Variables included in the data:

#   place.id:      Local authority ID
#   place.name:    Local authority name
#   county:        County before the 1996 boundary changes
#   year:          Year
#   log.price:     Log real house price index
#   log.earnings:  Log real male weekly earnings
#   refusal.rate:  Average refusal rate, 1979-2008 (0-1; constant within place)

# The house price index equals 100 in each place in 1974. It measures price
# changes since then, not differences in price levels across places.

# Use drop_na() to remove rows with missing values in place.id, year, log.price,
# or log.earnings.

housing.data <- housing.data %>%
  drop_na(place.id, year, log.price, log.earnings)

# Check the structure of the working data set using str() and summary():

str(housing.data)
summary(housing.data)



################################################################################
# Question 1: Simple OLS
################################################################################

# Before we run any regressions, let's check that we understand the data we're
# using. What variable(s) uniquely identify each row? How many years/places are
# covered by the data?



# Let's start by estimating the simple OLS relationship between log home prices
# and log earnings:

simple.OLS.model <- lm(log.price ~ log.earnings, data = housing.data)

# Use summary() to view the saved model's results:

summary(simple.OLS.model)

# Now, we'll use ggplot() to visualize the relationship between earnings and
# home prices:

ggplot(housing.data, aes(x = log.earnings, y = log.price)) +
  geom_point(alpha = 0.3, color = "steelblue") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Log Real Weekly Earnings",
       y = "Log Real House Price Index") +
  theme_minimal()

# Interpret the slope. Should we interpret this coefficient as a causal estimate
# of the effect of earnings on home prices? HINT: Can you think of any possible
# omitted variables?



################################################################################
# Question 2: Variation over Time
################################################################################

# Next, we'll group the data by year and calculate the average (log) price and
# (log) earnings for each year. We'll save this as national.data:

national.data <- housing.data %>%
  group_by(year) %>%
  summarize(log.price = mean(log.price),
            log.earnings = mean(log.earnings),
            .groups = "drop")

# Now, we can plot the average log price over time:

ggplot(national.data, aes(x = year, y = log.price)) +
  geom_line(color = "steelblue") +
  labs(x = "Year", y = "Mean Log Real House Price Index") +
  theme_minimal()

# Adapt the code above to generate a plot of average log earnings over time.
# Describe the two series briefly; do you notice a shared pattern?



# Using housing.data, let's see what happens when we add year to the simple
# OLS model above. We can start by running the following:

lm(log.price ~ log.earnings + year, data = housing.data) %>%
  summary()

# Notice how year just gets a single coefficient. This is because R treats year
# as a numeric variable. Using factor(), run another regression where we
# treat year as a factor variable:



# Year FEs absorb changes shared across places in a given year. For example, a
# recession may lower house prices across England. Year FEs control for that
# nationwide change (but they won't account for some places being hit harder
# than others). How does the earnings coefficient compare with simple OLS?



################################################################################
# Question 3: Place Fixed Effects
################################################################################

# Just like in the US, different areas of England differ for all kinds of reasons
# like climate, geography, etc. We can control for differences that are constant
# over time by including a fixed effect for location. We can do this by adding
# factor(place.id) to our simple OLS regression.

place.model <- lm(log.price ~ log.earnings + factor(place.id),
                  data = housing.data)

summary(place.model)$coefficients["log.earnings", ]

# Compare the earnings coefficient here with that from our simple
# OLS model above. What changed? Do you think this place FE model suffers from
# any potential OVB? HINT: Think about your answer to Q2 above.



################################################################################
# Question 4: Place and Year Fixed Effects
################################################################################

# Now, let's combine the fixed effects/factor variables that we used in Q2 and
# Q3 above in a single model. When we have both group and time FEs, we can refer
# to the resulting regression model as a two-way fixed effects (TWFE) model.

twfe.model <- lm(log.price ~ log.earnings + factor(place.id) + factor(year),
                 data = housing.data)

summary(twfe.model)$coefficients["log.earnings", ] %>% round(4)

# We've absorbed constant differences across places and changes common to
# all places in each year. How does the earnings coefficient compare with
# our earlier estimates?



# What residual variation remains in our data set? Can you imagine any potential
# omitted variables?



################################################################################
# End of Activity
################################################################################
