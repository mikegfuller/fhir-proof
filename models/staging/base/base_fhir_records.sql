{{
    config(
        materialized='view'
    )
}}

select 
    record_id,
    record_date,
    source_system,
    fhir_data,
    created_at,
    filename,
    file_row_number
from {{ source('raw', 'fhir_data') }}
