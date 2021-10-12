
{{ config(
    materialized="table"
) }}

SELECT
  id            AS beer_id,
  name          AS beer_name,
  style         AS beer_style,
  abv + 0.5     AS abv,
  ibu           AS ibu,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
