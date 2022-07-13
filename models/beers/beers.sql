
{{ config(
    materialized="table"
) }}

SELECT
  id            AS beer_id,
  TRIM(name)    AS beer_name,
  style         AS beer_style,
  abv           AS abv,
  CASE 
       WHEN ibu <= 12 THEN 'Extra Malty'
       WHEN ibu <= 32 THEN 'Malty'
       WHEN ibu <= 52 THEN 'Well Balanced'
       WHEN ibu <= 82 THEN 'Hoppy'
       WHEN ibu > 82 THEN 'Extra Hoppy'
   END AS bitterness,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
