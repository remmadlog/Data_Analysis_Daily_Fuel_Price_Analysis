Daily German Fuel Price Analysis (2024)
================

## Dataset

The dataset we are using can be found
[here](https://dev.azure.com/tankerkoenig/_git/tankerkoenig-data?path=/README.md&_a=preview).
There one can obtain way more data for different years. We will only
focus on the year 2024.

This dataset contains of several `.csv` files. One file per day, sorted
in folders by month. One file is of the following form:

> The head contains:
>
> `date,station_uuid,diesel,e5,e10,dieselchange,e5change,e10change`
>
> Meaning:
>
> | Feld         | Bedeutung                               |
> |--------------|-----------------------------------------|
> | date         | Time of change                          |
> | station_uuid | UUID of stations                        |
> | diesel       | Price Diesel                            |
> | e5           | Price Super E5                          |
> | e10          | Price Super E10                         |
> | dieselchange | 0=no change, 1=change, 2=removed, 3=new |
> | e5change     | 0=no change, 1=change, 2=removed, 3=new |
> | e10change    | 0=no change, 1=change, 2=removed, 3=new |

Since the dataset ist quit detailed, and therefor very large (about
11.5GB), we will focus on less information. We will add a `date_app`
column that rounds to the full hour and aggregate all by that and brand.
Therefore, we will no longer have the unique station information, but we
will end up with a more manageable amount of data.

## Preparation and Transformation

For each month there is a different folder labeled `01` to `12`. We will
do the following: - iterate over each month `i in 1:12` - get a list of
files (one file per day) per folder (one folder per month) - open each
file (day) - join the station information, to obtain the `brand`
column - create a date approximation column `date_app`, contain date of
day and the full hour - group by `date_app` and `brand`

The script can be found [here](transforming_cleaning_agg_date_brand.R)

``` r
# joining/merging dataframes
library(dplyr)
# general handling analytics
library(tidyverse)


# open station file
df_station <- read.csv("Datasets/stations.csv")

# initiate an empty dataframe to build upon
df <-  data.frame()

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
            left_join(df_station, by =c("station_uuid"="uuid")) %>%
            select(date, station_uuid, brand, diesel,e5,e10) %>%
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
            group_by(date_app, brand) %>%
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

write.csv(df,file='Datasets/agg_dataset.csv', row.names=FALSE)
```

## Analysis

With the creation of our dataframe behind us, we will now process to do
some analysis. To be more precise we will have a look at the
following: - price per fuel per - `hour` - `weekday` - `tod` (time of
day) - price per fuel per `brand` per - `hour` - `weekday` - `tod` (time
of day) - price per fuel per brand over time

The main question `When and where to refuel?` we be answered during this
investigation.

We start by loading the `tidyverse` library and reading the aggregated
CSV file.

``` r
# general handling analytics
library(tidyverse)

# open station file
df <- read.csv("Datasets/agg_dataset.csv")
```

### Fuel Price by Weekday

We group by `weekday` and consider the average fuel price.

``` r
df %>%
    group_by(weekday) %>%
    summarise(diesel=mean(diesel),
              e5=mean(e5),
              e10=mean(e10))
```

    ## # A tibble: 7 × 4
    ##   weekday    diesel    e5   e10
    ##   <chr>       <dbl> <dbl> <dbl>
    ## 1 Dienstag     1.63  1.77  1.72
    ## 2 Donnerstag   1.62  1.77  1.72
    ## 3 Freitag      1.63  1.77  1.72
    ## 4 Mittwoch     1.62  1.77  1.72
    ## 5 Montag       1.63  1.78  1.72
    ## 6 Samstag      1.63  1.78  1.72
    ## 7 Sonntag      1.63  1.78  1.72

``` r
print(head(df,7))
```

    ##        date_app       brand   diesel       e5      e10 gr_size weekday hour   tod
    ## 1 2024-01-01 00             1.683295 1.775682 1.717955      44  Montag    0 night
    ## 2 2024-01-01 00   A Energie 1.656500 1.774000 1.714000       4  Montag    0 night
    ## 3 2024-01-01 00     ALLGUTH 1.673444 1.737889 1.684556       9  Montag    0 night
    ## 4 2024-01-01 00         AMB 1.709000 1.819000 1.759000       1  Montag    0 night
    ## 5 2024-01-01 00        ARAL 1.794852 1.872968 1.812968    1051  Montag    0 night
    ## 6 2024-01-01 00        AVIA 1.685993 1.775667 1.715993     153  Montag    0 night
    ## 7 2024-01-01 00 AVIA Xpress 1.715818 1.800364 1.740364      11  Montag    0 night

We notice that there is not a huge differance in pricing. This might be
due to larger differences in prices per month.

To see if that might be the case, we first add the column `month`

``` r
df$month <- str_split_i(df$date_app, "-",2)
```

Then we take the average:

``` r
df %>%
        group_by(month) %>%
    summarise(diesel=mean(diesel),
              e5=mean(e5),
              e10=mean(e10))
```

    ## # A tibble: 12 × 4
    ##    month diesel    e5   e10
    ##    <chr>  <dbl> <dbl> <dbl>
    ##  1 01      1.69  1.77  1.71
    ##  2 02      1.73  1.80  1.74
    ##  3 03      1.71  1.82  1.77
    ##  4 04      1.71  1.89  1.83
    ##  5 05      1.65  1.86  1.80
    ##  6 06      1.63  1.81  1.76
    ##  7 07      1.63  1.81  1.75
    ##  8 08      1.58  1.76  1.70
    ##  9 09      1.52  1.69  1.63
    ## 10 10      1.55  1.70  1.65
    ## 11 11      1.57  1.69  1.64
    ## 12 12      1.58  1.70  1.65

``` r
print(head(df,12))
```

    ##         date_app                    brand   diesel       e5      e10 gr_size    weekday hour   tod month
    ## 1  2024-01-01 00                          1.683295 1.775682 1.717955      44    Montag    0 night    01
    ## 2  2024-01-01 00                A Energie 1.656500 1.774000 1.714000       4    Montag    0 night    01
    ## 3  2024-01-01 00                  ALLGUTH 1.673444 1.737889 1.684556       9    Montag    0 night    01
    ## 4  2024-01-01 00                      AMB 1.709000 1.819000 1.759000       1    Montag    0 night    01
    ## 5  2024-01-01 00                     ARAL 1.794852 1.872968 1.812968    1051    Montag    0 night    01
    ## 6  2024-01-01 00                     AVIA 1.685993 1.775667 1.715993     153    Montag    0 night    01
    ## 7  2024-01-01 00              AVIA Xpress 1.715818 1.800364 1.740364      11    Montag    0 night    01
    ## 8  2024-01-01 00                   Access 1.664000 1.739000 1.679000       2    Montag    0 night    01
    ## 9  2024-01-01 00                     Agip 1.812750 1.901500 1.842750      16    Montag    0 night    01
    ## 10 2024-01-01 00            Ahlert Junior 1.705667 1.792333 1.732333       3    Montag    0 night    01
    ## 11 2024-01-01 00         Argos Tankstelle 1.654000 1.729000 1.669000       4    Montag    0 night    01
    ## 12 2024-01-01 00 Autofit Freie Tankstelle 1.739000 1.804000 1.744000       2    Montag    0 night    01

So averaging over, e.g., every **monday**, results in an outcome that’s
to flat.

We will try to count the weekdays that are lowest per week. For that we
need to know the numer of the week:

``` r
df$nweek <- strftime(str_split_i(df$date_app, " ",1), format = "%V")
```

Let us focus in **e10** for a moment.

Next we filter by `nweek` and `week`, form the average and consider
columns were the minimum for each group is present. Then we group by
`weekday` to count the entries. We should end up with a list of weekdays
and how often they were the lowest price

``` r
df_weekdays <- df %>%
    group_by(nweek, weekday) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_e10 = n()) %>%
    arrange(desc(amount_e10))
```

For **e10** we see that **Mondays** and **Tuesdays** are the best ways
to refile in general.

Doing the same for **diesel** and **e5**:

``` r
temp <- df %>%
    group_by(nweek, weekday) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_e5 = n()) %>%
    arrange(desc(amount_e5))

df_weekdays <- left_join(df_weekdays,temp, by = "weekday")

temp <- df %>%
    group_by(nweek, weekday) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel, na.rm=TRUE)) %>%
    group_by(weekday) %>%
    summarise(amount_diesel = n()) %>%
    arrange(desc(amount_diesel))

df_weekdays <- left_join(df_weekdays,temp, by = "weekday")
```

Print the results:

``` r
print(df_weekdays)
```

    ## # A tibble: 7 × 4
    ##   weekday    amount_e10 amount_e5 amount_diesel
    ##   <chr>           <int>     <int>         <int>
    ## 1 Montag             11        11             6
    ## 2 Dienstag           10        10             8
    ## 3 Donnerstag          8         8            11
    ## 4 Mittwoch            8         8             9
    ## 5 Sonntag             6         6             5
    ## 6 Samstag             5         5             5
    ## 7 Freitag             4         4             8

Using this procedure we continue to figure out the best time to refuel.
\### Best Time of Day to Refuel

Adding a `day` column.

``` r
df$day <- str_split_i(df$date_app, " ",1)
```

Then following the same idea as before. Considering the following table,

``` r
df_tod <- df %>%
    group_by(day, tod) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(tod) %>%
    summarise(amount_e10 = n()) %>%
    arrange(desc(amount_e10))

temp <- df %>%
    group_by(day, tod) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(tod) %>%
    summarise(amount_e5 = n()) %>%
    arrange(desc(amount_e5))

df_tod <- left_join(df_tod, temp, by="tod")


temp <- df %>%
    group_by(day, tod) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(tod) %>%
    summarise(amount_diesel = n()) %>%
    arrange(desc(amount_diesel))

df_tod <- left_join(df_tod, temp, by="tod")
```

Printing the output

``` r
print(df_tod)
```

    ## # A tibble: 1 × 4
    ##   tod     amount_e10 amount_e5 amount_diesel
    ##   <chr>        <int>     <int>         <int>
    ## 1 evening        366       366           366

We notice that the best time of day is **evening**. Refueling in the
evening is cheaper for 366 out of 366 days in 2024.

### Best Time to Refuel

We learned the day and the general time of day to refuel. Next we will
see at witch exact hour of the day one should refill.

``` r
df_h <- df %>%
    group_by(day, hour) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(hour) %>%
    summarise(amount_e10 = n()) %>%
    arrange(desc(amount_e10))

temp <- df %>%
    group_by(day, hour) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(hour) %>%
    summarise(amount_e5 = n()) %>%
    arrange(desc(amount_e5))

df_h <- left_join(df_h, temp, by="hour")


temp <- df %>%
    group_by(day, hour) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(hour) %>%
    summarise(amount_diesel = n()) %>%
    arrange(desc(amount_diesel))

df_h <- left_join(df_h, temp, by="hour")
```

Having a look at the table

``` r
print(df_h)
```

    ## # A tibble: 4 × 4
    ##    hour amount_e10 amount_e5 amount_diesel
    ##   <int>      <int>     <int>         <int>
    ## 1    21        269       263           282
    ## 2    19         73        81            71
    ## 3    18         22        21            11
    ## 4    11          2         1             1

we notice that best time to refuel is a 09:00pm.

### Best combination

We do the same as before but we group for all components, namely for
`nweek, weekday, tod` and `hour`. In order to calculate a average price.
Then match it with the minimum per group, that is given by
`weekday, tod` and `hour`. Counting the amount of occupying minima we
obtain the following:

``` r
df_comb_e10 <- df %>%
    group_by(nweek, weekday, tod, hour) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(weekday, tod, hour) %>%
    summarise(amount_e10 = n(), av_e10 = mean(e10)) %>%
    arrange(desc(amount_e10))
```

``` r
print(head(df_comb_e10,10))
```

    ## # A tibble: 10 × 5
    ## # Groups:   weekday, tod [10]
    ##    weekday    tod      hour amount_e10 av_e10
    ##    <chr>      <chr>   <int>      <int>  <dbl>
    ##  1 Donnerstag morning    11         52   1.71
    ##  2 Freitag    morning    11         52   1.71
    ##  3 Mittwoch   morning    11         52   1.71
    ##  4 Montag     morning    11         52   1.71
    ##  5 Samstag    morning    11         52   1.71
    ##  6 Sonntag    morning    11         52   1.70
    ##  7 Dienstag   morning    11         50   1.70
    ##  8 Montag     evening    21         42   1.69
    ##  9 Samstag    evening    21         42   1.68
    ## 10 Sonntag    night       0         42   1.73

Doing the same for **e5** and \*\*diesel:

``` r
df_comb_e5 <- df %>%
    group_by(nweek, weekday, tod, hour) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(weekday, tod, hour) %>%
    summarise(amount_e5 = n(), av_e5 = mean(e5)) %>%
    arrange(desc(amount_e5))
```

``` r
print(head(df_comb_e5,10))
```

    ## # A tibble: 10 × 5
    ## # Groups:   weekday, tod [10]
    ##    weekday    tod      hour amount_e5 av_e5
    ##    <chr>      <chr>   <int>     <int> <dbl>
    ##  1 Dienstag   morning    11        52  1.76
    ##  2 Donnerstag morning    11        52  1.76
    ##  3 Freitag    morning    11        52  1.76
    ##  4 Mittwoch   morning    11        52  1.76
    ##  5 Montag     morning    11        52  1.77
    ##  6 Samstag    morning    11        52  1.76
    ##  7 Sonntag    morning    11        52  1.76
    ##  8 Samstag    evening    21        44  1.74
    ##  9 Montag     evening    21        42  1.74
    ## 10 Freitag    evening    21        41  1.74

``` r
df_comb_diesel <- df %>%
    group_by(nweek, weekday, tod, hour) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(weekday, tod, hour) %>%
    summarise(amount_diesel = n(), av_diesel = mean(diesel)) %>%
    arrange(desc(amount_diesel))
```

``` r
print(head(df_comb_diesel,10))
```

    ## # A tibble: 10 × 5
    ## # Groups:   weekday, tod [10]
    ##    weekday    tod      hour amount_diesel av_diesel
    ##    <chr>      <chr>   <int>         <int>     <dbl>
    ##  1 Donnerstag morning    11            52      1.61
    ##  2 Freitag    morning    11            52      1.62
    ##  3 Mittwoch   morning    11            52      1.61
    ##  4 Montag     morning    11            52      1.62
    ##  5 Samstag    morning    11            52      1.61
    ##  6 Sonntag    morning    11            52      1.61
    ##  7 Dienstag   morning    11            50      1.61
    ##  8 Dienstag   evening    21            44      1.60
    ##  9 Montag     evening    21            44      1.60
    ## 10 Freitag    evening    21            40      1.60
