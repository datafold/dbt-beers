{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true}
) }}

SELECT
 beers_with_breweries.beer_id               AS beer_id,
 beers_with_breweries.beer_name             AS beer_name,
 beers_with_breweries.beer_style            AS beer_style,
 beers_with_breweries.abv                   AS abv,
 beers_with_breweries.ibu                   AS ibu,
 beers_with_breweries.ounces                AS ounces,

 beers_with_breweries.brewery_id            AS brewery_id,
 beers_with_breweries.brewery_name          AS brewery_name,
 beers_with_breweries.brewery_city          AS brewery_city,
 beers_with_breweries.brewery_state         AS brewery_state,
 beers_with_breweries.brewery_country       AS brewery_country,

 orders.order_no                            AS order_no,
 order_lines.order_line                     AS order_line,
 orders.created_at                          AS order_created_at,
 order_lines.quantity                       AS order_li_quantity,
 order_lines.price                          AS order_li_price_each,
 order_lines.quantity * order_lines.price   AS order_li_price_total

FROM {{ ref('orders') }} orders
JOIN {{ ref('order_lines') }} order_lines USING (order_no)
JOIN {{ ref('beers_with_breweries') }} beers_with_breweries USING (beer_id)