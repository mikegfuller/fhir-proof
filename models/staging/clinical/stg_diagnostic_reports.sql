with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as diagnostic_report_id,
        f.value:resource:status::string as status,
        f.value:resource:category[0]:coding[0]:code::string as category_code,
        f.value:resource:category[0]:coding[0]:display::string as category_display,
        f.value:resource:code:coding[0]:code::string as report_code,
        f.value:resource:code:coding[0]:display::string as report_name,
        f.value:resource:subject:reference::string as patient_reference,
        f.value:resource:effectiveDateTime::timestamp as effective_date,
        f.value:resource:issued::timestamp as issued_date,
        f.value:resource:performer[0]:reference::string as performer_reference,
        f.value:resource:performer[0]:display::string as performer_display
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'DiagnosticReport'
)

select 
    diagnostic_report_id,
    status,
    category_code,
    category_display,
    report_code,
    report_name,
    {{ extract_id('patient_reference') }} as patient_id,
    {{ extract_id('performer_reference') }} as performer_id,
    performer_display,
    effective_date,
    issued_date
from flattened
