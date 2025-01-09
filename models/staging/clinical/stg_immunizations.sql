with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as immunization_id,
        f.value:resource:status::string as status,
        f.value:resource:vaccineCode:coding[0]:code::string as vaccine_code,
        f.value:resource:vaccineCode:coding[0]:display::string as vaccine_name,
        f.value:resource:patient:reference::string as patient_reference,
        f.value:resource:occurrenceDateTime::timestamp as occurrence_date,
        f.value:resource:manufacturer:display::string as manufacturer,
        f.value:resource:lotNumber::string as lot_number,
        f.value:resource:expirationDate::date as expiration_date,
        f.value:resource:site:coding[0]:display::string as site,
        f.value:resource:route:coding[0]:display::string as route,
        f.value:resource:doseQuantity:value::float as dose_value,
        f.value:resource:doseQuantity:unit::string as dose_unit
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'Immunization'
)

select 
    immunization_id,
    status,
    vaccine_code,
    vaccine_name,
    {{ extract_id('patient_reference') }} as patient_id,
    occurrence_date,
    manufacturer,
    lot_number,
    expiration_date,
    site,
    route,
    dose_value,
    dose_unit
from flattened
