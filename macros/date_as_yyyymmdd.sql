{%- macro date_as_yyyymmdd() -%}
    {{ date_format() }}(
        {{ caller() }},
        {% if target.type == 'databricks' %}
            'yMMdd'
        {% else %}
            'YYYYMMDD'
        {% endif %}
    )
{%- endmacro -%}
