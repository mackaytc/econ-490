################################################################################
# ECON 490 Capstone Lab Activity 2: Estimating Your Specification
################################################################################
#
# Last week you ran the full pipeline on the CPS data. Tonight you run it on
# your own data.
#
# You will build your analysis sample, estimate your main regression, and
# produce the table and figure that go in your paper. Everything you make
# tonight belongs in your outline and your final paper.
#
# Bring your data file and any code you have already written.
#
# Save this file with your name in the file name. Upload it to Canvas with your
# Word document before you leave.
#
################################################################################
# Getting Set Up
################################################################################

library(tidyverse)
library(estimatr)
library(broom)

# Load your data. Use whichever line matches your file type.

# my.data <- read_csv("your-file.csv")
# my.data <- readRDS("your-file.Rds")
# my.data <- haven::read_dta("your-file.dta")

################################################################################
# Question 1: Know Your Data
################################################################################

# Run these three lines before anything else.

# dim(my.data)
# names(my.data)
# glimpse(my.data)

# Q1a. What does one row represent?
#
# ANSWER:
#
# Q1b. What is your outcome variable? Write the exact variable name.
#
# ANSWER:
#
# Q1c. What is your main explanatory variable? Write the exact variable name.
#
# ANSWER:

################################################################################
# Question 2: Build Your Analysis Sample
################################################################################

# Your raw data almost certainly holds rows you do not want. Drop them here.
# Use filter() for rows. Use select() if you want to trim variables.
#
# Common restrictions include an age range, a set of years, a geography, or
# people who are employed.
#
# Write your own version of the line below.

# my.sample <- my.data %>%
#   filter(age >= 25, age <= 64)

# Every restriction needs a reason. Record them as you go.
#
# Q2a. List each restriction and why you made it.
#
# ANSWER:
#   Restriction 1:
#   Reason:
#
#   Restriction 2:
#   Reason:

################################################################################
# Question 3: The Sample Construction Note
################################################################################

# Readers need to know how many observations you started with and how many you
# ended with. So do you. Run this after each filter to track your counts.

# nrow(my.data)
# nrow(my.sample)

# Q3a. Fill in the numbers.
#
# ANSWER:
#   Started with:            observations
#   Dropped:                 observations
#   Final analysis sample:   observations
#
# This goes in the Data section of your paper. Write it as a sentence.
#
# Q3b. Write that sentence now.
#
# ANSWER:

################################################################################
# Question 4: Build Your Variables
################################################################################

# If your outcome or explanatory variable is categorical, convert it to a 0/1
# indicator. This is the table() and ifelse() pattern from last week.

# table(my.sample$your.variable, useNA = "ifany")

# my.sample <- my.sample %>%
#   mutate(my.indicator = ifelse(your.variable == "Yes", 1, 0))

# Q4a. Check every variable you built. Do the counts match the raw table?
#
# ANSWER:
#
# Q4b. How many missing values does your outcome have? What did you do about
#      them?
#
# ANSWER:

################################################################################
# Question 5: Summary Statistics
################################################################################

# Build a summary table for every variable in your regression.

# summary.table <- my.sample %>%
#   summarize(mean.outcome = mean(my.outcome, na.rm = TRUE),
#             sd.outcome   = sd(my.outcome, na.rm = TRUE),
#             mean.x       = mean(my.x, na.rm = TRUE),
#             sd.x         = sd(my.x, na.rm = TRUE),
#             observations = n())

# print(summary.table)
# write_csv(summary.table, "summary-statistics.csv")

# Q5a. Look at the mean of your outcome. Does it seem plausible? If it does
#      not, something upstream is wrong. Find it now.
#
# ANSWER:

################################################################################
# Question 6: Three Regressions
################################################################################

# This is the core of tonight. You will estimate the same relationship three
# times, adding controls each time.
#
# Model 1 is your outcome on your main explanatory variable. Nothing else.
# Model 2 adds basic demographic controls.
# Model 3 adds the rest of your controls.

# model.1 <- lm_robust(my.outcome ~ my.x, data = my.sample)
# model.2 <- lm_robust(my.outcome ~ my.x + age + sex, data = my.sample)
# model.3 <- lm_robust(my.outcome ~ my.x + age + sex + as.factor(educ),
#                      data = my.sample)

# summary(model.1)
# summary(model.2)
# summary(model.3)

# Export all three. tidy() cleans up each one.

# write_csv(tidy(model.1), "model-1.csv")
# write_csv(tidy(model.2), "model-2.csv")
# write_csv(tidy(model.3), "model-3.csv")

# Q6a. Write down the coefficient on your main explanatory variable in each
#      model.
#
# ANSWER:
#   Model 1:
#   Model 2:
#   Model 3:
#
# Q6b. Did the coefficient move as you added controls? By how much?
#
# ANSWER:
#
# Q6c. This is omitted variable bias in your own data. If the coefficient moved
#      a lot, your controls were picking up something your first model missed.
#      Which control did the most work?
#
# ANSWER:

################################################################################
# Question 7: A Figure
################################################################################

# Make one figure showing your main relationship. Pick whichever fits.
#
# Option A is a scatter plot with a fitted line. Use it for two continuous
# variables.

# my.plot <- ggplot(my.sample, aes(x = my.x, y = my.outcome)) +
#   geom_point(alpha = 0.3) +
#   geom_smooth(method = "lm") +
#   labs(title   = "Write a real title here",
#        x       = "Plain English label",
#        y       = "Plain English label",
#        caption = "Data source: name your source.") +
#   theme_minimal()

# Option B is a bar chart of group means. Use it when your explanatory variable
# is categorical.

# group.means <- my.sample %>%
#   group_by(my.group) %>%
#   summarize(mean.outcome = mean(my.outcome, na.rm = TRUE))

# my.plot <- ggplot(group.means, aes(x = my.group, y = mean.outcome)) +
#   geom_col() +
#   labs(title   = "Write a real title here",
#        x       = "Plain English label",
#        y       = "Plain English label",
#        caption = "Data source: name your source.") +
#   theme_minimal()

# print(my.plot)
# ggsave("main-figure.png", my.plot, width = 7, height = 4.5)

# Q7a. No R variable names anywhere in your labels. Check your figure again.

################################################################################
# Question 8: Interpretation
################################################################################

# Q8a. Interpret the coefficient from Model 3 in one sentence. Give the units.
#      Use the form "a one-unit increase in X is associated with a B-unit
#      change in Y."
#
# ANSWER:
#
# Q8b. Is it statistically significant at the 5 percent level?
#
# ANSWER:
#
# Q8c. Is it large? Compare it to the mean of your outcome from Question 5. A
#      coefficient can be significant and still be too small to matter.
#
# ANSWER:
#
# Q8d. Name the most important variable you could not control for. How would it
#      bias your estimate?
#
# ANSWER:

################################################################################
# Stretch: Heterogeneity
################################################################################

# Finish early? Add a fourth model with an interaction term. This tests whether
# your relationship differs across groups. You built these in Coding Activity 4.

# model.4 <- lm_robust(my.outcome ~ my.x * my.group + age + sex,
#                      data = my.sample)
# summary(model.4)

# Does the relationship look different across groups? Say so in one sentence.

################################################################################
# What to Submit
################################################################################

# Upload two files to Canvas before you leave.
#
#   1. This .R file with your answers filled in
#   2. A Word document holding your summary statistics table, your three-column
#      regression table, and your figure
#
# Format everything following the Lab 2 handout. Your regression table has one
# column per model. Your reader should see the coefficient move across columns.
