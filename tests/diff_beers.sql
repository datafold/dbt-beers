{{ 
    audit_helper.compare_all_columns(
        a_relation=ref('beers'),
        b_relation=api.Relation.create(database='INTEGRATION', schema='INTEGRATION', identifier='beers'), 
        exclude_columns=[], 
        primary_key='beer_id',
        summarize=false
    ) 
}}
where not perfect_match