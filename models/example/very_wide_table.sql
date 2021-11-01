
{{ config(
    materialized="table"
) }}

WITH generated_orders AS (
    {% for num_rows in range(10) %}
        {% for num_cols in range(220) %}
          SELECT
             RAND() AS col{{ num_cols }}{% if not loop.last %},{% endif %}
        {% endfor %}

        {% if not loop.last %}
            UNION ALL
        {% endif %}
    {% endfor %}
)

SELECT *
FROM generated_orders