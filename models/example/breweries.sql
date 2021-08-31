
{{ config(
    materialized="table"
) }}

SELECT
  id                    AS brewery_id,
  name                  AS brewery_name,
  city                  AS brewery_city,
  trim(state)           AS brewery_state
FROM
  {{ ref('seed_breweries') }}
-- WHERE
--   trim(string_field_3) <> 'TX'
