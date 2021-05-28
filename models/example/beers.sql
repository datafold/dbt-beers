

SELECT
  id            AS id,
  name          AS beer_name,
  style         AS beer_style,
  abv           AS abv,
  ibu           AS ibu,
  brewery_id    AS brewery_id,
  ounces        AS ounces
FROM
  {{ source('beers', 'beers') }}
