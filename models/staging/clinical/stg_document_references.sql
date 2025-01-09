with source as (
    select * from {{ ref('base_fhir_records') }}
),

flattened as (
    select 
        f.value:resource:id::string as document_reference_id,
        f.value:resource:status::string as status,
        f.value:resource:docStatus::string as doc_status,
        f.value:resource:type:coding[0]:code::string as document_type_code,
        f.value:resource:type:coding[0]:display::string as document_type_display,
        f.value:resource:category[0]:coding[0]:code::string as category_code,
        f.value:resource:category[0]:coding[0]:display::string as category_display,
        f.value:resource:subject:reference::string as patient_reference,
        f.value:resource:date::timestamp as document_date,
        f.value:resource:author[0]:reference::string as author_reference,
        f.value:resource:authenticator:reference::string as authenticator_reference,
        f.value:resource:content[0]:attachment:contentType::string as content_type,
        f.value:resource:content[0]:attachment:url::string as content_url,
        f.value:resource:content[0]:attachment:title::string as content_title,
        f.value:resource:content[0]:attachment:creation::timestamp as content_creation_date
    from source,
    lateral flatten(input => fhir_data:entry) f
    where f.value:resource:resourceType::string = 'DocumentReference'
)

select 
    document_reference_id,
    status,
    doc_status,
    document_type_code,
    document_type_display,
    category_code,
    category_display,
    {{ extract_id('patient_reference') }} as patient_id,
    {{ extract_id('author_reference') }} as author_id,
    {{ extract_id('authenticator_reference') }} as authenticator_id,
    document_date,
    content_type,
    content_url,
    content_title,
    content_creation_date
from flattened
