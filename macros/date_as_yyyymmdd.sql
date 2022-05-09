{#
Convert a date to a YYYYMMDD string.

This macro is needed because the date format string differs from one database backend to another.
#}
{%- macro date_as_yyyymmdd() -%}
    {{ return(adapter.dispatch('date_as_yyyymmdd')()) }}
{%- endmacro -%}


{%- macro default__date_as_yyyymmdd() -%}
    {{ date_format() }}(
        {{ caller() }},
        'YYYYMMDD'
    )
{%- endmacro -%}


{%- macro databricks__date_as_yyyymmdd() -%}
    {{ date_format() }}(
        {{ caller() }},
        {# Reference: https://docs.databricks.com/sql/language-manual/sql-ref-datetime-pattern.html #}
        'yMMdd'
    )
{%- endmacro -%}
