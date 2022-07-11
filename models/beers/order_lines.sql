{{ config(
    materialized='table',
    unique_key='order_line',
    persist_docs={"relation": true, "columns": true}
) }}

-- We'll fake some data, since this is an example repository
-- we want to make sure that we continue to generate data up
-- to today

WITH day_table AS (SELECT seq4() day_ago from table(generator(rowcount=>30))),
order_table  AS (SELECT seq4() order_number from table(generator(rowcount=>10))),
line_table  AS (SELECT seq4() line_no from table(generator(rowcount=>3))) 

SELECT {{ date_format() }}(
           DATEADD(Day, -1 * day_ago , current_timestamp),
           concat('YYYYMMDD',cast(order_number as varchar))
       )                                                   AS order_no,
       {{ date_format() }}(
           DATEADD(Day, -1 *  day_ago, current_timestamp),
           CONCAT('YYYYMMDD', cast(order_number as varchar),cast(line_no))
       )                                                   AS order_line,
       (
       -- Deterministically select a random beer
           SELECT MOD(
                      ABS(HASH( order_number + line_no )),
                      (
                          SELECT MAX(beer_id) FROM {{ ref('beers') }}
                      )
           )
       )                                                   AS beer_id,
       1 +MOD(ABS(HASH( order_number + line_no )), 3)      AS quantity,
       MOD(ABS(HASH( order_number + line_no )), 300) / 100 AS price,
       DATEADD(Day, -1 *  day_ago , current_timestamp)     AS created_at,
       current_timestamp                                   AS changed_at


from
    day_table cross join order_table cross join line_table



{% if is_incremental() %}
    WHERE created_at::date > (SELECT MAX(created_at)::date FROM {{ this }})
{% endif %}
