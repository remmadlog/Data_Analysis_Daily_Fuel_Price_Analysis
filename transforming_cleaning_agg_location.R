# joining/merging dataframes
library(dplyr)
# general handling analytics
library(tidyverse)


# open station file
df_station <- read.csv("Datasets/stations.csv")

# initiate an empty dataframe to build upon
df <-  data.frame()

# set post_code
postcode <-  33100

# filter df_station for post_code
df_station <- df_station %>%
            filter(post_code == postcode)


# getting a list of all files per month
# iterating over month
for (i in 1:12){
  # turn the int 3 into the str "03"
  if (i<10){
    folder <- paste0("0", toString(i))
  } else{
    folder <- toString(i)
  }
  path <- paste0("Datasets/2024/", folder)
  list_of_files <- list.files(path =path,
                            pattern = "\\.csv$",
                            full.names = TRUE)

  # iterating over each file (day) for the current month
  for (file_path in list_of_files){
    # open file (daily information)
    df_file <- read.csv(file_path) %>%
            inner_join(df_station, by =c("station_uuid"="uuid")) %>%
            select(date, station_uuid, post_code, city, name, brand, diesel,e5,e10) %>%
            filter(diesel>0.7,
                    diesel<3,
                    e5>0.7,
                    e5<3,
                    e10>0.7,
                    e10<3)   # We do that to avoid foulty outleyers

    # looking at the ``brand`` we notice some whitspace, let's remove it
    df_file$brand <- str_squish(df_file$brand)

    # set date_app YYYY-MM-DD HH
    df_file$date_app <- str_split_i(df_file$date, ":",1)
    temp <- df_file %>%
            group_by(date_app, station_uuid, post_code, city, name, brand) %>%
            summarise(diesel = mean(diesel),
                      e5 = mean(e5),
                      e10 = mean(e10),
                      gr_size = n())

    # add the day of the week as column
    temp$weekday <- weekdays(as.Date(str_split_i(temp$date_app, " ",1)))

    # add hour column
    temp$hour <- str_split_i(temp$date_app, " ",2)

    # add time of day colums that provides the information of time of day by
    # # night, morning, midday, evening in even 6h chuncks
    # # tod - time of day
    temp$tod <-  NA
    temp$tod[temp$hour %in% c("00", "01", "02", "03", "04", "05")] <- "night"
    temp$tod[temp$hour %in% c("06", "07", "08", "09", "10", "11")] <- "morning"
    temp$tod[temp$hour %in% c("12", "13", "14", "15", "16", "17")] <- "midday"
    temp$tod[temp$hour %in% c("18", "19", "20", "21", "22", "23")] <- "evening"

    # combine df with temp -- add rows from temp
    df <- rbind(df, temp)

    # remove ``temp`` and ``df_file`` from memory
    rm(temp,df_file)
  }
}

# adding month as column
df$month <- str_split_i(df$date_app, "-",2)

# adding calendar week as column
df$nweek <- strftime(str_split_i(df$date_app, " ",1), format = "%V")

# adding day as column
df$day <- str_split_i(df$date_app, " ",1)

#save file
write.csv(df,file='Datasets/agg_dataset_location.csv', row.names=FALSE)
