with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as procedure_id,
        f.value:resource:status::string as status,
        f.value:resource:code:coding[0]:code::string as procedure_code,
        f.value:resource:code:coding[0]:display::string as procedure_name,
        f.value:resource:subject:reference::string as patient_reference,
        f.value:resource:performedDateTime::timestamp as performed_date,
        f.value:resource:performer[0]:actor:reference::string as performer_reference,
        f.value:resource:performer[0]:actor:display::string as performer_display,
        f.value:resource:location:reference::string as location_reference,
        f.value:resource:location:display::string as location_display,
        f.value:resource:outcome:coding[0]:display::string as outcome
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'Procedure'
)

select 
    procedure_id,
    status,
    procedure_code,
    procedure_name,
    {{ extract_id('patient_reference') }} as patient_id,
    {{ extract_id('performer_reference') }} as performer_id,
    performer_display,
    {{ extract_id('location_reference') }} as location_id,
    location_display,
    performed_date,
    outcome
from flattened
