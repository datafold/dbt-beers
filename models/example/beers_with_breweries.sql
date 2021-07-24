{{ config(
    persist_docs={"relation": true, "columns": true}
) }}

SELECT *,
       'change' as changed
FROM {{ ref('beers') }}
JOIN {{ ref('breweries') }} USING (brewery_id)
