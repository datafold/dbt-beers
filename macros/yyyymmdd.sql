{#
Convert a date to a YYYYMMDD string.

This macro is needed because the date format string differs from one database backend to another.
#}
{%- macro yyymmdd() -%}
    {{ return(adapter.dispatch('yyymmdd')()) }}
{%- endmacro -%}


{%- macro default__yyymmdd() -%}
    'YYYYMMDD'
{%- endmacro -%}


{%- macro databricks__yyymmdd() -%}
    {# Reference: https://docs.databricks.com/sql/language-manual/sql-ref-datetime-pattern.html #}
    'yMMdd'
{%- endmacro -%}
