SELECT
    district_code,
    DATE_TRUNC('month', filing_date) AS filing_month,
    COUNT(*) AS cases_filed,
    AVG(decision_date - filing_date) AS avg_disposal_days
FROM {{ ref('stg_cases') }}
GROUP BY 1, 2