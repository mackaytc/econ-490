################################################################################
# ECON 490 In-Class Activity: Conditional Means and Regression
################################################################################

# Today we reviewed conditional distributions, fitted lines, and OLS. This
# activity puts those ideas into R. It uses the same ACS data and the same
# functions you'll need for Coding Activity 2.

# Work through the questions below. Write your code in the space provided.
# Once you're finished with the activity, I will review your code in class.



################################################################################
# Setup
################################################################################

# We'll use the tidyverse package for data cleaning, and download the data 
# using the workflow below: 

library(tidyverse)

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/R-resources/",
                   "main/data/ECON-490-ACS-sample-data-CSV.csv")

acs.data <- read_csv(data.url)

# Same cleaning steps as you'll see in Coding Activity 2. Code below uses the
# tidyverse package to drop missing values, keep positive incomes, and restrict
# to ages 20 to 60:

acs.data <- drop_na(acs.data) %>%
  filter(hhincome > 0) %>%
  filter(age >= 20 & age <= 60)



################################################################################
# Question 1: Conditional Means with a Binary Variable
################################################################################

# In the slides, we compared food stamp receipt across employed and unemployed
# people. That's a conditional mean. Here's one way to get it:

summarize(filter(acs.data, employed == 1), food.stamp.rate = mean(food_stamp))

# In the space below, calculate the food stamp rate for the unemployed. Then
# say in a comment which group is higher, and by how much. HINT: If you want 
# to see what values employed takes, you can use the table() function:





################################################################################
# Question 2: Estimating the Line with lm()
################################################################################

# Age is continuous, so we fit a line through it instead of comparing groups.
# In the space below, regress hhincome on age, save the model as age.model,
# and print the results with summary().





################################################################################
# Question 3: Predicted Values
################################################################################

# Use your coefficients to calculate predicted income for a 35-year-old. Pull
# the coefficients out of the model rather than typing the numbers in by hand:

#   age.model$coefficients["(Intercept)"]
#   age.model$coefficients["age"]





# Now do the same for a 36-year-old. Take the difference between the two
# predictions. In a comment, compare that difference to your age coefficient.





################################################################################
# Question 4: Adding a Second Variable
################################################################################

# Regression can hold more than one variable. In the space below, regress
# hhincome on age and employed. Save it as full.model and print the summary.





# In a comment, state what the employed coefficient means in plain English.
# Use the phrasing from the slides: a one-unit increase in X is associated
# with a ___ change in average Y.





################################################################################
# End of Activity
################################################################################

# No need to submit anything once you're done; just make sure to show me your 
# code before leaving. 

