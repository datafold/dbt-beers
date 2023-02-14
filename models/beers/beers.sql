
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
       WHEN ibu <= 20 THEN 'Extra Malty'
       WHEN ibu <= 35 THEN 'Malty'
       WHEN ibu <= 55 THEN 'Well Balanced'
       WHEN ibu <= 80 THEN 'Hoppy'
       WHEN ibu > 80 THEN 'Extra Hoppy'
  END AS bitterness,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
