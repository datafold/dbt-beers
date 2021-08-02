
{{ config(
    materialized="table"
) }}

SELECT
  id            AS beer_id,
  name          AS beer_name,
  style         AS beer_style,
  abv           AS abv,
  ibu           AS ibu,
  brewery_id    AS brewery_id,
  ounces        AS ounces,
  '1'           AS one
FROM
  {{ ref('seed_beers') }}
