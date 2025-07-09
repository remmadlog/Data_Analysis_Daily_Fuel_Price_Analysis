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

Searching for the best combination of **weekday**, **time of day** and **time**, we get the following:

### e10:
| Weekday   | ToD       | Hour    | Amount e10  | average price |
|-----------|-----------|---------|-------------|---------------|
| Thursday  | morning   | 11      | 52          | 1.706         |
| Friday    | morning   | 11      | 52          | 1.707         |
| Wednesday | morning   | 11      | 52          | 1.706         |
| Monday    | morning   | 11      | 52          | 1.709         |
| Saturday  | morning   | 11      | 52          | 1.705         |
| Sunday    | morning   | 11      | 52          | 1.704         |
| Tuesday   | morning   | 11      | 50          | 1.703         |
| Monday    | evening   | 21      | 42          | 1.685         |
| Saturday  | evening   | 21      | 42          | 1.681         |
| Sunday    | night     | 0       | 42          | 1.725         |


### e5:
| Weekday   | ToD      | Hour    | Amount e5  | average price  |
|-----------|----------|---------|------------|----------------|
| Tuesday   | morning  | 11      | 52         | 1.763          |
| Thursday  | morning  | 11      | 52         | 1.762          |
| Friday    | morning  | 11      | 52         | 1.763          |
| Wednesday | morning  | 11      | 52         | 1.762          |
| Monday    | morning  | 11      | 52         | 1.766          |
| Saturday  | morning  | 11      | 52         | 1.762          |
| Sunday    | morning  | 11      | 52         | 1.761          |
| Samstag   | evening  | 21      | 44         | 1.737          |
| Monday    | evening  | 21      | 42         | 1.737          |
| Friday    | evening  | 21      | 41         | 1.742          |

### diesel:
| Weekday   | ToD       | Hour    | Amount diesel   | average price   |
|-----------|-----------|---------|-----------------|-----------------|
| Thursday  | morning   | 11      | 52              | 1.614           |
| Friday    | morning   | 11      | 52              | 1.616           |
| Wednesday | morning   | 11      | 52              | 1.614           |
| Monday    | morning   | 11      | 52              | 1.619           |
| Saturday  | morning   | 11      | 52              | 1.613           |
| Sunday    | morning   | 11      | 52              | 1.612           |
| Tuesday   | morning   | 11      | 50              | 1.614           |
| Tuesday   | evening   | 21      | 44              | 1.597           |
| Monday    | evening   | 21      | 44              | 1.597           |
| Friday    | evening   | 21      | 40              | 1.599           |


## Conclusion

### For the non combine investigation we see the following:

The best **weekday** to refuel are **Friday** and **Saturday** for **e5** and **e10**.

The best **time of day** is the **evening**.

The best **time** is **09:00pm**.

This does not mean that **Monday** at **09:00pm** is always the best time to refuel **e10**.
This marly means that **Monday** is a good day, the **evening** is a solid time versinkt and that **09:00pm** is a cheap time **IN GENERAL**.

### For the combined investigation we see the following:

The price of fuel drops in the morning around 11am.
This is in high contrast to our finding for the best **time of day** as well as for the best **time**.

Let us comment on this.
Take the example of 52 hit for the minimum at **Thursday morning at 11am**.
In **52** out of **366** days, this is the lowest point for the fuel price.
So in about **14%** of all hours of the year **Thursday morning at 11am** is a good bet on average.

Considering that on average, out of 366 days, 366 evening are cheaper than the other **times of the day**, I would rather refuel in the evening that in a Thursday morning at 11am.

Similar is true for the **weekdays**.
Because 11 out of 52 mean that in 21% of all cases Monday is the best day to refuel e10.
That is way beyond 14%.

And for the **time**, we see that about 270 out of 366 days are resulting in 9pm.
That means that 74% of the time it is best to refuel at 9pm.


In conclusion, base on the daily fuel price changes of 2024, I would recommend to refuel at 9pm or in the general versinkt -- the evening.
If it about the day too, I would say go for Monday or Tuesday (e10, e5) or Thursday (diesel).
Might be a good idea to combine this.




## Brand consideration
_WIP_
