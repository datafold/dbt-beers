{{ config(
    materialized="table",
    persist_docs={"relation": true, "columns": true}
) }}

-- We'll fake some data, since this is an example repository
-- we want to make sure that we continue to generate data up
-- to today

{% for day_ago in range(30) %}
    {% for order_number in range(10) %}
      SELECT
         TO_VARCHAR(
            DATEADD(Day, -1, current_timestamp),
            'YYYYMMDD{{ order_number }}'
         )::int                                                            AS order_no,
         {% if order_number is divisibleby 7 %}
            'PENDING'                                                      AS status,
         {% else %}
            'DELIVERED'                                                    AS status,
         {% endif %}
         DATEADD(Day, -1, current_timestamp)                               AS created_at,
         current_timestamp                                                 AS changed_at

      {% if not loop.last %}
        UNION ALL
      {% endif %}
    {% endfor %}

    {% if not loop.last %}
        UNION ALL
    {% endif %}
{% endfor %}
