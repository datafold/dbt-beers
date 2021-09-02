{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true}
) }}

-- We'll fake some data, since this is an example repository
-- we want to make sure that we continue to generate data up
-- to today

{% for day_ago in range(30) %}
    {% for order_number in range(10) %}
        -- Each order has between 1 and 5 order_lines
        {% for order_line in range(3) %}
            SELECT TO_VARCHAR(
                        DATEADD(Day, -1 * {{ day_ago }}, current_timestamp),
                        'YYYYMMDD{{ order_number }}'
                   )::int AS order_no,
                   {{ order_line }}            AS order_line,
                   (
                        -- select a random beer
                        SELECT beer_id
                        FROM {{ ref('beers') }}
                        ORDER BY RANDOM(22)
                        LIMIT 1
                   )                           AS beer_id,
                   {{ range(1, 5) | random }}  AS quantity,
                   {{ range(1, 51) | random }} AS price

            {% if not loop.last %}
              UNION ALL
            {% endif %}
        {% endfor %}
        {% if not loop.last %}
        UNION ALL
        {% endif %}
  {% endfor %}

  {% if not loop.last %}
    UNION ALL
  {% endif %}
{% endfor %}