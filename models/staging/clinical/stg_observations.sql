with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as observation_id,
        f.value:resource:status::string as status,
        f.value:resource:category[0]:coding[0]:code::string as category_code,
        f.value:resource:category[0]:coding[0]:display::string as category_display,
        f.value:resource:code:coding[0]:code::string as observation_code,
        f.value:resource:code:coding[0]:display::string as observation_name,
        f.value:resource:subject:reference::string as patient_reference,
        f.value:resource:effectiveDateTime::timestamp as effective_date,
        f.value:resource:valueQuantity:value::float as value_quantity,
        f.value:resource:valueQuantity:unit::string as value_unit
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'Observation'
)

select 
    observation_id,
    status,
    category_code,
    category_display,
    observation_code,
    observation_name,
    {{ extract_id('patient_reference') }} as patient_id,
    effective_date,
    value_quantity,
    value_unit
from flattened
