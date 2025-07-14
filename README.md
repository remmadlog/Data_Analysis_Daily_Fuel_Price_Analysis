# TOC
<details>
  <summary>Click to show</summary>

  - [Daily Fuel Prices in Germany in 2024](#daily-fuel-prices-in-germany-in-2024)
    * [Best Day to Refuel](#best-day-to-refuel)
      * [Best Time of Day to Refuel](#best-time-of-day-to-refuel)
      * [Best Time to Refuel](#best-time-to-refuel)
      * [Best Combination of Weekday, Time of Day and Hour](#best-combination-of-weekday-time-of-day-and-hour)
        + [e10:](#e10)
        + [e5:](#e5)
        + [diesel:](#diesel)
      * [Conclusion](#conclusion)
        + [For the non combine investigation we see the following:](#for-the-non-combine-investigation-we-see-the-following)
        + [For the combined investigation we see the following:](#for-the-combined-investigation-we-see-the-following)
      * [Brand consideration](#brand-consideration)

</details>

---


# Daily Fuel Prices in Germany in 2024

This project is a learning project.
We will mainly use **R** to answer the following questions:
- What is the best **day** to refuel?
- What **time of day** is the cheapest to refuel?
  - In a more general sense: ``morning, midday, evening, night``.
  - In a detailed sense: ``00:00, 01:00, ..., 23:00``.
- Wich brand should you use to save money?
- Location base example:
  - What stations in ``postcode`` are good to use, e.g.,
    - on **Monday**
    - in the **morning**
    - at **4am**.

> [!IMPORTANT]
> We marly present results in this file, for more explanations and details see [Daily_Fuel_Analysis.md](Daily_Fuel_Analysis.md).

> [!NOTE]
> For questions related to an even more general overview, like month behaviour, we refer to [this](https://github.com/remmadlog/Data_Analysis_Fuel_Prices/tree/master) project.

> [!NOTE]
> The dataset used can be found [here](https://dev.azure.com/tankerkoenig/_git/tankerkoenig-data?path=/README.md&_a=preview).

> [!NOTE]
> Folder structure:
> - Dataset
>   - 2024
>     - 01
>       - 2024-01-01-prices.csv
>       - ...
>       - 2024-01-31-prices.csv
>     - ...
>       - ...
>     - 12
>       - ...
>   - ``agg_dataset.csv``
>   - ``stations.scv``


> [!NOTE]
> Regarding cleaning, we could do more than we will.
> We could reduce outliers by searching for gaps or ``wrong`` data, or we could get rid of stations near highways.
> But since this is a small learning project, we will skip this and be more rough by filtering (price should inbetween 0.7 and 3).


## Best Day to Refuel
To avoid getting a too general average, I decided to track the cheapest day of each week in 2024.
As a result we get the following table in decreasing order.

| time of day | amount_e10  | amount_e5 | amount_diesel |
|-------------|-------------|-----------|---------------|
| Friday      | 4           | 4         | 8             | 
| Saturday    | 5           | 5         | 5             |
| Sunday      | 6           | 6         | 5             |
| Thursday    | 8           | 8         | 11            |
| Wednesday   | 8           | 8         | 9             |
| Tuesday     | 10          | 10        | 8             |
| Monday      | 11          | 11        | 6             |


## Best Time of Day to Refuel

Following the same idea as for the weekdays, I tracked the amount of the cheapest ``tod`` for each day.
Out of 366 day in 2024, at 366 days it is cheaper to refuel in the evening, between 06:00pm and 11:59pm.

| time of day | amount_e10 | amount_e5 | amount_diesel |
|-------------|------------|-----------|---------------|
| evening     | 366        | 366       | 366           |


## Best Time to Refuel

Again tracking the amount, this time of the best time (full hour) per day we get the following table.

| time     | amount_e10 | amount_e5 | amount_diesel |
|----------|------------|-----------|---------------|
| 11:00 am | 2          | 1         | 1             |
| 06:00 pm | 22         | 21        | 11            |
| 07:00 pm | 73         | 81        | 71            |
| 09:00 pm | 269        | 263       | 286           |

We conclude, that, in general, 09:00pm is the best time to refuel, if you want to save the most.

> [!IMPORTANT]
> We should take in consideration, that the price of fuel does not change each hour. So this result might be a bit misleading, 
> since we only have information about the time a price changed.
> But therefore we considered the general time of day and concluded that **evening** is a good time to refuel.


## Best Combination of Weekday, Time of Day and Hour

Searching for the best combination of **weekday** and **time**, we obtain the table below.
In there, the average price is the mean over all ``weekday`` x ``time`` combinations, e.g. the average price for **Monday** at **9om**.


### e10:
| weekday    | hour | amount_e10 | av_e10 |
|:----------:|:----:|:----------:|:------:|
|   Monday   |  21  |     42     | 1.687  |
|  Saturday  |  21  |     42     | 1.689  |
|   Friday   |  21  |     41     | 1.686  |
|  Tuesday   |  21  |     40     | 1.685  |
|  Thursday  |  21  |     40     | 1.685  |
|   Sunday   |  21  |     34     | 1.692  |
| Wednesday  |  21  |     30     | 1.685  |
| Wednesday  |  19  |     16     | 1.694  |
|   Sunday   |  19  |     12     | 1.701  |
|  Tuesday   |  19  |     10     | 1.694  |


### e5:
| weekday    | hour | amount_e5 | av_e5 |
|:----------:|:----:|:---------:|:-----:|
|  Saturday  |  21  |    44     | 1.746 |
|   Monday   |  21  |    42     | 1.744 |
|   Friday   |  21  |    41     | 1.743 |
|  Tuesday   |  21  |    36     | 1.742 |
|  Thursday  |  21  |    36     | 1.742 |
|   Sunday   |  21  |    35     | 1.749 |
| Wednesday  |  21  |    29     | 1.742 |
| Wednesday  |  19  |    17     | 1.751 |
|  Tuesday   |  19  |    13     | 1.751 |
|  Thursday  |  19  |    13     | 1.751 |

### diesel:
| weekday    | hour | amount_diesel | av_diesel |
|:----------:|:----:|:-------------:|:---------:|
|  Tuesday   |  21  |      44       |   1.588   |
|   Monday   |  21  |      44       |   1.592   |
|   Friday   |  21  |      40       |   1.590   |
|   Sunday   |  21  |      40       |   1.595   |
|  Thursday  |  21  |      39       |   1.588   |
|  Saturday  |  21  |      37       |   1.592   |
| Wednesday  |  21  |      36       |   1.588   |
| Wednesday  |  19  |      14       |   1.600   |
|  Saturday  |  19  |      13       |   1.603   |
|   Friday   |  19  |      11       |   1.602   |


## Conclusion

### For the non combine investigation we see the following:

The best **weekday** to refuel are **Friday** and **Saturday** for **e5** and **e10**.

The best **time of day** is the **evening**.

The best **time** is **09:00pm**.

This does not mean that **Monday** at **09:00pm** is always the best time to refuel **e10**.
This marly means that **Monday** is a good day, the **evening** is a solid time versinkt and that **09:00pm** is a cheap time **IN GENERAL**.

### For the combined investigation we see the following:

The price of fuel drops in the evening around 9pm.
This reflects the findings so far.

We notice that the **weekday** is not as important as the **time**.
All fuel prices drop around 7pm and 9pm on all days.
Therefore, rather focusing on a day, focus on the time.




## Brand consideration

Answering the question of **Where to refuel?**, we proceed as follows:
First we only consider **brands** with at least **300** stations.
Then we continue to proceed as before, by counting how often a brand has the lowest price out of 366 days.
Thus, resulting in the following table:

| e10 | brand | amount | e5 | brand      | amount   | diesel  | brand      | amount  |
|-----|-------|--------|----|------------|----------|---------|------------|---------|
|     | JET   | 211    |    | JET        | 202      |         | Raiffeisen | 162     |
|     | STAR  | 76     |    | STAR       | 86       |         | JET        | 112     |
|     | HEM   | 58     |    | HEM        | 52       |         | STAR       | 91      |
|     | AVIA  | 20     |    | AVIA       | 19       |         | HEM        | 1       |
|     | ESSO  | 1      |    | Raiffeisen | 5        |         |            |         | 



## Postcode Consideration
For this section, we will consider an example in order to reduce the need to work with a lot of the data.


### Creating the File
Starting with filtering and transforming in [transforming_cleaning_agg_location.R](transforming_cleaning_agg_location.R), 
we obtain a dataset, [agg_dataset_location.csv](Datasets/agg_dataset_location.csv), for the postcode **33100**.


### Analysis
Using this ``.csv`` we first consider for each day of each week the cheapest station.
Counting their appearance results in the following tables:

<details>
<summary>Diesel Table</summary>

|  weekday   |             station_uuid             |                         df_station.name                          | size |
|:----------:|:------------------------------------:|:----------------------------------------------------------------:|:----:|
|  Dienstag  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  33  |
|  Dienstag  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  15  |
|  Dienstag  | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  4   |
| Donnerstag | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  30  |
| Donnerstag | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  19  |
| Donnerstag | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  2   |
| Donnerstag | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|  Freitag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  37  |
|  Freitag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  14  |
|  Freitag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|  Mittwoch  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  43  |
|  Mittwoch  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  7   |
|  Mittwoch  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|   Montag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  38  |
|   Montag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  11  |
|   Montag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|   Montag   | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|  Samstag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  28  |
|  Samstag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  23  |
|  Samstag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|  Sonntag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  35  |
|  Sonntag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  17  |
|  Sonntag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |

</details>


<details>
<summary>E5 Table</summary>

|  weekday   |             station_uuid             |                         df_station.name                          | size |
|:----------:|:------------------------------------:|:----------------------------------------------------------------:|:----:|
|  Dienstag  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  30  |
|  Dienstag  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  15  |
|  Dienstag  | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  5   |
|  Dienstag  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
| Donnerstag | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  26  |
| Donnerstag | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  19  |
| Donnerstag | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  4   |
| Donnerstag | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  3   |
|  Freitag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  32  |
|  Freitag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  17  |
|  Freitag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|  Freitag   | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|  Mittwoch  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  28  |
|  Mittwoch  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  22  |
|  Mittwoch  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|  Mittwoch  | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|   Montag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  30  |
|   Montag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  20  |
|   Montag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|   Montag   | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|  Samstag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  25  |
|  Samstag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  25  |
|  Samstag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|  Sonntag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  29  |
|  Sonntag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  19  |
|  Sonntag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  4   |

</details>


<details>
<summary>E10 Table</summary>

|  weekday   |             station_uuid             |                         df_station.name                          | size |
|:----------:|:------------------------------------:|:----------------------------------------------------------------:|:----:|
|  Dienstag  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  31  |
|  Dienstag  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  15  |
|  Dienstag  | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  4   |
|  Dienstag  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
| Donnerstag | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  28  |
| Donnerstag | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  17  |
| Donnerstag | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  4   |
| Donnerstag | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  3   |
|  Freitag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  33  |
|  Freitag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  16  |
|  Freitag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|  Freitag   | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|  Mittwoch  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  27  |
|  Mittwoch  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  22  |
|  Mittwoch  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|  Mittwoch  | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  1   |
|   Montag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  29  |
|   Montag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  20  |
|   Montag   | 7e153319-1803-4975-8b72-9cacdbcd4e84 |                  Raiffeisen Westfalen Mitte eG                   |  2   |
|   Montag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  1   |
|  Samstag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  26  |
|  Samstag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  25  |
|  Samstag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  2   |
|  Sonntag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  31  |
|  Sonntag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  17  |
|  Sonntag   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  4   |

</details>

There we see for each day of the week, wich station and how often the station was the cheapest.



Following this example but reducing the output, we continue with a focus on **e10** and only the highest appearance, 
and investigate which station is the best at each day of the week, time of day and hour.

Resulting in the following table for the **day of the week**:

|  weekday   |             station_uuid             |        df_station.name        | size |
|:----------:|:------------------------------------:|:-----------------------------:|:----:|
|  Dienstag  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |  Tankstelle SB-Zentralmarkt   |  31  |
| Donnerstag | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |  Tankstelle SB-Zentralmarkt   |  28  |
|  Freitag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b | Raiffeisen Westfalen Mitte eG |  33  |
|  Mittwoch  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b | Raiffeisen Westfalen Mitte eG |  27  |
|   Montag   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b | Raiffeisen Westfalen Mitte eG |  29  |
|  Samstag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |  Tankstelle SB-Zentralmarkt   |  26  |
|  Sonntag   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |  Tankstelle SB-Zentralmarkt   |  31  |

> Out of 52

For the **time of day** we end up with this list:

|   tod   |             station_uuid             |                         df_station.name                          | size |
|:-------:|:------------------------------------:|:----------------------------------------------------------------:|:----:|
| evening | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 | 143  |
| midday  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    | 199  |
| morning | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    | 219  |
|  night  | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 | 237  |

> Out of 366


And lastly for each **hour** of the day, we get a longer table:

| hour |             station_uuid             |                       df_station.name                            | size   |
|:----:|:------------------------------------:|:----------------------------------------------------------------:|:------:|
|  0   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  159   |
|  1   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |   49   |
|  2   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |   5    |
|  3   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |   3    |
|  3   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |   3    |
|  4   | 0b173b12-5ff4-4fe3-93f5-c2c1b07fbb84 |                          Michael Dirker                          |  196   |
|  5   | 51d4b673-a095-1aa0-e100-80009459e03a | Supermarkt-Tankstelle am real,- Markt PADERBORN HUSENER STR. 121 |  340   |
|  6   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  156   |
|  7   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  248   |
|  8   | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  278   |
|  9   | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |  209   |
|  10  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  327   |
|  11  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  259   |
|  12  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  175   |
|  13  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  290   |
|  14  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  203   |
|  15  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  207   |
|  16  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  252   |
|  17  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  262   |
|  18  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  199   |
|  19  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  185   |
|  20  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  157   |
|  21  | 6197ee84-4a05-4b40-a8f4-e33c07aac90a |                    Tankstelle SB-Zentralmarkt                    |  131   |
|  22  | 0b173b12-5ff4-4fe3-93f5-c2c1b07fbb84 |                          Michael Dirker                          |  229   |
|  23  | 078712a4-aaf4-4bce-b2a8-3f6a25ef055b |                  Raiffeisen Westfalen Mitte eG                   |   66   |

> Out of 366



### Remarks
For a different postcode one can change ``postcode`` in line **14** of [transforming_cleaning_agg_location.R](transforming_cleaning_agg_location.R).
Modifying a bit more would make it possible to consider multiple postcodes, e.g., make a postcode list and filter for ``post_code %in% postcode_list``.

Changing ``postcode`` to ``city`` one could consider a whole city instead of a postcode area.

> [!IMPORTANT]
> In this case one has to clean the ``city`` column.
> An example for this can be found [here](https://github.com/remmadlog/Data_Analysis_Fuel_Prices/blob/master/Analysis_Fuel_Price.md) under **Location Comparison**.

For more information, we can change ``e10_hour <- df_loc_hour_e10 %>% filter(size==max(size))`` to ``e10_hour <- df_loc_hour_e10``.

If one wants results for a different fuel, they just needed to change ``e10`` to their preferred fuel.
