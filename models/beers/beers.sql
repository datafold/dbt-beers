
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
       WHEN ibu <= 50 THEN 'MALTY'
       WHEN ibu > 50 THEN 'HOPPY'
   END AS bitterness,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
