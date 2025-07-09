# general handling analytics
library(tidyverse)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# LOADING, TRANSFORMING AND ADDING
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# open station file
df <- read.csv("Datasets/agg_dataset.csv")


# adding month as column
df$month <- str_split_i(df$date_app, "-",2)

# adding calendar week as column
df$nweek <- strftime(str_split_i(df$date_app, " ",1), format = "%V")

# adding day as column
df$day <- str_split_i(df$date_app, " ",1)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# BRAND ANALYSIS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# calculating the brands with the highest amount of having the lowest price per day -- e10
# no consideration of how common the brand is
temp <- df %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(e10 = mean(e10)) %>%                  # calculate av price for each entry -> ungroups subgroup (brand)
  filter(e10 == min(e10)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(e10 = mean(e10), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))

print(head(temp,6))



# to take the amount of amount of stations by brand in consideration we consider ``stations.csv``
df_station <- read.csv("Datasets/stations.csv")

df_brand_size <- df_station %>%
  filter(brand!="") %>%           # rmoving unknown brands (blank)
  group_by(brand) %>%
  summarise(size=n()) %>%
  arrange(desc(size))


# filtering for brands that have fsize stations
# 300 feels like a good size
fsize <- 300
df_brand_size_fsize <- df_brand_size %>%
  filter(size>=fsize)

# repeating the evaluation from before, but only considering brand with 300+ stations
temp <- df %>%
  filter(brand %in% df_brand_size_fsize$brand) %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(e10 = mean(e10))  %>%                 # calculate av price for each entry -> ungroups subgroup (brand)
  filter(e10 == min(e10)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(e10 = mean(e10), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))

print(head(temp,6))

# other fuel consideration in .rmd -- just change e10 to e5 or diesel




