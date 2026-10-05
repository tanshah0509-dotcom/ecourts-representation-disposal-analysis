SELECT
    year, type_name,
    LOWER(REGEXP_REPLACE(type_name_s, '[^a-zA_Z0-9]', '', 'g')) AS type_normalized,
    count
FROM {{source('raw', 'type_name_key')}}