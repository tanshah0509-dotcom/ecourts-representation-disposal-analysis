SELECT
    year,
    TRIM(UPPER(dist_code)) AS district_code,
    state_code,
    type_name AS case_type,
    female_defendant,
    female_petitioner,
    female_adv_def,
    female_adv_pet,
    NULLIF(date_of_filing, '')::date AS filing_date,
    NULLIF(date_of_decision, '')::date AS decision_date,
    disp_name AS disposal_type
FROM {{ source('raw', 'raw_cases_2014') }}
WHERE date_of_decision IS NOT NULL AND date_of_decision != ''