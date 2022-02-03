{{ config(
    materialized='table',
    unique_key='order_no',
    persist_docs={"relation": true, "columns": true}
) }}

-- We'll fake some data, since this is an example repository
-- we want to make sure that we continue to generate data up
-- to today

WITH generated_orders AS (
    {% for day_ago in range(30) %}
        {% for order_number in range(10) %}
          SELECT
             TO_VARCHAR(
                DATEADD(Day, -1 * {{ day_ago }}, CURRENT_DATE),
                'YYYYMMDD{{ order_number }}'
             )::int                                                            AS order_no,
             {% if order_number is divisibleby 13 %}
                'PENDING'                                                      AS status,
             {% else %}
                'DELIVERED'                                                    AS status,
             {% endif %}
             DATEADD(Day, -1 * {{ day_ago }}, CURRENT_DATE)                    AS created_at,
             CURRENT_DATE.                                                     AS changed_at

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
FROM generated_orders

{% if is_incremental() %}
    WHERE created_at::date > (SELECT MAX(created_at)::date FROM {{ this }})
{% endif %}
