################################################################################
# ECON 490: Minimum Wages and Omitted Variable Bias
################################################################################

# In this activity, we'll cover:

#   - Using tidyverse to clean and aggregate panel data
#   - Running OLS regressions with lm()
#   - Visualizing relationships with ggplot2
#   - Omitted variable bias (OVB) in a real-world example

# Data comes from the replication package for "The Elusive Employment Effect
# of the Minimum Wage" by Alan Manning (2021) - our primary reading for the
# minimum wages module.

# When you're finished, save a copy of your code with your name in the file
# name and upload it to Canvas.

################################################################################
# Setup
################################################################################

# If you haven't installed tidyverse yet, uncomment and run the following line:

# install.packages("tidyverse")

library(tidyverse)

################################################################################
#
# Loading and Cleaning the Data
#
################################################################################

# We'll use a data set of teen employment rates and minimum wages by state and
# quarter, covering all 50 US states plus DC from 1979 to 2019:

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/econ-490/",
                   "refs/heads/main/modules/minimum-wages/",
                   "manning-article-data/manning-teen-employment.csv")

mw.data <- read_csv(data.url)

view(mw.data)

# Variables:
#
#   - year:          Survey year (1979 to 2019)
#   - quarter:       Quarter of the year (1 to 4)
#   - state.fips:    State FIPS code (numeric ID for each state)
#   - teen.emp.rate: Employment-to-population ratio for 16-19 year olds
#   - min.wage:      State minimum wage in dollars
#
# teen.emp.rate is the share of 16-19 year olds who are employed. A value of
# 0.40 means 40% of teens are working.

summary(mw.data$teen.emp.rate)
summary(mw.data$min.wage)

################################################################################
#
# Data Cleaning: Creating National Averages
#
################################################################################

# Our raw data has one row per state-quarter. We'll collapse it to national
# averages by year using group_by() and summarize():

national.data <- mw.data %>%
  group_by(year) %>%
  summarize(teen.emp.rate = mean(teen.emp.rate),
            min.wage = mean(min.wage))

view(national.data)

# We now have 41 rows - one per year, with teen.emp.rate and min.wage averaged
# across all states and quarters within each year.

summary(national.data$teen.emp.rate)
summary(national.data$min.wage)

################################################################################
#
# Activity Questions
#
################################################################################

# We want to apply our regression skills from the prior coding activities to 
# understand our OVB definition using this data set.

################################################################################
# Question 1: The "Naive" Regression
################################################################################

# We'll start with a simple OLS regression of teen employment on minimum wages.
# Recall from Coding Activity 2: lm() puts our outcome (Y) on the left of the
# ~ and our explanatory variable (X) on the right.

naive.model <- lm(teen.emp.rate ~ min.wage, data = national.data)

summary(naive.model)

# In the space below, interpret the coefficient on min.wage. What does it say
# about the relationship between minimum wages and teen employment? Is it
# statistically significant?




# Can we conclude from this regression that raising the minimum wage causes
# teen employment to fall? Why or why not?





################################################################################
# Question 2: Plotting Teen Employment Over Time
################################################################################

# Before drawing conclusions, let's look more closely at the data. Here's a
# scatterplot of teen employment rates over time:

ggplot(national.data, aes(x = year, y = teen.emp.rate)) +
  geom_point(color = "steelblue") +
  labs(x = "Year",
       y = "Teen Employment Rate",
       title = "Teen Employment Rate Over Time (1979-2019)") +
  theme_minimal()

# Notice the strong downward trend over four decades.

# In the space below, modify the ggplot code above to plot minimum wages
# (min.wage) over time. Update the y-axis label and title accordingly.





# What do you notice? Write a comment describing the trend in minimum wages
# over time and how it compares to the trend in teen employment.





################################################################################
# Question 3: Correlations
################################################################################

# Both variables appear to trend over time. We can quantify this with the
# cor() function. Here's the correlation between teen employment and MW:

cor(national.data$teen.emp.rate, national.data$min.wage)

# In the space below, calculate:
#
#   1. The correlation between min.wage and year
#   2. The correlation between teen.emp.rate and year




# Write a comment summarizing what the three correlations tell us:
#
#   - Is the minimum wage correlated with time?
#   - Is teen employment correlated with time?
#   - Based on our OVB definition from the lecture slides, what does this tell
#       us about our regression in Question 1? 





################################################################################
# Question 4: Controlling for Time
################################################################################

# Both MW and teen employment are strongly correlated with time. This is a
# potential OVB problem - "year" could be an omitted variable correlated with
# both X and Y, which would bias our naive estimate.

# In the space below, run a regression of teen.emp.rate on min.wage AND year.
# Save the output as time.model, then use summary() to view the results.




# Compare the min.wage coefficient to our naive model from Question 1. Did it
# get larger, smaller, or stay about the same?




# The coefficient changed - our naive regression was picking up shared time
# trends in addition to any MW-employment relationship. That's OVB.
#
# Adding a single year variable doesn't fully solve the problem, though. There
# are other potential omitted variables we haven't accounted for: differences
# across states, regional economic conditions, demographic shifts, etc. Our
# estimate could still be biased.
#
# OVB is hard to eliminate with simple controls. Getting a credible estimate
# requires careful thinking about specification - exactly what Manning does
# in his paper.



################################################################################
# Looking Ahead: What Does Manning Find?
################################################################################

# Manning runs seven different specifications of this regression, progressively
# adding richer controls: state FE, time FE, state-specific trends, regional
# time effects, etc.
#
# His key finding: the estimated employment effect is highly sensitive to which
# controls are included. With basic controls, the coefficient is negative and
# significant - similar to what we found. With more flexible time controls, the
# coefficient shrinks and becomes insignificant. There's no consistent evidence
# for a large negative employment effect.
#
# That's what makes the effect "elusive." We'll revisit this data in the next
# activity using two-way fixed effects (state + time FE) to see how estimates
# change with better controls.

################################################################################
# End of Activity
################################################################################

# Save this file with your name in the file name, and upload your .R code
# file to Canvas.
