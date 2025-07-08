# Daily Fuel Prices in Germany in 2024

This project is a learning project.
We will mainly use **R** to answer the following questions:
- What is the best **day** to refuel?
- What **time of day** is the cheapest to refuel?
  - In a more general sense: ``morning, midday, evening, night``.
  - In a detailed sense: ``00:00, 01:00, ..., 23:00``.
- Wich brand should you use to save money?

> For questions related to an even more general overview, like month behaviour, we refer to [this](https://github.com/remmadlog/Data_Analysis_Fuel_Prices/tree/master) project.

> For an overview of the code see the ``.rmd`` [Daily_Fuel_Analysis.md](Daily_Fuel_Analysis.md) or the ``.R`` files 
> [time_analysis.R](time_analysis.R)
> [transforming_cleaning.R](transforming_cleaning.R)

## Best Day to Refuel
To avoid getting a too general average, I decided to track the cheapest day of each week in 2024.
As a result we get the following table in decreasing order.

| time of day | amount_e10  | amount_e5 | amount_diesel  |
|-------------|-------------|-----------|----------------|
| Friday      | 4           |  4        | 8              | 
| Saturday    | 5           | 5         | 5              |
| Sunday      | 6           | 6         | 5              |
| Thursday    | 8           | 8         | 11             |
| Wednesday   | 8           | 8         | 9              |
| Tuesday     | 10          | 10        | 8              |
| Monday      | 11          | 11        | 6              |


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


## Conclusion

The best **weekday** to refuel are **Friday** and **Saturday** for **e5** and **e10**.

The best **time of day** is the **evening**.

The best **time** is **09:00pm**.

This does not mean that **Monday** at **09:00pm** is always the best time to refuel **e10**.
This marly means that **Monday** is a good day, the **evening** is a solid time versinkt and that **09:00pm** is a cheap time **IN GENERAL**.


## Brand consideration
_WIP_
