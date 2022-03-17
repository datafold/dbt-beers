SELECT
    beer_id,
    ibu
FROM {{ ref('beers' )}}
WHERE ibu < 0 OR ibu > 140

