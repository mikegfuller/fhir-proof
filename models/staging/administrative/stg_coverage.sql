with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as coverage_id,
        f.value:resource:status::string as status,
        f.value:resource:type:coding[0]:code::string as coverage_type_code,
        f.value:resource:type:coding[0]:display::string as coverage_type_display,
        f.value:resource:subscriber:reference::string as subscriber_reference,
        f.value:resource:beneficiary:reference::string as beneficiary_reference,
        f.value:resource:dependent::string as dependent,
        f.value:resource:relationship:coding[0]:code::string as relationship_code,
        f.value:resource:period:start::date as period_start,
        f.value:resource:period:end::date as period_end,
        f.value:resource:payor[0]:display::string as payor_display,
        f.value:resource:class[0]:type:coding[0]:code::string as class_code,
        f.value:resource:class[0]:value::string as class_value,
        f.value:resource:class[0]:name::string as class_name
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'Coverage'
)

select 
    coverage_id,
    status,
    coverage_type_code,
    coverage_type_display,
    {{ extract_id('subscriber_reference') }} as subscriber_id,
    {{ extract_id('beneficiary_reference') }} as beneficiary_id,
    dependent,
    relationship_code,
    period_start,
    period_end,
    payor_display,
    class_code,
    class_value,
    class_name
from flattened
