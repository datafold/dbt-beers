{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true}
) }}

SELECT *
FROM {{ ref('beers') }}
JOIN {{ ref('breweries') }} USING (brewery_id)
