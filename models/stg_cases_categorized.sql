-- models/stg_cases_categorized.sql
SELECT 
    c.*,
    x.canonical_value AS canonical_type
FROM {{ ref('stg_cases') }} c
LEFT JOIN {{ ref('stg_type_clean') }} t
 ON c.case_type = t.type_name::text AND c.year = t.year::text
LEFT JOIN {{ source('raw', 'type_crosswalk') }} x ON t.type_normalized = x.messy_value