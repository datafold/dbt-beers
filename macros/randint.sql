{#
Not every DB has a function to return random integer within the given range.

* For Snowflake, there is a native implementation;
* For Databricks, we have to use a custom expression.

The name of the macro is borrowed from the analogous Python `random.randint()` function.
#}

{%- macro randint(min, max) -%}
    {{ return(adapter.dispatch('randint')(min, max)) }}
{%- endmacro -%}


{%- macro default__randint(min, max) -%}
    UNIFORM({{ min }}, {{ max }}, RANDOM())
{%- endmacro -%}


{%- macro databricks__randint(min, max) -%}
    (RANDOM() * {{ max - min }} + {{ min }})::int
{%- endmacro -%}
