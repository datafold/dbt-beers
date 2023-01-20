{{ 
    audit_helper.compare_all_columns(
        a_relation=ref('orders'),
        b_relation=api.Relation.create(database='INTEGRATION', schema='BEERS', identifier='orders'), 
        exclude_columns=['customer_id', 'changed_at'], 
        primary_key='order_no',
        summarize=false
    ) 
}}
where not perfect_match