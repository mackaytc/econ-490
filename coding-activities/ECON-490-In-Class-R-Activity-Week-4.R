################################################################################
# ECON 490 In-Class Activity: Merging Data and Logs in Regression
################################################################################

# This activity reviews combining data sets, and using logs in regressions. The
# regression we'll run is similar to what we've seen in the slides; we'll
# consider the relationship between home price and square footage, first in
# levels, then in logs.

# Work through the questions below. Write your code in the space provided.
# Once you're finished with the activity, I will review your code in class.



################################################################################
# Setup
################################################################################

# The data for the activity is posted on Kaggle. It gives us information on 
# 21,000+ home sales in King County, WA (Seattle area) from 2014-2015. Each row 
# of the data is one home sale. 

# Variable definitions are available here:

#   https://geodacenter.github.io/data-and-lab/KingCounty-HouseSales2015/

# The data is posted as a .zip file. Run the code below to download the data, 
# unzip it, and load into R using read_csv(): 

library(tidyverse)

data.url <- paste0("https://www.kaggle.com/api/v1/datasets/download/",
                   "harlfoxem/housesalesprediction")

zip.file <- tempfile(fileext = ".zip")

download.file(data.url, zip.file, mode = "wb")

home.data <- read_csv(unzip(zip.file, "kc_house_data.csv", exdir = tempdir()))

# We'll start by doing some light data processing. We'll use select() to just 
# keep the columns/variables we need for our analysis, then filter to keep 
# houses with a reasonable number of bedrooms (between 1 and 6). 

home.data <- select(home.data, id, date, price, bedrooms, bathrooms,
                    sqft_living, sqft_lot, floors, waterfront, yr_built,
                    zipcode) %>%
  filter(bedrooms >= 1 & bedrooms <= 6)

# From the slides: str() should be your best friend. Run it and take a look at
# what each variable looks like before going further:

str(home.data)



################################################################################
# Question 1: Grouped Summary Stats and Merging
################################################################################

# Suppose we want to compare each home's price to the average price of homes
# with the same number of bedrooms. To do that, we can use tidyverse to go 
# through a two-step process: 

#   (1) Calculate the average by bedroom count, then 
#   (2) Merge those averages back onto the sales-level data.

# Step 1 uses group_by() + summarize(). Run the code below:

bedroom.means <- group_by(home.data, bedrooms) %>%
  summarize(mean.price.bedrooms = mean(price),
            n.sales = n())

bedroom.means

# Before merging, think about data structure (the "Before You Combine Data"
# slide). In a comment below, answer:
#   (a) What uniquely identifies a row in home.data? HINT: it's not just id.
#       Try sum(duplicated(home.data$id)) to see why.
#   (b) What uniquely identifies a row in bedroom.means?
#   (c) Which data set is less granular, and so what's our key variable?





# Step 2: use left_join() to merge bedroom.means onto home.data by bedrooms.
# Save the result as home.merged. Then sanity check it: compare nrow() for
# home.data and home.merged, and run summary() on the new mean.price.bedrooms
# column to check for NAs.





# Now use the merged data. Use mutate() to create price.vs.group, equal to
# price divided by mean.price.bedrooms. Then use summarize() to calculate the
# share of homes that sold for more than the average home with the same
# number of bedrooms. HINT: mean(price.vs.group > 1) gives you a share.





# Your turn: repeat the process above, but group by zipcode instead of
# bedrooms. There are 70 zip codes in the data. Calculate mean price by
# zipcode, merge it back onto home.data, and check nrow() before and after.





################################################################################
# Question 2: Home Prices and Square Footage in Levels
################################################################################

# From the slides:

#   Home Price_i = B0 + B1 * Square Footage_i + u_i

# In the space below, regress price on sqft_living, save the model as
# level.model, and print the results with summary().





# In a comment, interpret the coefficient on sqft_living using the phrasing
# from the slides: a 1-sq. foot increase in size is associated with a $___
# change in average price.



# Use your coefficients to calculate the predicted price for a 2,000 sq. ft.
# home and a 2,100 sq. ft. home. Pull the coefficients out of the model
# rather than typing the numbers in by hand:

#   level.model$coefficients["(Intercept)"]
#   level.model$coefficients["sqft_living"]





################################################################################
# Question 3: The Same Regression in Logs
################################################################################

# To use logs, a variable has to be strictly greater than 0. Check that this
# holds for price and sqft_living (summary() or min() will do it):



# Use mutate() to add two variables to home.data: log.price = log(price) and
# log.sqft = log(sqft_living). Then regress log.price on log.sqft, save it as
# log.model, and print the summary.





# In a comment, interpret the coefficient on log.sqft. Remember, in a log-log
# regression the slope is an elasticity: a 1% increase in size is associated
# with a ___% change in average price.



# Compare the two models. Which coefficient would be easier to explain to
# someone who's never seen this data? Write a sentence or two in a comment.





################################################################################
# End of Activity
################################################################################

# No need to submit anything once you're done; just make sure to show me your
# code before leaving.
