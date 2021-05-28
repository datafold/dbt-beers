

SELECT *
FROM {{ ref('beers') }}
JOIN {{ ref('breweries') }} USING (brewery_id)
