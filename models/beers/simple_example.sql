{{ config(schema='test_custom_schema') }}

select
1 as id
,'a' as data_col

UNION ALL

select
2 as id,
'd' as data_col
