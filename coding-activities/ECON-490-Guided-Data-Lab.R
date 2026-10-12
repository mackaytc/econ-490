################################################################################
# ECON 490 Capstone Lab Activity 1: Building a Working Data Set
################################################################################
#
# Tonight we'll walk through the full pipeline that turns a raw data file into
# the tables and figures that go in your capstone paper:
#
#   - Loading a data set and figuring out what's actually in it
#   - Building a 0/1 indicator variable out of a categorical variable
#   - Aggregating individual-level data up to the state-by-year level
#   - Producing a summary statistics table
#   - Producing a figure
#   - Running a regression and exporting the results
#
# We'll all work with the same data set so we can move through this together.
# Next week you'll run this same pipeline on your own capstone data.
#
# When you're finished, save a copy of your code with your name in the file
# name and upload it to Canvas along with your Word document.
#
################################################################################
# Getting Set Up
################################################################################

# We need three packages tonight. You've used tidyverse already. The other two
# are new: estimatr gives us lm_robust() for regressions with robust standard
# errors, and broom gives us tidy() for turning model output into something you
# can actually export.

# If you haven't installed these before, uncomment and run the next line:

# install.packages(c("estimatr", "broom"))

library(tidyverse)
library(estimatr)
library(broom)

################################################################################
# Loading the CPS Data
################################################################################

# Download individual-level-CPS-data.Rds from Canvas, then load it. The easiest
# approach is Session > Set Working Directory > Choose Directory, pointing R at
# the folder where you saved the file. Then run:

cps.data <- readRDS("individual-level-CPS-data.Rds")

# The Current Population Survey is a monthly survey run by the Census Bureau
# and the BLS. It's the source of the official unemployment rate, and it's one
# of the most useful data sets available for capstone projects: it covers
# earnings, employment, education, health insurance, poverty, and migration.
#
# There's a documentation file on Canvas describing each variable. Keep it open
# while you work.

################################################################################
# Question 1: What's In This Data Set?
################################################################################

# Never start analyzing a data set before you know what's in it. Run each of
# these and look at the output:

dim(cps.data)          # how many rows and columns?
names(cps.data)        # what are the variables called?
glimpse(cps.data)      # variable types and the first few values

# Q1a. How many observations (rows) are in the data? How many variables?
#
# ANSWER:
#
# Q1b. What does a single row represent -- a person, a household, or a state?
#
# ANSWER:
#
# Q1c. Which years does the data cover? Use the following to find out:

table(cps.data$year)

# ANSWER:

################################################################################
# Question 2: Building a Poverty Indicator
################################################################################

# Our outcome tonight is the poverty rate. Start by looking at how the poverty
# variable is stored:

table(cps.data$poverty.status, useNA = "ifany")

# Notice two things: this is a Yes/No categorical variable rather than a number,
# and some observations are missing (NA).
#
# We can't take the average of a "Yes"/"No" variable. So we convert it into a
# 0/1 indicator using mutate() and ifelse(), the same way you built the college
# indicator in Coding Activity 4:

cps.data <- cps.data %>%
  mutate(in.poverty = ifelse(poverty.status == "Yes", 1, 0))

# Q2a. Check your work. Run the following -- the counts should line up with the
#      table you ran above:

table(cps.data$in.poverty, useNA = "ifany")

# Q2b. Why does taking the average of a 0/1 indicator give you a proportion?
#      Write a one-sentence answer below.
#
# ANSWER:

################################################################################
# Question 3: Aggregating to the State-by-Year Level
################################################################################

# Right now each row is a person. But our research question is about places, so
# we want each row to be a state in a given year. That's what group_by() and
# summarize() do: collapse many rows down into one row per group.

state.year.data <- cps.data %>%
  group_by(census.region, state.fip, year) %>%
  summarize(poverty.rate = mean(in.poverty, na.rm = TRUE)) %>%
  ungroup()

# The na.rm = TRUE argument tells R to ignore the missing observations we found
# in Question 2 when calculating the average.
#
# R will print a message here that starts with "summarise() has grouped output
# by...". That's not an error -- it's R telling you it left the data grouped.
# The ungroup() line above is what clears that, so you can safely ignore it.

