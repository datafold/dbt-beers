
SELECT
  int64_field_0   AS brewery_id,
  string_field_1  AS brewery_name,
  string_field_2  AS brewery_city,
  string_field_3  AS brewery_state
FROM
  {{ source('beers', 'breweries') }}
