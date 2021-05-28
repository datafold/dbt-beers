{{ config(
  persist_docs={"relation": true, "columns": true}
) }}

SELECT
  brewery_state              brewery_state,
  COUNT(DISTINCT brewery_id) unique_breweries,
  COUNT(DISTINCT beer_style) unique_styles,
  AVG(abv)                   avg_abv,
  AVG(ibu)                   avg_ibu
FROM
  {{ ref('beers_with_breweries') }}
GROUP BY
  brewery_state
