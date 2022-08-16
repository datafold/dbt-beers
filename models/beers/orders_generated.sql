{{ config(
    materialized='table',
    persist_docs={"relation": true, "columns": true}
) }}


with dates as ( --generate dates for the last year
  select
  dateadd(day,-seq4(),current_date) as _date
  from table(generator(rowcount => (365
                                   )))
)

,generate_seasonal_data as (
    select
    _date
    --date parts
    ,quarter(_date) as quarter_of_year
    ,month(_date) as month_of_year
    ,weekofyear(_date) as week_of_year
    ,dayofweek(_date) as day_of_week
    ,dayofyear(_date) as day_of_year
    ,_date - '2021-01-01'::date as increasing_constant
    --beer holidays
    ,to_char(_date,'mm-dd') in (
        '03-17' --St Patrick's
        ,'07-04' --4th of July
        ,'11-24' --Thanksgiving
        ,'12-25' --Christmas
        ,'12-31' --New Year's
    ) as is_beer_holiday
    ,case --beer orders increase preceeding beer holidays
        when is_beer_holiday then 10
        when lag(is_beer_holiday,-1) over (order by _date) then 9
        when lag(is_beer_holiday,-2) over (order by _date) then 8
        when lag(is_beer_holiday,-3) over (order by _date) then 7
        when lag(is_beer_holiday,-4) over (order by _date) then 6
        when lag(is_beer_holiday,-5) over (order by _date) then 5
        when lag(is_beer_holiday,-6) over (order by _date) then 4
        when lag(is_beer_holiday,-7) over (order by _date) then 3
        when lag(is_beer_holiday,-8) over (order by _date) then 2
        when lag(is_beer_holiday,-9) over (order by _date) then 1
        else 0
    end as beer_holiday_constant
    --generate seasonal data using cosine
    ,500 as mean
    ,1000 as offset
    ,cos(day_of_year/365*52*pi()- pi() ) * mean + offset as cycle
    --add noise to seasonal data using normal function
    ,100 as noise_mean
    ,250 as noise_var
    ,normal(noise_mean,noise_var,random()) as noise --normally distributed random #s
    ,cycle 
            + noise
            + month_of_year * 150 --increase orders over the course of the year
            + beer_holiday_constant * 150 --increase orders around holidays
            + increasing_constant --general increase over time
            + case --new years smoothing
                when day_of_year between 1 and 15 then 1000
                when day_of_year between 16 and 40 then 500
                else 0 end
        as seed_data_point
    from dates
)

,daily_total_orders as (
    select
    _date as order_date
    ,seed_data_point::int as total_orders
    from generate_seasonal_data
)

,row_numbers as ( --generate a row numbers to be used to construct orders table
    select row_number() over (order by seq4()) as row_num from table(generator(rowcount=>10000))
)

,order_rows as ( --use row_numbers and synthetic data to create a row for each order
    select 
    orders.order_date
    ,row_numbers.row_num
    from daily_total_orders as orders
    inner join row_numbers on row_numbers.row_num <= orders.total_orders
    order by 1,2
)

,orders_raw as ( --create order number and beer id
    select
    order_date
    ,to_char(order_date,'yyyymmdd')||lpad(row_num,5,0) as order_number
    ,normal(1000, 250, random())::int as beer_id --randomly generate beer id (normalized distribution; mean id 1000, dev 250)
    from order_rows
)

select
orders.order_date
,orders.order_number
,beers.beer_id
,beers.beer_name
,beers.beer_style
,beers.abv as beer_abv
,beers.bitterness
,breweries.brewery_id
,breweries.brewery_name
,breweries.brewery_state
,breweries.brewery_country
from orders_raw as orders
inner join  {{ ref('beers') }} as beers
    on orders.beer_id = beers.beer_id
inner join  {{ ref('breweries') }} as breweries
    on beers.brewery_id = breweries.brewery_id
