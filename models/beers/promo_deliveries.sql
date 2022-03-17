{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true},
    transient=false
) }}

SELECT
 customer_id,
 'Hoppy' AS promo
FROM {{ ref('orders') }}
WHERE customer_id IN(
    SELECT customer_id 
      FROM {{ ref('orders') }} o
      JOIN {{ ref('order_lines') }} ol
      USING (order_no)
      JOIN {{ ref('beers') }} b
      USING(beer_id)
      GROUP BY 1
      HAVING COUNT(CASE WHEN b.bitterness = 'Hoppy' THEN 1 END) >= 1)
UNION ALL

SELECT
 customer_id,
 'Malty' AS promo
FROM {{ ref('orders') }}
WHERE customer_id IN(
    SELECT customer_id
      FROM {{ ref('orders') }} o
      JOIN {{ ref('order_lines') }} ol
      USING (order_no)
      JOIN {{ ref('beers') }} b
      USING(beer_id)
      GROUP BY 1
     HAVING COUNT(CASE WHEN b.bitterness = 'Malty' THEN 1 END) >= 1)
