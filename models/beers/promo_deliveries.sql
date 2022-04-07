{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true},
    transient=false
) }}

SELECT customer_id,
       'Hoppy' AS promo,
       COUNT(DISTINCT b.beer_name) AS cnt_beers_purchased    
  FROM {{ ref('orders') }} o
  JOIN {{ ref('order_lines') }} ol
  USING (order_no)
  JOIN {{ ref('beers') }} b
  USING(beer_id)
  GROUP BY 1
  HAVING SUM(b.bitterness = 'Hoppy')
         >
         SUM(b.bitterness = 'Malty')

UNION

SELECT customer_id,
       'Malty' AS promo,
       COUNT(DISTINCT b.beer_name) AS cnt_beers_purchased
  FROM {{ ref('orders') }} o
  JOIN {{ ref('order_lines') }} ol
  USING (order_no)
  JOIN {{ ref('beers') }} b
  USING(beer_id)
  GROUP BY 1
  HAVING SUM(b.bitterness = 'Malty')
         >
         SUM(b.bitterness = 'Hoppy')


