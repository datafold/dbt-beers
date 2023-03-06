
{{ config(
    materialized="table"
) }}

SELECT
  id            AS beer_id,
  TRIM(name)    AS beer_name,
  style         AS beer_style,
  abv           AS abv,
  ibu           AS ibu,
  CASE 
       WHEN ibu <= 40 THEN 'Malty'
       WHEN ibu > 40 THEN 'Hoppy'
   END AS bitterness,
  brewery_id    AS brewery_id,
  ounces        AS ounces,
  1 AS const
FROM
  {{ ref('seed_beers') }}
