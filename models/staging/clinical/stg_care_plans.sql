with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as care_plan_id,
        f.value:resource:status::string as status,
        f.value:resource:intent::string as intent,
        f.value:resource:category[0]:coding[0]:code::string as category_code,
        f.value:resource:category[0]:coding[0]:display::string as category_display,
        f.value:resource:title::string as title,
        f.value:resource:subject:reference::string as patient_reference,
        f.value:resource:period:start::date as period_start,
        f.value:resource:period:end::date as period_end,
        f.value:resource:created::date as created_date,
        f.value:resource:author:reference::string as author_reference
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'CarePlan'
)

select 
    care_plan_id,
    status,
    intent,
    category_code,
    category_display,
    title,
    {{ extract_id('patient_reference') }} as patient_id,
    {{ extract_id('author_reference') }} as author_id,
    period_start,
    period_end,
    created_date
from flattened
