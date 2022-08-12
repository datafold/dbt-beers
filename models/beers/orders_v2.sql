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
            --add date constants to have sales increase over the course of the year
            + day_of_week
            + week_of_year
            + month_of_year * 200
            + quarter_of_year
            + increasing_constant --up and to the right constant
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
,abv as beer_abv
,breweries.brewery_id
,breweries.brewery_name
,breweries.brewery_state
,breweries.brewery_country
from orders_raw as orders
inner join  {{ ref('beers') }} as beers
    on orders.beer_id = beers.beer_id
inner join  {{ ref('breweries') }} as breweries
    on beers.brewery_id = breweries.brewery_id
