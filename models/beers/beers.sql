
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
       WHEN ibu <= 30 THEN 'Malty'
       WHEN ibu < 60 AND ibu >30 THEN 'Hoppy'
       WHEN ibu > 60 THEN 'Aromatic'
   END AS bitterness,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ ref('seed_beers') }}
