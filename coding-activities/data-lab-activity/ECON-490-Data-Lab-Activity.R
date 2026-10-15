################################################################################
# ECON 490 Data Lab: Doctors and Flu Shots
################################################################################

# In this lab, you'll use county data to answer the following questions: Do
# counties with more primary care doctors have higher flu shot rates? Is this
# relationship different in rural vs. urban counties?

# You will produce four data analysis outputs:

#   1) A graph showing the distribution of your variables
#   2) A summary statistics table
#   3) A basic regression table showing the first stage of your results
#   4) A second regression table showing results using an interaction term

# SUBMISSION: You should submit two files to Canvas before the end of class:

#   1) This R script with your completed code. 
#   2) A Word document with your graph and neatly formatted tables.

# The README file in the data-lab-activity folder on GitHub describes each
# variable in the data.



################################################################################
# Setup
################################################################################

# We'll use three packages. The estimatr package lets us use lm_robust(). The
# broom package gives us tidy(), which puts regression output in a table format
# that is easier to work with and export.

# If you have not installed these packages, uncomment the lines below and run
# both lines of code:

# install.packages("estimatr")
# install.packages("broom")

library(tidyverse)
library(estimatr)
library(broom)

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/econ-490/main/",
                   "coding-activities/data-lab-activity/",
                   "ECON-490-county-health-data.csv")

county.data <- read_csv(data.url)

# Each row is one county. In the interaction lecture slides, we used a binary
# indicator for West Coast states. In this lab, we'll use an indicator for rural
# counties, where rural = 1 if 50% or more of the population lives in rural
# areas.

county.data <- county.data %>%
  mutate(rural = ifelse(pct.rural >= 50, 1, 0),
         area = ifelse(rural == 1, "Rural", "Urban"))

# We can use table() to count the rural and urban counties:

table(county.data$area)



################################################################################
# Question 1: Plot
################################################################################

# For your capstone project, you'll generate descriptive output that shows your
# audience the distribution of your outcome/explanatory variables. Here, we'll
# show a scatter plot of doctors per 10,000 people and flu shot rates, with
# rural and urban counties in different colors.

# NOTE: Nine small counties have more than 25 doctors per 10,000 people. We'll
# use coord_cartesian() to hide them, but the fitted lines still use them.

# GOAL: In labs(), replace the text in capital letters with axis labels in plain
# English. Do not use R variable names.

flu.plot <- ggplot(county.data, aes(x = doctors.per.10k, y = flu.shot.rate,
                                    color = area)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  coord_cartesian(xlim = c(0, 25)) +
  labs(x = "WRITE AN X-AXIS LABEL HERE",
       y = "WRITE A Y-AXIS LABEL HERE",
       color = NULL,
       caption = "Source: County Health Rankings & Roadmaps, 2025.") +
  theme_minimal()

flu.plot

ggsave("flu-shot-plot.png", flu.plot, width = 7, height = 4.5)

# NEXT STEPS: Copy the plot into your Word document. Make sure to include a
# descriptive title.



################################################################################
# Question 2: Summary Statistics Table
################################################################################

# A summary statistics table shows the distribution of key variables in your
# analysis. We'll construct a summary statistics table that compares the average
# rural county with the average urban county. 

# GOAL: In the code below, n() counts the counties in each group. You should add
# two more lines to the summarize() function to calculate the mean of
# pct.65.older and the mean of median.income.

summary.table <- county.data %>%
  group_by(area) %>%
  summarize(counties = n(),
            # Add two more lines here to summarize additional variables
            flu.shot.rate = mean(flu.shot.rate),
            doctors.per.10k = mean(doctors.per.10k))

summary.table

# Copy this table into Word. Put the variables in rows and the two groups in
# columns. Round to one decimal place. If you like, you can edit the table in 
# Excel before copying it into Word.



################################################################################
# Question 3: Simple Regression
################################################################################

# We'll start by considering the following simple OLS regression: 

model.1 <- lm_robust(flu.shot.rate ~ doctors.per.10k, data = county.data)

# Remember that each row of our data is a county. This means we can use state
# fixed effects to control for average differences across states (e.g., average
# differences in spending on public health initiatives). 

# GOAL: Run a new regression using the formula above, adding factor(state) as a
# control/explanatory variable. Save the regression as model.2 using "<-". 



# The tidy() function puts our regression output into a table format. We can use
# filter() to keep only the output we're interested in. In this case, we don't
# need to print all the state FEs because our focus is on the doctors variable.

tidy(model.1) %>%
  filter(term == "doctors.per.10k") %>%
  select(term, estimate, std.error, p.value)

# The select() function picks out the specific statistics we care about. Here's
# the same output for model.2:

tidy(model.2) %>%
  filter(term == "doctors.per.10k") %>%
  select(term, estimate, std.error, p.value)

# GOAL: Take a look at the sample regression tables to get a sense of how to
# generate regression output tables. Then, make a Word table with one column for
# each regression model:

#   - Show each coefficient. Put the standard error in parentheses below it.
#   - Add a "State controls" row. Write "No" for model.1 and "Yes" for model.2.
#   - Add a row for the number of counties. Run model.1$nobs to get it.
#   - Do not show the state coefficients. As part of your notes for the table, 
#       include the following: "Column 2 includes a control for each state."



################################################################################
# Question 4: Regression With an Interaction Term
################################################################################

# The plot shows a different slope for each group. An interaction term
# measures this difference and tells us if it is statistically significant.

# Write model.3 below. Start with the model.2 formula. Then add rural and the
# interaction doctors.per.10k:rural. Use the same syntax as the interaction
# lecture slides.



# Once you've run your model.3 regression, you can view the output using this: 

tidy(model.3) %>%
  filter(term %in% c("doctors.per.10k", "rural", "doctors.per.10k:rural")) %>%
  select(term, estimate, std.error, p.value)

# Make a second Word table for model.3. Show the three coefficients with the
# standard errors in parentheses. Add the "State controls" row, the number of
# counties, and the same note as in Question 3.



################################################################################
# Before You Submit
################################################################################

# Check your Word document to make sure you have each of the following: 
#   - A title, plain-English axis labels, and a source note for your graph.
#   - A title and a note for each table.
#   - Plain-English variable names everywhere (no R variable names).
#   - Numbers rounded to fewer decimals or fewer.

# Then submit your Word document and this R script to Canvas.


