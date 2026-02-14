{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true}
) }}

SELECT *
FROM {{ ref('beers') }} beers
JOIN {{ ref('breweries') }} breweries USING (brewery_id)
limit 5
