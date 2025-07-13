Daily German Fuel Price Analysis (2024)
================

# TOC

<details>

<summary>

Click to show
</summary>

- [Dataset](#dataset)
- [When Should You Refuel?](#when-should-you-refuel)
  - [Preparation and Transformation](#preparation-and-transformation)
  - [Analysis](#analysis)
    - [Fuel Price by Weekday](#fuel-price-by-weekday)
    - [Best Time of Day to Refuel](#best-time-of-day-to-refuel)
    - [Best Time to Refuel](#best-time-to-refuel)
    - [Best combination](#best-combination)
- [Where to Refuel?](#where-to-refuel)
  - [Brand Analysis](#brand-analysis)
- [Post Code Consideration](#post-code-consideration)

</details>

------------------------------------------------------------------------

# Dataset

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

# When Should You Refuel?

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

# for .md tables
library(pander)

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
pander(head(df,10), style = 'rmarkdown')
```

|   date_app    |     brand     | diesel |  e5   |  e10  | gr_size |
|:-------------:|:-------------:|:------:|:-----:|:-----:|:-------:|
| 2024-01-01 00 |               | 1.683  | 1.776 | 1.718 |   44    |
| 2024-01-01 00 |   A Energie   | 1.657  | 1.774 | 1.714 |    4    |
| 2024-01-01 00 |    ALLGUTH    | 1.673  | 1.738 | 1.685 |    9    |
| 2024-01-01 00 |      AMB      | 1.709  | 1.819 | 1.759 |    1    |
| 2024-01-01 00 |     ARAL      | 1.795  | 1.873 | 1.813 |  1051   |
| 2024-01-01 00 |     AVIA      | 1.686  | 1.776 | 1.716 |   153   |
| 2024-01-01 00 |  AVIA Xpress  | 1.716  |  1.8  | 1.74  |   11    |
| 2024-01-01 00 |    Access     | 1.664  | 1.739 | 1.679 |    2    |
| 2024-01-01 00 |     Agip      | 1.813  | 1.901 | 1.843 |   16    |
| 2024-01-01 00 | Ahlert Junior | 1.706  | 1.792 | 1.732 |    3    |

Table continues below

| weekday | hour |  tod  |
|:-------:|:----:|:-----:|
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |
| Montag  |  0   | night |

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
pander(head(df,10), style = 'rmarkdown')
```

|   date_app    |     brand     | diesel |  e5   |  e10  | gr_size |
|:-------------:|:-------------:|:------:|:-----:|:-----:|:-------:|
| 2024-01-01 00 |               | 1.683  | 1.776 | 1.718 |   44    |
| 2024-01-01 00 |   A Energie   | 1.657  | 1.774 | 1.714 |    4    |
| 2024-01-01 00 |    ALLGUTH    | 1.673  | 1.738 | 1.685 |    9    |
| 2024-01-01 00 |      AMB      | 1.709  | 1.819 | 1.759 |    1    |
| 2024-01-01 00 |     ARAL      | 1.795  | 1.873 | 1.813 |  1051   |
| 2024-01-01 00 |     AVIA      | 1.686  | 1.776 | 1.716 |   153   |
| 2024-01-01 00 |  AVIA Xpress  | 1.716  |  1.8  | 1.74  |   11    |
| 2024-01-01 00 |    Access     | 1.664  | 1.739 | 1.679 |    2    |
| 2024-01-01 00 |     Agip      | 1.813  | 1.901 | 1.843 |   16    |
| 2024-01-01 00 | Ahlert Junior | 1.706  | 1.792 | 1.732 |    3    |

Table continues below

| weekday | hour |  tod  | month |
|:-------:|:----:|:-----:|:-----:|
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |
| Montag  |  0   | night |  01   |

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
pander(df_weekdays, style = 'rmarkdown')
```

|  weekday   | amount_e10 | amount_e5 | amount_diesel |
|:----------:|:----------:|:---------:|:-------------:|
|   Montag   |     11     |    11     |       6       |
|  Dienstag  |     10     |    10     |       8       |
| Donnerstag |     8      |     8     |      11       |
|  Mittwoch  |     8      |     8     |       9       |
|  Sonntag   |     6      |     6     |       5       |
|  Samstag   |     5      |     5     |       5       |
|  Freitag   |     4      |     4     |       8       |

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
pander(df_tod, style = 'rmarkdown')
```

|   tod   | amount_e10 | amount_e5 | amount_diesel |
|:-------:|:----------:|:---------:|:-------------:|
| evening |    366     |    366    |      366      |

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
pander(df_h, style = 'rmarkdown')
```

| hour | amount_e10 | amount_e5 | amount_diesel |
|:----:|:----------:|:---------:|:-------------:|
|  21  |    269     |    263    |      282      |
|  19  |     73     |    81     |      71       |
|  18  |     22     |    21     |      11       |
|  11  |     2      |     1     |       1       |

we notice that best time to refuel is a 09:00pm.

### Best combination

We do the same as before but we group for all components, namely for
`nweek, weekday` and `hour`. In order to calculate an average price.
Then match it with the minimum per group, that is given by `weekday` and
`hour`. Counting the amount of occupying minima we obtain the following:

``` r
df_comb_e10 <- df %>%
    group_by(nweek, weekday, hour) %>%
    summarise(e10=mean(e10)) %>%
    filter(e10 == min(e10)) %>%
    group_by(weekday, hour) %>%
    summarise(amount_e10 = n()) %>%
    arrange(desc(amount_e10))
```

``` r
pander(head(df_comb_e10,10), style = 'rmarkdown')
```

|  weekday   | hour | amount_e10 |
|:----------:|:----:|:----------:|
|   Montag   |  21  |     42     |
|  Samstag   |  21  |     42     |
|  Freitag   |  21  |     41     |
|  Dienstag  |  21  |     40     |
| Donnerstag |  21  |     40     |
|  Sonntag   |  21  |     34     |
|  Mittwoch  |  21  |     30     |
|  Mittwoch  |  19  |     16     |
|  Sonntag   |  19  |     12     |
|  Dienstag  |  19  |     10     |

Doing the same for **e5** and \*\*diesel:

``` r
df_comb_e5 <- df %>%
    group_by(nweek, weekday, hour) %>%
    summarise(e5=mean(e5)) %>%
    filter(e5 == min(e5)) %>%
    group_by(weekday, hour) %>%
    summarise(amount_e5 = n()) %>%
    arrange(desc(amount_e5))
```

``` r
pander(head(df_comb_e5,10), style = 'rmarkdown')
```

|  weekday   | hour | amount_e5 |
|:----------:|:----:|:---------:|
|  Samstag   |  21  |    44     |
|   Montag   |  21  |    42     |
|  Freitag   |  21  |    41     |
|  Dienstag  |  21  |    36     |
| Donnerstag |  21  |    36     |
|  Sonntag   |  21  |    35     |
|  Mittwoch  |  21  |    29     |
|  Mittwoch  |  19  |    17     |
|  Dienstag  |  19  |    13     |
| Donnerstag |  19  |    13     |

``` r
df_comb_diesel <- df %>%
    group_by(nweek, weekday, hour) %>%
    summarise(diesel=mean(diesel)) %>%
    filter(diesel == min(diesel)) %>%
    group_by(weekday, hour) %>%
    summarise(amount_diesel = n()) %>%
    arrange(desc(amount_diesel))
```

``` r
pander(head(df_comb_diesel,10), style = 'rmarkdown')
```

|  weekday   | hour | amount_diesel |
|:----------:|:----:|:-------------:|
|  Dienstag  |  21  |      44       |
|   Montag   |  21  |      44       |
|  Freitag   |  21  |      40       |
|  Sonntag   |  21  |      40       |
| Donnerstag |  21  |      39       |
|  Samstag   |  21  |      37       |
|  Mittwoch  |  21  |      36       |
|  Mittwoch  |  19  |      14       |
|  Samstag   |  19  |      13       |
|  Freitag   |  19  |      11       |

Lastly we create a tabel, that contains the average prices for all
weekdays at 7pm and 9pm.

``` r
df %>%
      group_by(weekday, hour) %>%
      summarise(av_e10 = mean(e10),
                av_e5 = mean(e5),
                av_diesel = mean(diesel)) %>%
      filter(hour == 21 | hour == 19) %>%
      pander(style = 'rmarkdown')
```

    ## `summarise()` has grouped output by 'weekday'. You can override using the
    ## `.groups` argument.

|  weekday   | hour | av_e10 | av_e5 | av_diesel |
|:----------:|:----:|:------:|:-----:|:---------:|
|  Dienstag  |  19  | 1.694  | 1.751 |   1.601   |
|  Dienstag  |  21  | 1.685  | 1.742 |   1.588   |
| Donnerstag |  19  | 1.694  | 1.751 |    1.6    |
| Donnerstag |  21  | 1.685  | 1.742 |   1.588   |
|  Freitag   |  19  | 1.695  | 1.752 |   1.602   |
|  Freitag   |  21  | 1.686  | 1.743 |   1.59    |
|  Mittwoch  |  19  | 1.694  | 1.751 |    1.6    |
|  Mittwoch  |  21  | 1.685  | 1.742 |   1.588   |
|   Montag   |  19  | 1.696  | 1.753 |   1.604   |
|   Montag   |  21  | 1.687  | 1.744 |   1.592   |
|  Samstag   |  19  | 1.697  | 1.754 |   1.603   |
|  Samstag   |  21  | 1.689  | 1.746 |   1.592   |
|  Sonntag   |  19  | 1.701  | 1.758 |   1.608   |
|  Sonntag   |  21  | 1.692  | 1.749 |   1.595   |

# Where to Refuel?

## Brand Analysis

We start by calculating the brands with the highest amount of having the
lowest price per day for e10. Here is no consideration of how common the
brand is or how many stations there are

``` r
temp <- df %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(e10 = mean(e10)) %>%                  # calculate av price for each entry -> ungroups subgroup (brand)
  filter(e10 == min(e10)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(e10 = mean(e10), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))
```

Having a look at the output:

``` r
pander(head(temp,10), style = 'rmarkdown')
```

|          brand          |  e10  | size |
|:-----------------------:|:-----:|:----:|
|    Union Zapfstelle     | 1.604 |  98  |
|  Tankstelle Scharlibbe  | 1.65  |  74  |
| GILLET tanken & waschen | 1.58  |  42  |
|    V-Markt Mainburg     | 1.654 |  15  |
|       Winkler 24h       | 1.579 |  13  |
|   DONIG ARAL-Vertrieb   | 1.646 |  10  |
|  Hoffmann Tankstellen   | 1.674 |  6   |
|      Schnorberger       | 1.674 |  6   |
|  Tankstelle Logabirum   | 1.667 |  6   |
|    V-Markt Lauingen     | 1.639 |  5   |

In order to take the amount of stations by brand in consideration we
consider `stations.csv`.

``` r
df_station <- read.csv("Datasets/stations.csv")

df_brand_size <- df_station %>%
  filter(brand!="") %>%           # rmoving unknown brands (blank)
  group_by(brand) %>%
  summarise(size=n()) %>%         # count how many stations are there (size of group)
  arrange(desc(size))
```

We will only consider brand with more than `fsize` stations. In our case
we set `fsize = 300`.

``` r
fsize <- 300

df_brand_size_fsize <- df_brand_size %>%
  filter(size >= fsize)
```

Repeating the evaluation from before, but only considering brand with
300 or more stations.

``` r
temp <- df %>%
  filter(brand %in% df_brand_size_fsize$brand) %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(e10 = mean(e10))  %>%                 # calculate av price for each entry -> ungroups subgroup (brand)
  filter(e10 == min(e10)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(e10 = mean(e10), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))
```

Leads to the following:

``` r
pander(head(temp,10), style = 'rmarkdown')
```

| brand |  e10  | size |
|:-----:|:-----:|:----:|
|  JET  | 1.702 | 211  |
| STAR  | 1.716 |  76  |
|  HEM  | 1.713 |  58  |
| AVIA  | 1.778 |  20  |
| ESSO  | 1.656 |  1   |

We see that **JET** is on **211** days the cheapest brand on average for
e10, out of 366 possible days of 2024.

For **e5** and **diesel** we are following the example above:

``` r
temp_e5 <- df %>%
  filter(brand %in% df_brand_size_fsize$brand) %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(e5 = mean(e5))  %>%                 # calculate av price for each entry -> ungroups subgroup (brand)
  filter(e5 == min(e5)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(e5 = mean(e5), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))

temp_diesel <- df %>%
  filter(brand %in% df_brand_size_fsize$brand) %>%
  group_by(day,brand) %>%                         # group brand per day
  summarise(diesel = mean(diesel))  %>%                 # calculate av price for each entry -> ungroups subgroup (brand)
  filter(diesel == min(diesel)) %>%                     # find min for each group (day)
  group_by(brand) %>%                             # groups each brand over possible 366 days
  summarise(diesel = mean(diesel), size=n()) %>%        # calculate av price per brand and count group size (how often was it min)
  arrange(desc(size))
```

Leads to the following:

``` r
pander(head(temp_e5,10), style = 'rmarkdown')
```

|   brand    |  e5   | size |
|:----------:|:-----:|:----:|
|    JET     | 1.764 | 202  |
|    STAR    | 1.772 |  86  |
|    HEM     | 1.766 |  52  |
|    AVIA    | 1.84  |  19  |
| Raiffeisen | 1.802 |  5   |
|    ESSO    | 1.701 |  2   |

``` r
pander(temp_diesel, style = 'rmarkdown')
```

|   brand    | diesel | size |
|:----------:|:------:|:----:|
| Raiffeisen | 1.636  | 162  |
|    JET     |  1.61  | 112  |
|    STAR    | 1.611  |  91  |
|    HEM     | 1.543  |  1   |

# Post Code Consideration

For this section, we will consider an example in order to reduce the
need to work with a lot of the data.

For this we follow the example of
`transforming_cleaning_agg_date_brand.R`, but instead of aggregating
over all ids, we want to be able to differentiate the stations. Since we
would obtain a large and long file if we consider all the possible post
codes, we only focus on one specific post code: **33100**.

``` r
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
            select(date, station_uuid, post_code, city, brand, diesel,e5,e10) %>%
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
            group_by(date_app, station_uuid, post_code, city, brand) %>%
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
```

**To be continued**
