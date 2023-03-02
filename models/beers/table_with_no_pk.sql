{{ config(
    materialized='table',
    persist_docs={"relation": true, "columns": true}
) }}

WITH generated_orders AS (
    {% for day_ago in range(30) %}
        {% for order_number in range(10) %}
          SELECT
              CONCAT(
                   {{ date_format() }}(
                        DATEADD(Day, -1 * {{ day_ago }}, CURRENT_DATE),
                        {{ yyymmdd() }}
                   ),
                   '22'
             )::int                                                            AS order_no,


             {% if order_number is divisibleby 13 %}
                'PENDING'                                                      AS status,
             {% else %}
                'DELIVERED'                                                    AS status,
             {% endif %}
             DATEADD(Day, -1 * {{ day_ago }}, CURRENT_DATE)                    AS created_at,
             current_timestamp                                                 AS changed_at

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
