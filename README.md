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

> For questions related to an even more general overview, like month behaviour, we refer to [this](https://github.com/remmadlog/Data_Analysis_Fuel_Prices/tree/master) project.

> The dataset used can be found [here](https://dev.azure.com/tankerkoenig/_git/tankerkoenig-data?path=/README.md&_a=preview).

> Folderstructure:
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

> For an overview of the code see the ``.rmd`` [Daily_Fuel_Analysis.md](Daily_Fuel_Analysis.md) or the ``.R`` files 
> [time_analysis.R](time_analysis.R)
> [transforming_cleaning_agg_date_brand.R](transforming_cleaning_agg_date_brand.R)
> [brand_analysis.R](brand_analysis.R)

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

## Post Code Consideration
For this section, we will consider an example in order to reduce the need to work with a lot of the data.

**WIP**