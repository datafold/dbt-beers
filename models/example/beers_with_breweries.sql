{{ config(
    materialized="table"
) }}

SELECT *
FROM {{ ref('beers') }} beers
JOIN {{ ref('breweries') }} breweries USING (brewery_id)