# Q3a. How many rows does state.year.data have? Given the number of states and
#      the number of years, is that the number you'd expect?

dim(state.year.data)

# ANSWER:
#
# Q3b. Look at the first several rows. What does one row represent now?

head(state.year.data)

# ANSWER:

################################################################################
# Question 4: Checking Your Categories
################################################################################

# Before making any output, look carefully at the region variable:

table(state.year.data$census.region)

# Q4a. One of these four region names is misspelled in the raw data. Which one?
#
# ANSWER:
#
# This is worth pausing on. Real data sets have errors in them, and whatever is
# stored in your data ends up in your tables and figures unless you fix it. We
# can correct it here:

state.year.data <- state.year.data %>%
  mutate(census.region = recode(census.region, "Norteast" = "Northeast"))

# Q4b. Run the table() line again to confirm the fix worked.

################################################################################
# Question 5: Summary Statistics Table
################################################################################

# Now we build the first piece of output for your Word document: average
# poverty rates by Census region.

region.summary <- state.year.data %>%
  group_by(census.region) %>%
  summarize(mean.poverty.rate = mean(poverty.rate),
            sd.poverty.rate   = sd(poverty.rate),
            min.poverty.rate  = min(poverty.rate),
            max.poverty.rate  = max(poverty.rate),
            n.observations    = n())

print(region.summary)

# Export it so you can open it in Excel and clean up the numbers:

write_csv(region.summary, "region-summary-table.csv")

# Q5a. Which region has the highest average poverty rate? Which has the lowest?
#
# ANSWER:
#
# Q5b. How large is the gap between them, in percentage points?
#
# ANSWER:

################################################################################
# Question 6: A Figure
################################################################################

# Next, a figure showing how the national poverty rate moved over time.

national.by.year <- state.year.data %>%
  group_by(year) %>%
  summarize(poverty.rate = mean(poverty.rate))

poverty.plot <- ggplot(national.by.year, aes(x = year, y = poverty.rate)) +
  geom_line() +
  geom_point() +
  labs(title   = "Average State Poverty Rate Over Time",
       x       = "Year",
       y       = "Average Poverty Rate",
       caption = "Data source: Current Population Survey, 2018-2022.") +
  theme_minimal()

print(poverty.plot)

# Save it so you can insert it into Word:

ggsave("poverty-over-time.png", poverty.plot, width = 7, height = 4.5)

# Q6a. Notice that the axis labels use plain English rather than variable names
#      like "poverty.rate". This is required in everything you submit.
#
# Q6b. What happens to the poverty rate in 2020 and 2021? Does that surprise
#      you, given what was happening at the time?
#
# ANSWER:

################################################################################
# Question 7: Regression
################################################################################

# Finally, a regression. We'll ask whether average poverty rates differ across
# Census regions, using region as a factor (categorical) explanatory variable.
#
# We use lm_robust() rather than lm() because it reports heteroskedasticity-
# robust standard errors, which is standard practice in applied economics.

poverty.model <- lm_robust(poverty.rate ~ as.factor(census.region),
                           data = state.year.data)

summary(poverty.model)

# That console output is hard to work with directly. tidy() converts it into a
# clean table you can export:

tidy(poverty.model)

write_csv(tidy(poverty.model), "regression-output.csv")

# Q7a. R picked one region as the omitted reference category. Which one? (Hint:
#      it's the region that doesn't appear as its own coefficient.)
#
# ANSWER:
#
# Q7b. Take the coefficient on the South. What does it tell you about poverty
#      rates in the South relative to the reference region?
#
# ANSWER:
#
# Q7c. Is that coefficient statistically significant at the 5 percent level?
#      How can you tell from the output?
#
# ANSWER:

################################################################################
# What to Submit
################################################################################

# Upload two files to Canvas before you leave tonight:
#
#   1. This .R file, with your answers filled in and your name in the file name
#   2. A Word document containing your summary statistics table, your figure,
#      and your regression results, formatted following the Lab 1 handout
#
# The handout covers how to get output out of R and into Word so that it looks
# like something you'd be willing to hand to a reader.
