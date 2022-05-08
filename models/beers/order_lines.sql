{{ config(
    materialized='table',
    unique_key='order_line',
    persist_docs={"relation": true, "columns": true}
) }}

-- We'll fake some data, since this is an example repository
-- we want to make sure that we continue to generate data up
-- to today

WITH generated_order_lines AS (
    {% for day_ago in range(30) %}
        {% for order_number in range(10) %}
            -- Each order has between 1 and 5 order_lines
            {% for order_line in range(3) %}
                SELECT CONCAT(
                            {% call date_as_yyyymmdd() %}
                                DATEADD(Day, -1 * {{ day_ago }}, current_timestamp)
                            {% endcall %},
                            '{{ order_number }}'
                       )                                   AS order_no,
                       CONCAT(
                           {% call date_as_yyyymmdd() %}
                                DATEADD(Day, -1 * {{ day_ago }}, current_timestamp)
                           {% endcall %},
                           '{{ order_number }}{{ order_line }}'
                       ) AS order_line,
                       (
                            -- Deterministically select a random beer
                            SELECT MOD(
                                ABS(HASH({{ order_number + order_line }})),
                                (
                                    SELECT MAX(beer_id) FROM {{ ref('beers') }}
                                )
                            )
                       )                                                          AS beer_id,
                       1 +MOD(ABS(HASH({{ order_number + order_line }})), 3)      AS quantity,
                       MOD(ABS(HASH({{ order_number + order_line }})), 300) / 100 AS price,
                       DATEADD(Day, -1 * {{ day_ago }}, current_timestamp)        AS created_at,
                       current_timestamp                                          AS changed_at

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
)

SELECT *
FROM generated_order_lines

{% if is_incremental() %}
    WHERE created_at::date > (SELECT MAX(created_at)::date FROM {{ this }})
{% endif %}
