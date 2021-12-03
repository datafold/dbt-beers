
{{ config(
    materialized="table"
) }}

SELECT
  id            AS beer_id,
  name          AS beer_name,
  style         AS beer_style,
  ROUND(abv, 2) AS abv,
  ROUND(ibu, 0) AS ibu,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
