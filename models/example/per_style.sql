{{ config(
    materialized="table"
) }}

SELECT
  beer_style,
  AVG(abv) avg_abv
FROM
  {{ ref('beers') }}
GROUP BY
  beer_style
