SELECT
    canonical_type,
    CASE 
        WHEN SPLIT_PART(female_petitioner, ' ', 1)::integer = 1 THEN 'female'
        WHEN SPLIT_PART(female_petitioner, ' ', 1)::integer = 0 THEN 'male'
        ELSE 'unclear'
    END AS petitioner_gender,
    AVG(decision_date - filing_date) AS avg_disposal_days,
    COUNT(*) AS case_count
FROM {{ ref('stg_cases_categorized') }}
WHERE SPLIT_PART(female_petitioner, ' ', 1)::integer IN (0, 1)
GROUP BY 1, 2