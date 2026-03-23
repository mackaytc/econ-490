################################################################################
# ECON 490 In-Class Activity: Interaction Terms in Regression
################################################################################

# In this activity, we'll use the ACS data from Coding Activity 2 to run
# interaction regressions. The goal is to see how estimated relationships change
# when we allow effects to differ across groups.

library(tidyverse)



################################################################################
# Load and Clean Data
################################################################################

# Load the same ACS sample data from Coding Activity 2:

data.url <- paste0("https://raw.githubusercontent.com/mackaytc/R-resources/",
                   "main/data/ECON-490-ACS-sample-data-CSV.csv")

acs.data <- read_csv(data.url)

# Same cleaning as CA2 -- drop NAs, keep positive income, ages 21-59:

acs.data <- drop_na(acs.data) %>%
  filter(hhincome > 0) %>%
  filter(age > 20 & age < 60)



################################################################################
# Setup: Create a College Indicator
################################################################################

# The education variable in our data takes values 1, 2, or 3, where 3 indicates
# a bachelor's degree or higher. We'll create a binary variable for college 
# graduates using mutate() + ifelse():

acs.data <- mutate(acs.data, college = ifelse(education == 3, 1, 0))

table(acs.data$college)



################################################################################
# Question 1: Baseline Regression
################################################################################

# Run the following regression of household income on age:

baseline <- lm(hhincome ~ age, data = acs.data)

summary(baseline)

# This model estimates a single slope = one coefficient on age that applies
# to every observation regardless of education, employment status, etc.

# In the space below, use the estimated coefficients to calculate the predicted
# household income for someone who is 30 years old, and then for someone who
# is 50 years old.





################################################################################
# Question 2: Does the Return to Age Differ by Education?
################################################################################

# The baseline model assumes each additional year of age has the same effect on
# income for everyone. That's a strong assumption. Does experience pay off more
# for college graduates?

# Run the following interaction regression:

interaction.model <- lm(hhincome ~ age + college + age:college, data = acs.data)

summary(interaction.model)

# The ":" operator creates an interaction term -- R multiplies age by college
# for each observation, the same way we discussed in the lecture slides.

# Using the output above, answer the following:

# (a) What is the estimated effect of one additional year of age on household
#     income for someone WITHOUT a college degree? (HINT: set college = 0 in
#     the regression equation and simplify.)



# (b) What is the estimated effect of one additional year of age on household
#     income for someone WITH a college degree? (HINT: set college = 1.)



# (c) Calculate predicted household income at age = 40 for a non-college
#     worker and for a college graduate. What's the difference?





################################################################################
# Question 3: Does the College Effect on Renting Depend on Age?
################################################################################

# Older people rent less than younger people, and college graduates rent less
# than non-graduates. But does education matter more for homeownership at
# different ages?

# First, create a binary variable called "older" equal to 1 for ages 40+:

acs.data <- mutate(acs.data, older = ifelse(age >= 40, 1, 0))

# In the space below, run a regression of renter on college, older, and the
# interaction of college and older. Save it as renter.model and print the
# summary.





# Using your output, answer the following:

# (a) What is the estimated effect of having a college degree on the
#     probability of renting for YOUNGER workers (older = 0)?



# (b) What is the estimated effect of having a college degree on the
#     probability of renting for OLDER workers (older = 1)?



# (c) Using a comment, explain in one sentence why the college-homeownership
#     gap might widen with age.



################################################################################
# End of Activity
################################################################################
