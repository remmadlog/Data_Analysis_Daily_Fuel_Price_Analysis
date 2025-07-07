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
# WEEKDAY ANALYSIS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# generating a datafarme the tracks the lowest price per weekday for each week and counts them

# for e10
df_weekdays <- df %>%
    group_by(nweek, weekday) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_e10 = n()) %>%
    arrange(amount_e10)


# for e5
temp <- df %>%
    group_by(nweek, weekday) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_e5 = n()) %>%
    arrange(amount_e5)

# joining with the df_weekdays dataframe
df_weekdays <- left_join(df_weekdays,temp, by = "weekday")


# for diesel
temp <- df %>%
    group_by(nweek, weekday) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_diesel = n()) %>%
    arrange(amount_diesel)

# joining with the df_weekdays dataframe
df_weekdays <- left_join(df_weekdays,temp, by = "weekday")

# printing results
print(df_weekdays)



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# TOD ANALYSIS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# following the same idea as before

df_tod <- df %>%
    group_by(day, tod) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(tod) %>%
    summarise(amount_e10 = n()) %>%
    arrange(amount_e10)


temp <- df %>%
    group_by(day, tod) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(tod) %>%
    summarise(amount_e5 = n()) %>%
    arrange(amount_e5)

df_tod <- left_join(df_tod, temp, by="tod")


temp <- df %>%
    group_by(day, tod) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(tod) %>%
    summarise(amount_diesel = n()) %>%
    arrange(amount_diesel)

df_tod <- left_join(df_tod, temp, by="tod")


print(df_tod)


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# TIME ANALYSIS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# follwoing the same idea as before

df_h <- df %>%
    group_by(day, hour) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(hour) %>%
    summarise(amount_e10 = n()) %>%
    arrange(amount_e10)


temp <- df %>%
    group_by(day, hour) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(hour) %>%
    summarise(amount_e5 = n()) %>%
    arrange(amount_e5)

df_h <- left_join(df_h, temp, by="hour")


temp <- df %>%
    group_by(day, hour) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(hour) %>%
    summarise(amount_diesel = n()) %>%
    arrange(amount_diesel)

df_h <- left_join(df_h, temp, by="hour")


print(df_h)
