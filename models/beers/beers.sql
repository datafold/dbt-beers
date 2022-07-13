
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
       WHEN ibu <= 12 THEN 'Extra Malty'
       WHEN ibu <= 32 THEN 'Malty'
       WHEN ibu <= 52 THEN 'Well Balanced'
       WHEN ibu <= 82 THEN 'Hoppy'
       WHEN ibu > 82 THEN 'Extra Hoppy'
   END AS bitterness,
    CASE 
       WHEN ibu <= 10 THEN 'Extra Malty'
       WHEN ibu <= 30 THEN 'Malty'
       WHEN ibu <= 60 THEN 'Well Balanced'
       WHEN ibu <= 90 THEN 'Hoppy'
       WHEN ibu > 90 THEN 'Extra Hoppy'
   END AS differnt_bitterness,
  brewery_id    AS brewery_id,
  ounces*2        AS ounces
FROM
  {{ ref('seed_beers') }}
